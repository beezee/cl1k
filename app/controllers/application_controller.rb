class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def not_found
		raise ActionController::RoutingError.new('Not Found')
	end

  private

    def redirect_to_dashboard
      redirect_to dashboard_path if signed_in?
    end
  
end
