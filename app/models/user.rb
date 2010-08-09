class User < ActiveRecord::Base
  acts_as_authentic

  has_many :collections
  has_many :restaurants, :through => :collections

  def foursquare_authorized?
    self.foursquare_oauth_token.present? && self.foursquare_oauth_secret.present?
  end

  def foursquare
    oauth = Foursquare::OAuth.new(ENV['FOURSQUARE_OAUTH_KEY'], ENV['FOURSQUARE_OAUTH_SECRET'])
    oauth.authorize_from_access(self.foursquare_oauth_token, self.foursquare_oauth_secret)
    Foursquare::Base.new(oauth)
  end
end
