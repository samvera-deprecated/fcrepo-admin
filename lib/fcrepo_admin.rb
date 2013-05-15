require 'fcrepo_admin/engine'
require 'blacklight'
require 'hydra/head'

module FcrepoAdmin

  #
  # FcrepoAdmin configuration settings
  #
  # MIME types representing text content that do not have "text" media type.
  mattr_accessor :extra_text_mime_types
  self.extra_text_mime_types = ['application/xml', 'application/rdf+xml', 'application/json']

  # Datastream profile keys for values to display on datastream index view
  mattr_accessor :datastream_index_columns
  self.datastream_index_columns = ["dsLabel", "dsMIME", "dsSize", "dsCreateDate"]

  # Datastream profile keys for values to display on datastream history view
  mattr_accessor :datastream_history_columns
  self.datastream_history_columns = ["dsCreateDate"]

  # Datastream context navigation items
  mattr_accessor :datastream_context_nav_items
  self.datastream_context_nav_items = [:current_version, :summary, :content, :download, :edit, :upload, :history]

  # Object context navigation items
  mattr_accessor :object_context_nav_items
  self.object_context_nav_items = [:summary, :datastreams, :permissions, :associations, :audit_trail]

  # Datastream profile values to display on object show view
  mattr_accessor :object_show_datastream_columns
  self.object_show_datastream_columns = ["dsLabel"]

  # Methods on ActiveFedora::Base objects that represent Fcrepo object properties
  mattr_accessor :object_properties
  self.object_properties = [:label, :state, :create_date, :modified_date, :owner_id]

  #
  # Autoloading
  #
  autoload :Ability, 'fcrepo_admin/ability'

  module Helpers
    autoload :BlacklightHelperBehavior, 'fcrepo_admin/helpers/blacklight_helper_behavior'
    autoload :ObjectsHelperBehavior, 'fcrepo_admin/helpers/objects_helper_behavior'
    autoload :DatastreamsHelperBehavior, 'fcrepo_admin/helpers/datastreams_helper_behavior'
    autoload :AssociationsHelperBehavior, 'fcrepo_admin/helpers/associations_helper_behavior'
    autoload :FcrepoAdminHelperBehavior, 'fcrepo_admin/helpers/fcrepo_admin_helper_behavior'
  end

  module Controller
    autoload :ControllerBehavior, 'fcrepo_admin/controller/controller_behavior'
  end

end
