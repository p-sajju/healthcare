class Api::V1::Patients::PatientsController < ApplicationController

	  #this action is used for confirm account

    def confirm
      @patient = Patient.find_by_confirmation_token(params[:confirmation_token])
      
      if @patient.present?
         @patient.update_attributes(confirmed_at: DateTime.now)
          render json: {message: "Your account has been confirmed.You can Sign in Now!"}
        else 
         render json: {alert: "Confirmation Link has Expired."}
      end

    end

     # This action is for forgot password 
    def forgot_password
       @patient = Patient.find_by_email(params[:email])
        if @patient.present?
          @patient.send_reset_password_instructions
          render json: {message: "Reset Link send succesfully in registerd Email."}
        else
          render json: {notice: "No account is registerd with this Email."}
        end
    end

     # This action is use for confirm forgot password link or update your password
    def reset_password_confirm
      @patient = Patient.find_by_reset_password_token(params[:reset_password_token])
      if @patient.present?
        @patient.update(password: params[:new_password])
        render json: {message: "Your Password changed successfully"}
      else
        render json: {notice: "Invalid patient"}
      end
    end

    #This action is used for Change Password or if you want to change your password any time you can change.
    def change_password
      if current_patient.present? && current_patient.valid_password?(params[:password])  
        if (params[:new_password]) == (params[:confirm_password])
          current_patient.update(password: params[:new_password])
          render json: {message: "Password Changed Successfully "}
        else
          render json: {message: "New Password doesn't match Confirm Password"}
        end
      else
        render json: {message: "Current Password is invalid"}
      end
    end

    def update
      @patient = Patient.find(params[:id])
      if @patient.update!(update_params)
        render json: {patient: @patient}, status: 200
      else
        render json: { errors: @patient.errors }, status: 422
      end
    end

    def uploader
      @patient = Patient.find(params[:id])
      image = @patient.create_image(file: params[:image])
      if image.present?
        render json: {patient: image.file},status: 200
      else
        render json: {errors: @patient}, status: 422
      end
    end

    def patient_search
      @patients = Patient.all
      @patients = Patient.where('LOWER(first_name) LIKE ?', "%#{params[:tags].downcase}%")
      if @patients.present?
        render json:{message: "Patient found Successfully ", patient: @patients}, status: 200
      else
        render json: {message: "No Record Found"}, status: 200
      end 
    end

   protected

    def update_params
      params.require(:patient).permit(:email, :city_id, :gender, :age, :date_of_birth, :patient_id, :address, :phone_number, :first_name, :last_name, :doctor_id)
    end
end
