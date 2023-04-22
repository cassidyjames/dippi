/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2023 Cassidy James Blaede <c@ssidyjam.es>
 */

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
    private const int DPI_INFER_HIDPI = 192; // According to GNOME

    private int aspect_width = DEFAULT_ASPECT_WIDTH;
    private int aspect_height = DEFAULT_ASPECT_HEIGHT;

    private double inches = 0.0;
    private int width = 0;
    private int height = 0;
    private bool is_default_display_type = true;
    private bool is_default_width = true;
    private bool is_default_height = true;

    private Gtk.Image diagram;
    private Gtk.Label dpi_result_label;
    private Gtk.Label logical_resolution_label;
    private Gtk.Label aspect_result_label;
    private Gtk.LinkButton link_button;
    private Gtk.ToggleButton internal_button;
    private Gtk.ToggleButton external_button;
    private Gtk.Stack range_stack;
    private Utils.DisplayType display_type;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            icon_name: APP_ID,
            resizable: false,
            title: App.NAME
        );
    }

    construct {
        var about_button = new Gtk.Button.from_icon_name ("about-symbolic") {
            tooltip_text = _("About")
        };
        about_button.add_css_class ("dim-label");

        var about_window = new Adw.AboutWindow () {
            transient_for = this,
            hide_on_close = true,

            application_icon = APP_ID,
            application_name = App.NAME,
            developer_name = App.DEVELOPER,
            version = VERSION,

            comments = _("Input a few simple details and figure out the aspect ratio, DPI, and other details of a particular display. Great for deciding which laptop or external monitor to purchase, and if it would be considered HiDPI."),

            website = "https://cassidyjames.com/dippi",
            issue_url = "https://github.com/cassidyjames/dippi/issues",

            // Credits
            developers = { "%s <%s>".printf (App.DEVELOPER, App.EMAIL) },
            designers = { "%s %s".printf (App.DEVELOPER, App.URL) },
            artists = {
                "Micah Ilbery https://micahilbery.com",
            },
            /// The translator credits. Please translate this with your name(s).
            translator_credits = _("translator-credits"),

            // Legal
            copyright = "Copyright © 2018–2023 %s".printf (App.DEVELOPER),
            license_type = Gtk.License.GPL_3_0,
        };

        var header = new Adw.HeaderBar () {
            title_widget = new Gtk.Label (null)
        };
        header.add_css_class ("flat");
        header.pack_start (about_button);

        diagram = new Gtk.Image () {
            icon_name = APP_ID,
            margin_bottom = 12,
            pixel_size = 128
        };

        var diag_label = new Gtk.Label (_("Diagonal size:")) {
            halign = Gtk.Align.END
        };

        var diag_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };
        var diag_entry_focus_controller = new Gtk.EventControllerFocus ();
        diag_entry.add_controller (diag_entry_focus_controller);

        var res_label = new Gtk.Label (_("Resolution:")) {
            halign = Gtk.Align.END
        };

        var width_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };
        var width_entry_focus_controller = new Gtk.EventControllerFocus ();
        width_entry.add_controller (width_entry_focus_controller);

        var height_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };
        var height_entry_focus_controller = new Gtk.EventControllerFocus ();
        height_entry.add_controller (height_entry_focus_controller);

        var x_label = new Gtk.Label (_("×"));
        var px_label = new Gtk.Label (_("px"));

        var inches_label = new Gtk.Label (_("inches")) {
            halign = Gtk.Align.START
        };

        var type_label = new Gtk.Label (_("Type:")) {
            halign = Gtk.Align.END
        };

        internal_button = new Gtk.ToggleButton () {
            label = Utils.DisplayType.INTERNAL.to_string ()
        };

        external_button = new Gtk.ToggleButton () {
            group = internal_button,
            label = Utils.DisplayType.EXTERNAL.to_string ()
        };

        var type_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        type_buttons.add_css_class ("linked");
        type_buttons.append (internal_button);
        type_buttons.append (external_button);

        var data_grid = new Gtk.Grid () {
            column_spacing = 6,
            margin_start = margin_end = 24,
            margin_top = 0,
            row_spacing = 6
        };

        data_grid.attach (diagram, 0, 0, 5);
        data_grid.attach (diag_label, 0, 1);
        data_grid.attach (diag_entry, 1, 1);
        data_grid.attach (inches_label, 2, 1, 2);
        data_grid.attach (res_label, 0, 2);
        data_grid.attach (width_entry, 1, 2);
        data_grid.attach (x_label, 2, 2);
        data_grid.attach (height_entry, 3, 2);
        data_grid.attach (px_label, 4, 2);
        data_grid.attach (type_label, 0, 3);
        data_grid.attach (type_buttons, 1, 3, 4);

        aspect_result_label = new Gtk.Label (null) {
            halign = Gtk.Align.START,
            margin_start = 32 + 6 + 6, // icon plus its margins
            valign = Gtk.Align.END
        };

        dpi_result_label = new Gtk.Label (null) {
            halign = Gtk.Align.START,
            valign = Gtk.Align.END
        };

        logical_resolution_label = new Gtk.Label (null) {
            halign = Gtk.Align.START,
            valign = Gtk.Align.END
        };

        link_button = new Gtk.LinkButton.with_label (
            "https://cassidyjames.com/dippi/",
            _("Share results…")
        ) {
            halign = Gtk.Align.END,
            valign = Gtk.Align.END,
            visible = false,
        };

        var invalid_range_grid = new RangeGrid (
            "loupe-large-symbolic",
            "accent",
            _("Analyze a Display"),
            _("For LoDPI, a DPI range of <b>90–150 is ideal for desktops</b> while <b>124–156 is ideal for laptops</b>.") + "\n\n" + _("For HiDPI, <b>180–300 is ideal for desktops</b> while <b>248–312 is ideal for laptops</b>.")
        );

        var low_range_grid = new RangeGrid (
            "dialog-error-symbolic",
            "error",
            _("Very Low DPI"),
            _("Text and UI are likely to be too big for typical viewing distances. <b>Avoid if possible.</b>")
        );

        var lodpi_low_range_grid = new RangeGrid (
            "dialog-warning-symbolic",
            "warning",
            _("Fairly Low DPI"),
            _("Text and UI might be too big for typical viewing distances, but it's <b>largely up to user preference</b> and physical distance from the display.")
        );

        var lodpi_ideal_range_grid = new RangeGrid (
            "test-pass-symbolic",
            "success",
            _("Ideal for LoDPI"),
            _("Not HiDPI, but <b>a nice sweet spot</b>. Text and UI should be legible at typical viewing distances.")
        );

        var lodpi_high_range_grid = new RangeGrid (
            "dialog-warning-symbolic",
            "warning",
            _("Potentially Problematic"),
            _("Relatively high resolution, but not quite HiDPI. Text and UI <b>may be too small by default</b>, but forcing HiDPI would make them appear too large. The experience may be slightly improved by increasing the text size.")
        );

        var lodpi_should_be_hidpi_range_grid = new RangeGrid (
            "settings-symbolic",
            "warning",
            _("Tweak for HiDPI"),
            _("This display may default to loDPI on some desktops, which could result in too-small text and UI. However, it <b>may be usable with HiDPI by manually enabling 2× scaling</b>. Further adjustments can be made by decreasing the text size.")
        );

        var unclear_range_grid = new RangeGrid (
            "dialog-warning-symbolic",
            "warning",
            _("Potentially Problematic"),
            _("This display is in a very tricky range and is <b>not likely to work well</b> with integer scaling out of the box.")
        );

        var hidpi_low_range_grid = new RangeGrid (
            "dialog-warning-symbolic",
            "warning",
            _("Potentially Problematic"),
            _("HiDPI by default, but <b>text and UI may appear too large</b>. Turning off HiDPI and increasing the text size might help.")
        );

        var hidpi_ideal_range_grid = new RangeGrid (
            "test-pass-symbolic",
            "success",
            _("Ideal for HiDPI"),
            _("Crisp HiDPI text and UI along with a readable size at typical viewing distances. <b>This is the jackpot.</b>")
        );

        var hidpi_high_range_grid = new RangeGrid (
            "dialog-warning-symbolic",
            "warning",
            _("Fairly High for HiDPI"),
            _("Text and UI are likely to appear <b>too small for typical viewing distances</b>. Increasing the text size may help.")
        );

        var high_range_grid = new RangeGrid (
            "dialog-error-symbolic",
            "error",
            _("Too High DPI"),
            _("Text and UI will appear <b>too small for typical viewing distances</b>.")
        );

        range_stack = new Gtk.Stack () {
            vexpand = true
        };
        range_stack.add_named (invalid_range_grid, "invalid");
        range_stack.add_named (low_range_grid, "low");
        range_stack.add_named (lodpi_low_range_grid, "lodpi-low");
        range_stack.add_named (lodpi_ideal_range_grid, "lodpi-ideal");
        range_stack.add_named (lodpi_high_range_grid, "lodpi-high");
        range_stack.add_named (lodpi_should_be_hidpi_range_grid, "lodpi-should-be-hidpi");
        range_stack.add_named (unclear_range_grid, "unclear");
        range_stack.add_named (hidpi_low_range_grid, "hidpi-low");
        range_stack.add_named (hidpi_ideal_range_grid, "hidpi-ideal");
        range_stack.add_named (hidpi_high_range_grid, "hidpi-high");
        range_stack.add_named (high_range_grid, "high");

        var assessment_grid = new Gtk.Grid () {
            column_spacing = 12,
            margin_end = 24,
            row_spacing = 6
        };
        assessment_grid.attach (range_stack, 0, 0, 4);
        assessment_grid.attach (aspect_result_label, 0, 1);
        assessment_grid.attach (dpi_result_label, 1, 1);
        assessment_grid.attach (logical_resolution_label, 2, 1);
        assessment_grid.attach (link_button, 3, 1);

        var main_layout = new Gtk.Grid () {
            column_spacing = 6,
            margin_bottom = 24
        };

        main_layout.attach (header, 0, 0, 2);
        main_layout.attach (data_grid, 0, 1);
        main_layout.attach (assessment_grid, 1, 1);

        var window_handle = new Gtk.WindowHandle () ;
        window_handle.child = main_layout;

        diag_entry.grab_focus ();

        set_content (window_handle);

        about_button.clicked.connect (() => about_window.present () );

        var direction = "diagonal";

        diag_entry_focus_controller.enter.connect ((event) => {
            direction = "diagonal";
            set_display_icon (direction);
        });

        width_entry_focus_controller.enter.connect ((event) => {
            direction = "horizontal";
            set_display_icon (direction);
        });

        height_entry_focus_controller.enter.connect ((event) => {
            direction = "vertical";
            set_display_icon (direction);
        });

        diag_entry.changed.connect (() => {
            string? text = diag_entry.get_text ();
            if (text != null && text != "") {
                inches = double.parse (diag_entry.get_text ());
                assess_dpi (
                    recalculate_dpi (inches, width, height),
                    infer_display_type (inches)
                );
            }
        });

        width_entry.changed.connect (() => {
            string? text = width_entry.get_text ();
            if (text != null && text != "") {
                width = int.parse (text);
                if ( width == 0 ) {
                    return;
                }
                is_default_width = false;

                recalculate_aspect (width, height);
                assess_dpi (
                    recalculate_dpi (inches, width, height),
                    display_type
                );

                if (!height_entry.has_focus && (is_default_height || height == 0)) {
                    double calculated_height = Math.round (
                        width *
                        DEFAULT_ASPECT_HEIGHT /
                        DEFAULT_ASPECT_WIDTH
                    );
                    height_entry.text = (calculated_height).to_string ();
                    is_default_height = true;
                }
            }
        });

        height_entry.changed.connect (() => {
            string? text = height_entry.get_text ();
            if (text != null && text != "") {
                height = int.parse (height_entry.get_text ());
                if ( height == 0 ) {
                    return;
                }
                is_default_height = false;

                recalculate_aspect (width, height);
                assess_dpi (
                    recalculate_dpi (inches, width, height),
                    display_type
                );

                if (!width_entry.has_focus && (is_default_width || width == 0)) {
                    double calculated_width = Math.round (
                        height *
                        DEFAULT_ASPECT_WIDTH /
                        DEFAULT_ASPECT_HEIGHT
                    );
                    width_entry.text = (calculated_width).to_string ();
                    is_default_width = true;
                }
            }
        });

        internal_button.toggled.connect (() => {
            if (internal_button.active) {
                display_type = Utils.DisplayType.INTERNAL;
                assess_dpi (Utils.dpi (inches, width, height), display_type);
                set_display_icon (direction);
            }

        });

        external_button.toggled.connect (() => {
            if (external_button.active) {
                display_type = Utils.DisplayType.EXTERNAL;
                assess_dpi (Utils.dpi (inches, width, height), display_type);
                set_display_icon (direction);
            }
        });
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
            aspect_width = width / Utils.greatest_common_divisor (width, height);
            aspect_height = height / Utils.greatest_common_divisor (width, height);
            aspect_result_label.label = (aspect_width).to_string () + _(":") + (aspect_height).to_string ();
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

        if (display_type == Utils.DisplayType.EXTERNAL ) {
            ideal_dpi = EXTERNAL_IDEAL_DPI;
            ideal_range = EXTERNAL_IDEAL_RANGE;
            unclear_range = EXTERNAL_UNCLEAR_RANGE;
        }

        if ( inches == 0 || width == 0 || height == 0 ) {
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
    }

    private Utils.DisplayType infer_display_type (double inches) {
        is_default_display_type = true;

        if (inches < INCHES_INFER_EXTERNAL) {
            display_type = Utils.DisplayType.INTERNAL;
            internal_button.active = true;
        } else {
            display_type = Utils.DisplayType.EXTERNAL;
            external_button.active = true;
        }

        return display_type;
    }

    private void set_display_icon (string direction) {
        diagram.icon_name = "display-measure-" + direction + display_type.icon_suffix ();
    }

    private class RangeGrid : Gtk.Grid {
        public string icon_name { get; construct; }
        public string style_class { get; construct; }
        public string title { get; construct; }
        public string description { get; construct; }

        public RangeGrid (string _icon_name, string _style_class, string _title, string _description) {
            Object (
                icon_name: _icon_name,
                style_class: _style_class,
                title: _title,
                description: _description
            );
        }

        construct {
            column_spacing = 12;
            row_spacing = 6;

            var icon = new Gtk.Image.from_icon_name (icon_name) {
                margin_top = 4,
                pixel_size = 32,
                valign = Gtk.Align.START
            };
            icon.add_css_class (style_class);

            var title_label = new Gtk.Label (title) {
                halign = Gtk.Align.START,
                valign = Gtk.Align.END,
                wrap = true,
            };
            title_label.add_css_class ("title-1");
            title_label.add_css_class (style_class);

            var description_label = new Gtk.Label (description) {
                max_width_chars = 40,
                use_markup = true,
                valign = Gtk.Align.START,
                wrap = true,
            };
            description_label.add_css_class ("body");

            attach (icon, 0, 0, 1, 2);
            attach (title_label, 1, 0);
            attach (description_label, 1, 1);
        }
    }
}
