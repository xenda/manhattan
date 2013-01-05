require "spec_helper"
require 'manhattan'
require 'mysterious_box'

describe Manhattan do

  let(:box) { MysteriousBox.new }

  it "creates a status map through the class method" do
    box.statuses.count.should be(3)
  end

  it "lists statuses" do
    MysteriousBox.statuses.should eq(["opened", "closed", "glowing"])
  end

  it "creates query methods for each state" do
    box.should respond_to(:opened?)
    box.should respond_to(:closed?)
    box.should_not respond_to(:eated?)
  end

  it "creates query methods that negated each state" do
    box.should respond_to(:not_opened?)
    box.should respond_to(:unopened?)
  end

  it "sets a new status" do
    box.mark_as_opened
    box.status.should == "opened"
  end

  describe "when setting an state" do

    before do
      box.mark_as_opened
    end

    it "allows to query current state" do
      box.opened?.should eq(true)
      box.closed?.should eq(false)
    end

    it "allows to query the negated state" do
      box.unopened?.should eq(false)
      box.not_closed?.should eq(true)
    end

    it "calls a before and after state method only if it exists" do
      box.should_receive(:before_glowing)
      box.mark_as_glowing
    end

  end



end