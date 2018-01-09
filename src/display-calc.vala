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

// Above 150 but below 192 is potentially problematic
// Above 300 is potentially problematic

const int MIN_HIDPI = 192;
const int DEFAULT_ASPECT_RATIO_WIDTH = 16;
const int DEFAULT_ASPECT_RATIO_HEIGHT = 9;
// const int MIN_PROBLEMATIC_LODPI = 150;

public class DisplayCalc : Gtk.Window {
  public DisplayCalc () {

    double inches = 0.0;
    int width = 0;
    int height = 0;
    bool default_width = false;
    bool default_height = false;
    int aspect_width = DEFAULT_ASPECT_RATIO_WIDTH;
    int aspect_height = DEFAULT_ASPECT_RATIO_HEIGHT;

    this.title = "Dippi";
    this.border_width = 12;
    this.window_position = Gtk.WindowPosition.CENTER;
    this.set_default_size (300, 400);
    this.set_resizable (false);
    this.destroy.connect (Gtk.main_quit);

    var layout = new Gtk.Grid ();
    layout.column_spacing = 6;
    layout.row_spacing = 6;

    var inches_entry = new Gtk.Entry();
    inches_entry.max_length = 5;
    inches_entry.max_width_chars = 5;
    inches_entry.width_chars = 5;

    var width_entry = new Gtk.Entry();
    width_entry.max_length = 5;
    width_entry.max_width_chars = 5;
    width_entry.width_chars = 5;

    var height_entry = new Gtk.Entry();
    width_entry.max_length = 5;
    height_entry.max_width_chars = 5;
    height_entry.width_chars = 5;

    var diag_label = new Gtk.Label ("Diagonal size:");
    diag_label.halign = Gtk.Align.END;

    var res_label = new Gtk.Label ("Resolution:");
    res_label.halign = Gtk.Align.END;

    var dpi_label = new Gtk.Label ("DPI:");
    dpi_label.halign = Gtk.Align.END;

    var aspect_label = new Gtk.Label ("Aspect ratio:");
    aspect_label.halign = Gtk.Align.END;

    var x_label = new Gtk.Label ("×");
    var px_label = new Gtk.Label ("px");

    var inches_label = new Gtk.Label ("inches");
    inches_label.halign = Gtk.Align.START;

    var dpi_result_label = new Gtk.Label (null);
    dpi_result_label.halign = Gtk.Align.START;

    var aspect_result_label = new Gtk.Label (null);
    aspect_result_label.halign = Gtk.Align.START;


    // TODO: Deduplicate these
    inches_entry.changed.connect (() => {
      inches = double.parse (inches_entry.get_text ());
      width = int.parse (width_entry.get_text ());
      height = int.parse (height_entry.get_text ());

      if (inches > 0 && width > 0 && height > 0) {
        dpi_result_label.label = (dpi (inches, width, height)).to_string ();

        if (dpi (inches, width, height) >= MIN_HIDPI) {
          dpi_result_label.label = dpi_result_label.get_label () + " (HiDPI)";
        }
      }
    });

    width_entry.changed.connect (() => {
      inches = double.parse (inches_entry.get_text ());
      width = int.parse (width_entry.get_text ());
      height = int.parse (height_entry.get_text ());

      default_width = false;

      if (inches > 0 && width > 0 && height > 0) {
        dpi_result_label.label = (dpi (inches, width, height)).to_string ();

        aspect_width = width / greatest_common_divisor (width, height);
        aspect_height = height / greatest_common_divisor (width, height);
        aspect_result_label.label = (aspect_width).to_string () + ":" + (aspect_height).to_string ();

        if (dpi (inches, width, height) >= MIN_HIDPI) {
          dpi_result_label.label = dpi_result_label.get_label () + " (HiDPI)";
        }
      }

      if (default_height || height == 0) {
        double calculated_height = Math.round(width * DEFAULT_ASPECT_RATIO_HEIGHT / DEFAULT_ASPECT_RATIO_WIDTH);
        height_entry.text = (calculated_height).to_string ();

        default_height = true;
      }
    });

    height_entry.changed.connect (() => {
      inches = double.parse (inches_entry.get_text ());
      width = int.parse (width_entry.get_text ());
      height = int.parse (height_entry.get_text ());

      default_height = false;

      if (inches > 0 && width > 0 && height > 0) {
        dpi_result_label.label = (dpi (inches, width, height)).to_string ();

        aspect_width = width / greatest_common_divisor (width, height);
        aspect_height = height / greatest_common_divisor (width, height);
        aspect_result_label.label = (aspect_width).to_string () + ":" + (aspect_height).to_string ();

        if (dpi (inches, width, height) >= MIN_HIDPI) {
          dpi_result_label.label = dpi_result_label.get_label () + " (HiDPI)";
        }
      }

      if (default_width || width == 0) {
        double calculated_width = Math.round(height * DEFAULT_ASPECT_RATIO_WIDTH / DEFAULT_ASPECT_RATIO_HEIGHT);
        width_entry.text = (calculated_width).to_string ();

        default_width = true;
      }
    });


    // column, row, column_span, row_span
    layout.attach (diag_label,          0, 0, 1, 1);
    layout.attach (inches_entry,        1, 0, 1, 1);
    layout.attach (inches_label,        2, 0, 2, 1);

    layout.attach (res_label,           0, 1, 1, 1);
    layout.attach (width_entry,         1, 1, 1, 1);
    layout.attach (x_label,             2, 1, 1, 1);
    layout.attach (height_entry,        3, 1, 1, 1);
    layout.attach (px_label,            4, 1, 1, 1);

    layout.attach (dpi_label,           0, 2, 1, 1);
    layout.attach (dpi_result_label,    1, 2, 4, 1);

    layout.attach (aspect_label,        0, 3, 1, 1);
    layout.attach (aspect_result_label, 1, 3, 4, 1);

    this.add (layout);
  }


  public static int main (string[] args) {
    Gtk.init (ref args);

    DisplayCalc app = new DisplayCalc ();
    app.show_all ();
    Gtk.main ();
    return 0;
  }


  public double dpi (double inches, int width, int height) {
    double unrounded_dpi = Math.sqrt( Math.pow (width, 2) + Math.pow (height, 2) ) / inches;
    return Math.round(unrounded_dpi);
  }

  public int greatest_common_divisor (int a, int b) {
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
