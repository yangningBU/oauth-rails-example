require 'rest-client'

class SessionController < ApplicationController
  HOME_URL = "http://lvh.me:8000"
  CALLBACK_URL = HOME_URL + "/authorized"

  GITHUB_BASE = "http://github.com"
  GITHUB_BASE_SECURE = "https://github.com"

  GITHUB_URL_ACCESS_TOKEN = GITHUB_BASE_SECURE + "/login/oauth/access_token"
  GITHUB_URL_GET_USER_INFO = "https://api.github.com/user"

  def home
    @user = session[:github_user]
    render 'home.html.erb'
  end

  def login
    #####
    # STEP 1 - call 'authorize' endpoint at Github to get a temporary code
    ####
    redirect_to github_url_authorize
  end

  def logout
    session.clear
    redirect_to action: 'home'
  end

  def authorized
    #####
    # STEP 2 - exchange the code we got from Github for an access token.
    # 
    # Github directed us here b/c of the redirect_uri in STEP 1
    ####
    csrf_check = params[:state]
    code = params[:code]

    if csrf_token == csrf_check
      post_params  = { 
        client_id: ENV["CLIENT_ID"],
        client_secret: ENV["CLIENT_SECRET"],
        code: code,
        state: csrf_token
      }
      post_headers = { :accept => :json }
      
      # Make actual POST request
      response = RestClient.post GITHUB_URL_ACCESS_TOKEN, post_params, post_headers
        
      if response.code < 300
        # I.e. in the 200 range (a success HTTP code), I'm not checking the lower bound
        # convert JSON string into ruby hash object
        token = JSON.parse(response)["access_token"]
        # now that we have the token, do something with it
        get_user_info(token)
      else
        flash[:alert] = "Code has expired. Try flow from the beginning."
      end
    else
      flash[:alert] = "There was a forgery attempt, try again."
    end

    redirect_to action: 'home'
  end

  #####
  # Helper Methods
  #####

  def get_user_info(access_token)
    #####
    # STEP 4 - query the acutal Github API now that we have an access token. I only want the user info
    #####
    response = RestClient.get GITHUB_URL_GET_USER_INFO, { :Authorization => "token #{access_token}" }
    if response.code < 300
      session[:github_user] = JSON.parse(response)
    else
      flash[:alert] = "Unauthorized to access user info. Perhaps the access token is no longer valid."
    end
  end

  def csrf_token
    # Generate a random alphanumeric mix-cased string of 15 characters long
    session['csrf_token'] ||= begin
      o = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
      (0...15).map { o[rand(o.length)] }.join
    end
  end

  def github_url_authorize
    GITHUB_BASE + 
    "/login/oauth/authorize" + 
    "?client_id=" + ENV["CLIENT_ID"] + 
    "&state=" + csrf_token + 
    "&redirect_uri=" + CGI.escape(CALLBACK_URL)
  end
end
