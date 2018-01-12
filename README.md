# Dippi

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)

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

You'll need the following dependencies to build:

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

-----

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)
