class App < ApplicationRecord
  include Tokenable

  store :preferences, accessors: [ :notifications, :gather_data, :test_app ], coder: JSON

  # http://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails
  # App.where('preferences @> ?', {notifications: true}.to_json)

  has_many :app_users
  has_many :users, through: :app_users
  has_many :conversations

  def add_user(attrs)
    email = attrs.delete(:email)
    user = User.find_or_initialize_by(email: email)
    #user.skip_confirmation!
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
    end
    user.save!
    ap = app_users.find_or_initialize_by(user_id: user.id)
    ap.assign_attributes(attrs)
    ap.save
    ap
  end

end