module FcrepoAdmin::Helpers
  module AssociationsHelperBehavior

    def link_to_association_target(association)
      target = @object.send(association.name)
      if association.collection?
        size = target.size
        link_to_unless size == 0, "#{association.class_name} (#{size})", fcrepo_admin.object_association_path(@object, association.name) do |text|
          text
        end
      else # not a collection
        if target
          link_to "#{association.class_name} #{target.pid}", fcrepo_admin.object_path(target)
        else
          "#{association.class_name} (not assigned)"
        end
      end
    end

    # We attempted to use Blacklight's #paginate_rsolr_response, but it causes a routing error 
    # b/c Kaminari as of version 0.14.1 cannot handle namespace-prefixed routes.
    # The fallback rendering bypasses Kaminari, but doesn't look so good on a large page set.
    # See https://github.com/amatsuda/kaminari/pull/322.
    def safe_paginate_rsolr_response(response)
      render :partial => "fcrepo_admin/pagination/links", :locals => {:response => response}
    end

  end
end
