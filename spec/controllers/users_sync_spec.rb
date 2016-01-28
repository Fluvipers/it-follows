require 'rails_helper'

describe UsersSyncController do

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect(User.count).to eq 0
        post :create, :user => {:first_name => "auuuu", last_name: "last", email: "email@remail.com", role: "Admin", confirmed_at: Time.now, country: "Colombia"}
        expect(response.status).to eq(200)
        expect(User.count).to eq 1
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect(User.count).to eq 0
        post :create, :user => {:first_name => "auuuu", last_name: "last", role: "Admin", confirmed_at: Time.now, country: "Colombia"} 
        expect(response.body).to eq ("{\"email\":[\"can't be blank\"]}")
        expect(response.status).to eq (422)
        expect(User.count).to eq 0
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "saves the changes in the database" do
        user = FactoryGirl.create(:user)
        put :update, id: user.id, :user => {:first_name => "No nuevo nombre", last_name: "last", email: "email@remail.com", role: "Admin", confirmed_at: Time.now, country: "Colombia"}
        expect(user.first_name).to eq "wendy"
        user.reload
        expect(user.first_name).to eq "No nuevo nombre"
      end
    end
    
    context "with invalid attributes" do
      it "does not save the changes in the database" do
        user = FactoryGirl.create(:user)
        put :update, id: user.id, :user => {:nothign => "No nuevo nombre"}
        expect(user.first_name).to eq "wendy"
        user.reload
        expect(user.first_name).to eq "wendy"
      end
    end
  end
end
