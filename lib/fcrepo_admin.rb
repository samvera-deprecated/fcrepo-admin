require 'fcrepo_admin/engine'
require 'blacklight'
require 'hydra/head'

module FcrepoAdmin
  autoload :SolrDocumentExtension, 'fcrepo_admin/solr_document_extension'
  autoload :ControllerBehavior, 'fcrepo_admin/controller_behavior'
  autoload :DatastreamAbility, 'fcrepo_admin/datastream_ability'
  module Helpers
    autoload :BlacklightHelperBehavior, 'fcrepo_admin/helpers/blacklight_helper_behavior'
    autoload :ObjectsHelperBehavior, 'fcrepo_admin/helpers/objects_helper_behavior'
  end
end
