require 'rails_helper'

describe UsersSyncController do

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect(User.count).to eq 0
        post :create, :user => {:first_name => "auuuu", encrypted_password: "$2a$10$W72NutgGkcEYMo3LweiDYOB4fHC/y6Bc7XLOVvk5hzW5BYBzwWmC2", last_name: "last",
                                email: "email@remail.com", role: "Admin", confirmed_at: Time.now, country: "Colombia"}

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq ({ "id" => User.last.id, "user_token" => User.last.authentication_token,
                                                  "encrypted_password" => "$2a$10$W72NutgGkcEYMo3LweiDYOB4fHC/y6Bc7XLOVvk5hzW5BYBzwWmC2"})
        expect(User.last.encrypted_password).to eq("$2a$10$W72NutgGkcEYMo3LweiDYOB4fHC/y6Bc7XLOVvk5hzW5BYBzwWmC2")
        expect(User.count).to eq 1
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect(User.count).to eq 0
        post :create, :user => {:first_name => "auuuu", last_name: "last", role: "Admin", confirmed_at: Time.now, country: "Colombia"} 

        expect(JSON.parse(response.body)).to eq ({"email" => ["can't be blank"]})
        expect(response.status).to eq (422)
        expect(User.count).to eq 0
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "saves the changes in the database" do
        user = FactoryGirl.create(:user)
        put :update, id: user.authentication_token,
          user: {first_name: "No nuevo nombre", encrypted_password: "$2a$10$W72NutgGkcEYMo3LweiDYOB4fHC/y6Bc7XLOVvk5hzW5BYBzwWmC2",
          last_name: "last", email: "email@remail.com", role: "Admin", confirmed_at: Time.now, country: "Colombia" }

        expect(JSON.parse(response.body)).to eq ({"id"=>User.last.id, "user_token"=>User.last.authentication_token, "encrypted_password"=>User.last.encrypted_password})
        expect(user.first_name).to eq user.first_name

        user.reload

        expect(user.first_name).to eq "No nuevo nombre"
        expect(user.encrypted_password).to eq("$2a$10$W72NutgGkcEYMo3LweiDYOB4fHC/y6Bc7XLOVvk5hzW5BYBzwWmC2")
      end
    end

    context "with invalid attributes" do
      it "does not save the changes in the database" do
        user = FactoryGirl.create(:user)
        put :update, id: user.authentication_token, user: {nothign: "No nuevo nombre"}

        expect(user.first_name).to eq user.first_name

        user.reload

        expect(JSON.parse(response.body)).to eq ({"id"=>User.last.id, "user_token"=>User.last.authentication_token, "encrypted_password"=>User.last.encrypted_password})
        expect(user.first_name).to eq user.first_name
      end
    end
  end
end
