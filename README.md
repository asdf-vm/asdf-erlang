# asdf-erlang

Erlang plugin for [asdf](https://github.com/asdf-vm/asdf) version manager that relies on [kerl](https://github.com/kerl/kerl) for builds.

This plugin aims to combine the best of both worlds by using kerl.

kerl's compatibility and build scripts, together with asdf's easy version switching and support for the .tool-versions file. You do not need to have kerl already installed to use this. The plugin will install it's own version of kerl automatically.

## Install

```
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Erlang. To specify custom options you can set environment variables just as you would when using kerl. For example, to skip the java dependency during installation use:

```
$ export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
$ asdf install erlang <version>
```

You can also install Erlang from git, or provide the url to a fork and build from git.

```
$ asdf install erlang ref:master

$ export OTP_GITHUB_URL="https://github.com/basho/otp"
$ asdf install erlang ref:basho
```

See [kerl](https://github.com/kerl/kerl) for the complete list of customization options. Note that the `KERL_BASE_DIR` and `KERL_CONFIG` environment variables are set by the plugin when it runs kerl so it will not be possible to customize them.

## Before `asdf install`

## Ubuntu and Debian
These steps assume a most recent build of Debian or Ubuntu Linux (currently
tested on Ubuntu 16.04 LTS, "Xenial Xerus"). Note that if you are using a
previous version of Linux, you may need a different version of one of the below
libraries.

Install the build tools (dpkg-dev g++ gcc libc6-dev make)
`apt-get -y install build-essential`

Automatic configure script builder (debianutils m4 perl)
`apt-get -y install autoconf`

Needed for HiPE (native code) support, but already installed by autoconf
`apt-get -y install m4`

Needed for terminal handling (libc-dev libncurses5 libtinfo-dev libtinfo5 ncurses-bin)
`apt-get -y install libncurses5-dev`

For building with wxWidgets (start observer or debugger!)
`apt-get -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3`

For building ssl (libssh-4 libssl-dev zlib1g-dev)
`apt-get -y install libssh-dev`

ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)
`apt-get -y install unixodbc-dev`

## Arch Linux
Provides most of the needed build tools.
`pacman -S --needed base-devel`

Needed for terminal handling
`pacman -S curses`

For building with wxWidgets (start observer or debugger!)
`pacman -S glu mesa wxgtk2 libpng`

For building ssl
`pacman -S libssh`

ODBC support
`sudo pacman -S unixodbc`

## OSX
For building with wxWidgets (start observer or debugger!)
`brew install wxmac`

## CentOS & Fedora

These steps assume a most recent build of CentOS (currently
tested on CentOS 7.5 x64 & Fedora 28 x64)

Install the build tools
`sudo yum groupinstall -y 'Development Tools'`

Automatic configure script builder
`sudo yum install -y autoconf`

Needed for terminal handling
`sudo yum install -y ncurses-devel`

For building with wxWidgets (start observer or debugger!)
`sudo yum install -y wxGTK-devel wxBase`

For building ssl
`sudo yum install -y openssl-devel`

for jinterface
`sudo yum install -y java-1.8.0-openjdk-devel`

ODBC support
`sudo yum install -y libiodbc unixODBC.x86_64 erlang-odbc.x86_64`

for the documentation to be built
`sudo yum install -y libxslt`
