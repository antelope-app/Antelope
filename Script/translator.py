import json
import sys

from rules.ez_translator import EZTranslator
from rules.rule_builder import RuleBuilder
from rules.rule import Rule

def validate(translated_rules):
    # TODO: Build this out to validate before producing raw JSON
    for rule in translated_rules:
        try:
            re.compile(rule["trigger"]["url-filter"])
        except:
            print rule

# Get the name of filter file
filter_file_name = sys.argv[1]
translated_rules = []

ez_translator = EZTranslator()
rule_builder = RuleBuilder(ez_translator)

with open(filter_file_name, "r") as adblock_filter_file:
    
    # Go the file and return only translatable rules
    # Translate these and accumulate in translated_rules
    for raw_rule in adblock_filter_file:
    	raw_rule = raw_rule.strip()
    	rule = rule_builder.build_rule(raw_rule)

    	if rule is not None:
        	translated_rules.append(rule.as_dict())
    
with open('mobilelist.json', "r") as mobile_list:
    mobile_rules = json.load(mobile_list)
    for rule in mobile_rules:
        translated_rules.append(rule)

translated_rules = sorted(translated_rules, key=lambda rule: rule["action"]["type"])

# This pretty prints to stdout. 
json = json.dumps(translated_rules, sort_keys=True, indent=4, separators=(',', ': '))
sys.stdout.write(json)

