/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2024 Cassidy James Blaede <c@ssidyjam.es>
 */

[GtkTemplate (ui = "/com/github/cassidyjames/dippi/ui/window.ui")]
public class NewWindow : Adw.ApplicationWindow {

    public NewWindow (Adw.Application app) {
        Object(application: app);
    }

    // private int recalculate_dpi (double inches, int width, int height) {
    //     if (inches > 0 && width > 0 && height > 0) {
    //         int calculated_dpi = Utils.dpi (inches, width, height);

    //         dpi_result_label.label = _("%d DPI").printf (calculated_dpi);

    //         recalculate_logical_resolution (width, height, calculated_dpi);
    //         return calculated_dpi;
    //     }

    //     dpi_result_label.label = "";
    //     logical_resolution_label.label = "";
    //     return 0;
    // }
}
