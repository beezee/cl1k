require 'spec_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

describe RedirectsController do
	let(:redirect) { FactoryGirl.create :redirect }
	let(:user) { FactoryGirl.create :user }

	shared_examples 'the clickthrough action' do

		describe 'request' do
			before { get :clickthrough, {redirect_slug: redirect.slug}, 'X_REAL_IP' => '133.713.371.337' } 
			specify { expect(response).to redirect_to(redirect.target) }
		end

		describe 'with ip from request headers' do
			specify do
				expect do
					get :clickthrough, {redirect_slug: redirect.slug}, 'X_REAL_IP' => '133.713.371.337'
				end.to change{Sidekiq::Extensions::DelayedClass.jobs.size}.by(1)
			end

			describe 'after processing queue' do
				let(:time) { Time.now }
				before do
					get :clickthrough, {redirect_slug: redirect.slug}, 'X_REAL_IP' => '133.713.371.337'
					time
				end

				specify do
					expect{ Sidekiq::Extensions::DelayedClass.drain }.to change(Click, :count).by(1) 
				end

				specify do
					time
					sleep 1
					Sidekiq::Extensions::DelayedClass.drain
					expect(Click.last.created_at).to be < time
				end
			end
		end	
	end
	
	context 'as a guest' do
		describe 'index' do
			before { get :index }

			it { should deny_access }
		end

		describe 'create' do
			before { post :create }

			it { should deny_access }
		end

		describe 'destroy' do
			before { delete :destroy, id: redirect.id }

			it { should deny_access }
		end

		describe 'clickthrough' do
			it_behaves_like 'the clickthrough action'
		end
	end

	context 'as a user' do
		before do
			user.redirects << redirect
			sign_in_as user
		end

		describe 'index' do
			before { get :index, format: :json }

			specify do
				expect(response).to be_success
				expect(response.body).to eq(user.redirects.to_json)
			end
		end

		describe 'create' do
			let(:redirect_1) { FactoryGirl.build :redirect }
			let(:redirect_2) { FactoryGirl.build :redirect }

			describe 'when redirect is valid' do
				specify do
					expect{post :create, format: :json, redirect: redirect_1.attributes}.
						to change(Redirect, :count).by(1)
					expect{post :create, format: :json, redirect: redirect_2.attributes}.
						to change{user.redirects.count}.by(1)
				end
			end

			describe 'when redirect is invalid' do
				before do
					Redirect.destroy_all
					redirect_1.target = ''
				end

				specify do
					expect{post :create, format: :json, redirect: redirect_1.attributes}.
						not_to change(Redirect, :count)
					expect(response.body).to include('error')
				end
			end
		end

		describe 'destroy' do
			let(:another_user) { FactoryGirl.create :user }

			context 'when redirect is owned by current user' do
				before { user.redirects << redirect }

				specify do
					expect{delete :destroy, format: :json, id: redirect.id}.to change{user.redirects.count}.by(-1)
				end
			end

			context 'when redirect is owned by another user' do
				before { another_user.redirects << redirect }

				specify do
					expect{delete :destroy, format: :json, id: redirect.id}.not_to change(Redirect, :count)
				end
			end
		end

		describe 'clickthrough' do
			it_behaves_like 'the clickthrough action'
		end
	end
end
