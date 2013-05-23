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

    def associated_objects_per_page
      FcrepoAdmin.associated_objects_per_page
    end

  end
end
