/*
* Copyright (c) 2018 Cassidy James Blaede (https://cassidyjames.com)
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

public class MainWindow : Gtk.Window {
  private const int MIN_LODPI = 80;
  private const int MIN_IDEAL_LODPI = 108;
  private const int MAX_IDEAL_LODPI = 156;
  private const int MIN_HIDPI = 192;
  private const int MIN_IDEAL_HIDPI = 209;
  private const int MAX_IDEAL_HIDPI = MAX_IDEAL_LODPI * 2;
  private const int DEFAULT_ASPECT_RATIO_WIDTH = 16;
  private const int DEFAULT_ASPECT_RATIO_HEIGHT = 9;
  private const int MIN_PROBLEMATIC_LODPI = 150;

  private enum Range {
    TOO_LOW,
    LOW_LODPI,
    JUST_RIGHT_LODPI,
    ALMOST_HIDPI,
    BARELY_HIDPI,
    JUST_RIGHT_HIDPI,
    TOO_HIGH,
    NOT_SURE;

    public string title () {
      switch (this) {
        case TOO_LOW:
          return _("Too Low DPI");

        case LOW_LODPI:
          return _("Problematic");

        case JUST_RIGHT_LODPI:
          return _("Great!");

        case ALMOST_HIDPI:
          return _("Potentially Problematic");

        case BARELY_HIDPI:
          return _("Problematic");

        case JUST_RIGHT_HIDPI:
          return _("Cassidy Approved!");

        case TOO_HIGH:
          return _("Too High DPI");

        case NOT_SURE:
          return _("Enter Some Data");

        default:
            assert_not_reached();
      }
    }

    public string description () {
      switch (this) {
        case TOO_LOW:
          return _("Text and UI are likely to be too big for typical viewing distances. Avoid if possible unless you need very large text and UI.");

        case LOW_LODPI:
          return _("Text and UI might be too big for typical viewing distances, but it's largely up to user preference.");

        case JUST_RIGHT_LODPI:
          return _("Not HiDPI, but a nice sweet spot. Text and UI should be legible at typical viewing distances.");

        case ALMOST_HIDPI:
          return _("Relatively high resolution, but not quite HiDPI. Text and UI may be too small by default, but forcing HiDPI would make them appear fairly large. The experience may be slightly improved by increasing the text size.");

        case BARELY_HIDPI:
          return _("Technically HiDPI, but text and UI may appear too large. Turning off HiDPI and increasing the text size might help.");

        case JUST_RIGHT_HIDPI:
          return _("Crisp HiDPI text and UI along with a readable size at typical viewing distances. This is the jackpot.");

        case TOO_HIGH:
          return _("Text and UI are likely to appear too small for typical viewing distances. Increasing the text size may help.");

        case NOT_SURE:
          return _("Fill the inputs on the left to analyze a display.");

        default:
            assert_not_reached();
      }
    }

    public string icon () {
      switch (this) {
        case TOO_LOW:
          return _("dialog-error");

        case LOW_LODPI:
          return _("dialog-warning");

        case JUST_RIGHT_LODPI:
          return _("process-completed");

        case ALMOST_HIDPI:
          return _("dialog-warning");

        case BARELY_HIDPI:
          return _("dialog-warning");

        case JUST_RIGHT_HIDPI:
          return _("process-completed");

        case TOO_HIGH:
          return _("dialog-error");

        case NOT_SURE:
          return _("dialog-information");

        default:
            assert_not_reached();
      }
    }
  }

  private int aspect_width = DEFAULT_ASPECT_RATIO_WIDTH;
  private int aspect_height = DEFAULT_ASPECT_RATIO_HEIGHT;

  private bool is_hidpi = false;
  private double inches = 0.0;
  private int width = 0;
  private int height = 0;
  private bool is_default_width = false;
  private bool is_default_height = false;

  private Gtk.Image diagram;
  private Gtk.Entry diag_entry;
  private Gtk.Entry width_entry;
  private Gtk.Entry height_entry;
  private Gtk.Label dpi_result_label;
  private Gtk.Label aspect_result_label;
  private Gtk.Label range_title_label;
  private Gtk.Label range_description_label;
  private Gtk.Image range_icon;
  private Range range;


  public MainWindow (Gtk.Application application) {
    Object (
      application: application,
      border_width: 12,
      icon_name: "com.github.cassidyjames.dippi",
      resizable: false,
      title: _("Dippi"),
      window_position: Gtk.WindowPosition.CENTER
    );
  }


  construct {
    weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
    default_theme.add_resource_path ("/com/github/cassidyjames/dippi");

    diagram = new Gtk.Image.from_icon_name ("com.github.cassidyjames.dippi", Gtk.IconSize.INVALID);
    diagram.pixel_size = 128;
    diagram.margin_bottom = 12;

    var diag_label = new Gtk.Label (_("Diagonal size:"));
    diag_label.halign = Gtk.Align.END;

    diag_entry = new Gtk.Entry();
    diag_entry.max_length = 5;
    diag_entry.max_width_chars = 5;
    diag_entry.width_chars = 5;
    diag_entry.focus_in_event.connect ((event) => {
      diagram.icon_name = "video-display-measure-diagonal";
      return focus_in_event (event);
    });

    var res_label = new Gtk.Label (_("Resolution:"));
    res_label.halign = Gtk.Align.END;

    width_entry = new Gtk.Entry();
    width_entry.max_length = 5;
    width_entry.max_width_chars = 5;
    width_entry.width_chars = 5;
    width_entry.focus_in_event.connect ((event) => {
      diagram.icon_name = "video-display-measure-horizontal";
      return focus_in_event (event);
    });

    height_entry = new Gtk.Entry();
    width_entry.max_length = 5;
    height_entry.max_width_chars = 5;
    height_entry.width_chars = 5;
    height_entry.focus_in_event.connect ((event) => {
      diagram.icon_name = "video-display-measure-vertical";
      return focus_in_event (event);
    });

    var dpi_label = new Gtk.Label (_("DPI:"));
    dpi_label.halign = Gtk.Align.END;

    var aspect_label = new Gtk.Label (_("Aspect ratio:"));
    aspect_label.halign = Gtk.Align.END;

    var x_label = new Gtk.Label (_("×"));
    var px_label = new Gtk.Label (_("px"));

    var inches_label = new Gtk.Label (_("inches"));
    inches_label.halign = Gtk.Align.START;

    dpi_result_label = new Gtk.Label (null);
    dpi_result_label.halign = Gtk.Align.START;

    aspect_result_label = new Gtk.Label (null);
    aspect_result_label.halign = Gtk.Align.START;

    range_icon = new Gtk.Image.from_icon_name (Range.NOT_SURE.icon (), Gtk.IconSize.DIALOG);
    range_icon.margin_bottom = 12;

    range_title_label = new Gtk.Label (null);
    range_title_label.get_style_context ().add_class ("h2");
    range_title_label.wrap = true;
    range_title_label.label = Range.NOT_SURE.title ();

    range_description_label = new Gtk.Label (null);
    range_description_label.max_width_chars = 50;
    range_description_label.wrap = true;
    range_description_label.label = Range.NOT_SURE.description ();

    diag_entry.changed.connect (() => {
      inches = double.parse (diag_entry.get_text ());
      recalculate_dpi (inches, width, height);
      assess_range (dpi (inches, width, height));
    });

    width_entry.changed.connect (() => {
      width = int.parse (width_entry.get_text ());

      is_default_width = false;

      recalculate_dpi (inches, width, height);
      recalculate_aspect (width, height);
      assess_range (dpi (inches, width, height));

      if (!height_entry.has_focus && (is_default_height || height == 0)) {
        double calculated_height = Math.round(width * DEFAULT_ASPECT_RATIO_HEIGHT / DEFAULT_ASPECT_RATIO_WIDTH);
        height_entry.text = (calculated_height).to_string ();

        is_default_height = true;
      }
    });

    height_entry.changed.connect (() => {
      height = int.parse (height_entry.get_text ());

      is_default_height = false;

      recalculate_dpi (inches, width, height);
      recalculate_aspect (width, height);
      assess_range (dpi (inches, width, height));

      if (!width_entry.has_focus && (is_default_width || width == 0)) {
        double calculated_width = Math.round(height * DEFAULT_ASPECT_RATIO_WIDTH / DEFAULT_ASPECT_RATIO_HEIGHT);
        width_entry.text = (calculated_width).to_string ();

        is_default_width = true;
      }
    });


    var data_grid = new Gtk.Grid ();
    data_grid.column_spacing = 6;
    data_grid.margin = 24;
    data_grid.row_spacing = 6;

    // column, row, column_span, row_span
    data_grid.attach (diagram,                 0, 0, 5, 1);

    data_grid.attach (diag_label,              0, 1, 1, 1);
    data_grid.attach (diag_entry,              1, 1, 1, 1);
    data_grid.attach (inches_label,            2, 1, 2, 1);

    data_grid.attach (res_label,               0, 2, 1, 1);
    data_grid.attach (width_entry,             1, 2, 1, 1);
    data_grid.attach (x_label,                 2, 2, 1, 1);
    data_grid.attach (height_entry,            3, 2, 1, 1);
    data_grid.attach (px_label,                4, 2, 1, 1);

    data_grid.attach (dpi_label,               0, 3, 1, 1);
    data_grid.attach (dpi_result_label,        1, 3, 4, 1);

    data_grid.attach (aspect_label,            0, 4, 1, 1);
    data_grid.attach (aspect_result_label,     1, 4, 4, 1);


    var assessment_grid = new Gtk.Grid ();
    assessment_grid.column_spacing = 6;
    assessment_grid.row_spacing = 6;
    assessment_grid.valign = Gtk.Align.CENTER;

    // column, row, column_span, row_span
    assessment_grid.attach (range_icon,              0, 0, 1, 1);
    assessment_grid.attach (range_title_label,       0, 1, 1, 1);
    assessment_grid.attach (range_description_label, 0, 2, 1, 1);


    var main_layout = new Gtk.Grid ();
    main_layout.column_spacing = 6;
    main_layout.row_spacing = 6;

    // column, row, column_span, row_span
    main_layout.attach (data_grid,       0, 0, 1, 1);
    main_layout.attach (assessment_grid, 1, 0, 1, 1);


    add (main_layout);
  }


  private int recalculate_dpi (double inches, int width, int height) {
    if (inches > 0 && width > 0 && height > 0) {
      int calculated_dpi = dpi (inches, width, height);

      dpi_result_label.label = (calculated_dpi).to_string ();

      if (calculated_dpi >= MIN_HIDPI) {
        is_hidpi = true;
        dpi_result_label.label = dpi_result_label.get_label () + _(" (HiDPI)");
      } else {
        is_hidpi = false;
      }

      return calculated_dpi;
    }

    return 0;
  }


  private void recalculate_aspect (int width, int height) {
    if (width > 0 && height > 0) {
      aspect_width = width / greatest_common_divisor (width, height);
      aspect_height = height / greatest_common_divisor (width, height);
      aspect_result_label.label = (aspect_width).to_string () + _(":") + (aspect_height).to_string ();
    }
  }


  private int dpi (double inches, int width, int height) {
    double unrounded_dpi = Math.sqrt( Math.pow (width, 2) + Math.pow (height, 2) ) / inches;
    return (int)unrounded_dpi;
  }


  private Range assess_range (double calculated_dpi) {
    Range assessment;

    if ( width == 0 || height == 0 ) {
      assessment = range.NOT_SURE;
    }

    else if (calculated_dpi < MIN_LODPI) {
      assessment = range.TOO_LOW;
    }

    else if (calculated_dpi < MIN_IDEAL_LODPI) {
      assessment = range.LOW_LODPI;
    }

    else if (calculated_dpi <= MAX_IDEAL_LODPI) {
      assessment = range.JUST_RIGHT_LODPI;
    }

    else if (calculated_dpi < MIN_HIDPI) {
      assessment = range.ALMOST_HIDPI;
    }

    else if (calculated_dpi < MIN_IDEAL_HIDPI) {
      assessment = range.BARELY_HIDPI;
    }

    else if (calculated_dpi <= MAX_IDEAL_HIDPI) {
      assessment = range.JUST_RIGHT_HIDPI;
    }

    else if (calculated_dpi > MAX_IDEAL_HIDPI) {
      assessment = range.TOO_HIGH;
    }

    else {
      assessment = range.NOT_SURE;
    }

    range_icon.icon_name = assessment.icon ();
    range_title_label.label = assessment.title ();
    range_description_label.label = assessment.description ();

    return assessment;
  }


  private int greatest_common_divisor (int a, int b) {
    if (a == 0) {
      return b;
    }

    if (b == 0) {
      return a;
    }

    if (a > b) {
      return greatest_common_divisor(a % b, b);
    } else {
      return greatest_common_divisor(a, b % a);
    }
  }
}

