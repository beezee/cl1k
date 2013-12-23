class Redirect < ActiveRecord::Base
	belongs_to :user
	has_many :clicks
	validates :user_id, presence: true
	validates :target, format: 
    { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\Z/ix,
      message:  'must be a valid url' }
	before_validation :ensure_unique_slug

	private

		def self.random_slug
			('A'...'Z').to_a.concat(('a'...'z').to_a).
					concat((0...9).to_a).concat(['-', '_']).shuffle[0..5].join ''
		end

		def ensure_unique_slug
			self.slug = Redirect.random_slug if (self.slug.nil? or self.slug.empty?)
			while !Redirect.find_by(:slug, self.slug).nil? do
				self.slug = Redirect.random_slug
			end
		end
end
