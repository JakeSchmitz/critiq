require 'spec_helper'

describe "Feature Creation" do 
	let(:feature) {build :feature}
	let(:product) {create :product}
	let(:feature_group) {create :feature_group}

	describe "Feature creation from a new product" do 
	
		before :each do
			visit_product_tab 'VOTE'
			click_button 'create-poll'
		end

		context "when creating singles" do 
			it "creates a singleton drive with valid info" do 
				find('#singleton-choice').click
				within 'form.single-form-body' do 
					fill_in 'form-quest', with: feature.name
					fill_in 'form-desc', with: feature.description
					click_on 'form-submit-button'
				end
				expect(page).to have_content feature.name
			end
		end

		context "when creating comparisons" do 
			it "creates a commaprison drive with valid info and opens an option form" do 
				find('#comparison-choice').click
				within 'form.comparison-form-body' do 
					fill_in 'feature_group_name', with: feature.name
					fill_in 'form-desc', with: feature.description
					click_on "ADD OPTIONS"
				end
				expect(page).to have_content feature.name
				expect(page).to have_content feature.description
				expect(page.find('#form-opt').visible?).to be_true
			end
		end		
	end

	describe "Feature creation from existing product" do 
		before :each do
			login_user
			create :feature_group
			create :feature
			create :feature_group, singles: false
			visit product_path product
			click_link 'VOTE'
		end

		it "can open a new singleton feature form" do 
			click_button '+ ADD ANOTHER'
			expect(page.find('#form-quest').visible?).to be_true
		end

		it "can open a new comparison feature form" do 
			click_button '+ ADD OPTION'
			expect(page.find('#form-opt').visible?).to be_true
		end

	end
end