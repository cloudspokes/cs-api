require 'spec_helper'
require 'stats'

describe Stats do

  # get oauth tokens for different users
  before(:all) do
    VCR.use_cassette "shared/public_oauth_token", :record => :all do
      @public_oauth_token = SfdcHelper.public_access_token
    end
  end  	

  describe "public stats" do
    it "should return the correct keys" do
      VCR.use_cassette "lib/stats/public_success" do
        results = Stats.public(@public_oauth_token)
				%w{challenges_won featured_challenge_id featured_challenge_details 
					challenges_open featured_member_wins money_up_for_grabs 
					featured_challenge_prize money_pending featured_member_pic 
					entries_submitted featured_member_active featured_member_username 
					featured_challenge_name featured_member_money members}.each do |k|
					results.should have_key(k)
				end
      end
    end
  end	

end