require 'spec_helper'

describe VicfaContent do

  it "has zero records" do
    VicfaContent.count.should == 0
  end

  it "passes validation with no params" do
    FactoryGirl.create(:vicfa_content)
    VicfaContent.count.should == 1
  end

  it "should respond to pathogens" do
    @vicfa = VicfaContent.new
    @vicfa.respond_to?(:pathogens).should == true
  end

  it "should respond to reference_datasets" do
    @vicfa = VicfaContent.new
    @vicfa.respond_to?(:reference_datasets).should == true
  end

  it "should respond to resources" do
    @vicfa = VicfaContent.new
    @vicfa.respond_to?(:resources).should == true
  end

  it "fails validation on poorly formatted wiki_link (using errors_on)" do
    VicfaContent.new({
      :wiki_link => 'htp://en.wikipedia.org'
    }).should have(1).error_on(:wiki_link)
  end

  it "passes validation with properly formatted wiki_link (using errors_on)" do
    VicfaContent.new({
      :wiki_link => 'http://en.wikipedia.org'
    }).should have(0).error_on(:wiki_link)
  end

  it "returns true if attributes are empty" do
    @vicfa = VicfaContent.new
    @vicfa.attributes_empty?({}).should == true
  end

  it "returns false if attributes are not empty" do
    @vicfa = VicfaContent.new
    @vicfa.attributes_empty?({ "key"=>"val" }).should == false
  end

end
