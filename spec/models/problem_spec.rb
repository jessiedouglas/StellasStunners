require 'spec_helper'

describe Problem do
  it "allows a standard problem" do
    problem = FactoryGirl.build(:problem)
    expect(problem).to be_valid
  end
  
  it "requires all necessary fields" do
    p1 = FactoryGirl.build(:problem, title: "")
    p2 = FactoryGirl.build(:problem, body: "")
    p3 = FactoryGirl.build(:problem, solution: "")
    
    [p1, p2, p3].each do |problem|
      expect(problem).to_not be_valid
    end
  end
  
  it "allows a stella number and is_original to be false" do
    p1 = FactoryGirl.build(:problem, stella_number: 4000.12)
    p2 = FactoryGirl.build(:problem, is_original: false)
    
    expect(p1).to be_valid
    expect(p2).to be_valid
  end
end
