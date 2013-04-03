require 'spec_helper'

describe "catalog/show.html.erb" do
  subject { page }
  before { visit catalog_path(object, :use_route => 'fcrepo_admin') }
  after { object.delete }
  context "Basic object" do
    let(:object) { ActiveFedora::Base.create }
    it "should link to all datastreams"
    it "should link to its audit trail"
  end
  context "object has admin policy" do
    it "should link to the APO"
  end
end
