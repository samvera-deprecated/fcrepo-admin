require 'spec_helper'

describe "objects/properties.html.erb" do
  before { visit fcrepo_admin.properties_object_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:content_model) }
  it "should display the object's properties" do
    page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.state"))
    page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.create_date"))
    page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.modified_date"))
    page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.owner_id"))
    page.should have_content(I18n.t("fcrepo_admin.object.properties.keys.label"))
  end
end
