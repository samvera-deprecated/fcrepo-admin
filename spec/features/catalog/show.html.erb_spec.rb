require 'spec_helper'

describe "catalog/show.html.erb" do
  after { object.delete }
  context "basic object" do
    let(:object) { ContentModel.create(:title => "Test Object") }
    it "should link to all datastreams" do
      visit catalog_path(object)
      object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
        page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, dsid))
      end
    end
    it "should link to its audit trail" do
      visit catalog_path(object)
      page.should have_link(I18n.t("fcrepo_admin.audit_trail.title"))
    end
  end
  context "object has admin policy" do
    it "should link to the APO"
  end
end
