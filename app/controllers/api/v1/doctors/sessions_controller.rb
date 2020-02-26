# frozen_string_literal: true
module Api
  module V1
    module Doctors
      class SessionsController < Devise::SessionsController
        # prepend_before_action :allow_params_authentication!, only: :create
        
        def create
          reset_session
          if @doctor = warden.authenticate!(auth_options)
             @token = Tiddle.create_and_return_token(@doctor, request)
             render json: { doctor: @doctor, authentication_token: @token }
          else
            render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
          end

        end

        def destroy
          if current_doctor 
            Tiddle.expire_token(current_doctor, request) 
            render json: { status: 'Succesfully Sign Out' }, status: 200
          else
            render json: { error: 'invalid token' }, status: 401
          end
        end

        protected

        def sign_in_params
          devise_parameter_sanitizer.sanitize(:sign_in)
        end

        def resource_name
          :doctor
        end
        
      end
    end
  end
end