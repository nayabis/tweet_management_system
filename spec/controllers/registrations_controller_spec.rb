require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

	describe 'create' do

		it "should create user" do
			post :create, params: {"email" => "user@gmail.com", "password" => "123456", "password_confirmation" => "123456"}
			res = JSON.parse(response.body)
    		expect(res["status"]).to eq(200)
    		expect(res["message"]).to eq(I18n.t('user.registration_success'))
		end

		it "should throw error" do
			post :create, params: {"email" => "user@gmail.com", "password" => "12345667", "password_confirmation" => "123456"}
			res = JSON.parse(response.body)
    		expect(res["error_message"]).to eq(I18n.t('user.registration_failed'))
		end
	end
end
