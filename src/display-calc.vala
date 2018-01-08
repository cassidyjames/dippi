int main (string[] args) {
  Gtk.init (ref args);

  var window = new Gtk.Window ();
  window.title = "Display Calc";
  window.set_border_width (12);
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size (350, 70);
  window.destroy.connect (Gtk.main_quit);

  var button_calc = new Gtk.Button.with_label ("Calculate");
  button_calc.clicked.connect (() => {
    button_calc.label = "Wee";
    button_calc.set_sensitive (false);
  });

  window.add (button_calc);
  window.show_all ();

  Gtk.main ();
  return 0;
}
