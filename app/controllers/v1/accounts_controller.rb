class V1::AccountsController < V1::ApplicationController

  before_filter :restrict_access

  #
  # Post method to create a new member in db.com and send welcome email
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - params -> hash containing values to use for new user
  #      - for third-party: provider, provider_username, username, email, name (can be blank)
  #      - for cloudspokes: username, email, password 
  # * *Returns* :
  #   - JSON containing the following keys: username, sfdc_username, success, message 
  # * *Raises* :
  #   - ++ ->
  #  
  def create
    expose Account.create(@oauth_token, params)
  end

  #
  # Post method to authenticates a membername and password against db.com.
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess)
  #   - password -> the db.com password
  # * *Returns* :
  #   - JSON containing the following keys: access_token, success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def authenticate
    expose Account.authenticate(@oauth_token, params[:membername], params[:password])
  end

  #
  # Activates a member and their sfdc account
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess)
   # * *Returns* : 
  #   - boolean
  # * *Raises* :
  #   - ++ ->
  #  
  def activate
    expose Account.activate(@oauth_token, params[:membername])
  end  

  #
  # Disables a member and their sfdc account
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess)
   # * *Returns* : 
  #   - boolean
  # * *Raises* :
  #   - ++ ->
  #  
  def disable
    expose Account.disable(@oauth_token, params[:membername])
  end    

  #
  # Finds a member's account info by their membername.
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to find
  # * *Returns* :
  #   - JSON containing the following keys: username, sfdc_username, success
  #     profile_pic, email and accountid
  # * *Raises* :
  #   - ++ ->
  #  
  def find
    expose Account.find(@oauth_token, params[:membername])
  end  

  #
  # Finds a user by their membername and service ('cloudspokes' or third party).
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to find
  #   - service -> the thirdparty or 'cloudspokes' service
  # * *Returns* :
  #   - JSON containing the following keys: username, sfdc_username, success
  #     profile_pic, email and accountid
  # * *Raises* :
  #   - ++ ->
  #  
  def find_by_service
    expose Account.find_by_service(@oauth_token, params[:service], params[:service_username])
  end

  #
  # Creates a passcode in salesforce for resetting a member's password and sends email via Apex. 
  # Only works if member is using CloudSpokes to manage their account.
  # DEPRECATED
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to reset
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def reset_password
    expose Account.reset_password(@oauth_token, params[:membername])
  end

  #
  # Resets a member's password in salesforce is CloudSpokes is managing their account.
  # DEPRECATED
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to reset
  #   - passcode -> the passcode sent to them via email
  #   - new_password -> the new password to change their account to
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def update_password
    expose Account.update_password(@oauth_token, params[:membername], params[:passcode], params[:new_password])
  end 

  #
  # Updates their passcode in SFDC with token from devise
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to reset
  #   - token -> the token generated by devise
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def update_password_token
    expose Account.update_password_token(@oauth_token, params[:membername], params[:token])
  end    

  #
  # Resets a member's password in salesforce is CloudSpokes is managing their account.
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to reset
  #   - passcode -> the passcode sent to them via email
  #   - new_password -> the new password to change their account to
  #   - token -> the token generated by devise
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def change_password_with_token
    expose Account.change_password_with_token(@oauth_token, params[:membername], params[:token], params[:new_password])
  end    

  #
  # Sets a member as being referred by another member
  # * *Args*    :
  #   - access_token -> the oauth token to use
  #   - membername -> the cloudspokes member name (mess) to set the referral fro
  #   - referral_id_or_membername -> the referral id or member name of the referring member
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def referred_by
    expose Account.referred_by(@oauth_token, params[:membername], params[:referral_id_or_membername])
  end     

  #
  # Updates the marketing info for a member
  # * *Args*    :
  #   - admin_oauth_token -> the oauth token to use -- ALWAYS USES ADMIN TOKEN FOR SECURITY
  #   - membername -> the cloudspokes member name (mess) to set the referral fro
  #   - params -> params containing the marketing info to update
  # * *Returns* :
  #   - JSON containing the following keys: success, message
  # * *Raises* :
  #   - ++ ->
  #  
  def apply_marketing_info
    expose Account.apply_marketing_info(admin_oauth_token, params[:membername], params)
  end   

  #
  # Returns member & account info based
  # * *Args*    :
  #   - admin_oauth_token -> the oauth token to use -- ALWAYS USES ADMIN TOKEN FOR SECURITY
  #   - params -> params containing either the email or member name
  # * *Returns* :
  #   - JSON containing the member info
  # * *Raises* :
  #   - ++ ->
  #  
  def whois
    expose Account.whois(admin_oauth_token, params)
  end   

end