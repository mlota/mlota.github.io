#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build
find ./_site -name "*.html" -exec bundle exec htmlbeautifier {} \;
bundle exec htmlproof ./_site --disable-external --check-html --verbose

# cleanup
rm -rf ../mlota.github.io.master

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/mlota/mlota.github.io.git ../mlota.github.io.master

# copy generated HTML site to `master' branch
cp -R _site/* ../mlota.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../mlota.github.io.master
git config user.email "melvin_lota@hotmail.com"
git config user.name "Mel Lota"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1 