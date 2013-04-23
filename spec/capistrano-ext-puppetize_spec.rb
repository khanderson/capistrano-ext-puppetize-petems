require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Capistrano::Puppetize do
	before do
		@configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    @configuration.extend(Capistrano::Puppetize)
    Capistrano::Puppetize.load_into(@configuration)
  end

  subject(:puppetize) { @configuration }

  describe 'puppet namespace' do
    before do
      @configuration.set(:deployer, "JC Denton")
      @configuration.set(:application, "daedalus")
      @configuration.set(:branch, "master")
      @configuration.set(:stage, "staging")
      @configuration.set(:current_release, "/for/bar/current")
      @configuration.set(:app_host_name, "Helios")
    end

    it "defines puppet:install" do
      puppetize.find_and_execute_task('puppet:install')
      puppetize.find_task('puppet:install')
    end

    it "performs puppet:install before deploy:finalize_update" do
      puppetize.should callback('puppet:install').before('deploy:finalize_update')
    end

    it 'should create the puppet file and run it' do
      puppetize.find_and_execute_task('puppet:install')
      puppetize.should have_run("chmod a+x /etc/puppet/apply")
      puppetize.should have_run("sudo /etc/puppet/apply")
    end

  end

end