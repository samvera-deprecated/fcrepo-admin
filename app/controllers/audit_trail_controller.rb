class AuditTrailController < ApplicationController
  
  def index
    @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
    if @object.respond_to?(:audit_trail)
      if params[:download]
        send_data @object.audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
      end
    else
      render :text => "Object does not implement access to Fedora audit trail", :status => 404
    end
  end
  
end
