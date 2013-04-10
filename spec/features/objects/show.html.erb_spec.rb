require 'spec_helper'

describe "objects/show.html.erb" do
  after { object.delete }
  context "basic object" do
    let(:object) { FactoryGirl.create(:content_model) }
    it "should display the object's properties" do
      visit fcrepo_admin.object_path(object)
      page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.state"))
      page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.create_date"))
      page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.modified_date"))
      page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.owner_id"))
      page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.label"))
    end
    it "should link to all datastreams" do
      visit fcrepo_admin.object_path(object)
      object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
        page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, dsid))
      end
    end
    it "should link to its audit trail" do
      visit fcrepo_admin.object_path(object)
      page.should have_link(I18n.t("fcrepo_admin.audit_trail.title"), :href => fcrepo_admin.object_audit_trail_index_path(object))
    end
    context "object governed by an admin policy" do
      it "should link to the APO"
    end
  end
end
