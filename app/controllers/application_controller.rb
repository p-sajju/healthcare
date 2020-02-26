class ApplicationController < ActionController::Base
	protect_from_forgery unless: -> { request.format.json? }
	# skip_before_action :verify_signed_out_user, only: :destroy
 	# before_action :authenticate_api_v1_doctor!, :do_not_set_cookie, if: -> { request.format.json? }
 	private
 
 	def do_not_set_cookie
  	 request.session_options[:skip] = true
 	end

end
