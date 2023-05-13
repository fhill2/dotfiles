// https://github.com/tsaost/autoload-temporary-addon
// this file needs to be symlinked to /opt/firefox-nightly/defaults/pref/config-prefs.js

// config-prefs.js file for [Firefox program folder]\defaults\pref
pref("general.config.obscure_value", 0);
// the file named in the following line must be in [Firefox program folder]
pref("general.config.filename", "userChrome.js");
// disable the sandbox to run unsafe code
pref("general.config.sandbox_enabled", false);
