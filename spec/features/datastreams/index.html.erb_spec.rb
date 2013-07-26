require 'spec_helper'

describe "datastreams/index.html.erb" do
  before { visit fcrepo_admin.object_datastreams_path(object) }
  after { object.delete }
  let(:object) { FactoryGirl.create(:item) }
  it "should link to all datastreams" do
    object.datastreams.each do |dsid, ds|
      page.should have_link(dsid, :href => fcrepo_admin.object_datastream_path(object, ds))
    end
  end
  context "datastream is not persisted to Fedora" do
    it "should display a 'not used' label" do
      page.should have_xpath("//td[@class = \"#{object.safe_pid}-datastreams-content-not-persisted\" and contains(., \"#{I18n.t('fcrepo_admin.datastream.not_persisted')}\")]")
    end
  end
  context "datastream label is blank" do
    it "should display a 'no label' label" do
      page.should have_xpath("//em[contains(., \"#{I18n.t('fcrepo_admin.datastream.profile.no_label')}\")]")
    end
  end
  context "datastream label is not blank" do
    it "should display the datastream label" do
      page.should have_xpath("//td[@class = \"#{object.safe_pid}-datastreams-RELS-EXT-dsLabel\" and contains(., \"Fedora Object-to-Object Relationship Metadata\")]")
    end
  end
end
