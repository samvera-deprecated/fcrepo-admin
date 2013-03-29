module DulHydra
  autoload :AdminPolicies, 'dul_hydra/admin_policies'
  autoload :Datastreams, 'dul_hydra/datastreams'
  autoload :Permissions, 'dul_hydra/permissions'
  autoload :SolrHelper, 'dul_hydra/solr_helper'
  autoload :Utils, 'dul_hydra/utils'

  module Controllers
    autoload :ControllerBehavior, 'dul_hydra/controllers/controller_behavior'
  end

  module Helpers
    autoload :CatalogHelperBehavior, 'dul_hydra/helpers/catalog_helper_behavior'
  end

  module Models
    autoload :Auditable, 'dul_hydra/models/auditable'
    autoload :Base, 'dul_hydra/models/base'
    autoload :SolrDocument, 'dul_hydra/models/solr_document'
  end

end
