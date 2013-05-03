module FcrepoAdmin
  module Ability
    extend ActiveSupport::Concern
    
    included do
      self.ability_logic += [:fcrepo_admin_aliases]
    end

    def fcrepo_admin_aliases
      alias_action :download, :to => :read
      alias_action :audit_trail, :to => :read
      alias_action :permissions, :to => :read
      alias_action :content, :to => :read
      alias_action :upload, :to => :update
    end

  end
end
