class RedirectsController < ApplicationController

	before_filter :authorize, except: :clickthrough
	respond_to :json

	def index
		respond_with current_user.redirects
	end

	def create
		respond_with current_user.redirects.create redirect_params
	end

	def destroy
		@redirect = current_user.redirects.find_by_id(params[:id])
		@redirect.try(:destroy)
		respond_with @redirect
	end

	def clickthrough
		@redirect = Redirect.find_by_slug(params[:redirect_slug]) || not_found
		redirect_to @redirect.target
	end

	private

		def redirect_params
			params.require(:redirect).permit [:target]
		end
end
