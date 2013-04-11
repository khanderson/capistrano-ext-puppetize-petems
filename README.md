# capistrano-ext-puppetize-petems

This is my fork of the [capistrano-ext-puppetize](https://github.com/petems/capistrano-ext-puppetize) gem. I made a few changes and tweaks, plus I'm hosting it on Rubygems.

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
set :project_puppet_dir, "foo/bar/"
#Default location if not set: #{current_release}/config/puppet/

To specify where to put the puppet executable `apply` file
set :puppet_install_dir, "/opt/scripts/puppet"
#Default location if not set: /etc/puppet/
```

### Living with RVM

1. Remove any/all use of the rvm-capistrano extension, which interferes badly with our desire to run things on RVM-less systems.

1. If you are using bundler and intend to use RVM, set the `bundle_cmd` setting appropriately (and make sure you're using it instead of hardcoding the string)

````
set :rvm_ruby_string, '1.9.3-p194'
set :bundle_cmd, "rvm #{rvm_ruby_string} do bundle"
# ...
run "cd #{current_path} && #{try_sudo} #{bundle_cmd} exec unicorn -c #{current_path}/config/unicorn.xhr.rb -E #{rails_env} -D"
````

1. Likewise for other commands that need to run in the context of rvm
````
set :whenever_command, "#{fetch(:bundle_cmd)} exec whenever"
````
1. A convenient way of installing RVM using Puppet is to use the puppet module at https://github.com/jfryman/puppet-rvm

