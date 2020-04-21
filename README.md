
A set of scripts to build the package for Sugarizer on Linux (.deb, .AppImage, .snap).

You're suppose to have in `../sugarizer` the Sugarizer repository.

To build, just launch:

    ./make_electron.sh

At end, the `./dist` directory contain build result. A `./sugarizer` is created during build. 

Comment line 10 to generate .snap package.

Comment line 11 to generate .deb and .AppImage package.

Use `full` parameter to avoid the minimize step (resulting files are bigger but build take less time).

    ./make_electron.sh full

