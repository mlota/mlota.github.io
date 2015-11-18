#!/usr/bin/env bash

set -e # halt script on error

rm -r ./_site
bundle exec jekyll build
find ./_site -name "*.html" -exec bundle exec htmlbeautifier {} \;
bundle exec htmlproof ./_site --disable-external --check-html