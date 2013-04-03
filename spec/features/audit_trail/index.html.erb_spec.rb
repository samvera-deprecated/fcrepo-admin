require 'spec_helper'

describe "audit_trail/index.html.erb" do
  subject { page }
  let(:object) { ActiveFedora::Base.create }
  before { visit fcrepo_admin.audit_trail_index_path(object) }
  after { object.delete }
  it "should display the audit trail" do
    pending "Merging of https://github.com/projecthydra/active_fedora/pull/47 into active_fedora"
    expect(subject).to have_content(object.pid)
    expect(subject).to have_link("Download Raw XML", :href => "#{fcrepo_admin.audit_trail_index_path(object)}?download=true")
  end
end
