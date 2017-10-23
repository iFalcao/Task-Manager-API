require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  # If the test doesn't need a build object, you can use:
  it { is_expected.to validate_presence_of(:email) }

  # Working with Shoulda Matchers methods to create less verbose tests
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('user@test.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  



=begin
  subject { FactoryGirl.build :user }
  it { expect(subject).to respond_to :email }
  
  context 'when user name is blank' do
    before { user.name = nil }

    it { expect(user).not_to be_valid }
  end
=end

end
