require 'fcrepo_admin/engine'
require 'blacklight'
require 'hydra/head'

module FcrepoAdmin

  #
  # FcrepoAdmin configuration settings
  #
  mattr_accessor :read_only
  self.read_only = false

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
  mattr_accessor :datastream_nav_items
  self.datastream_nav_items = [:dsid, :version, :current_version, :summary, :content, :download, :edit, :upload, :history]

  mattr_accessor :datastream_show_profile_keys
  self.datastream_show_profile_keys = ["dsLabel", "dsMIME", "dsVersionID", "dsCreateDate", "dsState", 
                                       "dsFormatURI", "dsControlGroup", "dsSize", "dsVersionable", 
                                       "dsInfoType", "dsLocation", "dsLocationType", "dsChecksumType",
                                       "dsChecksum"]

  # Sanity check on amount of text data to make editable via web form
  mattr_accessor :max_editable_datastream_size
  self.max_editable_datastream_size = 1024 * 64

  # Object context navigation items
  mattr_accessor :object_nav_items
  self.object_nav_items = [:pid, :summary, :datastreams, :permissions, :associations, :audit_trail]

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
