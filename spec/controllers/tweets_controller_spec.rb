require 'rails_helper'

RSpec.describe TweetsController, type: :controller do

  describe "index" do

  	before(:each) do
  		User.destroy_all
  		Tweet.destroy_all
  	end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "should return not_authenticated" do
    	get :index
    	res = JSON.parse(response.body)
    	expect(res["message"]).to eq(I18n.t('user.not_authenticated'))
    end

    it "should return tweets" do
    	allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(User.first)
    	tweet1 = create(:tweet)
    	get :index
    	res = JSON.parse(response.body)
    	expect(res["status"]).to eq(200)
    	expect(res["data"].count).to eq(Tweet.all.count)
    end
  end

  describe "create" do

  	before(:each) do
  		User.destroy_all
  		Tweet.destroy_all
  	end

  	it "returns http success" do
  		  user = create(:user)
      	post :create, params: {"message" => "Demo Tweet", "email" => user.email, "password" => user.password}
      	expect(response).to have_http_status(:success)
    end

    it "shoud create post successfully" do
      user = create(:user)
      post :create, params: {"message" => "Demo Tweet", "email" => user.email, "password" => user.password}
      res = JSON.parse(response.body)
      expect(res["status"]).to eq(200)
      expect(res["message"]).to eq(I18n.t('tweet.success.create'))
    end
  end

  describe "update" do

  	it "returns http success" do
  		user = create(:user)
    	post :create, params: {"message" => "Demo Tweet", "email" => user.email, "password" => user.password}
    	expect(response).to have_http_status(:success)
    end

    context 'success' do

	    it "The user is the owner of the post" do
	  		post = create(:tweet)
	  		user = post.user
	      put :update, params: { "id"=> post.id, "message" => "Demo Tweet update", "email" => user.email, "password" => user.password}
	      res = JSON.parse(response.body)
	      expect(res["status"]).to eq(200)
	      expect(res["message"]).to eq(I18n.t('tweet.success.update'))
	    end

	    it "The user is admin" do
	  		post = create(:tweet)
	  		user = create(:user, email: "admin@twitter.com", password: "123456")
	  		expect(user.admin?).to be_truthy
      	put :update, params: { "id"=> post.id, "message" => "Demo Tweet update", "email" => user.email, "password" => user.password}
      	res = JSON.parse(response.body)
      	expect(res["status"]).to eq(200)
      	expect(res["message"]).to eq(I18n.t('tweet.success.update'))
	    end
	end

	context 'Failure' do

		it "The user is non-admin" do
	  		post = create(:tweet)
	  		user = create(:user, email: "non_admin@hmail.com", password: "123456")
	  		expect(user.admin?).to be_falsey
      	put :update, params: { "id"=> post.id, "message" => "Demo Tweet update", "email" => user.email, "password" => user.password}
      	res = JSON.parse(response.body)
      	expect(res["status"]).to eq(401)
      	expect(res["message"]).to eq(I18n.t('user.unauthorized'))
	    end
	end
  end

  describe 'delete' do

  	it"should allow admin users to delete" do
  		post = create(:tweet)
  		user = create(:user, email: "admin@twitter.com", password: "123456")
  		expect(user.admin?).to be_truthy
  		delete :destroy, params: {"id" => post.id, "email" => user.email, "password" => user.password}
  		res = JSON.parse(response.body)
    	expect(res["status"]).to eq(200)
    	expect(res["message"]).to eq(I18n.t('tweet.success.delete'))
  	end

  	it "should allow tweet owner to delete" do
  		post = create(:tweet)
  		user = post.user
  		expect(user.admin?).to be_falsey
  		delete :destroy, params: {"id" => post.id, "email" => user.email, "password" => user.password}
  		res = JSON.parse(response.body)
    	expect(res["status"]).to eq(200)
    	expect(res["message"]).to eq(I18n.t('tweet.success.delete'))
  	end

  	it "should not allow non admin users to delete" do
  		post = create(:tweet)
  		user = create(:user, email: "non_admin@hmail.com", password: "123456")
  		expect(user.admin?).to be_falsey
  		delete :destroy, params: {"id" => post.id, "email" => user.email, "password" => user.password}
  		res = JSON.parse(response.body)
    	expect(res["status"]).to eq(401)
    	expect(res["message"]).to eq(I18n.t('user.unauthorized'))
  	end
  end

end
