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

int main (string[] args) {
  Gtk.init (ref args);

  var window = new Gtk.Window ();
  window.title = "Display Calc";
  window.set_border_width (12);
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size (500, 400);
  window.set_resizable (false);
  window.destroy.connect (Gtk.main_quit);

  var layout = new Gtk.Grid ();
  layout.column_spacing = 6;
  layout.row_spacing = 6;

  var width_entry = new Gtk.Entry();
  width_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
  width_entry.set_placeholder_text ("Pixel width");
	width_entry.icon_press.connect ((pos, event) => {
	  if (pos == Gtk.EntryIconPosition.SECONDARY) {
		  width_entry.set_text ("");
		}
	});

  var height_entry = new Gtk.Entry();
  height_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
  height_entry.set_placeholder_text ("Pixel height");
	height_entry.icon_press.connect ((pos, event) => {
	  if (pos == Gtk.EntryIconPosition.SECONDARY) {
		  height_entry.set_text ("");
		}
	});

  var inches_entry = new Gtk.Entry();
  inches_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
  inches_entry.set_placeholder_text ("Display size (inches)");
	inches_entry.icon_press.connect ((pos, event) => {
	  if (pos == Gtk.EntryIconPosition.SECONDARY) {
		  inches_entry.set_text ("");
		}
	});

  var dpi_label = new Gtk.Label (null);

  var button_calc = new Gtk.Button.with_label ("Calculate");
  button_calc.clicked.connect (() => {
    dpi_label.label = "Wee";
    button_calc.set_sensitive (false);
  });

  // attach (widget, column, row, column_span, row_span)
  layout.attach (width_entry, 0, 1, 1, 1);
  layout.attach (height_entry, 0, 2, 1, 1);
  layout.attach (button_calc, 0, 3, 2, 1);
  layout.attach (dpi_label, 0, 4, 1, 1);

  window.add (layout);
  window.show_all ();

  Gtk.main ();
  return 0;
}
