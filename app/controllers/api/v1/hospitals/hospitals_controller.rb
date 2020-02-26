class Api::V1::Hospitals::HospitalsController < ApplicationController
	#this action is used for confirm account
  
  def index
    if @hospitals = Hospital.all
       render json: {hospital: @hospitals}
    else
       render json: {message: "Something went wrong, Data not loaded properly."}
    end
  end

  def confirm
    @hospital = Hospital.find_by_confirmation_token(params[:confirmation_token])
    
    if @hospital.present?
       @hospital.update_attributes(confirmed_at: DateTime.now)
        render json: {message: "Your account has been confirmed.You can Sign in Now!"}
      else 
       render json: {alert: "Confirmation Link has Expired."}
    end

  end

   # This action is for forgot password 
  def forgot_password
     @hospital = Hospital.find_by_email(params[:email])
      if @hospital.present?
        @hospital.send_reset_password_instructions
        render json: {message: "Reset Link send succesfully in registerd Email."}
      else
        render json: {notice: "No account is registerd with this Email."}
      end
  end

   # This action is use for confirm forgot password link or update your password
  def reset_password_confirm
    @hospital = Hospital.find_by_reset_password_token(params[:reset_password_token])
    if @hospital.present?
      @hospital.update(password: params[:new_password])
      render json: {message: "Your Password changed successfully"}
    else
      render json: {notice: "Invalid hospital"}
    end
  end

  #This action is used for Change Password or if you want to change your password any time you can change.
  def change_password
    if current_hospital.present? && current_hospital.valid_password?(params[:password])  
      if (params[:new_password]) == (params[:confirm_password])
        current_hospital.update(password: params[:new_password])
        render json: {message: "Password Changed Successfully "}
      else
        render json: {message: "New Password doesn't match Confirm Password"}
      end
    else
      render json: {message: "Current Password is invalid"}
    end
  end

  def update
    @hospital = Hospital.find(params[:id])
    if @hospital.update!(update_params)
      render json: {hospital: @hospital}, status: 200
    else
      render json: { errors: @hospital.errors }, status: 422
    end
  end

  def uploader
    @hospital = Hospital.find(params[:id])
    image = @hospital.image.create(file: params[:image])
     if image.present?
      render json: {hospital: image.file},status: 200
     else
      render json: {errors: @hospital}, status: 422
     end
  end

  def hospital_search
    @hospitals = Hospital.all
    @hospitals = Hospital.where('LOWER(name) LIKE ?', "%#{params[:tags].downcase}%")
    @hospitals = Hospital.joins(:procedures).where('procedures.name LIKE ? OR LOWER(procedures.name) LIKE ?', "%#{params[:tags]}%", "%#{params[:tags].downcase}%")
    if @hospitals.present?
      render json:{message: "Hospital found Successfully ", hospital: @hospitals}, status: 200
    else
      render json: {message: "No Record Found"}, status: 200
    end 
  end

  protected

  def update_params
    params.require(:hospital).permit(:email, :city_id,  :address, :phone_number, :name)
  end

end
