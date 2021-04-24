
A script to build the package for Sugarizer on Linux (.deb, .AppImage), Snapcraft (.snap), MacOS (.dmg) or Window (.exe).

You're suppose to have in `../sugarizer` the Sugarizer repository.

To build, just launch:

    ./make_electron.sh <target> [full]

Where:

* <target> should be `linux`, `snap`, `mac` or `win`
* `full` is to avoid the minimize step (resulting files are bigger but build take less time)

At end, the `./dist` directory contain build result. A `./sugarizer` is created during build.
