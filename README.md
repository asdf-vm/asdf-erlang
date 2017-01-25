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

## Before `asdf install`

Install the build tools (dpkg-dev g++ gcc libc6-dev make)  
`apt-get -y install build-essential`

Automatic configure script builder (debianutils m4 perl)  
`apt-get -y install autoconf`

Needed for HiPE (native code) support, but already installed by autoconf  
`apt-get -y install m4`

Needed for terminal handling (libc-dev libncurses5 libtinfo-dev libtinfo5 ncurses-bin)  
`apt-get -y install libncurses5-dev`

For building with wxWidgets (start observer or debugger!)  
+ **Linux**: `apt-get -y install libwxgtk2.8-dev libgl1-mesa-dev libglu1-mesa-dev libpng3`
+ **OS X**: `brew install wxmac`

For building ssl (libssh-4 libssl-dev zlib1g-dev)  
`apt-get -y install libssh-dev`

ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)  
`apt-get -y install unixodbc-dev`
