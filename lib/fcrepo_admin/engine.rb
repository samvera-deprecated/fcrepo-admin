module FcrepoAdmin
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    config.before_initialize do
      # load ActiveFedora decorators
      require 'fcrepo_admin/decorators/active_fedora/base_decorator'
      require 'fcrepo_admin/decorators/active_fedora/datastream_decorator'
    end

  end
end
