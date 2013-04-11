require 'capistrano'
module Capistrano
  module Puppetize
    def self.load_into(configuration)
      configuration.load do
        before "deploy:finalize_update", "puppet:install"
        namespace :puppet do
          desc "Install and run puppet manifests"
          task :install do
            # Export capistrano variables as Puppet facts so that the
            # site.pp manifest can make decisions on what to install based
            # on its role and environment.  We only export string variables
            # -- not class instances, procs, and other outlandish values
            app_host_name = fetch(:app_host_name) #force this for now
            facts = variables.find_all { |k, v| v.is_a?(String) }.
            map {|k, v| "FACTER_cap_#{k}=#{v.inspect}" }.
            join(" ")

            puppet_location = fetch(:puppet_install_dir, "/etc/puppet")

            # create puppet/fileserver.conf from given puppet file location
            puppet_d= fetch(:project_puppet_dir, "#{current_release}/config/puppet")
            put(<<FILESERVER, "#{puppet_d}/fileserver.conf")
[files]
  path #{puppet_d}/files
  allow 127.0.0.1
[root]
  path #{current_release}\n  allow 127.0.0.1
FILESERVER
            # A puppet run can be started at any time by running the created puppet file (eg. /etc/puppet/apply)
            put(<<P_APPLY, "#{puppet_location}/apply")
#!/bin/sh
#{facts} puppet apply \\
 --modulepath=#{puppet_d}/modules:#{puppet_d}/vendor/modules \\
 --templatedir=#{puppet_d}/templates \\
 --fileserverconfig=#{puppet_d}/fileserver.conf \\
 #{puppet_d}/manifests/site.pp
P_APPLY
            run "chmod a+x #{puppet_location}/apply"
            run "sudo #{puppet_location}/apply"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Puppetize.load_into(Capistrano::Configuration.instance)
end