require 'rails_helper'

RSpec.describe User, type: :model do
  after(:each) do
    User.delete_all
  end

  it 'is set to an employee on creation if email address is 8thLight email' do
    User.create(
      email: 'test@8thlight.com',
      password: Devise.friendly_token[0, 20],
      first_name: 'test',
      last_name: 'test'
    )

    expect(User.first[:employee]).to be_truthy
  end

  it 'is not an employee if the email does not end in 8thlight.com' do
    User.create(
      email: 'test@8thlight.comx',
      password: Devise.friendly_token[0, 20],
      first_name: 'test',
      last_name: 'test'
    )

    expect(User.first[:employee]).to be_falsey
  end
end
