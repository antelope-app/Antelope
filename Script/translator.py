import json
import sys

from rules.ez_translator import EZTranslator
from rules.rule_builder import RuleBuilder
from rules.rule import Rule

def is_ascii(s):
    return all(ord(c) < 128 for c in s)

# Get the name of filter file
filter_file_name = sys.argv[1]
translated_rules = []

with open(filter_file_name, "r") as adblock_filter_file:
    # Accumulate all of our translated rules
    ez_translator = EZTranslator()
    rule_builder = RuleBuilder(ez_translator)
    
    # Go the file and return only translatable rules
    # Translate these and accumulate in translated_rules
    for raw_rule in adblock_filter_file:
    	rule = rule_builder.build_rule(raw_rule)
    	if rule is not None:
    		print rule.as_dict()
        	translated_rules.append(rule.as_dict())
    
with open('mobilelist.json', "r") as mobile_list:
        mobile_rules = json.load(mobile_list)
        for rule in mobile_rules:
            translated_rules.append(rule)
    
# This pretty prints to stdout.  
#sys.stdout.write(json.dumps(translated_rules, sort_keys=True, indent=4, separators=(',', ': '), encoding="ascii"))

