require 'spec_helper'

describe FcrepoAdmin::ObjectsController do
  context "#show" do
    subject { get :show, :id => object, :use_route => 'fcrepo_admin' }
    let(:object) { FactoryGirl.create(:content_model) }
    after { object.delete }
    it { should render_template(:show) }
  end
  context "#audit_trail" do
    let(:object) { FactoryGirl.create(:content_model) }
    after { object.delete }
    subject { get :audit_trail, :id => object, :use_route => 'fcrepo_admin' }
    it { should render_template(:audit_trail) }
  end
  context "#audit_trail?download=true" do
    subject { get :audit_trail, :id => object, :download => 'true', :use_route => 'fcrepo_admin' }
    let(:object) { FactoryGirl.create(:content_model) }
    after { object.delete }
    its(:response_code) { should eq(200) }
  end
end
