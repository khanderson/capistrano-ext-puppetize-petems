before "deploy:updated", "puppet:install"

namespace :puppet do
  desc "Install and run puppet manifests"
  task :install do
    # Export capistrano variables as Puppet facts so that the
    # site.pp manifest can make decisions on what to install based
    # on its role and environment.  We only export string variables
    # -- not class instances, procs, and other outlandish values
    facts = Capistrano::Puppetize.load_facts

    puppet_location = fetch(:puppet_install_dir, "/etc/puppet")

    # create puppet/fileserver.conf from given puppet file location
    puppet_d = fetch(:project_puppet_dir, "#{release_path}/config/puppet")
    
    # Allow directories to to be given as procs.
    # If it depends on release_path this is important as release_path isn't set right early on.
    puppet_d.is_a?(Proc) and puppet_d = puppet_d.call
    puppet_location.is_a?(Proc) and puppet_location = puppet_location.call
    
    fileserver_conf = <<ENDS
[files]
  path #{puppet_d}/files
  allow 127.0.0.1
[root]
  path #{release_path}\n  allow 127.0.0.1
ENDS
  
    # A puppet run can be started at any time by running the created puppet file (eg. /etc/puppet/apply)
    apply_script = <<ENDS
    #!/bin/sh
#{facts} puppet apply \\
 --modulepath=#{puppet_d}/modules:#{puppet_d}/vendor/modules \\
 --templatedir=#{puppet_d}/templates \\
 --fileserverconfig=#{puppet_d}/fileserver.conf \\
 #{puppet_d}/manifests/site.pp
ENDS

    on roles(fetch(:puppet_roles, :all)) do |host|
      upload! StringIO.new(fileserver_conf), "#{puppet_d}/fileserver.conf"
      upload! StringIO.new(apply_script), "#{puppet_location}/apply"
      run "chmod a+x #{puppet_location}/apply"
      run "sudo #{puppet_location}/apply"
    end
  end

  task :install_vagrant do
    # For testing under Vagrant/VirtualBox we can also write
    # /etc/puppet/vagrant-apply which runs puppet
    # using files in the /vagrant directory.  On vagrant+virtualbox
    # deployments this is a shared directory which maps onto the
    # host's project checkout area, so puppet tweaks can be made and
    # tested locally without pushing each change to github.

    facts = Puppetize.load_facts(variables)

    puppet_location = fetch(:puppet_install_dir, "/etc/puppet")
    test_d = "/vagrant/config/puppet"
    
    fileserver_conf = <<ENDS
[files]
  path #{test_d}/files
  allow 127.0.0.1
[root]
  path /vagrant
  allow 127.0.0.1
ENDS


    vagrant_apply = <<-ENDS 
#!/bin/sh
#{facts} puppet apply \\
 --modulepath=#{test_d}/modules:#{test_d}/vendor/modules \\
 --templatedir=#{test_d}/templates  \\
 --fileserverconfig=/tmp/fileserver.conf  \\
 #{test_d}/manifests/site.pp
ENDS

    on roles(fetch(:puppet_roles, :all)) do |host|
      upload! StringIO.new(fileserver_conf), "/tmp/fileserver.conf"
      upload! StringIO.new(vagrant_apply), "#{puppet_location}/vagrant-apply"
      run "chmod a+x #{puppet_location}/vagrant-apply"
      run "sudo #{puppet_location}/vagrant-apply"
    end
  end
end

namespace :load do
  task :defaults do
    set :assets_roles, [:web]
    set :assets_prefix, 'assets'
    set :linked_dirs, fetch(:linked_dirs, []).push("public/#{fetch(:assets_prefix)}")
  end
end
