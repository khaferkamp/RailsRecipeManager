require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create(chefname: "john", email: "john@example.com")
  end

  test "chef should be valid" do
    assert @chef.valid?
  end

  test "chefname should be present" do
    @chef.chefname= " "

    assert_not @chef.valid?
  end

  test "chefname should not be too long" do
    @chef.chefname= "a"*51

    assert_not @chef.valid?
  end

  test "chefname should not be too short" do
    @chef.chefname= "a"

    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email= " "

    assert_not @chef.valid?
  end

  test "email should be unique" do
    dup_chef = @chef.dup
    dup_chef.email = @chef.email
    @chef.save

    assert_not dup_chef.valid?
  end

  test "email should be a valid email" do
    @chef.email= "email"

    assert_not @chef.valid?
  end

  test "email should accept whitelist entries" do
    valid_addresses = %w[john@example.com will.wills@hoster.de master.yoda@force.net]

    valid_addresses.each do |val|
      @chef.email = val
      assert @chef.valid?, "#{val.inspect} should be valid"
    end
  end

  test "email should reject blacklist entries" do
    not_valid_addresses = %w[john@example @hoster.de .net]

    not_valid_addresses.each do |val|
      @chef.email = val
      assert_not @chef.valid?, "#{val.inspect} should not be valid"
    end
  end
end
