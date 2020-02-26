# frozen_string_literal: true

module Api
  module V1
    module Hospitals
    class RegistrationsController < Devise::RegistrationsController
     before_action :configure_permitted_parameters
     skip_before_action :verify_authenticity_token, :only => [:create]

         def new
          build_resource
          yield resource if block_given?
         end
     # POST /resource
         def create
           ActiveRecord::Base.transaction do
             build_resource(sign_up_params)
             if resource.blank?
              render json: { message: "params not present" }
             else
              resource.save
                yield resource if block_given?
             end
             unless resource.persisted?
               clean_up_passwords resource
               set_minimum_password_length
               return render json:{errors: resource.errors.as_json}
             end
             if resource.active_for_authentication?
               sign_up(resource_name, resource)
             else
               expire_data_after_sign_in!
             end
             @hospital = resource
             render json: { hospital: resource, status: :success, message: "Hospital created successfully" }
           end
         end

        

        protected
         def configure_permitted_parameters
           param_keys = [:email, :password, :city_id,  :address, :phone_number, :name]
           devise_parameter_sanitizer.permit(:sign_up, keys: param_keys)
           # devise_parameter_sanitizer.permit(:account_update, keys: param_keys)
         end

         def resource_name
           :hospital
         end
         
         end
      end
  end
end
