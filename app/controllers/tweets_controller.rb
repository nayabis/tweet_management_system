class TweetsController < ApplicationController
	
	before_action :authenticate_user
	before_action :set_tweets,:admin_authorization, only: [:update, :destroy]


	def index
		@tweets = Tweet.all
		render json: {
			status: 200,
			data: @tweets
		}
	end

	def create
		tweet = Tweet.create!(message: params[:message], user_id: (session[:user_id] || @current_user.id))
		
		if tweet
			render json: {
				status: 200,
				message: I18n.t('tweet.success.create')
			}
		else
			render json:{
				status: 500,
				message: I18n.t('tweet.failure')
			}
		end
		rescue => error
		render json: {error_message: error.message, message: I18n.t('tweet.failure')}
	end

	def destroy
		if @tweet
			@tweet&.destroy!
			render json: {
				status: 200,
				message: I18n.t('tweet.success.delete')
			}
		else
			render json:{
				status: 500,
				message: I18n.t('tweet.failure')
			}
		end
		rescue => error
		render json: {error_message: error.message}

	end

	def update
		tweet = @tweet&.update!(message: params[:message])
		if tweet
			render json: {
				status: 200,
				message: I18n.t('tweet.success.update')
			}
		else
			render json:{
				status: 500,
				message: I18n.t('tweet.failure')
			}
		end
		rescue => error
		render json: {error_message: error.message}
	end

	private

	def set_tweets
		@tweet = Tweet.find_by(id: params[:id])
	end

	def admin_authorization
		unless (@current_user.try(:admin?) || (@tweet.user == @current_user))
			render json: {
					status: 401,
					message: I18n.t('user.unauthorized')
				} and return
		end
	end
end
