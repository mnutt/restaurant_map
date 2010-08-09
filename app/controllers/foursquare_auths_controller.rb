class FoursquareAuthsController < ApplicationController
  before_filter :require_user
  before_filter :load_consumer, :except => :destroy

  def index
    if session[:foursquare_request_token] && params[:oauth_token]
      access_token, access_secret = @consumer.authorize_from_request(session[:foursquare_request_token],
                                                                     session[:foursquare_request_secret],
                                                                     params[:oauth_token])

      current_user.update_attributes(:foursquare_oauth_token => access_token,
                                     :foursquare_oauth_secret => access_secret)

      flash[:notice] = "Foursquare! Yay!"
      redirect_to my_account_path
    else
      redirect_to my_account_path
    end
  end

  def create
    session[:foursquare_request_token]  = @consumer.request_token.token
    session[:foursquare_request_secret] = @consumer.request_token.secret

    redirect_to @consumer.request_token.authorize_url
  end

  def destroy
    current_user.update_attributes(:foursquare_oauth_token => nil, :foursquare_oauth_secret => nil)
    respond_to do |format|
      format.js
    end
  end

private
  def load_consumer
    @consumer = Foursquare::OAuth.new(
      ENV['FOURSQUARE_OAUTH_KEY'],
      ENV['FOURSQUARE_OAUTH_SECRET']
    )
  end
end
