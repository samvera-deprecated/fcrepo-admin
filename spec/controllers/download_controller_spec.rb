require 'spec_helper'

describe FcrepoAdmin::DownloadController do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "#show" do
    #get :show, :object_id => object.pid, :id => object.descMetadata, :use_route => 'fcrepo_admin'
    pending "Test response body or size"
    pending "Test response header filename"
  end
end
