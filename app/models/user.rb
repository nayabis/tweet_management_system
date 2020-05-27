class User < ApplicationRecord

	has_secure_password
	
	ADMIN_EMAIL_DOMAIN = ["twitter.com", "tweet.com"]

	validates_presence_of :email
	validates_uniqueness_of :email
	has_many :tweets
	after_create :set_default_role

	def generate_password_token!
	 self.reset_password_token = generate_token
	 self.reset_password_sent_at = Time.now.utc
	 save!
	end

	def password_token_valid?
	 (self.reset_password_sent_at + 4.hours) > Time.now.utc
	end

	def reset_password!(password)
	 self.reset_password_token = nil
	 self.password = password
	 save!
	end

	private

	def generate_token
		SecureRandom.hex(10)
	end
	
	def set_default_role
		self.admin = true if User::ADMIN_EMAIL_DOMAIN.include? self.get_email_domain.to_s
		self.save
	end

	def get_email_domain
		self.email.split("@").last
	end
end
