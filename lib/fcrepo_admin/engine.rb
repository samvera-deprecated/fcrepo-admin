require 'fcrepo_admin/fcrepo_admin_helper'

module FcrepoAdmin
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'fcrepo_admin.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper FcrepoAdmin::FcrepoAdminHelper
      end
    end

  end
end
