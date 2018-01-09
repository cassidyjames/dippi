# Dippi

Calculate display information like DPI and aspect ratio given some simple input.

![Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* cmake
* libgtk-3-dev
* valac (>= 0.26)

It's recommended to create a clean build environment

    mkdir build
    cd build/

Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make

To install, use `make install`, then execute with `com.github.cassidyjames.display-calc`

    sudo make install
    com.github.cassidyjames.display-calc
