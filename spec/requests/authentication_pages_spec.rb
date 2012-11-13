require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  
  describe "signin" do
    before { visit signin_path }
    
    describe "before signing in pages should not have links" do
    let(:user) {FactoryGirl.create(:user) }
    it { should_not have_link('Profile', href: user_path(user)) }
    it { should_not have_link('Settings', href: edit_user_path(user)) }
    end
  
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in(user)
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
     
      describe "followed by signout" do
           before { click_link "Sign out" }
           it { should have_link('Sign in') }
        end
    end
  end
    describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
       describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end
      
    describe "in the Relationships controller" do
      
      describe "submitting to the create action" do
        before { post relationships_path }
        specify { response.should redirect_to(signin_path)}
      end

      describe "submitting to the destroy action" do
        before { delete relationship_path(1) }
        specify { response.should redirect_to(signin_path) }
      end
    end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
  end
      
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        
          describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: 'Following') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Followers') }
        end
      end
    end
  end
end