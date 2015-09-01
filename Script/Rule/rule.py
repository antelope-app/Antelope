from enum import Enum

'''
  These classes define an iOS 9 AdBlock rule in Python.

  https://www.webkit.org/blog/3476/content-blockers-first-look/
'''

class Action:
    def __init__(self, action_type):
    '''
        “type” (string, mandatory): defines what to do when the rule is activated.
                Potential values - “block”, “block-cookies”, “css-display-none”, “ignore-previous-rules”
        “selector” (string, mandatory for the “css-display-none” type): defines a selector list to apply on the page.
    '''    
    self.type = action_type
    self.selector = ""        

class Trigger:
    def __init__(self, url_filter):
        '''
            “url-filter” (string, mandatory): matches the resource’s URL.

            “resource-type”: (array of strings, optional): matches how the resource will be used.
                  Potential values - "document", "image", "style-sheet", "script", "font", "raw", "svg-document"
                                       "media", "popup"

            “load-type”: (array of strings, optional): matches the relation to the main resource.
                  Potential values - "first-party", "third-party"

            “if-domain”/”unless-domain” (array of strings, optional): matches the domain of the document.
        '''
        self.url_filter = url_filter
        self.resource_type = []
        self.load_type = []
        self.if_domain = []
        self.unless_domain = []

class Rule:
    # Public
    def __init__(self, raw_rule):
        self.raw_rule = raw_rule
        self.action = Action()
        self.trigger = Trigger()

        self._populate()

    def isBlockingRule(self):
        return self.type == RuleType.block_domain or /
               self.type == RuleType.block_exact or /
               self.type == RuleType.block_part

    # Private
    def _populate(self):
        self._populateType()
        self._populateOptions()

    def _populateType(self):
        if self.raw_rule.startswith("!"):
            self.type = RuleType.comment
        elif self.raw_rule.startswith("||"):
            self.type = RuleType.block_domain
        elif self.raw_rule.startswith("|"):
            self.type = RuleType.block_exact
        elif "##" in self.raw_rule:
            self.type = RuleType.selector
        elif self.raw_rule.startswith("@@"):
            self.type = RuleType.exception
        else: 
            self.type = RuleType.block_part

    def _populateOptions(self):
        options = None

        if '$' in self.raw_rule:
            separator_index = target.index('$')
            options = self.raw_rule[:option_separator_index]

        for option in options:
            if option.startswith("domain="):
                # Do domain parsing
            elif "third-party" in option:
                self.load_type = 
            else:
                # Do resource type parsing

class EZRuleType(Enum):
    comment = 1
    block_domain = 2
    block_part = 3
    block_exact = 4
    selector = 5
    exception = 6





