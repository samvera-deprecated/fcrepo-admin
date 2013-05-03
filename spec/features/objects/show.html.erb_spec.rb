require 'spec_helper'

describe "objects/show.html.erb" do
  before { visit fcrepo_admin.object_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:item) }
  it "should link to other views" do
    page.should have_link(I18n.t("fcrepo_admin.object.nav.items.audit_trail"), :href => fcrepo_admin.audit_trail_object_path(object))
    page.should have_link(I18n.t("fcrepo_admin.object.nav.items.permissions"), :href => fcrepo_admin.permissions_object_path(object))
    page.should have_link(I18n.t("fcrepo_admin.object.nav.items.associations"), :href => fcrepo_admin.object_associations_path(object))
    page.should have_link(I18n.t("fcrepo_admin.object.nav.items.datastreams"), :href => fcrepo_admin.object_datastreams_path(object))
  end
end
