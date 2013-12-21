class Click < ActiveRecord::Base
	validates :city_id, presence: true
	validates :redirect_id, presence: true
	belongs_to :redirect
	belongs_to :city

	before_validation :find_or_create_city
	after_validation :geocode
	after_validation :parse_user_agent

	
	private
		
		def address
			return @address unless @address.nil?
			@geocoder_results =  Geocoder.search(self.ip_address)
			return @address = UnspecifiedAddress.new if @geocoder_results.nil?
			@address = @geocoder_results.first.nil? ? UnspecifiedAddress.new : @geocoder_results.first
		end

		def geocode
			return if (!self.latitude.nil? and !self.longitude.nil?) or address.nil?
			self.latitude = address.latitude
			self.longitude = address.longitude
		end

		def find_or_create_city
			return if self.city.is_a? City
			self.city = City.find_or_create_by name: address.city, state: address.state,
						country: address.country
		end

		def empty_user_agent
			self.browser = self.version = self.platform = 'Unspecified'
		end

		def parse_user_agent
			return empty_user_agent if (self.user_agent.nil? or self.user_agent.blank?)
			ua = UserAgent.parse(self.user_agent)
			self.browser = ua.browser.to_s
			self.version = ua.version.to_s
			self.platform = ua.platform.to_s
		end
end
