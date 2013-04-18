require 'fcrepo_admin/engine'
require 'blacklight'
require 'hydra/head'

module FcrepoAdmin
  autoload :SolrDocumentExtension, 'fcrepo_admin/solr_document_extension'
  autoload :ControllerBehavior, 'fcrepo_admin/controller_behavior'
  autoload :DatastreamAbility, 'fcrepo_admin/datastream_ability'
  autoload :BlacklightHelperBehavior, 'fcrepo_admin/blacklight_helper_behavior'
end
