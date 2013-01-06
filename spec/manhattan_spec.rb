require "spec_helper"

describe Manhattan do

  let(:box) { MysteryBox.new }
  let(:empty_box) { EmptyBox.new }

  it "creates a status map through the class method" do
    box.statuses.count.should be(3)
  end

  it "starts with an empty status" do
    box.status.should be_nil
  end

  it "lists statuses" do
    MysteryBox.statuses.should eq(["opened", "closed", "glowing"])
  end

  it "creates query methods for each state" do
    box.should respond_to(:is_opened?)
    box.should respond_to(:is_closed?)
    box.should_not respond_to(:is_eated?)
  end

  it "should fail is using a defined method" do
    fake_box = MysteryBox.dup
    expect { fake_box.has_statuses(:new) }.to raise_error(Manhattan::AlreadyDefinedMethod)
  end

  it "creates query methods that negated each state" do
    box.should respond_to(:is_not_opened?)
    box.should respond_to(:is_unopened?)
  end

  it "sets a new status" do
    box.mark_as_opened
    box.status.should == "opened"
  end

  it "isolates the change to only one instance" do
    box.mark_as_opened
    another_box = MysteryBox.new
    another_box.status.should_not == "opened"
  end

  describe "when setting an state" do

    before do
      box.mark_as_opened
    end

    it "allows to query current state" do
      box.is_opened?.should eq(true)
      box.is_closed?.should eq(false)
    end

    it "allows to query the negated state" do
      box.is_unopened?.should eq(false)
      box.is_not_closed?.should eq(true)
    end

    it "calls a before and after state method only if it exists" do
      box.should_receive(:before_glowing)
      box.mark_as_glowing
    end

    it "creates related scopes" do
      MysteryBox.should respond_to(:opened)
      MysteryBox.should respond_to(:closed)
    end

    it "queries through clases scopes" do
      MysteryBox.opened.count.should eq(1)
      MysteryBox.closed.count.should eq(0)
    end

  end

  describe "when using alternate columns" do
    it "takes the alternate column" do
      empty_box.mark_as_opened
      empty_box.state.should eq("opened")
    end

    it "starts with the default state" do
      empty_box.state.should eq("opened")
    end
  end

end