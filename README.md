# Dippi

Calculate display information like DPI and aspect ratio given some simple input.

![Screenshot](data/screenshot.png?raw=true)


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

