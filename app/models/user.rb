class User < ActiveRecord::Base
  acts_as_authentic

  has_many :collections
  has_many :restaurants, :through => :collections, :order => 'created_at DESC'

  def foursquare_authorized?
    self.foursquare_oauth_token.present? && self.foursquare_oauth_secret.present?
  end

  def foursquare
    # return false # Airplane mode

    begin
      oauth = Foursquare::OAuth.new(ENV['FOURSQUARE_OAUTH_KEY'], ENV['FOURSQUARE_OAUTH_SECRET'])
      oauth.authorize_from_access(self.foursquare_oauth_token, self.foursquare_oauth_secret)
      Foursquare::Base.new(oauth)
    rescue SocketError, Errno::EAGAIN, Timeout::Error => err
      nil
    end
  end

  def recent_restaurants
    self.restaurants.order('created_at DESC').limit(5)
  end
end
