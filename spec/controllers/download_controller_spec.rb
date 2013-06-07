require 'spec_helper'

describe FcrepoAdmin::DownloadController do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "#show" do
    it "should have the right content and headers" do
      get :show, :object_id => object.pid, :id => object.descMetadata, :use_route => 'fcrepo_admin'
      response.headers['Content-Disposition'].should == "inline; filename=\"#{object.pid.sub(/:/, '_')}__descMetadata.xml\""
    end
  end
end
