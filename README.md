# asdf-erlang

Erlang plugin for [asdf](https://github.com/HashNuke/asdf) version manager

## Install

```
asdf plugin-add erlang https://github.com/HashNuke/asdf-erlang.git
```

## Use

Check [asdf](https://github.com/HashNuke/asdf) readme for instructions on how to install & manage versions of Erlang.

When installing Erlang using `asdf install`, you can pass custom configure options with the following env vars:

* `ERLANG_CONFIGURE_OPTIONS` - use only your configure options
* `ERLANG_EXTRA_CONFIGURE_OPTIONS` - append these configure options along with ones that this plugin already uses
