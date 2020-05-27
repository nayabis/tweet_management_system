FactoryBot.define do
  
  factory :user do
    email {"test@user.com"}
    password {"qwerty123"}
  end

  factory :tweet do
  	association :user
    message {"tweet_message_default"}
  end

end