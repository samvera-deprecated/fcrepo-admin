require 'spec_helper'

describe FcrepoAdmin::DatastreamsController do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "#show" do
    subject { get :show, :object_id => object, :id => object.descMetadata, :use_route => 'fcrepo_admin' }
    it { should render_template(:show) }
  end
  context "#content" do
    subject { get :content, :object_id => object, :id => object.descMetadata, :use_route => 'fcrepo_admin' }
    it { should render_template(:content) }
  end
  context "#download" do
    subject { get :download, :object_id => object, :id => object.descMetadata, :use_route => 'fcrepo_admin' }
    it { should be_successful }
  end
  context "change methods" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
      object.save
      sign_in user
    end
    after { user.delete }
    context "#edit" do
      context "content is editable" do
        subject { get :edit, :object_id => object, :id => object.descMetadata, :use_route => 'fcrepo_admin' }
        it { should render_template(:edit) }
      end
      context "content is not editable" do
        before do
          object.content.content = File.read(File.join(Rails.root, "spec", "fixtures", "files", "hydra.jpg"), {mode: 'rb'})
          object.save
        end
        subject { get :edit, :object_id => object, :id => object.content, :use_route => 'fcrepo_admin' }
        its(:response_code) { should eq(403) }
      end
    end
    context "#upload" do
      context "content is uploadable" do
        subject { get :upload, :object_id => object, :id => object.descMetadata, :use_route => 'fcrepo_admin' }
        it { should render_template(:upload) }        
      end
      context "content is not uploadable" do
        subject { get :upload, :object_id => object, :id => object.externalMetadata, :use_route => 'fcrepo_admin' }
        its(:response_code) { should eq(403) }
      end
    end
    context "#update" do
      context "content" do
        before do
          content = <<EOS
<dc xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dcterms:title>Altered Test Component</dcterms:title>
</dc>
EOS
          put :update, :object_id => object, :id => object.descMetadata, :content => content, :use_route => 'fcrepo_admin'
          object.reload
        end
        it "should update the datastream content and redirect to the show page" do
          object.title.should == "Altered Test Component"
          # TODO get this to work
          # response.should redirect_to :action => :show, :object_id => object, :id => datastream, :use_route => 'fcrepo_admin'
          response.response_code.should == 302
        end
      end
      context "file" do
        before do
          put :update, :object_id => object, :id => object.descMetadata, :file => fixture_file_upload('/files/descMetadata.xml', 'text/xml'), :use_route => 'fcrepo_admin'
          object.reload
        end
        it "should update the datastream content and redirect to the show page" do
          object.title.should == "Altered Test Component"
          # TODO get this to work
          # response.should redirect_to :action => :show, :object_id => object, :id => datastream, :use_route => 'fcrepo_admin'
          response.response_code.should == 302
        end
      end
    end
  end
end
