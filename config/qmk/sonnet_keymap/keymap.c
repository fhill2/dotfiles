/*
Copyright 2020 Álvaro "Gondolindrim" Volpato <alvaro.volpato@usp.br>

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

// qmk compile -kb mode/m75h -km sonnet_keymap
//


#include QMK_KEYBOARD_H
#include "os_detection.h"

enum custom_keycodes {
    OS_TILD = SAFE_RANGE,
};


const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT_ansi_blocker(
        KC_ESC  , KC_F1  , KC_F2  , KC_F3  , KC_F4  ,           KC_F5  , KC_F6,  KC_F7  , KC_F8  , KC_F9  , KC_F10 , KC_F11 , KC_F12,            KC_DEL ,
        OS_TILD, KC_1   , KC_2   , KC_3   , KC_4   , KC_5   , KC_6,   KC_7   , KC_8   , KC_9   , KC_0   , KC_MINS, KC_EQL , KC_BSPC,           KC_HOME,
        KC_TAB  , KC_Q   , KC_W   , KC_E   , KC_R   , KC_T   , KC_Y,   KC_U   , KC_I   , KC_O   , KC_P   , KC_LBRC, KC_RBRC, KC_BSLS,           KC_PGUP,
        KC_LCTL , KC_A   , KC_S   , KC_D   , KC_F   , KC_G   , KC_H,   KC_J   , KC_K   , KC_L   , KC_SCLN, KC_QUOT, KC_ENT ,                      KC_PGDN,
        KC_LSFT ,          KC_Z   , KC_X   , KC_C   , KC_V   , KC_B,   KC_N   , KC_M   , KC_COMM, KC_DOT , KC_SLSH, KC_RSFT,           KC_UP  , KC_END ,
        KC_LALT , KC_LGUI, KC_LWIN,                                 KC_SPC,                                 MO(4), KC_RCTL,           KC_LEFT, KC_DOWN, KC_RGHT
    ),
    [1] = LAYOUT_ansi_blocker(
        _______, _______, _______, _______, _______,           _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           KC_MUTE,
        KC_TAB, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           KC_VOLU,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,                      KC_VOLD,
        _______,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______, KC_MPLY,
        _______, _______, _______,                                 _______,                                 _______, _______,           _______, _______, _______
    ),

    [2] = LAYOUT_ansi_blocker(
        _______, _______, _______, _______, _______,           _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_F1, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,                      _______,
        KC_F2,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______, _______,
        KC_F3, _______, KC_LALT,                                 _______,                                 _______, _______,           _______, _______, _______
    ),
    [3] = LAYOUT_ansi_blocker(
        _______, _______, _______, _______, _______,           _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_TAB, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______,
        KC_LCTL, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,                      _______,
        KC_F2,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______, _______,
        KC_F3, _______, KC_LALT,                                 _______,                                 _______, _______,           _______, _______, _______
    ),
    [4] = LAYOUT_ansi_blocker(
        _______, _______, _______, _______, _______,           _______, _______, _______, _______, _______, _______, _______, _______,          _______,
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           DF(0),
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,          DF(1),
        _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,                      DF(2),
        _______,          _______, _______, _______, _______, _______, _______, _______, _______, _______, _______, _______,           _______, DF(3),
        _______, _______, _______,                                 _______,                                 _______, _______,           _______, _______, _______
    )
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (record->event.pressed) {
        if (keycode == OS_TILD) {
            uint16_t key_to_send;

            // --- THE CRITICAL FIX ---
            // Use the documented function: detected_host_os()
            if (detected_host_os() == OS_MACOS) {
                // If on macOS, send the keycode that worked for Grave/Tilde
                key_to_send = KC_NONUS_BACKSLASH;
            } else {
                // Otherwise (Windows/Linux), send the keycode that works there
                key_to_send = KC_TILD;
            }

            tap_code(key_to_send);
            return false; // Handled
        }
    }
    return true; // Pass through
}
