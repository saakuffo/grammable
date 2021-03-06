require 'rails_helper'

RSpec.describe GramsController, type: :controller do

  describe "grams#destroy" do

    it "shouldn't let users who didn't create the gram destroy it" do
      gram_to_destroy = FactoryGirl.create(:gram)
      other_user = FactoryGirl.create(:user)
      sign_in other_user
      delete :destroy, id: gram_to_destroy.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a gram" do
      gram_to_destroy = FactoryGirl.create(:gram)
      delete :destroy, id: gram_to_destroy.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy grams" do
      gram_to_destroy = FactoryGirl.create(:gram)
      sign_in gram_to_destroy.user
      delete :destroy, id: gram_to_destroy.id
      expect(response).to redirect_to root_path
      gram_to_destroy = Gram.find_by_id(gram_to_destroy.id)
      expect(gram_to_destroy).to eq nil
    end

    it "should return a 404 message if we cannot find a gram with the id that is specified" do
      gram_not_found = FactoryGirl.create(:user)
      sign_in gram_not_found
      delete :destroy, id: 'SPACEDUCK'
      expect(response).to have_http_status(:not_found)
    end

  end

  describe "grams#update aciton" do

    it "should't let users who didn't create the gram update it" do
      gram_to_edit = FactoryGirl.create(:gram)
      other_user = FactoryGirl.create(:user)
      sign_in other_user
      patch :update, id: gram_to_edit.id, gram: { message: "wahoo" }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a gram" do
      gram_to_update = FactoryGirl.create(:gram)
      patch :update, id: gram_to_update.id, gram: { message: "Hello" }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update grams" do
      gram_to_edit = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram_to_edit.user
      patch :update, id: gram_to_edit.id, gram: {message: 'Changed'}
      expect(response).to redirect_to root_path
      gram_to_edit.reload
      expect(gram_to_edit.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      gram_not_found = FactoryGirl.create(:user)
      sign_in gram_not_found
      patch :update, id: "VoLTA", gram: {message: "Changed"}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram_to_edit = FactoryGirl.create(:gram, message: "Initial Value")
      sign_in gram_to_edit.user
      patch :update, id: gram_to_edit.id, gram: { message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      gram_to_edit.reload
      expect(gram_to_edit.message).to eq "Initial Value"
    end

  end

  describe "grams#edit action" do

    it "shouldn't let users who did not create the gram edit a gram" do 
      gram_to_edit = FactoryGirl.create(:gram)
      other_user = FactoryGirl.create(:user)
      sign_in other_user
      get :edit, id: gram_to_edit.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a gram" do
      gram_to_edit = FactoryGirl.create(:gram)
      get :edit, id: gram_to_edit.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the gram is found" do
      gram_to_edit = FactoryGirl.create(:gram)
      sign_in gram_to_edit.user
      get :edit, id: gram_to_edit.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      gram_not_found = FactoryGirl.create(:user)
      sign_in gram_not_found
      get :edit, id: 'NADDER'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do
    it "should successfully show the pages if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe  "grams#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form"  do
      user = FactoryGirl.create(:user)

      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create action" do
    it "should require users to be logged in" do
      post :create, gram: { message: 'Hello!'}
      expect(response).to redirect_to new_user_session_path
    end

    it "should succesffuly create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, gram: { 
        message: 'Hello!',
        grampic: fixture_file_upload("/grampic.png", 'image/png')
      }

      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)

      sign_in user

      post :create, gram: { message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end
  end

end
