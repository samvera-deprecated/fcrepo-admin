require 'spec_helper'

describe AuditTrailController do
  context "#index" do
    subject { get :index, :object_id => object, :use_route => 'fcrepo_admin' }
    let(:object) { FactoryGirl.create(:fcrepo_object) }
    after { object.delete }
    it { should render_template(:index) } 
  end
  context "#index?download=true" do
    subject { get :index, :object_id => object, :download => 'true', :use_route => 'fcrepo_admin' }
    let(:object) { FactoryGirl.create(:fcrepo_object) }
    after { object.delete }
    it { should be_successful }
  end
end
