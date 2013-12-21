require 'spec_helper'

describe ClicksController do
	let(:redirect) { FactoryGirl.create :redirect }
	let(:user) { FactoryGirl.create :user }
	let(:another_user) { FactoryGirl.create :user }
	let(:click) { FactoryGirl.build :click }

	before { redirect.clicks << click }

	describe 'index' do
		context 'as a guest' do
			before { get :index, redirect_id: redirect.id }

			it { should deny_access }
		end

		context 'as a user' do
			before { sign_in_as user }

			context 'who owns the related redirect' do
				before do
					user.redirects << redirect
					get :index, format: :json, redirect_id: redirect.id
				end

				specify { expect(response.body).to eq(user.redirects.first.clicks.to_json) }
			end

			context 'who does not own the related redirect' do
				before do
					another_user.redirects << redirect
					get :index, format: :json, redirect_id: redirect.id
				end

				specify { expect(response).to redirect_to(root_path) }
			end
		end
	end
end
