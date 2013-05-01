require 'spec_helper'

describe FcrepoAdmin::ObjectsController do
  let(:object) { FactoryGirl.create(:content_model) }
  after { object.delete }
  context "#show" do
    subject { get :show, :id => object, :use_route => 'fcrepo_admin' }
    it { should render_template(:show) }
  end
  context "#audit_trail" do
    subject { get :audit_trail, :id => object, :use_route => 'fcrepo_admin' }
    it { should render_template(:audit_trail) }
  end
  context "#audit_trail?download=true" do
    subject { get :audit_trail, :id => object, :download => 'true', :use_route => 'fcrepo_admin' }
    its(:response_code) { should eq(200) }
  end
  context "#association" do
    subject { get :association, :id => object, :association => association, :use_route => 'fcrepo_admin' }
    context "not an association" do
      let(:association) { "foo" }
      its(:response_code) { should eq(404) }
    end
    context "collection" do
      pending
    end
    context "not a collection" do
      pending
    end
  end
end
