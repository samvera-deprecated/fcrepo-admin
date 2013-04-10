require 'spec_helper'

describe FcrepoAdmin::AuditTrailController do
  context "#index" do
    let(:object) { FactoryGirl.create(:content_model) }
    after { object.delete }
    it "should render the index template" do
      get :index, :object_id => object, :use_route => 'fcrepo_admin'
      response.should render_template(:index)
    end
  end
  context "#index?download=true" do
    context "object does not respond to audit_trail" do
      subject { get :index, :object_id => object, :download => 'true', :use_route => 'fcrepo_admin' }
      let(:object) { FactoryGirl.create(:content_model) }
      after { object.delete }
      its(:response_code) { should eq(200) }
    end
  end
end
