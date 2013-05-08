module FcrepoAdmin::Helpers
  module AssociationsHelperBehavior

    def link_to_association_target(association)
      target = @object.send(association.name)
      if association.collection?
        link_to_unless target.size == 0, "#{association.class_name.pluralize} (#{target.size})", fcrepo_admin.object_association_path(@object, association.name) do |text|
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

  end
end
