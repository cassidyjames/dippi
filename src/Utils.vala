/*
* Copyright © 2018–2020 Cassidy James Blaede (https://cassidyjames.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Cassidy James Blaede <c@ssidyjam.es>
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

    public enum Range {
        LOW,
        LODPI_LOW,
        LODPI_IDEAL,
        LODPI_HIGH,
        HIDPI_LOW,
        HIDPI_IDEAL,
        HIDPI_HIGH,
        HIGH,
        UNCLEAR,
        INVALID;

        public string title () {
            switch (this) {
                case LOW:
                    return _("Very Low DPI");

                case LODPI_LOW:
                    return _("Fairly Low DPI");

                case LODPI_IDEAL:
                    return _("Ideal for LoDPI");

                case LODPI_HIGH:
                case HIDPI_LOW:
                case UNCLEAR:
                    return _("Potentially Problematic");

                case HIDPI_IDEAL:
                    return _("Ideal for HiDPI");

                case HIDPI_HIGH:
                    return _("Fairly High for HiDPI");

                case HIGH:
                    return _("Too High DPI");

                case INVALID:
                    return _("Analyze a Display");

                default:
                        assert_not_reached ();
            }
        }

        public string description () {
            switch (this) {
                case LOW:
                    return _("Text and UI are likely to be too big for typical viewing distances. Avoid if possible.");

                case LODPI_LOW:
                    return _("Text and UI might be too big for typical viewing distances, but it's largely up to user preference and physical distance from the display.");

                case LODPI_IDEAL:
                    return _("Not HiDPI, but a nice sweet spot. Text and UI should be legible at typical viewing distances.");

                case LODPI_HIGH:
                    return _("Relatively high resolution, but not quite HiDPI. Text and UI may be too small by default, but forcing HiDPI would make them appear too large. The experience may be slightly improved by increasing the text size.");

                case HIDPI_LOW:
                    return _("HiDPI by default, but text and UI may appear too large. Turning off HiDPI and increasing the text size might help.");

                case HIDPI_IDEAL:
                    return _("Crisp HiDPI text and UI along with a readable size at typical viewing distances. This is the jackpot.");

                case HIDPI_HIGH:
                    return _("Text and UI are likely to appear too small for typical viewing distances. Increasing the text size may help.");

                case HIGH:
                    return _("Text and UI will appear too small for typical viewing distances.");

                case UNCLEAR:
                    return _("This display is in a very tricky range and is not likely to work well with integer scaling out of the box.");

                case INVALID:
                    return _("Enter details about a display to analyze it.");

                default:
                        assert_not_reached ();
            }
        }

        public string icon () {
            switch (this) {
                case LOW:
                case HIGH:
                    return "dialog-error";

                case LODPI_LOW:
                case LODPI_HIGH:
                case HIDPI_LOW:
                case HIDPI_HIGH:
                case UNCLEAR:
                    return "dialog-warning";

                case LODPI_IDEAL:
                case HIDPI_IDEAL:
                    return "process-completed";

                case INVALID:
                    return "dialog-information";

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
