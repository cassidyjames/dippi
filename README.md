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


## Made for [elementary OS](https://elementary.io)

Dippi is designed and developed on and for [elementary OS](https://elementary.io). Purchasing through AppCenter directly supports the development and ensures instant updates straight from me. Get it on AppCenter for the best experience.

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)


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

Dippi is made for elementary OS, but has been built and made available elsewhere by community members. These builds may have modifications or changes and **are not provided or supported by me**.

While not officially supported, Dippi typically runs well on Ubuntu and other Ubuntu-based OSes like Pop!\_OS. You can download .deb files for 16.04+ [here](http://packages.elementary.io/appcenter/pool/main/c/com.github.cassidyjames.dippi/). This version will **not** get automatic updates.

Dippi has also been made unofficially available via the AUR for Arch Linux under the name `dippi`.

A community-built and -maintained Flatpak is available on [Flathub](https://flathub.org/).


## Special Thanks

- [Micah Ilbery](https://github.com/TraumaD) for the shiny new icons!
- [Daniel Foré](https://github.com/danrabbit) for his apps to use as code examples
- [David Jordan](https://github.com/djordan2) for helping determine DPI ranges and putting up with my constant pinging to talk through them

-----

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.cassidyjames.dippi)
