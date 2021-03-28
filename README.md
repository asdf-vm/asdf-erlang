
## About

Under the hood, asdf-erlang will use existing [kerl](https://github.com/kerl/kerl) or install it if it's missing.

## Install

```
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
```

## Requirements

### macOS
* Homebrew
* Xcode CLI tools
* openssl
* wxmac

`brew install openssl wxmac`

Addtional dependencies if building from source:
`brew install autoconf libtool `

macOS will by default try to fetch and use prebuilt.

Note, for macOS 10.15.4 and newer, 22.3.1 is the earliest version that can be built from source. Earlier versions will fail to compile. See [this issue](https://github.com/kerl/kerl/issues/335#issuecomment-605487028) for details.



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

#### Ubuntu 20.04 LTS

If you want to install all the above:
`apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk`

#### Arch Linux
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

#### CentOS & Fedora

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

#### Solus

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

#### OpenJDK issues on Solus

I ran into an issue where `javac` wasn't a recognized command in the terminal despite having installed `openjdk-8` and `openjdk-8-devel`. Turns out it wasn't added to `PATH` by default. So simply add it to `PATH` like so:

```bash
# In ~/.bashrc add these to add Java to PATH
JAVA_HOME=/usr/lib64/openjdk-8
PATH=$PATH:$JAVA_HOME/bin

# In terminal
source ~/.bashrc
```

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Erlang. To specify custom options you [can set environment variables just as you would when using kerl](https://github.com/kerl/kerl#build-configuration).

### `KERL_CONFIGURE_OPTIONS `
To use custom build options you could set:

```shell
$ export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
$ asdf install erlang <version>
```
By default it will be set to:

```shell
    --disable-debug --disable-silent-rules --enable-dynamic-ssl-lib
    --enable-hipe --enable-sctp --enable-shared-zlib --enable-smp-support
    --enable-threads --enable-wx --without-javac
additional for macOS
    --with-ssl=$(brew --prefix openssl) --enable-darwin-64bit --enable-kernel-poll --with-dynamic-trace=dtrace

```

### `OTP_GITHUB_URL`
To use a different Erlang source from git set the url to a fork:

```shell
$ asdf install erlang ref:master

$ export OTP_GITHUB_URL="https://github.com/basho/otp"
$ asdf install erlang ref:basho
```

### Opting out of prebuilt for macOS

By default macOS will use prebuilt binaries if they're available but you can opt out by setting any of these:
* `OTP_GITHUB_URL`,
* `KERL_CONFIGURE_OPTIONS`
* `ASDF_ERLANG_FROM_SOURCE`

It will also opt out if `ASDF_INSTALL_TYPE` is `ref`


### Opting out of Erlang documentation
To opt out of building documenation you could set:
```shell
export KERL_BUILD_DOCS=NO
```

Erlang may come with documentation included (as man pages, pdfs and html files). This allows typing `erl -man mnesia` to get info on `mnesia` module. asdf-erlang uses kerl for builds, and [kerl](https://github.com/kerl/kerl) is capable of building the docs for specified version of Erlang.

For kerl to be able to build Erlang documentation requirements have to be met with additional dependencies have to be installed. For detailed list of dependencies for your OS please refer to the specific section above.


### Use a specific version of Kerl

To use a different version of kerl you could set:
```shell
export ASDF_KERL_VERSION="2.1.1"
```

### Kerl Config

Note that the `KERL_BASE_DIR` and `KERL_CONFIG` environment variables are set by the plugin to:
```shell
KERL_BASE_DIR="${ASDF_KERL_BASE_DIR:-${ASDF_DATA_DIR:-$HOME/.asdf}/tmp/$(plugin_name)/kerl}"
KERL_CONFIG="${KERL_BASE_DIR:-$(kerl_path)}/.kerlrc"
```
You can override both.

See [kerl](https://github.com/kerl/kerl#locations-on-disk) for the complete list of customization options.



