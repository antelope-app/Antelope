from enum import Enum

'''
  These classes define an iOS 9 AdBlock rule in Python.

  https://www.webkit.org/blog/3476/content-blockers-first-look/
'''
class Action:
    def __init__(self):
        '''
            type (string, mandatory): defines what to do when the rule is activated.
                    Potential values - block, block-cookies, css-display-none, ignore-previous-rules
            selector (string, mandatory for the css-display-none type): defines a selector list to apply on the page.
        '''    
        self.type = ""
        self.selector = ""        

class Trigger:
    def __init__(self):
        '''
            "url-filter" (string, mandatory): matches the resource’s URL.

            "resource-type": (array of strings, optional): matches how the resource will be used.
                  Potential values - "document", "image", "style-sheet", "script", "font", "raw", "svg-document"
                                       "media", "popup"

            "load-type": (array of strings, optional): matches the relation to the main resource.
                  Potential values - "first-party", "third-party"

            "if-domain"/"unless-domain" (array of strings, optional): matches the domain of the document.
        '''
        self.url_filter = ""
        self.resource_type = []
        self.load_type = []
        self.if_domain = []
        self.unless_domain = []

    def is_valid_resource_types(resource_type):
        valid_types = set(["document", "image", "style-sheet", 
                "script", "font", "raw", "svg-document"
                "media", "popup"])
        return resource_type in valid_types

class Rule:
    def __init__(self):
        self.action = Action()
        self.trigger = Trigger()