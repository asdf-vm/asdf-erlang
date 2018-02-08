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
  
See [kerl](https://github.com/kerl/kerl) for the complete list of customization options. Note that the `KERL_BASE_DIR` and `KERL_CONFIG` environment variables are set by the plugin when it runs kerl so it will not be possible to customize them. 

## Before `asdf install`

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
+ **Linux**: `apt-get -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3`
+ **OS X**: `brew install wxmac`

For building ssl (libssh-4 libssl-dev zlib1g-dev)  
`apt-get -y install libssh-dev`

ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)  
`apt-get -y install unixodbc-dev`
