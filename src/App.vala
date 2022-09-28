/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2022 Cassidy James Blaede <c@ssidyjam.es>
 */

public class Dippi.App : Adw.Application {
    public const string NAME = "Dippi";
    public const string DEVELOPER = "Cassidy James Blaede";

    public App () {
        Object (
            application_id: APP_ID,
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var app_window = new MainWindow (this);
        app_window.show ();

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
        var app = new App ();
        return app.run (args);
    }
}
