require 'spec_helper'

describe "objects/show.html.erb" do
  after { object.delete }
  context "basic object" do
    let(:object) { ContentModel.create(:title => "Test Object") }
    it "should link to all datastreams" do
      pending
      visit catalog_path(object)
      object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
        page.should have_link(dsid)
      end
    end
    it "should link to its audit trail" do
      pending
      visit catalog_path(object)
      page.should have_link(t("fcrepo_admin.audit_trail.title"))
    end
    context "object governed by an admin policy" do
      it "should link to the APO"
    end
  end
end
