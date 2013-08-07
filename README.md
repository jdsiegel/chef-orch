Overview
========

Orch is an opinionated cookbook that provisions all the neccessary bits
and pieces to run any rails or rack app with minimum fuss. You can have
one or more servers ready for an app deploy by setting a few node
attributes. No custom app-specific cookbook is required.

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

Here's the quickest way to try out the orch cookbook:

1. have a rails app that's ready for deployment

2. spin up a new ubuntu server. You can use Vagrant if you like, but make
  sure you add a Host section in your ssh config
3. `gem install berkshelf`

4. `gem install knife-solo`

5. create your kitchen with `knife solo init mykitchen`

6. `cd mykitchen` and edit your Berksfile:

  ```
  site :opscode

  cookbook 'apt'
  cookbook 'platform_packages'
  cookbook 'user'
  cookbook 'sudo'
  cookbook 'runit'
  cookbook 'orch', :git => 'https://github.com/jdsiegel/chef-orch.git'
  cookbook 'orch_db', :git => 'https://github.com/jdsiegel/chef-orch_db.git'
  cookbook 'orch_web', :git => 'https://github.com/jdsiegel/chef-orch_web.git'
  cookbook 'orch_app', :git => 'https://github.com/jdsiegel/chef-orch_app.git'
  ```

7. create a node json file for your server. Let's call it
  `nodes/myserver.json`

  ```
  {
    "run_list": [
      "recipe[platform_packages]", 
      "recipe[sudo]", 
      "recipe[user::data_bag]", 
      "recipe[orch::fullstack]"
    ],
    "users": ["deploy"],
    "authorization": {
      "sudo": {
        "users": ["deploy"],
        "passwordless": "true"
      }
    },
    "platform_packages": {
      "pkgs": [
        { "name": "curl" }
      ]
    },
    "postgresql": {
      "password": {
        "postgres": "masterhippo35"
      }
    },
    "nginx": {
      "version": "1.2.9"
    },
    "ruby_build": {
      "upgrade": true
    },
    "orch": {
      "apps": [
        {
          "name": "cashout",
          "user": "deploy",
          "port": 8000,
          "ruby_version": "2.0.0-p247",
          "db_password": "turkeymonkey2000",
          "db_type": "postgres",
          "servers": [ "localhost:8000" ],
          "processes": [["all", 1]],
          "environment": [
            ["RAILS_ENV", "staging"],
            ["RACK_ENV", "staging"]
          ]
        }
      ]
    }
  }
  ```

8. And we need a users data bag for the deploy user. Create the
   `data_bags/users` directory and add `deploy.json` with the
   following:

  ```
  {
    "id": "deploy",
    "username": "deploy",
    "ssh_keys": [
      "<your public ssh key here>"
    ]
  }
  ```
   Don't forget to put your public key in the `ssh_keys` array.

9. knife solo boostrap <node> nodes/yourserver.json

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
