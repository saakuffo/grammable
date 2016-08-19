require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do

    it "should allow users to create comments on grams" do
      comment_to_add = FactoryGirl.create(:gram)

      other_user = FactoryGirl.create(:user)
      sign_in other_user

      post :create, gram_id: comment_to_add.id, comment: { message: 'awesome gram' }

      expect(response).to redirect_to root_path
      expect(comment_to_add.comments.length).to eq 1
      expect(comment_to_add.comments.first.message).to eq "awesome gram"

    end

    it "should require a user to be logged in to comment on a gram" do
      comment_to_add = FactoryGirl.create(:gram)

      post :create, gram_id: comment_to_add.id, comment: { message: 'awesome gram' }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return http status code of not found if the gram isn't found" do
      other_user = FactoryGirl.create(:user)
      sign_in other_user

      post :create, gram_id: "YOLOSWAG", comment: { message: 'awesome gram' }
      expect(response).to have_http_status :not_found
    end

  end
end
