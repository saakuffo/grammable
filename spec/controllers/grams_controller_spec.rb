require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe  "grams#new action" do
    it "should successfully show the new form"  do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#creat action" do
    it "should succesffuly create a new gram in our database" do
      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to root_path

      expect(gram.message).to eq("Hello!")
    end
  end

end
