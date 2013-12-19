require 'spec_helper'

describe SiteController do
  let(:user) { FactoryGirl.create :user }
  subject { page }

  describe 'dashboard' do
    context 'as a guest' do
      before { get :dashboard }

      specify { expect(response).to redirect_to(sign_in_path) }
    end

    context 'as a user' do
      before do
				sign_in_as user
				get :dashboard
      end

      specify { expect(response).to be_success }
    end
  end

  describe 'index' do
    context 'as a guest' do
      before { get :index }

      specify { expect(response).to be_success }
    end

    context 'as a user' do
      before do
				sign_in_as user
				get :index
      end

      specify { expect(response).to redirect_to(dashboard_path) }
    end
  end

end
