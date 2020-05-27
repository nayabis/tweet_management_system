require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	describe 'create' do
		before(:each) do
	  		User.destroy_all
	  		Tweet.destroy_all
  		end

		it "should create session" do
			user = create(:user)
			post :create, params: {"email" => user.email, "password" => user.password}
			res = JSON.parse(response.body)
    		expect(res["status"]).to eq("session_created")
    		expect(res["logged_in"]).to be_truthy
    		expect(res["user"]["id"]).to eq(user.id)
		end

		it "should show invalid session" do
			post :create, params: {"email" => "qwerty@gmil.com", "password" => "1234567"}
			res = JSON.parse(response.body)
    		expect(res["status"]).to eq(401)
    		expect(res["message"]).to eq(I18n.t('user.not_found'))
		end
	end

	describe "logout" do
		it "should rest the session" do
			delete :logout
			res = JSON.parse(response.body)
			expect(res["status"]).to eq(200)
			expect(res["logged_out"]).to be_truthy
		end
	end

end
