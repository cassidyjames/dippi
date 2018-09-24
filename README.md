[![Build Status](https://travis-ci.org/cassidyjames/dippi.svg?branch=master)](https://travis-ci.org/cassidyjames/dippi)

<p align="center">
  <img src="https://cdn.rawgit.com/cassidyjames/dippi/master/data/icons/128/com.github.cassidyjames.dippi.svg" alt="Icon" />
</p>
<h1 align="center">Dippi</h1>
<p align="center">
  <a href="https://appcenter.elementary.io/com.github.cassidyjames.dippi"><img src="https://appcenter.elementary.io/badge.svg?new" alt="Get it on AppCenter" /></a>
</p>

![Screenshot](data/screenshot.png?raw=true)


## Calculate display info like DPI and aspect ratio

Analyze any display. Input a few simple details and figure out the aspect ratio, DPI, and other details of a particular display. Great for deciding which laptop or external monitor to purchase, and if it would be considered HiDPI.

### Handy features:

- Find out if a display is a good choice based on its size and resolution
- Get advice about different densities
- Learn the logical resolution
- Differentiate between laptops and desktop displays
- Stupid simple: all in a cute li'l window

Based on the expertise of Cassidy James Blaede and the actual logic System76 uses to determine screen size and resolution combinations.
    
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


## Developing and Building

If you want to hack on and build Dippi yourself, you'll need the following dependencies:

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


## Other Platforms

Dippi is made for elementary OS, but may have been built and made available elsewhere by third-parties. These builds may have modifications or changes and **are not provided nor supported by me**. The only supported version is distributed via AppCenter on elementary OS.

## Special Thanks

- [Micah Ilbery](https://github.com/TraumaD) for the shiny icons
- [Daniel Foré](https://github.com/danrabbit) for his apps to use as code examples
- [David Jordan](https://github.com/djordan2) for helping determine DPI ranges

-----

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)
