class Api::V1::Doctors::DoctorsController < ApplicationController

    def index
      if @doctors = Doctor.all
         @doctors = Hospital.find_by_id(params[:id]).doctors if params[:id].present?
         render json: {doctor: @doctors}
      else 
         render json: {message: "Unable to load data try after some time."}
      end
    end

	 #this action is used for confirm account
    def confirm
      @doctor = Doctor.find_by_confirmation_token(params[:confirmation_token])
      
      if @doctor.present?
         @doctor.update_attributes(confirmed_at: DateTime.now)
          render json: {message: "Your account has been confirmed at #{@doctor.confirmed_at}.You can Sign in Now!"}
        else 
         render json: {alert: "Confirmation Link has Expired."}
      end

    end

     # This action is for forgot password 
    def forgot_password
       @doctor = Doctor.find_by_email(params[:email])
        if @doctor.present?
          @doctor.send_reset_password_instructions
          render json: {message: "Reset Link send succesfully in registerd Email."}
        else
          render json: {notice: "No account is registerd with this Email."}
        end
    end

     # This action is use for confirm forgot password link or update your password
    def reset_password_confirm
      @doctor = Doctor.find_by_reset_password_token(params[:reset_password_token])
      if @doctor.present?
        @doctor.update(password: params[:new_password])
        render json: {message: "Your Password changed successfully"}
      else
        render json: {notice: "Invalid doctor"}
      end
    end

    #This action is used for Change Password or if you want to change your password any time you can change.
    def change_password
      if current_doctor.present? && current_doctor.valid_password?(params[:password])  
        if (params[:new_password]) == (params[:confirm_password])
          current_doctor.update(password: params[:new_password])
          render json: {message: "Password Changed Successfully "}
        else
          render json: {message: "New Password doesn't match Confirm Password"}
        end
      else
        render json: {message: "Current Password is invalid"}
      end
    end

    #this action is for Update users data
    def update
      @doctor = Doctor.find(params[:id])
      if @doctor.update!(update_params)
        render json: {doctor: @doctor}, status: 200
      else
        render json: { errors: @doctor.errors }, status: 422
      end
    end

    #this is to uploade profile photo 
    def uploader
      @doctor = Doctor.find(params[:id])
      image = @doctor.create_image(file: params[:image])
      if image.present?
        render json: {doctor: image.file},status: 200
      else
        render json: {errors: @doctor}, status: 422
      end

    end

    def doctor_search
      @doctors = Doctor.all
      @doctors = Doctor.where('LOWER(first_name) LIKE ?', "%#{params[:tags].downcase}%")
      @doctors = Doctor.joins(:patients).where('LOWER (patients.first_name) LIKE ? OR patients.first_name LIKE ?', "%#{params[:tags].downcase}%", "%#{params[:tags]}%")
      if @doctors.present?
        render json:{message: "Doctor found Successfully ", doctor: @doctors}, status: 200
      else
        render json: {message: "No Record Found"}, status: 200
      end 
    end

    def location
      doctor = Geocoder.search(params[:location])
      doctor.first.coordinates
      render json: {doctor: doctor, message: "here is ypur coordinates"}
    end
    
    protected

    def update_params
      params.require(:doctor).permit(:email, :city_id, :gender, :age, :speciality, :education, :address, :phone_number, :first_name, :last_name)
    end
end
