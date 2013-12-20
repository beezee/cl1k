require 'spec_helper'

describe Click do
	let(:click) { FactoryGirl.create :click }
	
	subject { click }

	it { should respond_to(:redirect_id) }
	it { should respond_to(:redirect) }
	it { should respond_to(:user_agent) }
	it { should respond_to(:browser) }
	it { should respond_to(:version) }
	it { should respond_to(:platform) }
	it { should respond_to(:latitude) }
	it { should respond_to(:longitude) }
	it { should respond_to(:ip_address) }
	it { should respond_to(:city_id) }
	it { should respond_to(:city) }

	it { should be_valid }

	describe 'without a redirect_id' do
		before { click.redirect_id = '' }

		it { should_not be_valid }
	end

	describe 'without a city_id' do
		before do
			click.city_id = ''
			click.valid?
		end

		its(:city_id) { should_not be_nil }
	end

	describe 'with only a valid ip address' do
		before { click.valid? }

		describe 'should populate lat/long' do
			its(:latitude) { should eq(42.35) }
			its(:longitude) { should eq(-71.2269) }
		end

		describe 'should find or create related city' do
			let(:click) { FactoryGirl.build :click }
			let(:another_click) { FactoryGirl.build :click }

			before do
				Click.destroy_all
				City.destroy_all
				click.city_id = ''
				another_click.city_id = ''
			end

			specify do
				expect { click.valid?; }.to change(City, :count).by(1)
				expect { another_click.save }.to_not change(City, :count)
			end

			describe 'and set correct city_id value' do
				before do
					click.save
					another_click.save
				end

				specify do
					expect(click.city).to be_a(City)
					expect(another_click.city).to be_a(City)
				end
			end
		end
	end

	describe 'when user agent string specified' do
		before { click.valid? }

		its(:browser) { should eq('Chrome') }
		its(:version) { should eq('31.0.1650.63') }
		its(:platform) { should eq('X11') }
	end

	describe 'when no user agent string specified' do
		before do
			click.user_agent = ''
			click.save
		end

		it { should be_valid }
		its(:browser) { should eq('Unspecified') }
		its(:version) { should eq('Unspecified') }
		its(:platform) { should eq('Unspecified') }
	end
end
