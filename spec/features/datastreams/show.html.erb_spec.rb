require 'spec_helper'

RSpec.configure do |c|
  Warden.test_mode!
end

describe "datastreams/show.html.erb" do
  let!(:object) { FactoryGirl.create(:content_model) }
  let(:dsid) { "descMetadata" }
  before { visit fcrepo_admin.object_datastream_path(object, dsid) }
  after { object.delete }
  it "should display all attributes of the datastream profile" do
    object.datastreams[dsid].profile.each do |key, value|
      # TODO use paths
      page.should have_content(I18n.t("fcrepo_admin.datastream.profile.#{key}"))
      page.should have_content(value)
    end
  end
  it "should have a link to download the datastream content" do
    page.should have_link(I18n.t("fcrepo_admin.datastream.download"), :href => "#{fcrepo_admin.object_datastream_path(object, dsid)}?download=true")
  end
  context "user can edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
      object.save
      login_as(user, :scope => :user, :run_callbacks => false) 
      visit fcrepo_admin.object_datastream_path(object, dsid)
    end
    after do
      user.delete
      Warden.test_reset!
    end
    it "should have a link to the edit page" do
      page.should have_link("", :href => fcrepo_admin.edit_object_datastream_path(object, dsid))
    end
  end
end
