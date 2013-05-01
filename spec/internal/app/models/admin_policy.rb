class AdminPolicy < Hydra::AdminPolicy
  
  has_many :governs, :property => :is_governed_by, :inbound => true, :class_name => 'ActiveFedora::Base'

end
