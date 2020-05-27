class PasswordsController < ApplicationController
	def forgot
	    if params[:email].blank? # check if email is present
	      return render json: {error: I18n.t('user.blank_email')}
	    end

	    user = User.find_by(email: params[:email]) # if present find user by email

	    if user.present?
	      user.generate_password_token! #generate pass token
	      # SEND EMAIL HERE
	      render json: {status: 200, token: user.reset_password_token}
	    else
	      render json: {error: I18n.t('user.not_found')}
	    end
  	end

	def reset
		token = params[:token].to_s

		if params[:email].blank?
		  return render json: {error: I18n.t('user.token.blank')}
		end

		user = User.find_by(reset_password_token: token)
		
		if user.present? && user.password_token_valid?
		  if user.reset_password!(params[:resetted_password])
		    render json: {status: 200, message: I18n.t('user.password_changed')}
		  else
		    render json: {error: user.errors.full_messages}, status: :unprocessable_entity
		  end
		else
		  render json: {error:  I18n.t('user.token.invalid_link')}
		end
	end
end
