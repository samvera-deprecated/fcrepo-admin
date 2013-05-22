module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    
    def show
      respond_to do |format|
        format.html { load_solr_document }
        format.xml { render :xml => @object.object_xml }
      end
    end

    def audit_trail
      if @object.auditable?
        respond_to do |format|
          format.html
          format.xml { render :xml => @object.audit_trail.to_xml }
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
