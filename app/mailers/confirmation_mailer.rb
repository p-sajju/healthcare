class ConfirmationMailer < ApplicationMailer
	def registration_confirmation(user) 
   @message = '	whatever you want to say here!'
   mail(:from => "myemailid@gmail.com", :to => user.email, :subject => "Thank you for registration")
	end
end
