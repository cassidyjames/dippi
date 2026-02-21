/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2026 Cassidy James Blaede <c@ssidyjam.es>
 */

[GtkTemplate (ui = "/com/cassidyjames/dippi/dippi.ui")]
public class Dippi.MainWindow : Adw.ApplicationWindow {
    private const int DEFAULT_ASPECT_WIDTH = 16;
    private const int DEFAULT_ASPECT_HEIGHT = 9;

    private const int INTERNAL_IDEAL_DPI = 140;
    private const int INTERNAL_IDEAL_RANGE = 16;
    private const int INTERNAL_UNCLEAR_RANGE = 14;

    private const int EXTERNAL_IDEAL_DPI = 120;
    private const int EXTERNAL_IDEAL_RANGE = 30;
    private const int EXTERNAL_UNCLEAR_RANGE = 20;

    private const double INCHES_INFER_EXTERNAL = 18;
    private const int DPI_INFER_HIDPI = 192; // According to GNOME and elementary

    private double inches = 0.0;
    private int width = 0;
    private int height = 0;
    private bool is_default_width = true;
    private bool is_default_height = true;

    [GtkChild]
    private unowned Gtk.Image diagram;
    [GtkChild]
    private unowned Gtk.Label dpi_result_label;
    [GtkChild]
    private unowned Gtk.Label logical_resolution_label;
    [GtkChild]
    private unowned Gtk.Label aspect_result_label;
    [GtkChild]
    private unowned Gtk.LinkButton link_button;
    [GtkChild]
    private unowned Adw.ToggleGroup type_group;
    [GtkChild]
    private unowned Adw.NavigationSplitView split_view;
    [GtkChild]
    private unowned Gtk.Stack range_stack;
    [GtkChild]
    private unowned Adw.SpinRow diag_entry;
    [GtkChild]
    private unowned Adw.SpinRow width_entry;
    [GtkChild]
    private unowned Adw.SpinRow height_entry;

    private Utils.DisplayType display_type;

    private SimpleAction calculate_action;

    private Gtk.EventControllerFocus width_entry_focus_ctrl;
    private Gtk.EventControllerFocus height_entry_focus_ctrl;

    public MainWindow (Adw.Application application) {
        Object (
            application: application
        );
    }

    construct {
var about_dialog = new Adw.AboutDialog.from_appdata (
            "/com/cassidyjames/dippi/metainfo.xml", VERSION
        ) {
            comments = _("Input a few simple details and figure out the aspect ratio, DPI, and other details of a particular display. Great for deciding which laptop or external monitor to purchase, and if it would be considered HiDPI."),
            artists = {
                "Micah Ilbery https://micahilbery.com",
            },
            /// The translator credits. Please translate this with your name(s).
            translator_credits = _("translator-credits"),
        };
        about_dialog.developers = {
            "%s %s".printf (
                about_dialog.developer_name,
                about_dialog.website
            ),
        };
        about_dialog.designers = {
            "%s %s".printf (
                about_dialog.developer_name,
                about_dialog.website
            ),
        };
        about_dialog.copyright = "© 2018–%i %s".printf (
            new DateTime.now_local ().get_year (),
            about_dialog.developer_name
        );
        this.icon_name = about_dialog.application_icon;
        this.title = about_dialog.application_name;

        var about_action = new SimpleAction ("about", null);
        about_action.activate.connect (() => about_dialog.present (this));

        calculate_action = new SimpleAction ("calculate", null);
        calculate_action.set_enabled (false);
        calculate_action.activate.connect (() => split_view.show_content = true);

        var action_group = new SimpleActionGroup ();
        action_group.add_action (about_action);
        action_group.add_action (calculate_action);
        this.insert_action_group ("win", action_group);

        link_button.remove_css_class ("flat");
        link_button.remove_css_class ("link");

        var direction = "diagonal";

        var diag_entry_focus_ctrl = new Gtk.EventControllerFocus ();
        diag_entry.add_controller (diag_entry_focus_ctrl);

        width_entry_focus_ctrl = new Gtk.EventControllerFocus ();
        width_entry.add_controller (width_entry_focus_ctrl);

        height_entry_focus_ctrl = new Gtk.EventControllerFocus ();
        height_entry.add_controller (height_entry_focus_ctrl);

        diag_entry_focus_ctrl.enter.connect ((event) => {
            direction = "diagonal";
            set_display_icon (direction);
        });

        width_entry_focus_ctrl.enter.connect ((event) => {
            direction = "horizontal";
            set_display_icon (direction);
        });

        height_entry_focus_ctrl.enter.connect ((event) => {
            direction = "vertical";
            set_display_icon (direction);
        });

        diag_entry.notify["value"].connect (() => {
            inches = diag_entry.value;
            assess_dpi (
                recalculate_dpi (inches, width, height),
                infer_display_type (inches)
            );
        });

        width_entry.notify["value"].connect (() => {
            width = (int) width_entry.value;
            if (width != 0) {
                is_default_width = false;
                recalculate_aspect (width, height);
                assess_dpi (
                    recalculate_dpi (inches, width, height),
                    display_type
                );

                if (!height_entry_focus_ctrl.contains_focus && (is_default_height || height == 0)) {
                    double calculated_height = Math.round (
                        width *
                        DEFAULT_ASPECT_HEIGHT /
                        DEFAULT_ASPECT_WIDTH
                    );
                    height_entry.value = calculated_height;
                    is_default_height = true;
                }
            }
        });

        height_entry.notify["value"].connect (() => {
            height = (int) height_entry.value;
            if (height != 0) {
                is_default_height = false;
                recalculate_aspect (width, height);
                assess_dpi (
                    recalculate_dpi (inches, width, height),
                    display_type
                );

                if (!width_entry_focus_ctrl.contains_focus && (is_default_width || width == 0)) {
                    double calculated_width = Math.round (
                        height *
                        DEFAULT_ASPECT_WIDTH /
                        DEFAULT_ASPECT_HEIGHT
                    );
                    width_entry.value = calculated_width;
                    is_default_width = true;
                }
            }
        });

        type_group.notify["active"].connect (() => {
            display_type = type_group.active == 0
                ? Utils.DisplayType.INTERNAL
                : Utils.DisplayType.EXTERNAL;
            assess_dpi (Utils.dpi (inches, width, height), display_type);
            set_display_icon (direction);
        });

        diag_entry.grab_focus ();
    }

    private int recalculate_dpi (double inches, int width, int height) {
        if (inches > 0 && width > 0 && height > 0) {
            int calculated_dpi = Utils.dpi (inches, width, height);

            dpi_result_label.label = _("%d DPI").printf (calculated_dpi);

            recalculate_logical_resolution (width, height, calculated_dpi);
            return calculated_dpi;
        }

        dpi_result_label.label = "";
        logical_resolution_label.label = "";
        return 0;
    }

    private void recalculate_aspect (int width, int height) {
        if (width > 0 && height > 0) {
            aspect_result_label.label = Utils.common_ratio (width, height);
        } else {
            aspect_result_label.label = "";
        }
    }

    private void recalculate_logical_resolution (int width, int height, int dpi) {
        if (width > 0 && height > 0) {
            if (dpi >= DPI_INFER_HIDPI) {
                int scaling_factor = 2;
                int logical_width = (int)(width / scaling_factor);
                int logical_height = (int)(height / scaling_factor);

                logical_resolution_label.label = "%d×%d@%dx".printf (
                    logical_width,
                    logical_height,
                    scaling_factor
                );
            } else {
                logical_resolution_label.label = "%d×%d".printf (width, height);
            }
        } else {
            logical_resolution_label.label = "";
        }
    }

    private void assess_dpi (double calculated_dpi, Utils.DisplayType display_type) {
        int ideal_dpi = INTERNAL_IDEAL_DPI;
        int ideal_range = INTERNAL_IDEAL_RANGE;
        int unclear_range = INTERNAL_UNCLEAR_RANGE;

        if (display_type == Utils.DisplayType.EXTERNAL) {
            ideal_dpi = EXTERNAL_IDEAL_DPI;
            ideal_range = EXTERNAL_IDEAL_RANGE;
            unclear_range = EXTERNAL_UNCLEAR_RANGE;
        }

        if (inches == 0 || width == 0 || height == 0) {
            range_stack.visible_child_name = "invalid";
            link_button.visible = false;
        } else if (calculated_dpi < ideal_dpi - ideal_range - INTERNAL_UNCLEAR_RANGE) {
            range_stack.visible_child_name = "low";
            link_button.visible = true;
        } else if (calculated_dpi < ideal_dpi - ideal_range) {
            range_stack.visible_child_name = "lodpi-low";
            link_button.visible = true;
        } else if (calculated_dpi <= ideal_dpi + ideal_range) {
            range_stack.visible_child_name = "lodpi-ideal";
            link_button.visible = true;
        } else if (calculated_dpi <= ideal_dpi + ideal_range + unclear_range) {
            range_stack.visible_child_name = "lodpi-high";
            link_button.visible = true;
        } else if (calculated_dpi < DPI_INFER_HIDPI) {
            range_stack.visible_child_name = "lodpi-should-be-hidpi";
            link_button.visible = true;
        } else if (calculated_dpi < (ideal_dpi - ideal_range - unclear_range) * 2) {
            range_stack.visible_child_name = "unclear";
            link_button.visible = true;
        } else if (calculated_dpi < (ideal_dpi - ideal_range) * 2) {
            range_stack.visible_child_name = "hidpi-low";
            link_button.visible = true;
        } else if (calculated_dpi <= (ideal_dpi + ideal_range) * 2) {
            range_stack.visible_child_name = "hidpi-ideal";
            link_button.visible = true;
        } else if (calculated_dpi <= (ideal_dpi + ideal_range + unclear_range) * 2) {
            range_stack.visible_child_name = "hidpi-high";
            link_button.visible = true;
        } else if (calculated_dpi > (ideal_dpi + ideal_range + unclear_range) * 2) {
            range_stack.visible_child_name = "high";
            link_button.visible = true;
        } else {
            range_stack.visible_child_name = "invalid";
            link_button.visible = false;
        }

        string type_param = "d";
        if (display_type == Utils.DisplayType.INTERNAL) {
            type_param = "l";
        }

        link_button.uri = "https://cassidyjames.com/dippi/?d=%g&w=%d&h=%d&t=%s".printf (
            inches,
            width,
            height,
            type_param
        );

        calculate_action.set_enabled (link_button.visible);
    }

    private Utils.DisplayType infer_display_type (double inches) {
        if (inches < INCHES_INFER_EXTERNAL) {
            display_type = Utils.DisplayType.INTERNAL;
            type_group.active = 0;
        } else {
            display_type = Utils.DisplayType.EXTERNAL;
            type_group.active = 1;
        }

        return display_type;
    }

    private void set_display_icon (string direction) {
        diagram.icon_name = "display-measure-" + direction + display_type.icon_suffix ();
    }
}
