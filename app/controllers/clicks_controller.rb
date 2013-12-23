class ClicksController < ApplicationController

	before_filter :authorize
	before_filter :set_redirect
	respond_to :json

	def index
		respond_with @redirect.clicks
	end

	def by_dimension
		not_found unless Click.new.has_attribute? params[:dimension] 
		top_dimensions = Click.where(redirect_id: @redirect.id)
			.select('count(id) as clicks', params[:dimension]).group(params[:dimension])
			.order('clicks desc').limit(10).to_a.collect { |c| c[params[:dimension]] }.uniq
		respond_with Click.where("redirect_id = ? and #{params[:dimension]} in (?) and created_at >= ?", @redirect.id, 
					 top_dimensions, 90.days.ago).select('count(id) as clicks', params[:dimension], 'date(created_at) as date')
						.group('date', params[:dimension]).order('date asc').group_by {|c| c[params[:dimension]] }
						.map { |days| { key: days[0], values: days[1].map {|d| [d.date.midnight.to_time.to_i*1000, d.clicks] } } }
	end

	private

		def set_redirect
			@redirect = current_user.redirects.find_by_id params[:redirect_id]
			return redirect_to root_path unless @redirect.is_a? Redirect
		end
end
