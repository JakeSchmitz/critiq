require 'spec_helper'

describe BountiesController do 
	before :each do 
		@user = create :user
		@product = create :product
	end


	context "new" do 
		before :each do 
			get :new, :product_id => 1
		end

		it "should assign the product and bounty" do 
			expect(assigns :product).to eq @product
			expect(assigns :bounty).to be_a Bounty
		end

		it "should be an ok response" do 
			expect(response).to be_ok
		end
	end

	context "create" do 
		let(:bounty_attrs) { FactoryGirl.attributes_for(:bounty) }

		it "should create with valid params" do
			BountiesController.stubs(:signed_in?).returns true
			BountiesController.any_instance.stubs(:current_user).returns @user
			expect{post :create, product_id: 1, bounty: bounty_attrs, action: "create" 
				}.to change {Bounty.count}.by 1
		end
	end

	context "show" do 
		before :each do 
			@bounty = create :bounty
			get :show, :id => 1, :product_id => 1 
		end

		it "should be an ok response" do 
			expect(response).to be_ok
		end

		it "assigns the correct bounty" do 
			expect(assigns :bounty).to eq @bounty
		end
	end
end