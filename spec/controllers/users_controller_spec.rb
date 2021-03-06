require 'rails_helper'

describe UsersController, type: :controller do

  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { User.create!(email: "testuser_2@email.com", password: "password_2") }


  describe 'GET #show' do
    context 'when an admin is logged in' do
      before do
        sign_in admin
      end
      it 'can access other user details' do
        get :show, params: { id: user2.id }
        expect(response).to be_ok
      end
    end

    context 'when a user is logged in' do
      before do
        sign_in user
      end
      it 'loads correct user details' do
        get :show, params: { id: user.id }
        expect(response).to be_ok
        expect(assigns(:user)).to eq user
      end
      it 'cannot access user two details' do
        get :show, params: { id: user2.id }
        expect(response).not_to be_ok
        redirect_to(root_path)
      end
    end

    context 'when a user is not logged in' do
      it 'redirects to login' do
        get :show, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
