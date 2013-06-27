module FcrepoAdmin
  module Ability
    extend ActiveSupport::Concern
    
    included do
      self.ability_logic += [:fcrepo_admin_object_permissions]
    end

    def fcrepo_admin_object_permissions
      FcrepoAdmin.object_permissions.each do |action, permission|
        can action, ActiveFedora::Base do |obj|
          send("test_#{permission}".to_sym, obj.pid)
        end
      end
    end

  end
end
