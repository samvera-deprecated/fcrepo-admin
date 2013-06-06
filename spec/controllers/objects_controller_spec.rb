require 'spec_helper'

describe FcrepoAdmin::ObjectsController do
  before { @object = FactoryGirl.create(:item) }
  after { @object.delete }
  context "#show" do
    context "html format" do
      subject { get :show, :id => @object, :use_route => 'fcrepo_admin' }
      it { should render_template(:show) }
    end
    context "xml format" do
      subject { get :show, :id => @object.pid, :format => 'xml', :use_route => 'fcrepo_admin' }
      its(:body) { should eq(@object.object_xml) }
    end
  end
  context "#audit_trail" do
    context "html format" do
      subject { get :audit_trail, :id => @object, :use_route => 'fcrepo_admin' }
      it { should render_template(:audit_trail) }
    end
    context "xml format" do
      subject { get :audit_trail, :id => @object.pid, :format => 'xml', :use_route => 'fcrepo_admin' }
      its(:body) { should eq(@object.audit_trail.to_xml) }
    end
  end
  context "#permissions" do
    subject { get :permissions, :id => @object, :use_route => 'fcrepo_admin' }
    it { should render_template(:permissions) }
  end
end
