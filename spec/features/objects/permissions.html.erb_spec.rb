require 'spec_helper'

describe "objects/permissions.html.erb" do
  after { object.delete }
  context "object governed by an admin policy" do
    let(:object) { FactoryGirl.create(:content_model_has_apo) }
    after { object.admin_policy.delete }
    it "should link to the APO" do
      visit fcrepo_admin.permissions_object_path(object)
      page.should have_link(object.admin_policy.pid, :href => fcrepo_admin.object_path(object.admin_policy))
    end
    it "should display the inherited permissions"
  end
end
