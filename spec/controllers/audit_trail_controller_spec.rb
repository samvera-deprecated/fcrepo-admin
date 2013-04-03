require 'spec_helper'

describe AuditTrailController do
  context "#index" do
    context "object does not respond to audit_trail" do
      subject { get :index, :object_id => object, :use_route => 'fcrepo_admin' }
      let(:object) { ActiveFedora::Base.create }
      after { object.delete }
      its(:response_code) { should eq(404) }
    end
  end
  context "#index?download=true" do
    context "object does not respond to audit_trail" do
      subject { get :index, :object_id => object, :download => 'true', :use_route => 'fcrepo_admin' }
      let(:object) { ActiveFedora::Base.create }
      after { object.delete }
      its(:response_code) { should eq(404) }
    end
  end
end
