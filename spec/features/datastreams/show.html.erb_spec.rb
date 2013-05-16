require 'spec_helper'

RSpec.configure do |c|
  Warden.test_mode!
end

describe "datastreams/show.html.erb" do
  let!(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "user can read" do
    before { visit fcrepo_admin.object_datastream_path(object, datastream) }
    context "content is text" do
      let(:datastream) { object.descMetadata }
      it "should display all attributes of the datastream profile" do
        datastream.profile.each do |key, value|
          page.should have_content(I18n.t("fcrepo_admin.datastream.profile.#{key}"))
        end
      end
      it "should have a link to download the datastream content" do
        page.should have_link(I18n.t("fcrepo_admin.datastream.nav.items.content"), :href => fcrepo_admin.content_object_datastream_path(object, datastream))
      end
      it "should have a link to view the content" do
        page.should have_link(I18n.t("fcrepo_admin.datastream.nav.items.content"), :href => fcrepo_admin.content_object_datastream_path(object, datastream))
      end
    end
    context "content is not text" do
      let(:datastream) { object.content }
      before do
        datastream.content = File.read(File.join(Rails.root, "spec", "fixtures", "files", "hydra.jpg"), {mode: 'rb'})
        object.save
      end
      it "should not have a link to view the content" do
        page.should_not have_link(I18n.t("fcrepo_admin.datastream.nav.items.content"), :href => fcrepo_admin.content_object_datastream_path(object, datastream))
      end
    end
  end
  context "user cannot edit" do
    let(:datastream) { object.descMetadata }
    before { visit fcrepo_admin.object_datastream_path(object, datastream) }
    it "should not have links to edit or upload" do
      page.should_not have_link(I18n.t("fcrepo_admin.datastream.nav.items.edit"), :href => fcrepo_admin.edit_object_datastream_path(object, datastream))
      page.should_not have_link(I18n.t("fcrepo_admin.datastream.nav.items.upload"), :href => fcrepo_admin.upload_object_datastream_path(object, datastream))
    end
  end
  context "user can edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      object.permissions = [{type: 'user', name: user.email, access: 'edit'}]
      object.save
      login_as(user, :scope => :user, :run_callbacks => false) 
      visit fcrepo_admin.object_datastream_path(object, datastream)
    end
    after do
      user.delete
      Warden.test_reset!
    end
    context "datastream content is editable" do
      let(:datastream) { object.descMetadata }
      it "should have an edit link" do
        page.should have_link(I18n.t("fcrepo_admin.datastream.nav.items.edit"), :href => fcrepo_admin.edit_object_datastream_path(object, datastream))
      end
    end
    context "datastream content is uploadable" do
      let(:datastream) { object.descMetadata }
      it "should have an upload link" do
        page.should have_link(I18n.t("fcrepo_admin.datastream.nav.items.upload"), :href => fcrepo_admin.upload_object_datastream_path(object, datastream))
      end
    end
  end
end
