require 'member'
require 'bunny'

class Squirrelforce  < Salesforce

	def self.unleash_squirrel

		b = Bunny.new ENV['CLOUDAMQP_URL']
		b.start
		q = b.queue(ENV['SQUIRRELFORCE_QUEUE'])
		q.publish('{"url":"https://google.com","Type":"apex","Name":"CPS-1234","ID":"a0GU0000007AGDa"}')
		b.stop
		'.... and we are off!!'

	end

	def self.reserve_server(access_token, membername)
		set_header_token(access_token) 
		  
		fetch_server_results = query(access_token, "select Id from Server__c where 
			platform__c = 'Salesforce.com' and Reserved_text__c = 'FREE' limit 1")

		unless fetch_server_results.empty?
			server = Forcifier::JsonMassager.deforce_json(fetch_server_results.first)
			# add a new reservation for this server
			create(access_token, 'Reservation__c', {'Reserved_Server__c' => server['id'], 
				'Reserved_Member__c' => Member.salesforce_member_id(access_token, membername), 
				'Start_Date__c' => DateTime.now})
		else
			{:success => false, :message => 'No available server with requested specifications.'}
		end

	end

	def self.release_server(access_token, reservation_id)
		destroy(access_token, 'Reservation__c', reservation_id)
	end	

end