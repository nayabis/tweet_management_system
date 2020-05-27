class ApplicationController < ActionController::API

	def authenticate_user
		@current_user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
		
		unless @current_user
			render json:{
				message: I18n.t('user.not_authenticated')

			}
		end

		rescue => error
		render json: {error_message: error.message}
	end
end
