require 'capistrano'

module Capistrano
  module Puppetize
    
    # This was less odious in Capistrano 2.x.
    def self.global_facts
      Capistrano::Configuration.env.send(:config).dup
    end
    
    # Extract useful facts from a Capistrano::SSHKit Host, such as that yielded to #on.
    def self.host_facts(host)
      exploded_roles = host.roles.each_with_object({}) do |role, vars|
        vars["role_#{role}"] = "1"
      end
      
      exploded_roles.merge(host: host.to_s, roles: host.roles.map(&:to_s).join(','))
    end

    def self.build_facter_environment(vars)
      vars.select do |k, v|
        v.is_a?(String)
      end.map do |k, v|
        "FACTER_cap_#{k}=#{v.inspect}"
      end.join(" ")
    end
  end
end

load File.expand_path("../../tasks/puppetize.rake", __FILE__)