#! /usr/bin/env bash

source /usr/local/share/python/common_functions.sh

alias_function do_build do_python_build_inner
do_build() {
  do_python_build_inner
  do_build_permissions
  do_pip
}
