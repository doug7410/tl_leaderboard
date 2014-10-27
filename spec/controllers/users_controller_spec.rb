require 'spec_helper'

describe UsersController do

  let(:patrick) { Fabricate(:user) }
  let(:mike) { Fabricate(:user, github_username: "mikey") }

  describe 'POST delete_user' do

    it 'sets @user variable' do
      user = Fabricate(:user)
      get :delete_user, id: user.id
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the delete user template' do
      user = Fabricate(:user)
      get :delete_user, id: user.id
      expect(response).to render_template :delete_user
    end

  end


  describe 'POST destroy_user' do

    it 'should should erase the user if input secret matches user secret'

  end


  describe 'GET update_users' do

    it 'sets the @users variable' do
      get :index
      expect(assigns(:users)).to include(mike, patrick)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end

  end

  describe 'GET index' do

    it 'sets the @users variable' do
      get :index
      expect(assigns(:users)).to include(mike, patrick)
    end


    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end

  end


  describe "POST create" do

    context 'sending emails' do

      after { ActionMailer::Base.deliveries.clear }

      it 'sends an email to the user with their delete user secret' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end


    end


    context 'with invalid inputs' do

      it 'renders the index template' do
        post :create, user: { name: "Patrick" }
        expect(response).to render_template :index
      end

      it 'does not create a new user' do
        post :create, user: {name: "Patrick"}
        expect(User.all.count).to eq(0)
      end

      it 'sets flash on unsuccessful save' do
        post :create, user: {name: "Patrick"}
        expect(flash[:error]).to be_present
      end

    end #end invalid inputs context

    context 'with valid inputs and valid github username' do

      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'saves user' do
        expect(User.all.count). to eq(1)
      end

      it 'sets the @users variable' do
        expect(assigns(:users).count).to eq(1)
      end

      it 'sets flash on successful save' do
        expect(flash[:success]).to be_present
      end

    end #end valid inputs and valid github username

    context 'with valid inputs but invalid github username' do

      it 'doesnt create a user if github user does not exist' do
        attributes = Fabricate.attributes_for(:user, github_username: 'xxccvvddsdf')
        post :create, user: attributes
        expect(User.all.count).to eq(0)
      end


      it 'sets username doesnt exist flash message' do
        attributes = Fabricate.attributes_for(:user, github_username: 'xxccvvddsdf')
        post :create, user: attributes
        expect(flash[:error]).to be_present
      end


      it 'redirects to index action' do
        attributes = Fabricate.attributes_for(:user, github_username: 'xxccvvddsdf')
        post :create, user: attributes
        expect(response).to render_template :index
      end


    end #end valid inputs but invalid github username

  end

end