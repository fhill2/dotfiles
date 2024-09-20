// https://docs.qmk.fm/config_options#behaviors-that-can-be-configured

// Settings for MODTAP - HYPER TAB
#define TAPPING_TERM 200 // 65535

// If Tab Pressed, WAIT >TAPPING_TERM, Tab Released
// Tab will still be sent instead of a NOOP
#define RETRO_TAPPING

// If Tab Pressed, WAIT >TAPPING_TERM, Tab Released
// With NO QUICK_TAP_TERM: Tab Pressed will send Tab Pressed, Tab Released (we don't want this)
// With QUICK_TAP_TERM: Tab Pressed will perform like normal
#define QUICK_TAP_TERM 200
// If another key is pressed while holding <Tab> during the TAPPING_TERM window
// the other key will be modified with <Hyper>
#define HOLD_ON_OTHER_KEY_PRESS


