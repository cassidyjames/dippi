# Leanback

Experimental TV/media center UI

## Made for GNOME

Designed and developed on and for GNOME. As such, contributors agree to abide by the [GNOME Code of Conduct](https://wiki.gnome.org/Foundation/CodeOfConduct).

## Developing and Building

Ideally I'd love for this to be a flatpak (for ease of development and distribution); however, I'm not sure how to get access to the host's installed apps, which is critical for an app launcher. As such, for now I recommend using [`toolbx`](https://containertoolbx.org/) for development. For example, with a Fedora 41 container:

### Create and enter the toolbox

```sh
toolbox create --distro fedora --release 41
toolbox enter fedora-toolbox-41
```

### Install dependencies

- meson
- valac
- appstream-devel
- gtk4-devel
- libadwaita-devel
- python3-gobject-devel

```sh
sudo dnf install @development-tools meson valac appstream-devel gtk4-devel
```
