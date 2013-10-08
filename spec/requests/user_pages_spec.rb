require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) } # uses: spec/factories.rb
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end

	describe "signup page" do
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
	end

	describe "signup" do

		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "after submission" do
			before do click_button submit 
				fill_in "Name",         with: ""
				fill_in "Email",        with: ""
				fill_in "Password",     with: ""
				fill_in "Confirmation", with: ""
			end

			it { should have_title('Sign up') }
			it { should have_content('Name can\'t be blank') }
			it { should have_content('Email can\'t be blank') }
			it { should have_content('Email is invalid') }
			it { should have_content('Password can\'t be blank') }
			it { should have_content('Password is too short (minimum is 6 characters)') }
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }

				#  Testing that newly signed-up users are also signed in
				it { should have_link('Sign out') }
			end
		end
	end
end