require 'dul_hydra/version'

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
  	autoload :AccessControllable, 'dul_hydra/models/access_controllable'
  	autoload :Auditable, 'dul_hydra/models/auditable'
  	autoload :Base, 'dul_hydra/models/base'
  	autoload :Describable, 'dul_hydra/models/describable'
  	autoload :Governable, 'dul_hydra/models/governable'
  	autoload :HasContent, 'dul_hydra/models/has_content'
  	autoload :HasContentMetadata, 'dul_hydra/models/has_content_metadata'
  	autoload :HasContentdm, 'dul_hydra/models/has_contentdm'
  	autoload :HasDigitizationGuide, 'dul_hydra/models/has_digitization_guide'
  	autoload :HasDPCMetadata, 'dul_hydra/models/has_dpc_metadata'
  	autoload :HasFMPExport, 'dul_hydra/models/has_fmp_export'
  	autoload :HasJhove, 'dul_hydra/models/has_jhove'
  	autoload :HasMarcXML, 'dul_hydra/models/has_marc_xml'
  	autoload :HasPreservationEvents, 'dul_hydra/models/has_preservation_events'
  	autoload :HasThumbnail, 'dul_hydra/models/has_thumbnail'
  	autoload :HasTripodMets, 'dul_hydra/models/has_tripod_mets'
  	autoload :SolrDocument, 'dul_hydra/models/solr_document'
  end

  module Scripts
    module Helpers
      autoload :BatchIngestHelper, 'dul_hydra/scripts/helpers/batch_ingest_helper'
    end

    autoload :BatchIngest, 'dul_hydra/scripts/batch_ingest'
  end

end