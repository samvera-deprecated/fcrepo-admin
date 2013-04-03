require 'spec_helper'
require 'helpers/features_helper'

RSpec.configure do |c|
  c.include FeaturesHelper
end

describe "catalog/show.html.erb" do
  subject { page }
  before { visit fcrepo_admin.catalog_path(object) }
  after do
    object.parent.delete if object.respond_to?(:parent) && object.parent
    if object.respond_to?(:children) && object.children
      object.children.each do |child|
        child.delete
      end
      object.reload
    end
    object.admin_policy.delete if object.admin_policy
    if object.respond_to?(:targets) && object.targets
      object.targets.each do |target|
        target.delete
      end
      object.reload
    end
    object.delete
  end
  context "Basic object" do
    let(:object) { ActiveFedora::Base.create }
    # it "should display the PID and model, title and identifier(s)" do
    #   expect(subject).to have_content(object.pid)
    #   expect(subject).to have_content(object.class.to_s)
    #   expect(subject).to have_content(object.title_display)
    #   expect(subject).to have_content(object.identifier.first)
    # end
    it "should link to all datastreams" do
      object.datastreams.reject { |dsid, ds| ds.profile.empty? }.each do |dsid, ds|
        expect(subject).to have_content(dsid)
      end
    end  
    it "should link to its audit trail" do
      expect(subject).to have_link("Audit Trail", :href => fcrepo_admin.audit_trail_index_path(object))
    end
  end
  # context "Object has a parent" do
  #   let(:object) { FactoryGirl.create(:item_in_collection_public_read) }
  #   it "should display its parent object" do
  #     #expect(subject).to have_link(object.parent.title_display, :href => catalog_path(object.parent))
  #     expect(subject).to have_content(object.parent.title_display)
  #   end
  # end
  # inline display of children is now deprecated in favor of displaying children on a separate page
  # see context "object can have children" for tests related to displaying the link to the children page on this page
  #context "Object has children" do
  #  context "Object has contentMetadata datastream" do
  #    let(:object) { FactoryGirl.create(:test_content_metadata_has_children) }
  #    it "should should display the children in proper order" do
  #      expect(subject).to have_link("DulHydra Test Child Object", catalog_path(object.children.first.pid))
  #      expect(subject).to have_link("DulHydra Test Child Object", catalog_path(object.children[1].pid))
  #      expect(subject).to have_link("DulHydra Test Child Object", catalog_path(object.children.last.pid))
  #      catalog_path(object.children.last.pid).should appear_before(catalog_path(object.children.first.pid))
  #    end
  #  end
  #end
  # context "object can have children" do
  #   context "object has children" do
  #     let (:object) { FactoryGirl.create(:test_parent_has_children) }
  #     it "should have a link to the list of its children" do
  #       expect(subject).to have_link("Children", :href => children_path(object))
  #     end
  #   end
  #   context "object does not have children" do
  #     let (:object) { FactoryGirl.create(:test_parent) }
  #     it "should not have a link to children" do
  #       expect(subject).to_not have_link("Children", :href => children_path(object))
  #     end
  #   end
  # end
  # context "object has a thumbnail" do
  #   let(:object) { FactoryGirl.create(:test_content_thumbnail) }
  #   it "should display the thumbnail" do
  #     expect(subject).to have_css(".img-polaroid")
  #   end
  # end
  context "object has admin policy" do
    let(:object) { FactoryGirl.create(:fcrepo_object_apo) }
    after do
      object.admin_policy.delete
      object.delete
    end
    it "should display its admin policy PID" #do
#      expect(subject).to have_content(object.admin_policy.pid)
#    end
  end
end
