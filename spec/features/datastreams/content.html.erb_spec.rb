require 'spec_helper'

describe "datastreams/content.html.erb" do
  let(:object) { FactoryGirl.create(:item) }
  after { object.delete }
  it "should display the datastream content"
end
