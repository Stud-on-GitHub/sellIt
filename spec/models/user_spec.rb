require 'rails_helper'

RSpec.describe User, type: :model do
  #use shoulda matcher https://github.com/thoughtbot/shoulda-matchers
  describe 'validations' do
    it { should validate_presence_of(:fullname) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should have_secure_password }
    it { should validate_presence_of(:password_digest) }
    it { should have_many(:classifieds) }
  end
end
