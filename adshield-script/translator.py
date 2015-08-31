import json
import sys

# From an adblock filter file, just yield the rules
# This should omit all the headers lines
def rules(adblock_filter_file):
	# Filter files seem to start every line with a character to indicate line type
	# Let's do the easy thing first then and just filter by first character
	excludeLineTypes = ["!", "["]
	for l in adblock_filter_file:
		if l[0] not in excludeLineTypes:
			# Clean off any introduced whitespace	
			yield l.strip()

# From a list of rules, only yield what we can actually translate 
def translatable(rules):
	# Not going to implement exceptions now
	excluded_rules = ["@@"]
	for r in rules:
		# There is probably a more elegant way to do this
		emit = True
		for excluded_rule in excluded_rules:
			if r.startswith(excluded_rule):
				emit = False
		if emit:
			yield r

# Take a AdBlock rule and translate to apple rule
def translate(rule):
	#Determine is we are blocking a load or hiding css
	block_css = False	
	css_selector = ""	
	
	# What kind of rule do we have - determine the url filter
	url_filter = rule

	if (rule.find("##") != -1):
		block_css = True		
		css_selector = rule[(rule.find("##") + 2):]	
		url_filter = rule[:rule.find("##")]	

		if not url_filter.startswith("||") and not url_filter.startswith("|"):
			url_filter = _prepend_http_regex(url_filter)
	
	# Adblock filter format has three types
	# BLOCK_DOMAIN - block everything from domain 
	# BLOCK_EXACT - block only on exact url match
	# BLOCK_PART - match is regex appears anywhere in url

	if (url_filter.startswith("||")):
		url_filter = url_filter[2:]
		url_filter = translateRegex("BLOCK_DOMAIN", url_filter)
	elif (url_filter.startswith("|")):
		url_filter = url_filter[1:]
		url_filter = translateRegex("BLOCK_EXACT", url_filter)	
	else:
		url_filter = translateRegex("BLOCK_PART", url_filter)
	
	# These block a CSS selector on any arbitrary page
	if url_filter == "" and css_selector is not None:
		url_filter = ".*"

	# Build the translated rule	
	translated_rule = {}
	translated_rule["trigger"] = {}
	translated_rule["trigger"]["url-filter"] = url_filter

	translated_rule["action"] = {}

	if css_selector:
		translated_rule["action"]["selector"] = css_selector
		translated_rule["action"]["type"] = "css-display-none"
	else:
		translated_rule["action"]["type"] = "block"
	
	return translated_rule

# Translate the adblock regular expression into the apple equivalent
# TODO - Update this to correctly translate the regexes
def translateRegex(matchType, url_filter):
	target = url_filter

	# Option separator indicates content types and should be ignored
	if '$' in target:
		option_separator_index = target.index('$')
		target = target[:option_separator_index]

	# ^ == ([./]) 
	if '^' in target:
		target = target.replace('^', "([./?&=:])")

	# * == .*
	if '*' in target:
		target = target.replace('*', ".*")
	
	if (matchType == "BLOCK_DOMAIN") or (matchType == "BLOCK_EXACT"):
		target = _prepend_http_regex(target)

	return target

def _prepend_http_regex(target):
    if len(target) == 0:
        return ".*" + target
    else:
        return "https?://(www.)?" + target

# Now we get down to actually running this program

# Get the name of filter file

filter_file_name = sys.argv[1]

with open(filter_file_name, "r") as adblock_filter_file:
	# Accumulate all of our translated rules
	# TODO - this can be made smarter so this whole thing is streaming rather than doing an accumulation
	translated_rules = []
	
	# Go the file and return only translatable rules
	# Translate these and accumulate in translated_rules
	for rule in translatable(rules(adblock_filter_file)):
		translated_rules.append(translate(rule))
	
	# This pretty prints to stdout.  You can remove the pretty printing, its just debug to read with it.	
	sys.stdout.write(json.dumps(translated_rules, sort_keys=True, indent=4, separators=(',', ': ')))

