# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
[
  {name: "Dr Nic Williams", email: "drnic@scopego.co"}
].each do |user_params|
  user = User.create(user_params.merge({
    password: "secret123!",
    password_confirmation: "secret123!",
    terms_of_service: true
  }))
  Jumpstart.grant_system_admin!(user)

  # account = user.personal_account
end
