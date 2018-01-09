# Display Calc

_Swankier name tbd._

Calculate display information given some simple input. Currently only handles DPI.

![Screenshot](data/screenshot.png?raw=true)

## Building, Testing, and Installation

You'll need the following dependencies:
* cmake
* libgtk-3-dev
* valac (>= 0.26)

It's recommended to create a clean build environment

    mkdir build
    cd build/

Run `cmake` to configure the build environment and then `make all test` to build and run automated tests

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make all test

To install, use `make install`, then execute with `io.elementary.appcenter`

    sudo make install
    com.github.cassidyjames.display-calc
