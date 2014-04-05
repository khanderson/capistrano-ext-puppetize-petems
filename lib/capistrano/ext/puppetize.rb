require 'capistrano'

module Capistrano
  module Puppetize
    
    # This was less odious in Capistrano 2.x.
    def self.capistrano_variables
      Capistrano::Configuration.env.send(:config).dup
    end

    def self.load_facts
      capistrano_variables.select do |k, v|
        v.is_a?(String)
      end.map do |k, v|
        "FACTER_cap_#{k}=#{v.inspect}"
      end.join(" ")
    end
  end
end

load File.expand_path("../../tasks/puppetize.rake", __FILE__)