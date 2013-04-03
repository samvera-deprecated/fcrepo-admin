require 'spec_helper'

shared_examples "a datastream profile view" do
  it { should render_template(:show) }
end

describe DatastreamsController do
  after { object.delete }
  context "#show" do
    let(:object) { ActiveFedora::Base.create }
    let(:dsid) { "DC" }
    context "profile information" do
      subject { get :show, :object_id => object, :id => dsid, :use_route => 'fcrepo_admin' }
      it { should render_template(:show) }
    end
    context "download content" do
      subject { get :show, :object_id => object, :id => dsid, :download => 'true', :use_route => 'fcrepo_admin' }
      # XXX more specific expectation
      it { should be_successful }
    end
  end
end
