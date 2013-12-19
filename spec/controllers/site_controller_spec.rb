require 'spec_helper'

describe SiteController do
  let(:user) { FactoryGirl.create :user }
  subject { page }

  describe 'dashboard' do
    context 'as a guest' do
      before { visit dashboard_path }

      specify { expect(response).to redirect_to(sign_in_path) }
    end

    context 'as a user' do
      before do
        visit dashboard_path(as: user)
      end

      specify { expect(response).to be_success }
    end
  end

  describe 'index' do
    context 'as a guest' do
      before { visit root_path }

      specify { expect(response).to be_success }
    end

    context 'as a user' do
      before do
        visit root_path(as: user)
      end

      specify { expect(response).to redirect_to(dashboard_path) }
    end
  end

end
