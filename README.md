Overview
========

Orch is an opinionated cookbook that provisions all the neccessary bits
and pieces to run any rails or rack app with minimum fuss. You can have
one or more servers ready for an app deploy by setting a few node
attributes. No custom cookbook required.

Features
========

* Configures all the basic components for a rails app:
    - mysql or postgresql database and user
    - nginx front-end web server with ssl support
    - installs any version of ruby via ruby-build
    - generates runit services from a Procfile
* Allows multiple apps per node by managing multiple rubies via chruby
  and forcing one app per user
* Works with your prefered deployment strategy (e.g. capistrano, vlad)
* Supports configuration of multiple servers (you could say it
  *orch*estrates multiple servers, for some definition of *orch*estrate)

You'll see that many opinionated decisions are made to simplify
configuration. Something 80 percent something 20 something.

Getting Started
===============

Here's the quickiest way to try out the orch cookbook:

*instructions here*

- have a new ubuntu 12.04 server ready
- gem install knife-solo (or pre-release alternative)
- create your kitchen with knife solo init 
- create a node file for your server
    * show sample attribute list
- knife solo boostrap <node> nodes/yourserver.json

Your server is ready for deploy!

Deploying your app
------------------

Now you can deploy with your favourite deployment tool. But first, you
need to ensure two things:

1. You use a login shell when executing commands on the server. This is
   needed for chruby to set the correct ruby path.
2. You deploy to $HOME/app. Orch will look for a Procfile in
   $HOME/app/current to configure any runit services.

For capistrano, you can handle both with the following in your deploy.rb:

    default_run_options[:shell] = '/bin/bash -l'
    set :deploy_to, '/home/deploy/app'

Platform
--------

* Ubuntu

Tested on:

* Ubuntu 12.04

Cookbooks
---------

This cookbook depends on three helper cookbooks. This is where all the
real work happens.

* [orch\_db](https://github.com/jdsiegel/chef-orch_db)
* [orch\_web](https://github.com/jdsiegel/chef-orch_web)
* [orch\_app](https://github.com/jdsiegel/chef-orch_app)

Attributes
==========

### chruby (optional)

A hash describing some options for installing chruby:

* version        - the version of chruby
* url            - the url of the chruby tarball
* checksum       - the sha256 hash of the chruby tarball
* force\_install - install chruby even if it's already installed

### apps

A list of hashes describing one or more ruby apps that will run on this
host. Each hash accepts the following:

* name          - the app's name
* user          - the app's user account
* ruby\_version - the app's ruby version. It is compiled by
  ruby\_build
* port          - the starting port number, set as the PORT env
  variable for your foreman processes. Defaults to 5000
* bundler\_version (optional) - A version of bundler specific to this
  app

### rubies\_path (optional)

The path where rubies are placed. Defaults to /opt/rubies

Usage
=====

* Add recipe[orch\_app] to the run list for your node and set the the
  apps attribute with the list of apps.

License and Author
==================

- Author:: Jeff Siegel

Copyright:: 2013 Jeff Siegel

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
