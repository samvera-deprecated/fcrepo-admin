# AdminPolicy does not subclass DulHydra::Models::Base
# b/c Hydra::AdminPolicy provides all the datastreams it needs.
class AdminPolicy < Hydra::AdminPolicy
  include DulHydra::Models::Governable
end
