/* Copyright 2021 Glorious, LLC <salman@pcgamingrace.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
// How to Install QMK on a fresh install (bootstrap):
// git clone https://github.com/qmk/qmk_firmware $HOME/qmk_firmware
// This symlink has to exist otherwise qmk compile / flash cannot find the keymap:
// ~/dot/config/qmk/fhill2_keymap -> ~/qmk_firmware/keyboards/gmmk/pro/rev1/ansi/keymaps
// Now run this to compile / flash:
// cd ~/qmk_firmware/keyboards/gmmk/pro/rev1/ansi/keymaps
// qmk setup
// qmk compile -kb gmmk/pro/rev1/ansi -km fhill2_keymap
// qmk flash -kb gmmk/pro/rev1/ansi -km fhill2_keymap
//
// HOW TO FLASH GMMK AFTER qmk compile
// https://www.gloriousgaming.com/en-uk/blogs/guides-resources/gmmk-2-qmk-installation-guide
// Note Linux does not support QMK Toolbox so flashing has to be done on the CLI
// https://docs.qmk.fm/newbs_flashing#flash-your-keyboard-from-the-command-line

// "qmk flash" into CLI
// Then - Unplug GMMK keyboard, hold <RAlt>|<MO(1)> and <\> while replugging the USB cable
// This is the QK_BOOT in the keymap
// NOTE: you dont need an extra keyboard, as qmk flash repeatedly tries to flash...

// If flashing fails the keyboard will be unresponsive and entering bootloader mode using keys won't be available
// If this happens, open the GMMK Pro and hold the button on the PCB board called "BOOT" while plugging the cable in

// MOD-TAP HYPER|TAB Configuration:
// https://docs.qmk.fm/tap_hold
//
// https://docs.qmk.fm/keycodes_magic
// Swap keycodes -> permanently enabled across restarts
// DF(1) key -> enables default mapping
// Ended up using this instead of the magic keycodes
//



#include "print.h"
/* #include "action_tapping.h" */

#include QMK_KEYBOARD_H

enum custom_keycodes {
    MG_EMACRO = SAFE_RANGE,
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

//      ESC      F1       F2       F3       F4       F5       F6       F7       F8       F9       F10      F11      F12	     Prt           Rotary(Mute)
//      ~        1        2        3        4        5        6        7        8        9        0         -       (=)	     BackSpc           Del
//      Tab      Q        W        E        R        T        Y        U        I        O        P        [        ]        \                 PgUp
//      Caps     A        S        D        F        G        H        J        K        L        ;        "                 Enter             PgDn
//      Sh_L              Z        X        C        V        B        N        M        ,        .        ?                 Sh_R     Up       End
//      Ct_L     Win_L    Alt_L                               SPACE                               Alt_R    FN       Ct_R     Left     Down     Right


    // The FN key by default maps to a momentary toggle to layer 1 to provide access to the QK_BOOT key (to put the board into bootloader mode). Without
    // this mapping, you have to open the case to hit the button on the bottom of the PCB (near the USB cable attachment) while plugging in the USB
    // cable to get the board into bootloader mode - definitely not fun when you're working on your QMK builds. Remove this and put it back to KC_RGUI
    // if that's your preference.
    //
    // To put the keyboard in bootloader mode, use FN+backslash. If you accidentally put it into bootloader, you can just unplug the USB cable and
    // it'll be back to normal when you plug it back in.
    //
    // This keyboard defaults to 6KRO instead of NKRO for compatibility reasons (some KVMs and BIOSes are incompatible with NKRO).
    // Since this is, among other things, a "gaming" keyboard, a key combination to enable NKRO on the fly is provided for convenience.
    // Press Fn+N to toggle between 6KRO and NKRO. This setting is persisted to the EEPROM and thus persists between restarts.
    // KC_CAPS

    [0] = LAYOUT(
        KC_ESC,  KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  KC_F11,  KC_F12,  KC_DEL,          KC_MUTE,
        KC_GRV,  KC_1,    KC_2,    KC_3,    KC_4,    KC_5,    KC_6,    KC_7,    KC_8,    KC_9,    KC_0,    KC_MINS, KC_EQL,  KC_BSPC,          KC_HOME,
        LCAG_T(KC_TAB),  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,    KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_LBRC, KC_RBRC, KC_BSLS,          KC_END,
        KC_LCTL, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,    KC_H,    KC_J,    KC_K,    KC_L,    KC_SCLN, KC_QUOT,          KC_ENT,           KC_PGUP,
        KC_LSFT,          KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,    KC_N,    KC_M,    KC_COMM, KC_DOT,  KC_SLSH,          KC_RSFT, KC_UP,   KC_PGDN,
        KC_LALT, KC_LGUI, KC_LALT,                            KC_SPC,                             KC_RALT, MO(4),   KC_RCTL, KC_LEFT, KC_DOWN, KC_RGHT
    ),
    // Default Layer containing only CAPS->LCTRL 
    // RAlt + backspace switches to this layer
    [1] = LAYOUT(
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_TAB, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_LCTL, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,           _______,
        _______,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______, _______,  _______,
        KC_LCTL, _______, _______,                            _______,                            _______, _______, _______, _______, _______, _______
    ),
    // Gaming
    [2] = LAYOUT(
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_F1, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,           _______,
        KC_F2,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______, _______,  _______,
        KC_F3, _______, _______,                            _______,                            _______, _______, _______, _______, _______, _______
    ),

    // Gaming
    [3] = LAYOUT(
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_TAB, _______, _______, MG_EMACRO, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_LCTL, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,           _______,
        KC_F2,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______, _______,  _______,
        KC_F3, _______, _______,                            _______,                            _______, _______, _______, _______, _______, _______
    ),



    // Fn Keyboard Layer
    // https://docs.qmk.fm/keycodes_magic
    // Modifications -> CL_SWAP -> disables Ctrl and reverts to CapsLock
    // RAlt 1 -> Disable all RGB
    [4] = LAYOUT(
        QK_CLEAR_EEPROM, KC_MYCM, KC_WHOM, KC_CALC, KC_MSEL, KC_MPRV, KC_MNXT, KC_MPLY, KC_MSTP, KC_MUTE, KC_VOLD, KC_VOLU, _______, CL_NORM,   _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           DF(0),
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, QK_BOOT,           DF(1),
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          _______,           DF(2),
        _______,          _______, _______, _______, _______, _______, NK_TOGG, _______, _______, _______, _______,          _______, _______,  DF(3),
        _______, _______, _______,                            _______,                            _______, _______, _______, _______, _______, _______
    ),




};
// clang-format on

/* #if defined(ENCODER_MAP_ENABLE) */
/* const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = { */
/*     [0] = { ENCODER_CCW_CW(KC_VOLD, KC_VOLU) }, */
/*     [1] = { ENCODER_CCW_CW(_______, _______) }, */
/*     [2] = { ENCODER_CCW_CW(_______, _______) }, */
/*     [3] = { ENCODER_CCW_CW(_______, _______) }, */
/*     [4] = { ENCODER_CCW_CW(_______, _______) }, */
/* }; */
/* #endif */



// DEBUGGING
// https://docs.qmk.fm/faq_debug

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case MG_EMACRO:
            if (record->event.pressed) {
                // When the key is pressed, register the keys sequentially.
                // Step 1: Press and release F11.
                /* register_code(KC_F11); */
                /* unregister_code(KC_F11); */
                /**/
                /* // Step 2: Press and release 'e'. */
                /* register_code(KC_E); */
                /* unregister_code(KC_E); */

                // Step 1: Tap the F11 key
                /* tap_code16(KC_E); */
                /* SEND_STRING(SS_TAP(KC_E) SS_DELAY(300) SS_TAP(KC_F11)); */
                tap_code(KC_E);
                /* wait_ms(500); */
                tap_code_delay(KC_F11, 300);
                // Add a non-blocking delay of 100 milliseconds
                /* tap_macro_wait(300); */

                // Step 2: Tap the 'e' key
                /* tap_code16(KC_F11); */

            }
            return false; // Return false to indicate that the key has been handled.
    }
    return true; // Return true for all other keycodes to be processed normally.
}
