require 'spec_helper'

describe User, :type => :model do

  it{is_expected.to have_many :restaurants}

  it{is_expected.to have_many :reviews}
end