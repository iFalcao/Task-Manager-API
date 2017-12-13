require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  # If the test doesn't need a build object, you can use:
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  # Working with Shoulda Matchers methods to create less verbose tests
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('user@test.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'returns email and created_at' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('123abcTOKEN456')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: 123abcTOKEN456")
    end
  end

  describe '#generate_authentication_token!' do
    it 'returns an unique auth Token' do
      allow(Devise).to receive(:friendly_token).and_return('GenToken123')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('GenToken123')
    end

    it 'generates another token if the generated one is already taken' do
      # Bellow, the Devise.friendly_token will return '123Token' in the first and second call
      # and will return 'in_case_the_first_fails' in third call
      allow(Devise).to receive(:friendly_token).and_return('123Token', '123Token', 'in_case_the_first_fails')
      some_user = create :user # '123Token'
      user.generate_authentication_token! # '123Token'

      expect(user.auth_token).not_to eq(some_user.auth_token)
    end
  end



=begin
  subject { FactoryBot.build :user }
  it { expect(subject).to respond_to :email }
  
  context 'when user name is blank' do
    before { user.name = nil }

    it { expect(user).not_to be_valid }
  end
=end

end
