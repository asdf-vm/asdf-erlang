# asdf-erlang

Erlang plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Erlang.

When installing Erlang using `asdf install`, you can pass custom configure options with the following env vars:

* `ERLANG_CONFIGURE_OPTIONS` - use only your configure options
* `ERLANG_EXTRA_CONFIGURE_OPTIONS` - append these configure options along with ones that this plugin already uses
* `ASDF_ERLANG_OPTIONS` - options for asdf-erlang itself. Available options:
    * `no-docs` - don't download and install the man pages

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
