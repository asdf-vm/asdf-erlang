# asdf-erlang

Erlang plugin for [asdf](https://github.com/asdf-vm/asdf) version manager that relies on [kerl](https://github.com/kerl/kerl) for builds.

This plugin aims to combine the best of both worlds by using kerl.

kerl's compatibility and build scripts, together with asdf's easy version switching and support for the .tool-versions file. You do not need to have kerl already installed to use this. The plugin will install it's own version of kerl automatically.

## Install

```
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

Important: Make sure to read the "Before asdf install" section below to install dependencies!

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Erlang. To specify custom options you [can set environment variables just as you would when using kerl](https://github.com/kerl/kerl#kerl_base_dir). For example, to skip the java dependency during installation use:

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

Note that if you are using a previous version of Linux, you may need a different version of one of the below
libraries.

### Ubuntu 16.04 LTS "Xenial Xerus"

Install the build tools (dpkg-dev g++ gcc libc6-dev make debianutils m4 perl) 
`apt-get -y install build-essential autoconf`

Needed for HiPE (native code) support, but already installed by autoconf
`apt-get -y install m4`

Needed for terminal handling (libc-dev libncurses5 libtinfo-dev libtinfo5 ncurses-bin)
`apt-get -y install libncurses5-dev`

For building with wxWidgets (start observer or debugger!)
`apt-get -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev`

For building ssl (libssh-4 libssl-dev zlib1g-dev)
`apt-get -y install libssh-dev`

ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)
`apt-get -y install unixodbc-dev`

For building documentation:
`apt-get install xsltproc fop`

If you want to install all the above: 
`apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop`

### Ubuntu 20.04 LTS

If you want to install all the above: 
`apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk`

## Arch Linux
Provides most of the needed build tools.
`pacman -S --needed base-devel`

Needed for terminal handling
`pacman -S ncurses`

For building with wxWidgets (start observer or debugger!)
`pacman -S glu mesa wxgtk2 libpng`

For building ssl
`pacman -S libssh`

ODBC support
`sudo pacman -S unixodbc`

## OSX

Install the build tools
`brew install autoconf`

For building with wxWidgets (start observer or debugger!)
`brew install wxmac`

### Dealing with OpenSSL issues on macOS

You may encounter an SSL error with an output along these lines:

```
crypto : No usable OpenSSL found
ssh : No usable OpenSSL found
ssl : No usable OpenSSL found
```

This issue has been documented [on
`kerl`](https://github.com/kerl/kerl#compiling-crypto-on-macs). If you see this
error, you can use the `--with-ssl` flag with a path before installing Erlang. Here is
an example that skips the java dependency and also sets a specific (and existing)
path for OpenSSL installed via brew on macOS.

```
$ export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl)"
$ asdf install erlang <version>
```

## CentOS & Fedora

These steps assume a most recent build of CentOS (currently
tested on CentOS 7.5 x64 & Fedora 28 x64)

Install the build tools
`sudo yum groupinstall -y 'Development Tools' 'C Development Tools and Libraries'`

Automatic configure script builder
`sudo yum install -y autoconf`

Needed for terminal handling
`sudo yum install -y ncurses-devel`

For building with wxWidgets (start observer or debugger!)
`sudo yum install -y wxGTK3-devel wxBase3`

For building ssl
`sudo yum install -y openssl-devel`

for jinterface
`sudo yum install -y java-1.8.0-openjdk-devel`

ODBC support
`sudo yum install -y libiodbc unixODBC-devel.x86_64 erlang-odbc.x86_64`

for the documentation to be built
`sudo yum install -y libxslt fop`

## Solus

Install the build tools

```bash
sudo eopkg it -c system.devel
```

For building wxWidgets

```bash
sudo eopkg install wxwidgets-devel mesalib-devel libglu-devel fop
```

For ODBC support

```bash
sudo eopkg install unixodbc-devel
```

For jinterface

```bash
sudo eopkg install openjdk-8 openjdk-8-devel
```

If you want to install all of the above

```bash
# Install build tools
sudo eopkg it -c system.devel

sudo eopkg install wxwidgets-devel mesalib-devel libglu-devel fop unixodbc-devel openjdk-8 openjdk-8-devel
```

### OpenJDK issues on Solus

I ran into an issue where `javac` wasn't a recognized command in the terminal despite having installed `openjdk-8` and `openjdk-8-devel`. Turns out it wasn't added to `PATH` by default. So simply add it to `PATH` like so:

```bash
# In ~/.bashrc add these to add Java to PATH
JAVA_HOME=/usr/lib64/openjdk-8
PATH=$PATH:$JAVA_HOME/bin

# In terminal
source ~/.bashrc
```

## Getting Erlang documentation

Erlang may come with documentation included (as man pages, pdfs and html files). This allows typing `erl -man mnesia` to get info on `mnesia` module. asdf-erlang uses kerl for builds, and [kerl](https://github.com/kerl/kerl) is capable of building the docs for specified version of Erlang. 

For kerl to be able to build Erlang documentation two requirements have to be met:
1. `KERL_BUILD_DOCS` environment variable has to be set
2. Additional dependencies have to be installed. For detailed list of dependencies for your OS please refer to the specific section above

**Note:** Environment variable has to be set before `asdf install erlang <version>` is executed, to take effect.

### Setting the environment variable in bash

Type: `export KERL_BUILD_DOCS=yes` to create `KERL_BUILD_DOCS` environment variable and set it to `true`. This line could be added to your `.bashrc` in case you want `KERL_BUILD_DOCS` to be set for future (future installations of Erlang). 

To remove environment variable: `unset KERL_BUILD_DOCS`.

### Setting the environment variable in fish shell

Type: `set -xg KERL_BUILD_DOCS yes` to set environment variable. In case you want it to be persisted between sessions (machine reboots - for example for future installations) type `set -xU KERL_BUILD_DOCS yes`.

To remove environment variable type: `set -e KERL_BUILD_DOCS`.
