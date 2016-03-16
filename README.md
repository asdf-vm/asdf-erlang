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
