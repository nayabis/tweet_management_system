require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
	
	describe "forgot" do
		it "should throw error if email is blank" do
			post :forgot, params: {email: nil}
			res = JSON.parse(response.body)
			expect(res["error"]).to eq(I18n.t('user.blank_email'))
		end

		it "success and generate token" do
			user = create(:user)
			post :forgot, params: {email: user.email}
			res = JSON.parse(response.body)
			expect(res["status"]).to eq(200)
			expect(res["token"].present?).to be_truthy
		end

		it "should throw error if email not found" do
			post :forgot, params: {email: "demo_email@gmail.com"}
			res = JSON.parse(response.body)
			expect(res["error"]).to eq(I18n.t('user.not_found'))

		end
	end

	describe "reset" do
		it "should throw error if email is blank" do
			post :reset, params: {email: nil}
			res = JSON.parse(response.body)
			expect(res["error"]).to eq(I18n.t('user.token.blank'))
		end

		it "should throw error if email not found" do
			post :reset, params: {email: "demo_email@gmail.com"}
			res = JSON.parse(response.body)
			expect(res["error"]).to eq(I18n.t('user.token.invalid_link'))
		end

		it "should throw error if token expired" do
			user = create(:user)
			allow(user).to receive(:password_token_valid?).and_return(false) 
			post :reset, params: {email: user.email}
			res = JSON.parse(response.body)
			expect(res["error"]).to eq(I18n.t('user.token.invalid_link'))
		end

		it "should successfully change the password" do
			token = SecureRandom.hex(10)
			user = create(:user)
			user.reset_password_token = token
			user.reset_password_sent_at = Time.now
			user.save
			allow(user).to receive(:password_token_valid?).and_return(true)
			post :reset, params: {email: user.email, resetted_password: "new_password", token: token}
			res = JSON.parse(response.body)
			expect(res["status"]).to eq(200)
			expect(res["message"]).to eq(I18n.t('user.password_changed'))
		end
	end
end
