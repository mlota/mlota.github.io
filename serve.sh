#!/usr/bin/env bash

set -e # halt script on error

bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch