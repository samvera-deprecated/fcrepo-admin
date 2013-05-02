module FcrepoAdmin::Helpers
  module AssociationsHelperBehavior

    def link_to_target(association)
      target = @object.send(association.name)
      if association.collection?
        text = "#{target.size} #{target.size == 1 ? 'object' : 'objects'}"
        if target.size > 0
          link_to text, fcrepo_admin.object_association_path(@object, association.name)
        else
          text
        end
      else # not a collection
        if target
          link_to target.pid, fcrepo_admin.object_path(target)
        else
          "[not assigned]"
        end
      end
    end

  end
end
