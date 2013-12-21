require 'spec_helper'

describe User do
	let(:user) { FactoryGirl.create :user }

	subject { user }
	
	it { should respond_to(:redirects) }
	it { should be_valid }

	describe 'with saved redirects' do
		let(:redirect) { FactoryGirl.build :redirect }
		before { user.redirects << redirect }

		specify do
			expect(user.reload.redirects.first).to be_a(Redirect)
			expect(user.reload.redirects.first).to eq(redirect)
		end
	end
end
