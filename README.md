<p align="center">
  <img src="https://cdn.rawgit.com/cassidyjames/dippi/master/data/icons/128/com.github.cassidyjames.dippi.svg" alt="Icon" />
</p>
<h1 align="center">Dippi</h1>
<p align="center">
  <a href="https://appcenter.elementary.io/com.github.cassidyjames.dippi"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p>

![Screenshot](data/screenshot.png?raw=true)

## Calculate display info like DPI and aspect ratio

Input a few simple details and figure out the aspect ratio, DPI, and other details of any display. Great for deciding which laptop or external monitor to purchase, and if it would be considered HiDPI.

Handy features:
- Find out if a display is a good choice based on its size and resolution
- Get advice about different densities
- Differentiation between laptops and desktop displays
- Stupid simple: all in a cute li'l window

Planned features:
- Projector-specific mode


## Building, Testing, and Installation

### Archlinux

You can get install Dippi from [AUR](https://aur.archlinux.org/packages/dippi/) using 
```
yaourt -S dippi
```

### Flatpak

The application is available as a flatpak package for other platforms. You will need to have `flatpak` installed.

1 - Enable [`flathub`](https://flathub.org/) repository
```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

2 - Install it
```
flatpak install flathub org.github.cassidyjames.dippi
```


### Manual installation

You'll need the following dependencies to build:

* libgranite-dev
* libgtk-3-dev
* meson
* valac

Run `meson build` to configure the build environment and run `ninja test` to build and run automated tests

    meson build --prefix=/usr
    cd build
    ninja test

To install, use `ninja install`, then execute with `com.github.cassidyjames.dippi`

    sudo ninja install
    com.github.cassidyjames.dippi


## Special Thanks

- [Micah Ilbery](https://github.com/TraumaD) for the shiny new icons!
- [Daniel Foré](https://github.com/danrabbit) for his apps to use as code examples
- [David Jordan](https://github.com/djordan2) for helping determine DPI ranges and putting up with my constant pinging to talk through them

-----

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)
