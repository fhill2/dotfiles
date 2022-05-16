

# from libqtile.command.client import CommandClient
# #dir(CommandClient)
# c = CommandClient()
# #print(c.call("status")())
# #print(dir(c))

# from libqtile.core.manager import Qtile
# print(dir(c))
# #Qtile.find_window()
# #print(Qtile.currentWindow)
# print(dir(c.qtile))
#print(sys.modules)
class Formatter(object):
    def __init__(self):
        print("init called")
        self.types = {}
        self.htchar = '\t'
        self.lfchar = '\n'
        self.indent = 0
        self.set_formater(object, self.__class__.format_object)
        self.set_formater(dict, self.__class__.format_dict)
        self.set_formater(list, self.__class__.format_list)
        self.set_formater(tuple, self.__class__.format_tuple)

    def set_formater(self, obj, callback):
        self.types[obj] = callback

    def __call__(self, value, **args):
        for key in args:
            setattr(self, key, args[key])
        formater = self.types[type(value) if type(value) in self.types else object]
        return formater(self, value, self.indent)

    def format_object(self, value, indent):
        return repr(value)

    def format_dict(self, value, indent):
        items = [
            self.lfchar + self.htchar * (indent + 1) + repr(key) + ': ' +
            (self.types[type(value[key]) if type(value[key]) in self.types else object])(self, value[key], indent + 1)
            for key in value
        ]
        return '{%s}' % (','.join(items) + self.lfchar + self.htchar * indent)

    def format_list(self, value, indent):
        items = [
            self.lfchar + self.htchar * (indent + 1) + (self.types[type(item) if type(item) in self.types else object])(self, item, indent + 1)
            for item in value
        ]
        return '[%s]' % (','.join(items) + self.lfchar + self.htchar * indent)

    def format_tuple(self, value, indent):
        items = [
            self.lfchar + self.htchar * (indent + 1) + (self.types[type(item) if type(item) in self.types else object])(self, item, indent + 1)
            for item in value
        ]
        return '(%s)' % (','.join(items) + self.lfchar + self.htchar * indent)


class Shape:
    def __init__(self):
        self.data = [1,2,9,8,7]
    def my_method():
        print("my method")
s = Shape()
stuff = ['spam', 'eggs', 'lumberjack', 'knights', 'ni']
print(repr(s))



# def pretty(d, indent=0):
#    for key, value in d.items():
#       print('\t' * indent + str(key))
#       if isinstance(value, dict):
#          pretty(value, indent+1)
#       else:
#          print('\t' * (indent+1) + str(value))

import pprint
pp = pprint.PrettyPrinter()
def pprint(o):
  pp.pprint(o)

import inspect
def dump(o):
  pprint(inspect.getmembers(o, inspect.ismethod)) # only works on classes
  pprint(o.__dict__)




def module_funct(arg1, arg2 = 'default', *args):
    """This is a module-level function."""
    local_var = arg1 * 3
    return local_var

class X(object):
    """Definition for X class."""

    def __init__(self, name):
        self.name = name

    def get_name(self):
        "Returns the name of the instance."
        return self.name

x_obj = X('sample_instance')

class Y(X):
    """This is the Y class, 
    child of X class.
    """

    # This method is not part of X class.
    def do_something(self):
        """Anything can be done here."""

    def get_name(self):
        "Overrides version from X"
        return 'Y(' + self.name + ')'

from libqtile.command.client import InteractiveCommandClient
import sys
c = InteractiveCommandClient()


x = X("myname")
pprint(inspect.getmembers(c, inspect.ismethod)) # only works on classes
#print(x)
#pprint(dir(c))
#pprint(inspect.getmembers(x, inspect.ismethod)) # only works on classes
pprint(x.__dict__)


#p = Formatter()
#  def p(o):
#   import pprint
#   pp = pprint.PrettyPrinter(indent=4)
#   pp.pprint(o)
#print(p(c))
#print([1,2,3,4])
#print(p([1,2,3,4]))
#print(dir(c))








