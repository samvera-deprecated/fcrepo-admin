require 'spec_helper'

describe "objects/show.html.erb" do
  before { visit fcrepo_admin.object_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:content_model) }
  it "should link to all datastreams" do
    object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each_key do |dsid|
      page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, dsid))
    end
  end
  it "should link to its audit trail" do
    page.should have_link(I18n.t("fcrepo_admin.object.audit_trail.title"), :href => fcrepo_admin.audit_trail_object_path(object))
  end
end
