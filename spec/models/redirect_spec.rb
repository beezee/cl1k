require 'spec_helper'

describe Redirect do
	let(:redirect) { FactoryGirl.create :redirect }

	subject { redirect }
	it { should respond_to(:target) }
	it { should respond_to(:slug) }
	it { should respond_to(:user) }
	it { should respond_to(:clicks) }
	it { should be_valid }

	describe 'with no user_id set' do
		before { redirect.user_id = nil }

		it { should_not be_valid }
	end

	describe 'without having to specify a slug' do
		before do
			redirect.slug = nil
			redirect.valid?
		end

		it { should be_valid; }
		its(:slug) { should_not be_nil }
		its(:slug) { should_not be_empty }
		
		describe 'with an empty slug set' do
			before do
				redirect.slug = ''
				redirect.valid?
			end

			it { should be_valid; }
			its(:slug) { should_not be_nil }
			its(:slug) { should_not be_empty }
		end
	end

	describe 'with an invalid target url set' do
		let(:invalid_urls) do
			['zthttpgoogle.com', 'as.dl',
			'ftp://thing.com', 'https://www', 'http:/www.invalid.com']
		end

		specify do
			invalid_urls.each do |url|
				redirect.target = url
				redirect.should_not be_valid
			end
		end
	end

	describe 'with a valid target url set' do
		let(:valid_urls) do
			['http://www.google.com', 'https://as.dl.co',
			'http://thing.com', 'https://www.yahoo.com']
		end

		specify do
			valid_urls.each do |url|
				redirect.target = url
				redirect.should be_valid
			end
		end
	end

	describe 'with click assigned' do
		let(:click) { FactoryGirl.build :click }

		before { redirect.clicks << click }

		specify { expect(redirect.reload.clicks.first).to eq click }
	end
end
