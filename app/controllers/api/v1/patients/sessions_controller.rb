# frozen_string_literal: true
module Api
  module V1
    module Patients
      class SessionsController < Devise::SessionsController
        # protect_from_forgery with: :null_session


        def create
          # @patient = Patient.find_by_email(sign_in_params[:email])
          # @patient && @patient.valid_password?(sign_in_params[:password])
          reset_session
          if @patient = warden.authenticate!(auth_options)
             @token = Tiddle.create_and_return_token(@patient, request)
             render json: { patient: @patient , authentication_token: @token}
          else
            render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
          end
        end

        def destroy
          if current_patient 
            Tiddle.expire_token(current_patient, request)
            render json: { notice: 'Succesfully Sign Out' }
          else
          # Client tried to expire an invalid token
            render json: { error: 'invalid token' }, status: 401
          end
        end

        protected

        def sign_in_params
          devise_parameter_sanitizer.sanitize(:sign_in)
        end

        def resource_name
          :patient
        end
        
      end
    end
  end
end
