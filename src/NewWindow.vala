/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2024 Cassidy James Blaede <c@ssidyjam.es>
 */

[GtkTemplate (ui = "/com/github/cassidyjames/dippi/ui/window.ui")]
public class NewWindow : Adw.ApplicationWindow {

    public NewWindow (Adw.Application app) {
        Object(application: app);
    }
}
