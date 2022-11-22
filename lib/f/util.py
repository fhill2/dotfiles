from subprocess import run
def run_sh(cmd, cwd=None):
    return run(cmd, capture_output=True, shell=True, cwd=cwd).stdout.decode('utf-8').strip().split("\n")





# Start Flavours
colors = {
  'base00' : '#212121',
  'base01' : '#303030',
  'base02' : '#353535',
  'base03' : '#4A4A4A',
  'base04' : '#B2CCD6',
  'base05' : '#EEFFFF',
  'base06' : '#EEFFFF',
  'base07' : '#FFFFFF',
  'base08' : '#F07178',
  'base09' : '#F78C6C',
  'base0A' : '#FFCB6B',
  'base0B' : '#C3E88D',
  'base0C' : '#89DDFF',
  'base0D' : '#82AAFF',
  'base0E' : '#C792EA',
  'base0F' : '#FF5370',
}
# End Flavours


# def dump(o):
#     prettyprint.pprint(o)



# def dump(o):
#     if isinstance(o, str):
#         for property, value in vars(o).items():
#             print(property, "=", value)
#     else:
#         print(o)

# def dump(obj):
#     # for standalone dump to output
#     from libqtile.log_utils import logger

#     def log(*args, **kwargs):
#         logger.warning(*args, **kwargs)

#     import inspect
#     print("====================== __DICT__ inspect.ismethod ==========")
#     method_names = [attr for attr in dir(obj) if inspect.ismethod(getattr(obj, attr))]
#     for method in method_names:
#         print(method)
#     if hasattr(obj, '__dict__'):
#         print("==================== __DICT__ vars() ==========")
#         for property, value in vars(obj).items():
#             print(property, "=", value)
#     elif hasattr(obj, '__slots__'):
#         return {attr: getattr(obj, attr, None) for attr in obj.__slots__}
#     elif type(obj) == str:
#         print(obj)
#     else:
#         print("no __dict__ or __slots__ or isnt str")




# def dump(obj):
#     import inspect
#     log("================================================= NEW DUMP ========================================")
#     log("====================== __DICT__ inspect.ismethod ==========")
#     method_names = [attr for attr in dir(obj) if inspect.ismethod(getattr(obj, attr))]
#     for method in method_names:
#         log(method)
#     if hasattr(obj, '__dict__'):
#         log("==================== __DICT__ vars() ==========")
#         # printing an object without __dict__ attribute results in error
#         for property, value in vars(obj).items():
#             log(property, "=", value)
#     elif hasattr(obj, '__slots__'):
#         return {attr: getattr(obj, attr, None) for attr in obj.__slots__}
#     elif type(obj) == str:
#         log(obj)
#     else:
#         log("no __dict__ or __slots__ or isnt str")


# prettyprint = pprint.PrettyPrinter(indent=4)


import sys
# sys.path.append(r'/home/f1/dev/cl/python/standalone')



def pp(stuff):
    import pprint
    pp = pprint.PrettyPrinter(indent=4, width=1)
    pp.pprint(stuff)
    print("prettypring called")
    # prettyprint.pprint(*args, **kwargs, indent=4)
    # prettyprint.pformat(*args, **kwargs)


# def pp()
    # json.dumps(indent=4, sort_keys=True)

import time
def log(*args, **kwargs):
    f = open("/home/f1/logs/python.log",'a')
    date = time.ctime()
    print(f"====== {date} =====", file=f)
    print(*args, **kwargs, file=f)
    f.close()

# import builtins
# builtins.log = log
# builtins.printl = log
# builtins.pp = pp
# import init


def dump(obj):
    import inspect
    x = []
    print("===================== methods ====================")
    for i in inspect.getmembers(obj):
        if not i[0].startswith('_'):
            if not inspect.ismethod(i[1]):
                x.append(i)
            else:
                print(i)
    print("===================== props ====================")
    for props in x:
        print(props)

def dump_out(obj):
    import inspect
    props = []
    out = "===================== methods ====================\n"
    for i in inspect.getmembers(obj):
        if not i[0].startswith('_'):
            if not inspect.ismethod(i[1]):
                props.append(str(i))
            else:
                out = out + str(i) + "\n"
    out = out + "===================== props ====================\n"
    for prop in props:
        out = out + str(prop) + "\n"
    return out
