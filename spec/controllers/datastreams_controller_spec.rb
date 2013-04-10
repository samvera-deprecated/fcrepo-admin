require 'spec_helper'

shared_examples "a datastream profile view" do
  it { should render_template(:show) }
end

describe FcrepoAdmin::DatastreamsController do
  after { object.delete }
  context "#show" do
    let(:object) { FactoryGirl.create(:content_model) } 
    let(:dsid) { "DC" }
    context "profile information" do
      subject { get :show, :object_id => object, :id => dsid, :use_route => 'fcrepo_admin' }
      it { should render_template(:show) }
    end
    context "download content" do
      subject { get :show, :object_id => object, :id => dsid, :download => 'true', :use_route => 'fcrepo_admin' }
      it { should be_successful }
    end
  end
end
