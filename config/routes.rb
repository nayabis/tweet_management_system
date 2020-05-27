Rails.application.routes.draw do
	#users
	post :sign_up, to: 'registrations#create'
	post :login, to: 'sessions#create'
	delete :log_out, to: "sessions#logout"
	post 'password/forgot', to: 'passwords#forgot'
	post 'password/reset', to: 'passwords#reset'
	#tweets
	get :tweets, to: "tweets#index"
	post :create_tweet, to: "tweets#create"
	put 'update_tweet/:id', to: "tweets#update"
	delete :delete_tweet, to: "tweets#destroy"
	
  	root 'tweets#index'
end
