require 'spec_helper'

describe "datastreams/index.html.erb" do
  before { visit fcrepo_admin.object_datastreams_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:item) }
  it "should link to all datastreams" do
    object.datastreams.each do |dsid, ds|
      page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, ds))
    end
  end  
end
