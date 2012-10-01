class Member < Salesforce

  def self.all(access_token, fields, order_by) 
    puts "fields: #{fields}"
    set_header_token(access_token)   
    make_pretty(get(ENV['SFDC_APEXREST_URL'] +  "/members?fields=#{esc fields}&orderby=#{esc order_by}"))
  end

  def self.search(access_token, fields, membername)
    set_header_token(access_token)    
    make_pretty(get(ENV['SFDC_APEXREST_URL'] +  "/members?fields=#{esc fields}&search=#{esc membername}"))
  end

  def self.challenges(access_token, membername)
    set_header_token(access_token)    
    make_pretty(get(ENV['SFDC_APEXREST_URL'] +  "/members/#{esc membername}/challenges"))
  end

  def self.recommendations(access_token, membername, fields) 
    set_header_token(access_token)    
    make_pretty(get(ENV['SFDC_APEXREST_URL'] +  "/recommendations?fields=#{esc fields}&search=#{esc membername}"))
  end

  def self.find_by_username(access_token, membername, fields)
    set_header_token(access_token)    
    make_pretty(get(ENV['SFDC_APEXREST_URL']+"/members/#{esc membername}?fields=#{esc fields}"))
  end

  def self.recommendation_create(access_token, for_member, from_member, comments)
    set_header_token(access_token)  

    options = {
      :body => {
        :recommendation_for_username => for_member,
        :recommendation_from_username => from_member,
        :recommendation_text => comments
      }
    }
    puts "options in api call to sfdc: #{options}"
    results = post(ENV['SFDC_APEXREST_URL']+'/recommendations', options)
    { :success => results['Success'], :message => results['Message'] }
  end

  def  self.hello
    "hello world"
  end  

end