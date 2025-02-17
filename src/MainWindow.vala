/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2025 Cassidy James Blaede <c@ssidyjam.es>
 */

[GtkTemplate (ui = "/com/cassidyjames/leanback/MainWindow.ui")]
public class MainWindow : Adw.ApplicationWindow {

    public MainWindow (Adw.Application app) {
        Object(application: app);
    }

    [GtkChild]
    unowned Gtk.FlowBox flowbox;

    construct {
        // var pool = new AppStream.Pool ();
        // pool.reset_extra_data_locations ();
        // pool.add_extra_data_location (
        //     "/run/host/usr/share/metainfo/",
        //     AppStream.FormatStyle.METAINFO
        // );
        // pool.set_flags (pool.get_flags () | AppStream.PoolFlags.LOAD_FLATPAK);

        foreach (var app in AppInfo.get_all ()) {
            var id = app.get_id ();
            var name = app.get_name ();

            var desktop = flatpakify(new DesktopAppInfo (id));

            if (desktop.should_show ()) {
                var icon = app.get_icon ();

                var image = new Gtk.Image.from_gicon (icon) {
                    css_classes = { "icon-dropshadow" },
                    icon_size = Gtk.IconSize.LARGE,
                    margin_top = 12,
                    margin_bottom = 12,
                    pixel_size = 128,
                };

                var label = new Gtk.Label (name) {
                    margin_top = 12,
                    margin_bottom = 12,
                };

                var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
                box.append (image);
                box.append (label);

                var button = new Gtk.Button () {
                    child = box,
                    css_classes = { "card" },
                };

                button.clicked.connect (() => {
                    message ("Go go gadget %s", desktop.get_commandline ());

                    // var context = Gdk.Display.get_default ().get_app_launch_context ();

                    desktop.launch (null, new AppLaunchContext ());
                });

                message ("✅ %s (%s)", name, id);
                flowbox.append (button);
            } else {
                message ("🙈 %s (%s)", name, id);
            }

            // if (desktop_app.get_boolean ("Terminal")) {
            //     continue;
            // }
        }

        // appstream_pool.load_async.begin (null, (obj, res) => {
        //     try {
        //         var loaded = appstream_pool.load_async.end (res);

        //         foreach (var app in app_entries) {
        //             critical (app);
        //             var component_table = new HashTable<string, AppStream.Component> (str_hash, str_equal);

        //             appstream_pool.get_components_by_id (app).as_array ().foreach ((component) => {
        //                 if (component_table[component.id] == null) {
        //                     component_table[component.id] = component;

        //                     var item = new Gtk.Label (component.name) {
        //                         vexpand = true,
        //                         hexpand = true,
        //                         width_request = 128,
        //                         height_request = 128,
        //                         css_classes = { "emoji", "card" }
        //                     };

        //                     critical ("appending %s", app);
        //                     flowbox.append (item);

                            // var repo_row = new RepoRow (
                            //     component.name,
                            //     icon_from_appstream_component (component),
                            //     Category.DEFAULT_APPS,
                            //     component.get_url (AppStream.UrlKind.BUGTRACKER)
                            // );

                            // listbox.append (repo_row);
        //                 }
        //             });
        //         }
        //     } catch (Error e) {
        //         critical (e.message);
        //     }
        // });
    }

    private string prefix_exec(string exec) {
        // Adapted from https://github.com/sonnyp/Junction/blob/112563b36352e3341eb9ce37c403eead1215d4ad/src/util.js#L185

        // var filename = app_info.get_filename ();
        // if (filename != null) {
        //     return app_info;
        // }

        // var key_file = new KeyFile ();
        // if (!key_file.load_from_file (filename, KeyFileFlags.NONE)) {
        //     critical("Could not load %s", filename);
        //     return null;
        // }

        // var exec = key_file.get_value ("Desktop Entry", "Exec");
        // if (exec != null) {
        //     critical ("No exec for %s", filename);
        //     return null;
        // }

        if (exec.has_prefix ("flatpak-spawn")) {
            return exec;
        } else if (Environment.get_variable ("FLATPAK_ID") != null) {

        }

        key_file.set_value ("Desktop Entry", "Exec", prefix_command_for_host (exec));

        return prefix_command_for_host (exec);
    }

    private string prefix_command_for_host (string command) {
      if (Environment.get_variable ("FLATPAK_ID") != null) {
        critical ("Flatpak!");
        return "flatpak-spawn --host %s".printf (command);
      }
      return command;
    }
}
