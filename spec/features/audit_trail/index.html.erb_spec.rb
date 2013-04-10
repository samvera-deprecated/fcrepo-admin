require 'spec_helper'

describe "audit_trail/index.html.erb" do
  let(:object) { ActiveFedora::Base.create }
  after { object.delete }
  it "should display the audit trail" do
    visit fcrepo_admin.object_audit_trail_index_path(object)
    page.should have_content(object.pid)
    page.should have_link(I18n.t("fcrepo_admin.audit_trail.download"), :href => "#{fcrepo_admin.object_audit_trail_index_path(object)}?download=true")
  end
end
