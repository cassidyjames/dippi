/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2018–2021 Cassidy James Blaede <c@ssidyjam.es>
 */

public class Dippi.MainWindow : Hdy.Window {
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
    private string direction = "";

    private Gtk.Image diagram;
    private Gtk.Entry diag_entry;
    private Gtk.Entry width_entry;
    private Gtk.Entry height_entry;
    private Gtk.Label dpi_result_label;
    private Gtk.Label logical_resolution_label;
    private Gtk.Label aspect_result_label;
    private Granite.Widgets.ModeButton type_modebutton;
    private Gtk.Label range_title_label;
    private Gtk.Label range_description_label;
    private Gtk.Image range_icon;
    private Utils.Range range;
    private Utils.DisplayType display_type;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            border_width: 0,
            icon_name: "com.github.cassidyjames.dippi",
            resizable: false,
            title: _("Dippi"),
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        Hdy.init ();

        weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/cassidyjames/dippi");

        var header = new Hdy.HeaderBar () {
           show_close_button = true
        };
        unowned Gtk.StyleContext header_context = header.get_style_context ();
        header_context.add_class ("default-decoration");
        header_context.add_class (Gtk.STYLE_CLASS_FLAT);

        diagram = new Gtk.Image.from_icon_name ("com.github.cassidyjames.dippi", Gtk.IconSize.INVALID) {
            margin_bottom = 12,
            pixel_size = 128
        };

        var diag_label = new Gtk.Label (_("Diagonal size:")) {
            halign = Gtk.Align.END
        };

        diag_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };

        diag_entry.focus_in_event.connect ((event) => {
            direction = "diagonal";
            set_display_icon ();
            return focus_in_event (event);
        });

        var res_label = new Gtk.Label (_("Resolution:")) {
            halign = Gtk.Align.END
        };

        width_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };

        width_entry.focus_in_event.connect ((event) => {
            direction = "horizontal";
            set_display_icon ();
            return focus_in_event (event);
        });

        height_entry = new Gtk.Entry () {
            max_length = 5,
            max_width_chars = 5,
            width_chars = 5
        };

        height_entry.focus_in_event.connect ((event) => {
            direction = "vertical";
            set_display_icon ();
            return focus_in_event (event);
        });

        var x_label = new Gtk.Label (_("×"));
        var px_label = new Gtk.Label (_("px"));

        var inches_label = new Gtk.Label (_("inches")) {
            halign = Gtk.Align.START
        };

        var type_label = new Gtk.Label (_("Type:")) {
            halign = Gtk.Align.END
        };

        type_modebutton = new Granite.Widgets.ModeButton ();
        type_modebutton.append_text (Utils.DisplayType.INTERNAL.to_string ());
        type_modebutton.append_text (Utils.DisplayType.EXTERNAL.to_string ());

        aspect_result_label = new Gtk.Label (null) {
            halign = Gtk.Align.START
        };

        dpi_result_label = new Gtk.Label (null) {
            halign = Gtk.Align.START
        };

        logical_resolution_label = new Gtk.Label (null) {
            expand = true,
            halign = Gtk.Align.START
        };


        range_icon = new Gtk.Image.from_icon_name (
            Utils.Range.INVALID.icon (),
            Gtk.IconSize.DIALOG
        );
        range_icon.margin_bottom = 12;
        range_icon.valign = Gtk.Align.START;

        range_title_label = new Gtk.Label (null) {
            halign = Gtk.Align.START,
            label = Utils.Range.INVALID.title (),
            valign = Gtk.Align.END,
            wrap = true,
            xalign = 0
        };
        range_title_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

        range_description_label = new Gtk.Label (null) {
            label = Utils.Range.INVALID.description (),
            margin_bottom = 12,
            max_width_chars = 50,
            valign = Gtk.Align.START,
            wrap = true,
            xalign = 0
        };
        range_description_label.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

        diag_entry.changed.connect (() => {
            inches = double.parse (diag_entry.get_text ());
            assess_dpi (
                recalculate_dpi (inches, width, height),
                infer_display_type (inches)
            );
        });

        width_entry.changed.connect (() => {
            width = int.parse (width_entry.get_text ());

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
        });

        height_entry.changed.connect (() => {
            height = int.parse (height_entry.get_text ());

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
        });

        type_modebutton.mode_changed.connect (() => {
            switch (type_modebutton.selected) {
                case 0:
                    display_type = Utils.DisplayType.INTERNAL;
                    break;

                case 1:
                    display_type = Utils.DisplayType.EXTERNAL;
                    break;

                default:
                    assert_not_reached ();
            }

            assess_dpi (Utils.dpi (inches, width, height), display_type);
            set_display_icon ();
        });

        var data_grid = new Gtk.Grid () {
            column_spacing = 6,
            margin = 24,
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
        data_grid.attach (type_modebutton, 1, 3, 4);

        var assessment_grid = new Gtk.Grid () {
            column_spacing = 12,
            halign = Gtk.Align.START,
            margin = 12,
            margin_top = 48,
            row_spacing = 6,
            valign = Gtk.Align.START
        };

        assessment_grid.attach (range_icon, 0, 0, 1, 2);
        assessment_grid.attach (range_title_label, 1, 0, 3);
        assessment_grid.attach (range_description_label, 1, 1, 3);
        assessment_grid.attach (aspect_result_label, 1, 2);
        assessment_grid.attach (dpi_result_label, 2, 2);
        assessment_grid.attach (logical_resolution_label, 3, 2);

        var main_layout = new Gtk.Grid () {
            column_spacing = 6,
            height_request = 258,
            row_spacing = 6,
            width_request = 710
        };

        main_layout.attach (header, 0, 0, 2);
        main_layout.attach (data_grid, 0, 1);
        main_layout.attach (assessment_grid, 1, 1);

        diag_entry.grab_focus ();

        var window_handle = new Hdy.WindowHandle ();
        window_handle.add (main_layout);

        add (window_handle);
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
            range = Utils.Range.INVALID;
        }

        else if (calculated_dpi < ideal_dpi - ideal_range - INTERNAL_UNCLEAR_RANGE) {
            range = Utils.Range.LOW;
        }

        else if (calculated_dpi < ideal_dpi - ideal_range) {
            range = Utils.Range.LODPI_LOW;
        }

        else if (calculated_dpi <= ideal_dpi + ideal_range) {
            range = Utils.Range.LODPI_IDEAL;
        }

        else if (calculated_dpi <= ideal_dpi + ideal_range + unclear_range) {
            range = Utils.Range.LODPI_HIGH;
        }

        else if (calculated_dpi < DPI_INFER_HIDPI) {
            range = Utils.Range.UNCLEAR;
        }

        else if (calculated_dpi < (ideal_dpi - ideal_range - unclear_range) * 2) {
            range = Utils.Range.UNCLEAR;
        }

        else if (calculated_dpi < (ideal_dpi - ideal_range) * 2) {
            range = Utils.Range.HIDPI_LOW;
        }

        else if (calculated_dpi <= (ideal_dpi + ideal_range) * 2) {
            range = Utils.Range.HIDPI_IDEAL;
        }

        else if (calculated_dpi <= (ideal_dpi + ideal_range + unclear_range) * 2) {
            range = Utils.Range.HIDPI_HIGH;
        }

        else if (calculated_dpi > (ideal_dpi + ideal_range + unclear_range) * 2) {
            range = Utils.Range.HIGH;
        }

        else {
            range = Utils.Range.INVALID;
        }

        range_icon.icon_name = range.icon ();
        range_title_label.label = range.title ();
        range_description_label.label = range.description ();
    }

    private Utils.DisplayType infer_display_type (double inches) {
        is_default_display_type = true;

        if (inches < 18) {
            display_type = Utils.DisplayType.INTERNAL;
            type_modebutton.selected = 0;
        } else {
            display_type = Utils.DisplayType.EXTERNAL;
            type_modebutton.selected = 1;
        }

        return display_type;
    }

    private void set_display_icon () {
        diagram.icon_name = "display-measure-" + direction + display_type.icon_suffix ();
    }
}
