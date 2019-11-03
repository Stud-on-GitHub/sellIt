require 'rails_helper'

RSpec.describe Classified, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should belong_to(:user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:price) }
  end
end
