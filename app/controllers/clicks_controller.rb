class ClicksController < ApplicationController

	before_filter :authorize
	respond_to :json

	def index
		@redirect = current_user.redirects.find_by_id params[:redirect_id]
		return redirect_to root_path unless @redirect.is_a? Redirect
		respond_with @redirect.clicks
	end
end
