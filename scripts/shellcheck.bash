#!/usr/bin/env bash

exec shellcheck -s bash -x \
  setup.bash \
  template/bin/* -P template/lib/
