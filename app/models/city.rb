class City < ActiveRecord::Base
	validates :country, presence:true
	validates :state, presence:true
	after_validation :geocode

	private
		
		def address
			return @address unless @address.nil?
			@geocoder_results = Geocoder.search("#{self.name} #{self.state} #{self.country}")
			return @geocoder_results if @geocoder_results.nil?
			@address = @geocoder_results.first	
		end
		
		def geocode
			return if address.nil?
		 	self.latitude = address.latitude
			self.longitude = address.longitude
		end
end
