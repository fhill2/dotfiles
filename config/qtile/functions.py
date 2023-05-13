from libqtile.command import lazy
# REMEMBER CUSTOM LAZY FUNCTIONS wont error on startup, they will error when keybind is pressed
# errors shown in main ~/.local/share/qtile/qtile.log
class Function(object):

     @staticmethod
     def dropdown_kill_toggle(name):
         @lazy.function
         def __inner(qtile): 
            self = qtile.groups_map["scratchpad"]
            if name in self.dropdowns:
                self.dropdowns[name].window.kill()
                self._spawn(self._dropdownconfig[name])
            else:
                self._spawn(self._dropdownconfig[name])
            #scratchpad.cmd_dropdown_toggle("omni")
            #scratchpad.dropdowns[name].toggle()
         return __inner
       
     @staticmethod
     def screen_to_group(screen, group):
         # screen 0 = main, screen 1 = alt
        @lazy.function
        def __inner(qtile):
            qtile.screens[screen].toggle_group(qtile.groups_map[group])
        return __inner 



     @staticmethod
     def boiler():
         @lazy.function
         def __inner(qtile):
            print("do a lazy thing here")
         return __inner
