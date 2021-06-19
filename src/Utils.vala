/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2021 Cassidy James Blaede <c@ssidyjam.es>
 */

namespace Dippi.Utils {
    public enum DisplayType {
        INTERNAL,
        EXTERNAL;

        public string to_string () {
            switch (this) {
                case INTERNAL:
                    return _("Laptop");

                case EXTERNAL:
                    return _("Desktop");

                default:
                    assert_not_reached ();
            }
        }

        public string icon_suffix () {
            switch (this) {
                case INTERNAL:
                    return "-notebook";

                case EXTERNAL:
                    return "";

                default:
                    assert_not_reached ();
            }
        }
    }

    public int dpi (double inches, int width, int height) {
        double unrounded_dpi = Math.sqrt (
            Math.pow (width, 2) +
            Math.pow (height, 2)
        ) / inches;
        int rounded_dpi = (int)unrounded_dpi;

        return rounded_dpi;
    }

    public int greatest_common_divisor (int a, int b) {
        if (a == 0) {
            return b;
        }

        if (b == 0) {
            return a;
        }

        if (a > b) {
            return greatest_common_divisor (a % b, b);
        } else {
            return greatest_common_divisor (a, b % a);
        }
    }
}
