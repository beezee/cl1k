class ClickTracker
	include Sidekiq::Worker
	sidekiq_options queue: :track

	def perform(options)
		Redis::Mutex.with_lock :click_tracker do
			sleep 1
			Click.create options
		end
	end
end
