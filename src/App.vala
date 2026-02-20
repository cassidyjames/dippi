/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2025 Cassidy James Blaede <c@ssidyjam.es>
 */

public class Dippi.App : Adw.Application {
    public App () {
        Object (
            application_id: APP_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var app_window = new MainWindow (this);
        app_window.present ();

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        set_accels_for_action ("app.quit", {
            "<Ctrl>Q",
            "<Ctrl>W",
        });

        quit_action.activate.connect (() => {
            if (app_window != null) {
                app_window.destroy ();
            }
        });
    }

    private static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }
}
