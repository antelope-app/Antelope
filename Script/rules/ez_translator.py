from rule_builder import Translator
from rule import Rule, Action, Trigger

import re
import sys

'''
   The core documentation for EasyList is found here:
        Cheatsheet: https://adblockplus.org/en/filter-cheatsheet
        Documentation: https://adblockplus.org/en/filters
'''
class EZRuleType:
    '''
        See cheatsheet for explanations.
        TODO: Support SelectorException and Invalid types
    '''
    unknown = 0
    comment = 1
    block_domain = 2
    block_part = 3
    block_exact = 4
    selector = 5
    exception = 6

class EZParseHelper:
    @staticmethod
    def split_at_string(target, splitter, right=True):
        separator_index = target.find(splitter)
        if right:
            non_inclusive_index = separator_index + len(splitter)
            return target[non_inclusive_index:]
        else:
            return target[:separator_index]

    @staticmethod
    def regex_for_type(ez_rule_type):
        # TODO: Make this actually RegEx to avoid ugly 'startswith' / 'in' division
        signifier = ""

        if ez_rule_type is EZRuleType.comment:
            return '!'
        elif ez_rule_type is EZRuleType.block_domain:
            return '||'
        elif ez_rule_type is EZRuleType.block_exact:
            return '|'
        elif ez_rule_type is EZRuleType.selector:
            return '##'
        elif ez_rule_type is EZRuleType.exception:
            return '@@'

        return signifier

    @staticmethod
    def is_ez_negated(target):
        return target.startswith('~')

class EZRule:
    def __init__(self, raw_rule):
        # The raw EasyList rule
        self.raw_rule = raw_rule

        # High level description of rule type
        self.type = EZRuleType.unknown

        # Url filter string in EasyList syntax
        self.url_filter = ""

        # Defines domains that rule is relevant for
        self.domains = []

        # Defines document type options
        self.content_options = []

        # Defines load type of document for rule
        self.load_types = []

        # Defines CSS selector 
        self.selector = ""

class EZRuleParser:
    def parse(self, raw_rule):
        raw_rule.strip()
        ez_rule = EZRule(raw_rule)

        ez_rule.type = EZRuleParser._type(raw_rule)
        if ez_rule.type is EZRuleType.selector:
            ez_rule.selector = EZRuleParser._css_selector(raw_rule)

        raw_options = EZRuleParser._raw_options(raw_rule)
        if raw_options is not None:
            ez_rule.content_options = EZRuleParser._content_options(raw_options)
            ez_rule.load_types = EZRuleParser._load_types(raw_options)
            ez_rule.domains = EZRuleParser._domains(raw_options)

        ez_rule.url_filter = EZRuleParser._url_filter(raw_rule, ez_rule.type)

        return ez_rule

    @staticmethod
    def _type(raw_rule):
        ez_rule_type = EZRuleType.unknown

        if raw_rule.startswith("!") or raw_rule.startswith("["):
            ez_rule_type = EZRuleType.comment
        elif raw_rule.startswith("||"):
            ez_rule_type = EZRuleType.block_domain
        elif raw_rule.startswith("|"):
            ez_rule_type = EZRuleType.block_exact
        elif "##" in raw_rule:
            ez_rule_type = EZRuleType.selector
        elif raw_rule.startswith("@@"):
            ez_rule_type = EZRuleType.exception
        else: 
            ez_rule_type = EZRuleType.block_part

        if "#@" in raw_rule:
            ez_rule_type = EZRuleType.unknown

        return ez_rule_type

    @staticmethod
    def _selector_url_filter(raw_rule):
        return EZParseHelper.split_at_string(raw_rule, "##", right=False)

    @staticmethod
    def _url_filter(raw_rule, ez_rule_type):
        url_filter = raw_rule

        # Remove selectors
        if '$' in url_filter:
            url_filter = EZParseHelper.split_at_string(url_filter, '$', right=False)

        if ez_rule_type is EZRuleType.selector:
            url_filter = EZRuleParser._selector_url_filter(url_filter)
        else:
            # To capture @@|| or @@| constructions 
            if ez_rule_type is EZRuleType.exception:
                regex = EZParseHelper.regex_for_type(ez_rule_type)

                #Casts the type to the newly pre-pended url_filter
                ez_rule_type = EZRuleParser._type(url_filter)

            regex = EZParseHelper.regex_for_type(ez_rule_type)

            url_filter = EZParseHelper.split_at_string(url_filter, regex)

        return url_filter

    @staticmethod
    def _raw_options(raw_rule):
        '''
            Gets all options from the raw_rule

            $ sign marks the additional options after the domain
            
            Ex. 
            ||ads.example.com^$script,image,domain=example.com|~foo.example.info
            => ['script', 'image', 'domain=example.com|~foo.example.info']

            These are referred to as a "raw options" because some further parsing is required
        '''
        options = None

        if '$' in raw_rule:
            options = EZParseHelper.split_at_string(raw_rule, '$').split(",")

        return options

    @staticmethod
    def _domains(raw_options):
        '''
            Gets the domain options from the raw_options
            
            Ex.
            domain=example.com|~foo.example.info => ['example.com', '~foo.example.info']
        '''
        domains = []

        for option in raw_options:
            if EZRuleParser._is_domain_option(option):
                domains = EZParseHelper.split_at_string(option, '=').split("|")
                break

        return domains

    @staticmethod
    def _is_domain_option(option):
        return option.startswith("domain=")

    @staticmethod
    def _load_types(raw_options):
        '''
            Gets the load type option from the raw options.

            Potential load type options are third-party or ~third-party            
        '''
        load_types = []

        for option in raw_options:
            if EZRuleParser._is_load_type_option(option):
                load_types.append(option)

        return load_types

    @staticmethod
    def _content_options(raw_options):
        '''
            If the type isn't a domain type or load type then it is a content options type.
        '''
        content_options = []

        for option in raw_options:
            if not EZRuleParser._is_domain_option(option) and \
               not EZRuleParser._is_load_type_option(option):
                content_options.append(option)

        return content_options

    @staticmethod
    def _is_load_type_option(option):
        return "third-party" in option

    @staticmethod
    def _css_selector(raw_rule, ez_rule_type=EZRuleType.selector):
        signifier = EZParseHelper.regex_for_type(ez_rule_type)
        non_inclusive_index = (raw_rule.find("##") + 2)
        return raw_rule[non_inclusive_index:]


class EZTranslator(Translator):
    def translate(self, raw_rule):
        parser = EZRuleParser()
        ez_rule = parser.parse(raw_rule)

        if ez_rule.type is EZRuleType.unknown or \
           ez_rule.type is EZRuleType.comment or \
           ez_rule.type is EZRuleType.exception:
           return None

        ios_rule = Rule()
        ios_rule.action = EZTranslator._action_from_ez(ez_rule)
        ios_rule.trigger = EZTranslator._trigger_from_ez(ez_rule)

        return ios_rule

    @staticmethod
    def _action_from_ez(ez_rule):
        ez_rule_type = ez_rule.type

        action = Action()
        action.type = EZTranslator._action_type(ez_rule_type)

        if ez_rule_type is EZRuleType.selector:
            action.selector = ez_rule.selector

        return action

    @staticmethod
    def _action_type(ez_rule_type):
        if ez_rule_type is EZRuleType.selector:
            return "css-display-none"
        elif ez_rule_type is EZRuleType.exception:
            return "ignore-previous-rules"
        else:
            return "block"

    @staticmethod
    def _trigger_from_ez(ez_rule):
        trigger = Trigger()
        trigger.url_filter = EZTranslator._regex_url_filter(ez_rule.url_filter, ez_rule.type)
        trigger.resource_type = EZTranslator._resource_types(ez_rule.content_options)
        trigger.load_type = EZTranslator._load_types(ez_rule.load_types)
        trigger.if_domain = EZTranslator._if_domains(ez_rule.domains)
        trigger.unless_domain = EZTranslator._unless_domains(ez_rule.domains)

        return trigger

    @staticmethod
    def _regex_url_filter(url_filter, ez_rule_type):
        target = url_filter

        # A little clean up
        target = target.strip()
        target = re.escape(target)

        # ^ matches separater characters
        if '^' in target:
            target = target.replace('^', "[\./?&=:]")

        # * == .*
        if '*' in target:
            target = target.replace('*', ".*")

        # Prepends URL for filtering
        if ez_rule_type is EZRuleType.block_domain or \
           ez_rule_type is EZRuleType.block_exact or \
           ez_rule_type is EZRuleType.exception or \
           ez_rule_type is EZRuleType.selector and len(url_filter) > 0:
            target = EZTranslator._prepend_http(target)
        elif ez_rule_type is EZRuleType.selector and \
           len(url_filter) is 0:
            target = ".*"

        # Match beginning and end of line
        if ez_rule_type is EZRuleType.block_exact:
            target = "^" + target + "$"

        # Can be any part of the string
        if ez_rule_type is EZRuleType.block_part:
            target = ".*" + target + ".*"

        # TODO: Add support for end line character (for example |)
        return target

    @staticmethod
    def _prepend_http(target):
        return "https?://([^/:]*\.)" + target

    @staticmethod
    def _resource_types(ez_content_options):
        resource_types = []

        for resource_type in ez_content_options:
            # For now we are going to ignore negating these cases
            if not EZParseHelper.is_ez_negated(resource_type) \
               and Trigger.is_valid_resource_type(resource_type):
                resource_types.append(resource_type)

        return resource_types

    @staticmethod
    def _load_types(ez_load_types):
        load_types = []

        for load_type in ez_load_types:
            if EZParseHelper.is_ez_negated(load_type):
                load_types.append("first-party")
            else:
                load_types.append("third-party")

        return load_types

    @staticmethod
    def _if_domains(ez_rule_domains):
        if_domains = []

        for domain in ez_rule_domains:
            if not EZParseHelper.is_ez_negated(domain):
                if_domains.append(EZTranslator._prepend_http(domain))

        return if_domains

    @staticmethod
    def _unless_domains(ez_rule_domains):
        unless_domains = []

        for domain in ez_rule_domains:
            if EZParseHelper.is_ez_negated(domain):
                unless_domains.append(EZTranslator._prepend_http(domain))

        return unless_domains



