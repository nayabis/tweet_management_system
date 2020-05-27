class SessionsController < ApplicationController
	
	def create
		user = User.find_by(email: params[:email])
				.try(:authenticate, params[:password])

		if user
			session[:user_id] = user.id
			render json: {
				status: :session_created,
				logged_in: :true,
				user: user
			}
		else
			render json: {
				status: 401,
				message: I18n.t('user.not_found')
			}
		end
	end

	def logout
		reset_session
		render json: {status: 200, logged_out: true}
	end
end