require 'spec_helper'

describe FcrepoAdmin::AssociationsController do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "#index" do
    subject { get :index, :object_id => object, :use_route => 'fcrepo_admin' }
    it { should render_template(:index) }
  end
  context "#show" do
    context "association is a collection" do
      let(:part) { FactoryGirl.create(:part) }
      before { object.parts << part }
      after do
        part.delete
        object.reload
      end
      subject { get :show, :object_id => object, :id => "parts", :use_route => 'fcrepo_admin' }
      it { should render_template(:show) }
    end
    context "association is not a collection" do
      subject { get :show, :object_id => object, :id => "collection", :use_route => 'fcrepo_admin' }
      context "has target" do
        let(:collection) { FactoryGirl.create(:collection) }
        before { collection.members << object }
        after { collection.delete }
        its(:response_code) { should eq(302) }
      end
      context "target is nil" do
        its(:response_code) { should eq(404) }
      end
    end
  end
end
