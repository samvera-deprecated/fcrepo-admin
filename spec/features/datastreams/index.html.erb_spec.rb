require 'spec_helper'

describe "datastreams/index.html.erb" do
  before { visit fcrepo_admin.object_datastreams_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:item) }
  it "should link to all persisted datastreams" do
    object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
      page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, dsid))
    end
  end  
end
