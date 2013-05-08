require 'spec_helper'

describe "associations/index.html.erb" do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  context "association is a collection" do
    let(:part) { FactoryGirl.create(:part) }
    before { object.parts << part }
    after do
      part.delete
      object.reload
    end
    it "should link to the show view of the association" do
      visit fcrepo_admin.object_associations_path(object)
      page.should have_link("Part (1)", :href => fcrepo_admin.object_association_path(object, "parts"))
    end
  end
  context "association is not a collection" do
    let(:collection) { FactoryGirl.create(:collection) }
    before { collection.members << object }
    after { collection.delete }
    it "should link to the show view of the target object" do
      pending "Bug in Capybara?"
      visit fcrepo_admin.object_associations_path(object)
      page.should have_link("Collection #{collection.pid}", :href => fcrepo_admin.object_path(collection))
    end
  end
end
