module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    before_filter :load_solr_document, :only => :show
    
    def show
    end

    def audit_trail
      if @object.auditable?
        if params[:download] # TODO use format instead download param
          send_data @object.audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
        end
      else
        render :text => I18n.t("fcrepo_admin.object.audit_trail.not_implemented"), :status => 404
      end
    end

    def permissions
    end

    protected

    def load_solr_document
      query = ActiveFedora::SolrService.construct_query_for_pids([@object.pid])
      @document = SolrDocument.new(ActiveFedora::SolrService.query(query).first, nil)
    end

  end
end
