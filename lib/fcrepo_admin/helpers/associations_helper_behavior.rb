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

    def render_association_collection
      begin 
        # Try to use Blacklight document index rendering ...
        render_document_index @documents
      rescue ActionView::MissingTemplate
        # By default, that will probably raise an exception
        # so fall back to custom fcrepo_admin rendering
        render :partial => 'association_collection', :locals => {:documents => @documents}
      end
    end

    def fcrepo_admin_solr_pagination_links(response)
      if response.total > response.rows
        render :partial => "fcrepo_admin/pagination/links", :locals => {:response => response}
      end
    end

    def fcrepo_admin_solr_pagination_info(response)
      render :partial => "fcrepo_admin/pagination/info", :locals => {:response => response}
    end

  end
end
