# capistrano3-ext-puppetize

[![Build Status](https://travis-ci.org/petems/capistrano-ext-puppetize-petems.png?branch=master)](https://travis-ci.org/petems/capistrano-ext-puppetize-petems)

This is a fork of the [capistrano-ext-puppetize](https://github.com/petems/capistrano-ext-puppetize) gem that has been suitably upgraded to work with Capistrano 3 (there were significant API changes between versions 2 and 3).

## What

This is a Capistrano extension to run Puppet manifests contained in the application repository before deploying the application.

Requirements:

* Puppet must already be installed on the system (TO-DO: add a task to test this)

## How

At the top of `Capfile` or `config/deploy.rb` add the line
````
require "capistrano/ext/puppetize"
````
This will define a Capistrano recipe `puppet:install` and hook it to run before `deploy:finalize_update`.

## When

By default, when the recipe runs it will cause the creation and execution of a file  on the target machine which runs Puppet in standalone (masterless) mode with a slew of appropriate parameters and options.

By default:
* the puppet manifest in `config/puppet/manifests/site.pp` is run

* all string-valued Capistrano configuration variables will be available as facts, with names prefixed `cap_` - for example, the Capistrano `:deploy_to` setting is available as the Puppet fact `cap_deploy_to`.

* a fileserver configuration is created such that `puppet:///files/foo` refers to `config/puppet/files/foo` and `puppet:///root/foo` refers to `foo` in the top directory of the project

* the modulepath is set to find modules in `config/puppet/modules` and
`config/puppet/vendor/modules`

* the template directory is set to `config/puppet/templates`

The file created (by default located at `/etc/puppet/apply`) is a perfectly ordinary shell script which can also be run at other times (e.g. unattended at boot, or from cron) to ensure that the system state is correct without having to do a deploy.

### Customising parameters

You can specify options for your project but adding the following to the deploy.rb:
```ruby
set :project_puppet_dir, -> { "#{release_path}/config/puppet" }
#Default location if not set: #{release_path}/config/puppet/

To specify where to put the puppet executable `apply` file
set :puppet_install_dir, -> { "#{release_path}/resources/puppet" }
#Default location if not set: /etc/puppet/
```

The directories can be given as Strings or Procs; be warned that if you provide a string that refers to release_path too early in your Capfile it will return a value like .../current/... instead of the timestamped release directory.
