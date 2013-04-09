require 'spec_helper'

describe "catalog/show.html.erb" do
  after { object.delete }
  context "Basic object" do
    let(:object) { ContentModel.create(:title => "Test Object") }
    it "should link to all datastreams" do
      visit catalog_path(object)
      object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
        page.should have_link(dsid)
      end
    end
    it "should link to its audit trail" do
      visit catalog_path(object)
      page.should have_link("Audit Trail")
    end
  end
  context "object has admin policy" do
    it "should link to the APO"
  end
end
