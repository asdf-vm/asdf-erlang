# asdf-erlang

Erlang plugin for [asdf](https://github.com/asdf-vm/asdf) version manager that relies on [kerl](https://github.com/kerl/kerl) for builds.

This plugin aims to combine the best of both worlds by using kerl.

kerl's compatibility and build scripts, together with asdf's easy version switching and support for the .tool-versions file. You do not need to have kerl already installed to use this. The plugin will install it's own version of kerl automatically.

## Install

```
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
```

**Important**: Make sure to read the [Before asdf install](#before-asdf-install) section below to install dependencies!

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Erlang. To specify custom options you [can set environment variables just as you would when using kerl](https://github.com/kerl/kerl#kerl_base_dir). For example, to skip the Java dependency during installation use:

```
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
asdf install erlang <version>
```

You can also install Erlang from git, or provide the url to a fork and build from git.

```
asdf install erlang ref:master

export OTP_GITHUB_URL="https://github.com/basho/otp"
asdf install erlang ref:basho
```

See [kerl](https://github.com/kerl/kerl) for the complete list of customization options. Note that the `KERL_BASE_DIR` and `KERL_CONFIG` environment variables are set by the plugin when it runs kerl so it will not be possible to customize them.

## Before `asdf install`

### Ubuntu and Debian

Note that if you are using a previous version of Linux, you may need a different version of one of the below
libraries.

#### Ubuntu 16.04 LTS "Xenial Xerus"

Install the build tools (dpkg-dev g++ gcc libc6-dev make debianutils m4 perl)
`apt-get -y install build-essential autoconf`

Needed for HiPE (native code) support, but already installed by autoconf
`apt-get -y install m4`

Needed for terminal handling (libc-dev libncurses5 libtinfo-dev libtinfo5 ncurses-bin)
`apt-get -y install libncurses5-dev`

For building with wxWidgets (start observer or debugger!). Note that you may need to select the right `wx-config` before installing Erlang.
`apt-get -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev`

For building ssl (libssh-4 libssl-dev zlib1g-dev)
`apt-get -y install libssh-dev`

ODBC support (libltdl3-dev odbcinst1debian2 unixodbc)
`apt-get -y install unixodbc-dev`

For building documentation:
`apt-get install xsltproc fop`

If you want to install all the above:
`apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop`

#### Ubuntu 20.04 LTS

If you need to use `wxWebView` in Erlang you'll want to install a library for it:
`apt-get -y install libwxgtk-webview3.0-gtk3-dev`

If you want to install all the above:
`apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk`

#### Ubuntu 24.04 LTS
If you want to install all the above:
`apt-get -y install build-essential autoconf m4 libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk`

#### Debian 12 (bookworm)

To install the whole dependency suite:
`apt-get -y install build-essential autoconf m4 libncurses-dev libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils openjdk-17-jdk`

#### Debian 13 (trixie)

To install the whole dependency suite:
`apt-get -y install build-essential autoconf m4 libncurses-dev libwxgtk3.2-dev libwxgtk-webview3.2-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils openjdk-21-jdk`

### Arch Linux

Provides most of the needed build tools.
`pacman -S --needed base-devel`

Needed for terminal handling
`pacman -S ncurses`

For building with wxWidgets (start observer or debugger!). Make sure `wx-config --selected-config` prints `gtk3-unicode-...` before installing Erlang. Older OTP builds may require wxgtk2, in that case install `wxgtk2-dev` from AUR.
`pacman -S glu mesa wxwidgets-gtk3 libpng`

For building ssl
`pacman -S libssh`

ODBC support
`sudo pacman -S unixodbc`

For building documentation and elixir reference builds:
`sudo pacman -S libxslt fop`

#### Dealing with ODBC issues on arch

You may encounter an ODBC error with an output along these lines:

```
error: ld returned 1 exit status
[x86_64-pc-linux-gnu/Makefile:112: ../priv/bin/x86_64-pc-linux-gnu/odbcserver] Error 1

or

* odbc           : ODBC library - link check failed
```

This issue has been discussed [here](https://github.com/asdf-vm/asdf-erlang/issues/286) and also appears on kerl. There are
a link error on Kerl auto configure. If you see this, add a export flag `--with-odbc` to KERL-CONFIGURE. Here is
an example that skips the java dependency and also sets a specific (and existing)
path for unixodbc installed via pacman:
```
export KERL_CONFIGURE_OPTIONS="--without-javac --with-odbc=/var/lib/pacman/local/unixodbc-$(pacman -Q unixodbc | cut -d' ' -f2)"
asdf install erlang <version>
```

### OSX

Note, for MacOS 10.15.4 and newer, 22.3.1 is the earliest version that can be installed through `kerl` (and, therefore, `asdf`). Earlier versions will fail to compile. See [this issue](https://github.com/kerl/kerl/issues/335#issuecomment-605487028) for details.

Install the build tools
`brew install autoconf`

Install OpenSSL
`brew install openssl@1.1`  _Erlang 24.1 and older require OpenSSL 1.1, [read more here](https://github.com/erlang/otp/issues/4577#issuecomment-925962048)_

Note, Erlang 25.1 and newer [support OpenSSL 3.0, even for production use.](https://github.com/erlang/otp/releases/tag/OTP-25.1)
If you want to build Erlang with openssl@3.0, install it by `brew install openssl`

For building with wxWidgets (start observer or debugger!). Note that you may need to select the right `wx-config` before installing Erlang.
`brew install wxwidgets`

For building documentation and elixir reference builds:
`brew install libxslt fop`

#### Dealing with OpenSSL issues on macOS

You may encounter an SSL error with an output along these lines:

```
crypto : No usable OpenSSL found
ssh : No usable OpenSSL found
ssl : No usable OpenSSL found
```

This issue has been documented [on `kerl`](https://github.com/kerl/kerl/issues/320). If you see this
error, you can use the [`--with-ssl`](https://github.com/asdf-vm/asdf-erlang/issues/82#issuecomment-415930974)
flag with a path before installing Erlang. Here is an example that skips the java dependency and also sets a specific (and existing)
path for [OpenSSL](https://github.com/kerl/kerl#kerl-and-openssl) installed via brew on macOS.

```
export KERL_CONFIGURE_OPTIONS="--without-javac --with-ssl=$(brew --prefix openssl@1.1)"
asdf install erlang <version>
```

### CentOS & Fedora

These steps assume a most recent build of CentOS (currently
tested on CentOS 7.5 x64 & Fedora 28 x64)

Install the build tools
`sudo yum install -y git gcc g++ automake autoconf`

Needed for terminal handling
`sudo yum install -y ncurses-devel`

For building with wxWidgets (start observer or debugger!). Note that you may need to select the right `wx-config` before installing Erlang.
`sudo yum install -y wxGTK-devel wxBase`

For building ssl
`sudo yum install -y openssl-devel`

For jinterface
`sudo yum install -y java-1.8.0-openjdk-devel`

ODBC support
`sudo yum install -y libiodbc unixODBC-devel.x86_64 erlang-odbc.x86_64`

For the documentation to be built
`sudo yum install -y libxslt fop`

### Solus

Install the build tools

```bash
sudo eopkg it -c system.devel
```

For building with wxWidgets (start observer or debugger!). Note that you may need to select the right `wx-config` before installing Erlang.

```bash
sudo eopkg install wxwidgets-devel libx11-devel mesalib-devel libglu-devel fop
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

sudo eopkg install wxwidgets-devel libx11-devel mesalib-devel libglu-devel fop unixodbc-devel openjdk-8 openjdk-8-devel
```

#### OpenJDK issues on Solus

I ran into an issue where `javac` wasn't a recognized command in the terminal despite having installed `openjdk-8` and `openjdk-8-devel`. Turns out it wasn't added to `PATH` by default. So simply add it to `PATH` like so:

```bash
# In ~/.bashrc add these to add Java to PATH
JAVA_HOME=/usr/lib64/openjdk-8
PATH=$PATH:$JAVA_HOME/bin

# In terminal
source ~/.bashrc
```

### openSUSE Tumbleweed

Even after you have installed the dependencies below, the Erlang installer will warn that g++ and openssl-devel appear missing.  This is safe to ignore.

The basic stuff to get Erlang to compile:

```
sudo zypper install unzip make automake autoconf gcc-c++ ncurses-devel
```

For crypto, ssh, and others (you probably want this):

```
sudo zypper install libssh-devel libopenssl-devel
```

For wx GUIs (observer, debugger, etc):

```
sudo zypper install wxGTK3-3_2-devel
```

To build documentation:

```
sudo zypper install fop libxml2-tools libxslt-tools
```

For ODBC support:

```
sudo zypper install unixODBC-devel
```

For jinterface:

```
sudo zypper install java-1_8_0-openjdk-devel
```

## Getting Erlang documentation

Erlang may come with documentation included (as man pages, pdfs and html files,
or even embedded documentation (via `c:h` function)).

For man pages this allows typing `erl -man ets` to get info on `ets` module.

For embedded documentation (on [OTP 23\+](https://www.erlang.org/downloads/23)):
- In Erlang's `erl`: via [`c:h/1,2,3`](https://erlang.org/doc/man/c.html#h/1) and [`c:ht/1,2,3`](https://erlang.org/doc/man/c.html#ht/1) for types
- In Elixir's `iex` (Elixir 1.7+): via [`h/1`](https://hexdocs.pm/iex/IEx.Helpers.html#h/1) and [`t/1`](https://hexdocs.pm/iex/IEx.Helpers.html#t/1) for types

`asdf-erlang` uses kerl for builds, and [kerl](https://github.com/kerl/kerl) is
capable of building the docs for specified version of Erlang in required
formats.

For kerl to be able to build Erlang documentation two requirements have to be met:
1. `KERL_BUILD_DOCS` environment variable has to be set to value `yes`
2. Additional dependencies have to be installed. For detailed list of dependencies for your OS please refer to the specific section above

Additionally, HTML and Man formats can be ignored entirely:
- `KERL_INSTALL_HTMLDOCS` set to `no` to not install HTML docs
- `KERL_INSTALL_MANPAGES` set to `no` to skip Man pages.

By default, docs in both of these formats are installed if `KERL_BUILD_DOCS` is set.

*It may be a good idea to disable those formats to **save space***, since **docs can easily take around 200MB** in addition to 100MB of base installation, yet to *still have docs inside shell*.

**Note:** Environment variable has to be set before `asdf install erlang <version>` is executed, to take effect.

### Setting the environment variable in bash

Type: `export KERL_BUILD_DOCS=yes` to create `KERL_BUILD_DOCS` environment variable and set it to `true`.
Repeat the same for `KERL_INSTALL_HTMLDOCS` `KERL_INSTALL_MANPAGES` if required (see above).

This line could be added to your `.bashrc` in case you want `KERL_BUILD_DOCS` to be set for future (future installations of Erlang).

To remove environment variable: `unset KERL_BUILD_DOCS`.

### Setting the environment variable in fish shell

Type: `set -xg KERL_BUILD_DOCS yes` to set environment variable.
Repeat the same for `KERL_INSTALL_HTMLDOCS` `KERL_INSTALL_MANPAGES` if required (see above).

In case you want it to be persisted between sessions (machine reboots - for example for future installations) type `set -xU KERL_BUILD_DOCS yes`.

To remove environment variable type: `set -e KERL_BUILD_DOCS`.

### Use a specific version of kerl

Overriding the default kerl version shouldn't ever be necessary, but if you want to you a specific version of kerl you can set:

```shell
export ASDF_KERL_VERSION="2.1.1"
```
