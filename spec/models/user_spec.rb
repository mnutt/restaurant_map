require 'spec/spec_helper'

describe User do
  describe "#foursquare_authorized?" do
    it "is authorized if user has foursquare attributes set" do
      @user = Factory.create(:user)
      @user.foursquare_oauth_token = '123'
      @user.foursquare_oauth_secret = '321'
      @user.should be_foursquare_authorized
    end
  end
end
