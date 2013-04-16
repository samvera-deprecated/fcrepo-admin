require 'spec_helper'

describe FcrepoAdmin::ObjectsController do
  context "#show" do
    subject { get :show, :id => object, :use_route => 'fcrepo_admin' }
    let(:object) { FactoryGirl.create(:content_model) }
    after { object.delete }
    it { should render_template(:show) }
  end
end
