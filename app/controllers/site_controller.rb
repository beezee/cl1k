class SiteController < ApplicationController
	before_filter :authorize, only: :dashboard
	before_filter :redirect_to_dashboard, only: :index

	def index
	end

	def dashboard
	end

end
