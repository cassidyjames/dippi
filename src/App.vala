/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2021 Cassidy James Blaede <c@ssidyjam.es>
 */

public class Dippi.App : Gtk.Application {
    public App () {
        Object (application_id: "com.github.cassidyjames.dippi",
        flags: ApplicationFlags.FLAGS_NONE);
    }

    protected override void activate () {
        unowned var gtk_settings = Gtk.Settings.get_default ();
        unowned var granite_settings = Granite.Settings.get_default ();

        gtk_settings.gtk_cursor_theme_name = "elementary";
        gtk_settings.gtk_icon_theme_name = "elementary";
        gtk_settings.gtk_theme_name = "io.elementary.stylesheet.grape";

        gtk_settings.gtk_application_prefer_dark_theme = (
            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
        );

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
            );
        });

        var app_window = new MainWindow (this);
        app_window.show_all ();

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        set_accels_for_action ("app.quit", {"Escape"});

        quit_action.activate.connect (() => {
            if (app_window != null) {
                app_window.destroy ();
            }
        });
    }

    private static int main (string[] args) {
        Gtk.init (ref args);

        var app = new App ();
        return app.run (args);
    }
}
