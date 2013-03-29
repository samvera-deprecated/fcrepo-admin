module DulHydra::Datastreams

  autoload :ContentMetadataDatastream, 'dul_hydra/datastreams/content_metadata_datastream'
  autoload :FileContentDatastream, 'dul_hydra/datastreams/file_content_datastream'
  autoload :ModsDatastream, 'dul_hydra/datastreams/mods_datastream'
  autoload :PremisEventDatastream, 'dul_hydra/datastreams/premis_event_datastream'
  
  CONTENT = "content"
  CONTENT_METADATA = "contentMetadata"
  CONTENTDM = "contentdm"
  DC = "DC"
  DESC_METADATA = "descMetadata"
  DIGITIZATION_GUIDE = "digitizationGuide"
  DPC_METADATA = "dpcMetadata"
  EVENT_METADATA = "eventMetadata"
  FMP_EXPORT = "fmpExport"
  JHOVE = "jhove"
  MARCXML = "marcXML"
  RELS_EXT = "RELS-EXT"
  RIGHTS_METADATA = "rightsMetadata"
  THUMBNAIL = "thumbnail"
  TRIPOD_METS = "tripodMets"
  
end