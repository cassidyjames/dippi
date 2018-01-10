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
  private const int MIN_HIDPI = 192;
  private const int DEFAULT_ASPECT_RATIO_WIDTH = 16;
  private const int DEFAULT_ASPECT_RATIO_HEIGHT = 9;
  // private const int MIN_PROBLEMATIC_LODPI = 150;

  private int aspect_width = DEFAULT_ASPECT_RATIO_WIDTH;
  private int aspect_height = DEFAULT_ASPECT_RATIO_HEIGHT;

  private bool is_hidpi = false;
  private double inches = 0.0;
  private int width = 0;
  private int height = 0;
  private bool is_default_width = false;
  private bool is_default_height = false;

  public MainWindow (Gtk.Application application) {
    Object (
      application: application,
      icon_name: "com.github.cassidyjames.dippi",
      resizable: false,
      title: _("Dippi"),
      border_width: 12,
      window_position: Gtk.WindowPosition.CENTER
    );
  }

  construct {
    weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
    default_theme.add_resource_path ("/com/github/cassidyjames/dippi");

    var layout = new Gtk.Grid ();
    layout.column_spacing = 6;
    layout.row_spacing = 6;

    var diagram = new Gtk.Image.from_icon_name ("com.github.cassidyjames.dippi", Gtk.IconSize.INVALID);
    diagram.pixel_size = 128;
    diagram.margin_bottom = 12;

    var diag_label = new Gtk.Label (_("Diagonal size:"));
    diag_label.halign = Gtk.Align.END;

    var diag_entry = new Gtk.Entry();
    diag_entry.max_length = 5;
    diag_entry.max_width_chars = 5;
    diag_entry.width_chars = 5;
    diag_entry.focus_in_event.connect ((event) => {
      diagram.icon_name = "video-display-measure-diagonal";
      return focus_in_event (event);
    });

    var res_label = new Gtk.Label (_("Resolution:"));
    res_label.halign = Gtk.Align.END;

    var width_entry = new Gtk.Entry();
    width_entry.max_length = 5;
    width_entry.max_width_chars = 5;
    width_entry.width_chars = 5;
    width_entry.focus_in_event.connect ((event) => {
      diagram.icon_name = "video-display-measure-horizontal";
      return focus_in_event (event);
    });

    var height_entry = new Gtk.Entry();
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

    var dpi_result_label = new Gtk.Label (null);
    dpi_result_label.halign = Gtk.Align.START;

    var aspect_result_label = new Gtk.Label (null);
    aspect_result_label.halign = Gtk.Align.START;


    diag_entry.changed.connect (() => {
      inches = double.parse (diag_entry.get_text ());

      recalculate_dpi (
        inches,
        width,
        height,
        dpi_result_label,
        width_entry,
        height_entry
      );
    });

    width_entry.changed.connect (() => {
      width = int.parse (width_entry.get_text ());

      is_default_width = false;

      recalculate_dpi (
        inches,
        width,
        height,
        dpi_result_label,
        width_entry,
        height_entry
      );

      recalculate_aspect (width, height, aspect_result_label);

      if (is_default_height || height == 0) {
        double calculated_height = Math.round(width * DEFAULT_ASPECT_RATIO_HEIGHT / DEFAULT_ASPECT_RATIO_WIDTH);
        height_entry.text = (calculated_height).to_string ();

        is_default_height = true;
      }
    });

    height_entry.changed.connect (() => {
      height = int.parse (height_entry.get_text ());

      is_default_height = false;

      recalculate_dpi (
        inches,
        width,
        height,
        dpi_result_label,
        width_entry,
        height_entry
      );

      recalculate_aspect (width, height, aspect_result_label);

      if (is_default_width || width == 0) {
        double calculated_width = Math.round(height * DEFAULT_ASPECT_RATIO_WIDTH / DEFAULT_ASPECT_RATIO_HEIGHT);
        width_entry.text = (calculated_width).to_string ();

        is_default_width = true;
      }
    });


    // column, row, column_span, row_span
    layout.attach (diagram,             0, 0, 5, 1);

    layout.attach (diag_label,          0, 1, 1, 1);
    layout.attach (diag_entry,          1, 1, 1, 1);
    layout.attach (inches_label,        2, 1, 2, 1);

    layout.attach (res_label,           0, 2, 1, 1);
    layout.attach (width_entry,         1, 2, 1, 1);
    layout.attach (x_label,             2, 2, 1, 1);
    layout.attach (height_entry,        3, 2, 1, 1);
    layout.attach (px_label,            4, 2, 1, 1);

    layout.attach (dpi_label,           0, 3, 1, 1);
    layout.attach (dpi_result_label,    1, 3, 4, 1);

    layout.attach (aspect_label,        0, 4, 1, 1);
    layout.attach (aspect_result_label, 1, 4, 4, 1);

    add (layout);
  }


  private void recalculate_dpi (
    double inches,
    int width,
    int height,
    Gtk.Label dpi_result_label,
    Gtk.Entry width_entry,
    Gtk.Entry height_entry
  ) {
    if (inches > 0 && width > 0 && height > 0) {
      dpi_result_label.label = (dpi (inches, width, height)).to_string ();

      if (dpi (inches, width, height) >= MIN_HIDPI) {
        is_hidpi = true;
        dpi_result_label.label = dpi_result_label.get_label () + _(" (HiDPI)");
      } else {
        is_hidpi = false;
      }
    }
  }


  private void recalculate_aspect (
    int width,
    int height,
    Gtk.Label aspect_result_label
  ) {
      if (width > 0 && height > 0) {
        aspect_width = width / greatest_common_divisor (width, height);
        aspect_height = height / greatest_common_divisor (width, height);
        aspect_result_label.label = (aspect_width).to_string () + ":" + (aspect_height).to_string ();
      }
  }


  private double dpi (double inches, int width, int height) {
    double unrounded_dpi = Math.sqrt( Math.pow (width, 2) + Math.pow (height, 2) ) / inches;
    return Math.round(unrounded_dpi);
  }


  private int greatest_common_divisor (int a, int b) {
    if (a == 0)
      return b;
    if (b == 0)
      return a;

    if (a > b)
      return greatest_common_divisor(a % b, b);
    else
      return greatest_common_divisor(a, b % a);
  }
}

