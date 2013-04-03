require 'spec_helper'

describe "catalog/index.html.erb" do
  let(:object) { ActiveFedora::Base.create }
  after { object.delete }
  context "search" do
    it "should display the PID of the object"
  end
end
