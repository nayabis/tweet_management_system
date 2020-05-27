class RegistrationsController < ApplicationController

	def create
		user = User.create!(
			email: params[:email],
			password: params[:password],
			password_confirmation: params[:password_confirmation])

		if user
			session[:user_id] = user.id
			render json: {
				status: 200,
				user: user,
				message: I18n.t('user.registration_success')
			}
		else
			render json: {
				status: 500,
				message: I18n.t('user.registration_failed')
			}
		end

		rescue => error
		render json: {error_message: I18n.t('user.registration_failed')}
	end
end
