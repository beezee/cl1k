require 'spec_helper'

describe City do
	let(:city) { FactoryGirl.create :city }

	subject { city }

	it { should respond_to(:name) }
	it { should respond_to(:state) }
	it { should respond_to(:country) }
	it { should respond_to(:latitude) }
	it { should respond_to(:longitude) }

	it { should be_valid }

	describe 'without a state' do
		before { city.state = '' }

		it { should_not be_valid }
	end

	describe 'without a country' do
		before { city.country = '' }

		it { should_not be_valid }
	end

	describe 'with city/state/country' do
		before { city.valid? }

		describe 'should populate lat/long' do
			its(:latitude) { should eq(42.3497948) }
			its(:longitude) { should eq(-71.2250533) }
		end
	end
end
