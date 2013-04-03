module DulHydra::Models
  module Auditable
    
    def audit_trail
      inner_object.audit_trail
    end

  end
end
