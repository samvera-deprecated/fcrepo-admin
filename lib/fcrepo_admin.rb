require 'fcrepo_admin/engine'
require 'blacklight'
require 'hydra/head'

module FcrepoAdmin
  autoload :SolrDocumentExtension, 'fcrepo_admin/solr_document_extension'
  autoload :DatastreamAbility, 'fcrepo_admin/datastream_ability'
  module Helpers
    autoload :BlacklightHelperBehavior, 'fcrepo_admin/helpers/blacklight_helper_behavior'
    autoload :ObjectsHelperBehavior, 'fcrepo_admin/helpers/objects_helper_behavior'
  end
  module Controller
    autoload :ControllerBehavior, 'fcrepo_admin/controller/controller_behavior'
    autoload :ObjectsBehavior, 'fcrepo_admin/controller/objects_behavior'
    autoload :DatastreamsBehavior, 'fcrepo_admin/controller/datastreams_behavior'
  end
end
