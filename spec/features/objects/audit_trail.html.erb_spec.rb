require 'spec_helper'

describe "audit_trail.html.erb" do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  it "should display the audit trail" do
    visit fcrepo_admin.audit_trail_object_path(object)
    page.should have_content(object.pid)
    page.should have_link(I18n.t("fcrepo_admin.object.audit_trail.download"), :href => "#{fcrepo_admin.audit_trail_object_path(object)}?download=true")
  end
end
