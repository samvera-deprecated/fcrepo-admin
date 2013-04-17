module FcrepoAdmin
  module CatalogHelperBehavior

    # Overrides Blacklight:CatalogHelperBehavior method
    def render_document_sidebar_partial(document = @document)
      render :partial => 'fcrepo_admin/catalog/show_sidebar'
    end

  end
end
