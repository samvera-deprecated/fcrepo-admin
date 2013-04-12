require 'spec_helper'

RSpec.configure do |c|
  Warden.test_mode!
end

describe "datastreams/edit.html.erb" do
  let(:object) { FactoryGirl.create(:content_model) }
  let(:user) { FactoryGirl.create(:user) }
  before { 
    object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
    object.save
    login_as(user, :scope => :user, :run_callbacks => false) 
    visit fcrepo_admin.edit_object_datastream_path(object, "descMetadata")
  }
  after do
    user.delete
    object.delete
    Warden.test_reset!
  end
  it "should provide an upload form to replace content" do
    
  end
  it "should provide a text field to edit/replace text content" do
    fill_in "content", :with => <<EOS
<dc xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dcterms:title>Altered Test Component</dcterms:title>
</dc>
EOS
    click_button I18n.t("fcrepo_admin.datastream.edit.submit")
    object.reload
    object.title.should == "Altered Test Component"
  end
end
