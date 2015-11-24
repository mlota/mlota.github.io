---
layout: post
title: Automating deployment of a GitHub Pages hosted site with Jekyll and Travis CI
subtitle: Searching for the perfect blog deployment workflow
published: true
date: "2015-11-23"
---


Earlier this month I set up this blog using the simple publishing mechanism provided by GitHub Pages and Jekyll. It all works perfectly, but as I began to delve deeper into Jekyll, I discovered that it's possible to create a more efficient deployment workflow using Travis CI and GitHub. I’m a big advocate of continuous deployment and build automation so I had to check this out.

I also decided to move away from using the out-of-the-box build process that GitHub Pages provides for Jekyll. This is mainly due to the added flexibility of using custom plugins, as GitHub Pages runs in `--safe` mode it effectively disables this feature. I found it wasn't too difficult to get this all setup, but it does mean that you’ll need a local development environment with Ruby and Jekyll installed.

## Development Environment

I'm using a Macbook Pro with OSX - El Capitan (ridiculous name btw) so I started out by grabbing a copy of the following:

- [Homebrew](http://brew.sh/) - A super-simple software package manager for the Mac. I found it was a bit like Chocolatey on Windows.
- [rbenv](https://github.com/sstephenson/rbenv) - I had to use this in order to install the latest version of Ruby (2.2.3 at the time of writing) without affecting the system installed version.
- [Bundler](http://bundler.io/) - This helps to manage Gem dependencies when working Ruby. I also like to set it up so that it installs required gems to the project directory to avoid clutter elsewhere

I cloned a copy of the current, GitHub Pages oriented site down to my local machine and created a `Gemfile` to add the Jekyll dependencies:

{% highlight ruby %}
source "https://rubygems.org"

gem "jekyll"
gem "jekyll-paginate"
{% endhighlight %}

I then ran the following command to install the gems into a **vendor** folder in the root of the project directory:

{% highlight bash %}
$ bundler install --path vendor
{% endhighlight %}

I also created a simple shell script to serve the site locally:

**serve.sh**
{% highlight bash %}
#!/usr/bin/env bash
set -e # halt script on error
bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
{% endhighlight %}

There are a few interesting things going on here which I'll elaborate on. Firstly it's worth mentioning that by default the site will be served on port 4000, so you'll be able to use your browser and navigate to [http://localhost:4000](http://localhost:4000). I'm also supplying the `jekyll serve` command with two arguments: 

* `--config` accepts a comma separated list of site config files. Whichever file comes last in the list will override any settings in the preceding file. I'm using this so that I can set a separate **baseurl** for dev, so that any global links work when I'm serving the site locally.
* `--watch` tells Jekyll to watch for any file changes in the project directory, and automatically regenerate the site

## Automated Deployment

Next up was automating the deployment of the site files to GitHub Pages. [Travis CI](https://travis-ci.org) is an online, continuous integration service used for building and testing code. I'm new to Travis, but I frequently use other CI tools such as Jenkins and TeamCity so the concepts were familiar. One nice thing about Travis is that it is completely free to use on public source code repositories, so it's ideal for a small project such as this blog.

For setting up the automated deployment, I used the following article as a reference point:

> [Automate GitHub Pages publishing with Jekyll and Travis CI](http://eshepelyuk.github.io/2014/10/28/automate-github-pages-travisci.html)

It roughly consists of performing the following steps

* Set up a new branch to contain the Jekyll source code and use the master branch to host the cleanly built site code
* Enabling Travis hook for the repository 
* Create a personal access token in GitHub
* Creating a .travis.yml and build.sh file
* Running the build

I won't go into too much detail about these points here, as the article is quite concise. I did however run into a minor issue with permissions on the `build.sh` file when I first tried running a build in Travis. After a bit of research I found this was due to the file requiring 'execute' permissions and could be easily remedied by adding a `chmod` command to the `.travis.yml` file: 

{% highlight yaml %}
before_script:
- chmod +x "./build.sh"
{% endhighlight %}

## Enhancements
With Travis in place, enabling test scripts in the build process becomes quite a trivial task. I added the following enhancements...

### HTML proofer
The [html-proofer](https://github.com/gjtorikian/html-proofer) Gem provides a set of tools for running checks on validity of links and images across a Jekyll generated site. I implemented this by adding the `html-proofer` Gem to the Gemfile and the following line to the `build.sh` file:

{% highlight bash %}
bundle exec htmlproof ./_site --disable-external --check-html --verbose
{% endhighlight %}

With the optional arguments in that command, I am disabling the check for external links, checking the output files for valid HTML and outputting verbose results to the console. 

### HTML Beautifier

Seeing as I have a touch of OCD, I like to keep the HTML output on my sites tidy and indented correctly. This is somewhat difficult to accomplish when working with Jekyll as the various includes and liquid templating leave unwanted spacing and indentation. I came across a Gem called [htmlbeautifier](https://github.com/threedaymonk/htmlbeautifier) which takes an input file and outputs a nicely indented HTML document. The documentation is a little sparse for this one, so I had to figure out how to run this for all the HTML files in the `_site` directory. I came up with the following command which can be added `build.sh` file and seems to work perfectly:

{% highlight bash %}
find ./_site -name "*.html" -exec bundle exec htmlbeautifier {} \;
{% endhighlight %}

## Summary

Switching from the standard GitHub Pages build process to Travis is not as daunting as it seems and I've certainly learnt a fair bit about Ruby and bash scripts along the way. Going forward, I'd like to look at other ways I can optimse the site during the build process such as minifying scripts. All of the code I've spoken about in this article is free to view on the [GitHub repository for this blog](https://github.com/mlota/mlota.github.io/tree/source). Hope this comes in handy for anyone looking to improve their Jekyll blog deployment :)
