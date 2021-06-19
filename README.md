# Dippi

![Screenshot](data/screenshot.png?raw=true)   | ![Screenshot](data/screenshot-2.png?raw=true)
--------------------------------------------- | ---------------------------------------------
![Screenshot](data/screenshot-3.png?raw=true) | ![Screenshot](data/screenshot-4.png?raw=true)

## Calculate display info like DPI and aspect ratio

Analyze any display. Input a few simple details and figure out the aspect ratio, DPI, and other details of a particular display. Great for deciding which laptop or external monitor to purchase, and if it would be considered HiDPI.

### Handy features:

- Find out if a display is a good choice based on its size and resolution
- Get advice about different densities
- Learn the logical resolution
- Differentiate between laptops and desktop displays
- Stupid simple: all in a cute li'l window

Based my expertise and experience shipping HiDPI hardware and software at System76 and elementary.

### Tells you if a display’s density is:

- Very Low DPI,
- Fairly Low DPI,
- Ideal for LoDPI,
- Potentially Problematic,
- Ideal for HiDPI,
- Fairly High for HiDPI, or
- Too High DPI

[Read about the design and development on Medium](https://medium.com/@cassidyjames/introducing-dippi-de2b526464ae)

## Made for [elementary OS](https://elementary.io)

Dippi is designed and developed on and for [elementary OS](https://elementary.io). Purchasing through AppCenter directly supports the development and ensures instant updates straight from me. Get it on AppCenter for the best experience.

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)

Flatpak versions may be made available on the [Releases](https://github.com/cassidyjames/dippi/releases) page, but these are intended for testing and will not get updates via Flatpak or your system's update mechanism. Versions of Dippi may have been built and made available elsewhere by third-parties; these builds may have modifications or changes and **are not provided nor supported by me**. The only supported version is distributed via AppCenter on elementary OS.

## Developing and Building

If you want to hack on and build Dippi yourself, you'll need the following dependencies:

* libgranite-dev
* libgtk-3-dev
* meson
* valac

Run `meson build` to configure the build environment and run `ninja` to build

    meson build --prefix=/usr
    ninja -C build
    
To run automated tests, use `ninja test`

    ninja -C build test

To install, use `ninja install`, then execute with `com.github.cassidyjames.dippi`

    ninja -C build install
    com.github.cassidyjames.dippi

## Special Thanks

- [Micah Ilbery](https://github.com/micahilbery) for the shiny icons
- [Daniel Foré](https://github.com/danrabbit) for his apps to use as code examples
