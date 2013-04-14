require 'cancan'

module FcrepoAdmin
  module DatastreamAbility
    extend ActiveSupport::Concern
    
    included do
      self.ability_logic += [:datastream_permissions]
    end

    def datastream_permissions
      can :read, ActiveFedora::Datastream do |ds|
        test_read(ds.pid)
      end 

      can [:edit, :update, :destroy], ActiveFedora::Datastream do |ds|
        test_edit(ds.pid)
      end
    end

  end
end
