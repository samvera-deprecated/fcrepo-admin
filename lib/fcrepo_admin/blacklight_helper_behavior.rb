module FcrepoAdmin
  module BlacklightHelperBehavior

    def link_to_document(doc, opts={:label=>nil, :counter => nil, :results_view => true})
      opts[:label] ||= blacklight_config.index.show_link.to_sym
      label = render_document_index_label doc, opts
      link_to label, fcrepo_admin.object_path(doc.id), { :'data-counter' => opts[:counter] }.merge(opts.reject { |k,v| [:label, :counter, :results_view].include? k  })
    end

  end
end
