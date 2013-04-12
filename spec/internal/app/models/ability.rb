class Ability
  include Hydra::Ability
  include Hydra::PolicyAwareAbility
  include FcrepoAdmin::DatastreamAbility
end
