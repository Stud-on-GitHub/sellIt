require 'rails_helper'

RSpec.describe Classified, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should belong_to(:user) }
  end
end
