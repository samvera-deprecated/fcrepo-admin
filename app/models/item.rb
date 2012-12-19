class Item < DulHydra::Models::Base
  
  include DulHydra::Models::HasContentdm
  include DulHydra::Models::HasMarcXML
  include DulHydra::Models::HasContentMetadata

  has_many :parts, :property => :is_part_of, :inbound => true, :class_name => 'Component'
  belongs_to :collection, :property => :is_member_of, :class_name => 'Collection'
    
end
