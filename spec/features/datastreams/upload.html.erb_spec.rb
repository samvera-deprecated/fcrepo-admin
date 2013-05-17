require 'spec_helper'

RSpec.configure do |c|
  Warden.test_mode!
end

describe "datastreams/upload.html.erb" do
  let(:object) { FactoryGirl.create(:item) }
  let(:user) { FactoryGirl.create(:user) }
  before { 
    object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
    object.save
    login_as(user, :scope => :user, :run_callbacks => false) 
    visit fcrepo_admin.upload_object_datastream_path(object, "descMetadata")
  }
  after do
    user.delete
    object.delete
    Warden.test_reset!
  end
  it "should provide an upload form" do
    attach_file "file", File.join(Rails.root, "spec", "fixtures", "files", "descMetadata.xml")
    click_button I18n.t("fcrepo_admin.datastream.upload.form.submit")
    object.reload
    object.title.should == "Altered Test Component"
  end
end
