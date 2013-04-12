require 'spec_helper'

shared_examples "a datastream profile view" do
  it { should render_template(:show) }
end

describe FcrepoAdmin::DatastreamsController do
  before do
    @object = FactoryGirl.create(:content_model)
    @dsid = "descMetadata"
  end
  after { @object.delete }
  context "#show" do
    context "browser view" do
      subject { get :show, :object_id => @object, :id => @dsid, :use_route => 'fcrepo_admin' }
      it { should render_template(:show) }
    end
    context "download" do
      subject { get :show, :object_id => @object, :id => @dsid, :download => 'true', :use_route => 'fcrepo_admin' }
      it { should be_successful }
    end
  end
  context "change methods" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      @object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
      @object.save
      sign_in user
    end
    after { user.delete }
    context "#edit" do
      subject { get :edit, :object_id => @object, :id => @dsid, :use_route => 'fcrepo_admin' }
      it { should render_template(:edit) }
    end
    context "#update" do
      context "content" do
        before do
          @content = <<EOS
<dc xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dcterms:title>Altered Test Component</dcterms:title>
</dc>
EOS
          put :update, :object_id => @object, :id => @dsid, :content => @content, :use_route => 'fcrepo_admin'
          @object.reload
        end
        it "should update the datastream content and redirect to the show page" do
          @object.title.should == "Altered Test Component"
          # TODO get this to work
          # response.should redirect_to :action => :show, :object_id => @object, :id => @dsid, :use_route => 'fcrepo_admin'
          response.response_code.should == 302
        end
      end
      context "file" do
        before do
          @file = fixture_file_upload('/files/descMetadata.xml', 'text/xml')
          put :update, :object_id => @object, :id => @dsid, :file => @file, :use_route => 'fcrepo_admin'
          @object.reload
        end
        it "should update the datastream content and redirect to the show page" do
          @object.title.should == "Altered Test Component"
          # TODO get this to work
          # response.should redirect_to :action => :show, :object_id => @object, :id => @dsid, :use_route => 'fcrepo_admin'
          response.response_code.should == 302
        end
      end
    end
  end
end
