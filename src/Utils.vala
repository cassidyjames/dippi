/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2024 Cassidy James Blaede <c@ssidyjam.es>
 */

namespace Dippi.Utils {
    public enum DisplayType {
        INTERNAL,
        EXTERNAL;

        public string to_string () {
            switch (this) {
                case INTERNAL:
                    ///TRANSLATORS: label for the button to select an internal/laptop display
                    return _("Laptop");

                case EXTERNAL:
                    ///TRANSLATORS: label for the button to select an external/desktop monitor
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

    public string common_ratio (int width, int height) {
        // We don't need every possible resolution/aspect ratio handled here, but
        // https://en.wikipedia.org/wiki/List_of_computer_display_standards
        // is a decent place to check. For now, this is just case-by-case for
        // common resolutions and aspect ratios we've seen in the wild.
        //
        // We can also use this to catch "backwards" ratios, e.g. portrait
        // displays (like on a smartphone).
        //
        // In general, put the true (or approximately true) ratio first, then put
        // any other aspect ratio (like one used in marketing) in parenthesis.

        int aspect_width = width / greatest_common_divisor (width, height);
        int aspect_height = height / greatest_common_divisor (width, height);

        string aspect_string = "%i:%i".printf (aspect_width, aspect_height);

        switch (aspect_string) {
            case "1:2":
            case "2:1":
                return "2:1 (18:9)";

            case "5:8":
            case "8:5":
                return "8:5 (16:10)";

            // Some smartphones
            case "18:37":
            case "37:18":
                return "37:18 (18.5:9)";

            // Pretty much just iPhone absurdity
            case "422:195":
            case "195:422":
            case "466:215":
            case "215:466":
            case "284:131":
            case "131:284":
            case "463:214":
            case "214:463":
            case "448:207":
            case "207:448":
            case "812:375":
            case "375:812":
            case "6:13":
            case "13:6":
                return "13:6 (19.5:9)";

            case "84:187":
            case "187:84":
            case "101:45":
            case "45:101":
                return "20:9";

            case "3:7":
            case "7:3":
            // e.g. 3440×1440
            case "43:18":
                return "7:3 (21:9)";

            // 1360×768
            case "48:85":
            case "85:48":
            // 1366×768
            case "384:683":
            case "683:384":
            // iPhone 6–8
            case "667:375":
            case "375:667":
            // iPhone 5
            case "71:40":
            case "40:71":
                return "16:9";

            default:
                return aspect_string;
        }
    }
}
