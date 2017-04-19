require 'rails_helper'

RSpec.describe PointsController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:point, value: "2", cashable_id: @resource.id, cashable_type: @resource.class.name) }

  let(:invalid_attributes) { FactoryGirl.attributes_for(:point, value: nil) }

  describe "GET #index" do
    context "as admin" do
      login_admin
      it "returns http 200" do
        get :index
        expect(response).to have_http_status(200)
      end
    end

    context "as user" do
      login_user
      it "returns http 200" do
        get :index
        expect(response).to have_http_status(200)
      end
    end

    context "as non-user" do
      it "returns http 302" do
        get :index
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #show" do
    before :each do
      user = FactoryGirl.create(:user)
      @point = user.points(attributes_for(:point))
    end

    context "as admin" do
      login_admin
      it "returns http 200" do
        get :show, id: @point.id
        expect(response).to have_http_status(200)
      end
    end

    context "as user" do
      login_user
      it "returns http 200" do
        get :show, id: @point.id
        expect(response).to have_http_status(200)
      end
    end

    context "as non-user" do
      it "returns http 302" do
        get :show, id: @point.id
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #new" do
    context "as admin" do
      login_admin
      it "returns http 200" do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    context "as user" do
      login_user
      it "should raise_error if not admin" do
        expect {
          get :new
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "as non-user" do
      it "returns http 302" do
        get :new
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      user = FactoryGirl.create(:user)
      @point = user.points(attributes_for(:point))
    end

    context "as admin" do
      login_admin
      it "returns http 200" do
        get :show, id: @point.id, point: valid_attributes
        expect(response).to have_http_status(200)
      end
    end

    context "as user" do
      login_user
      it "returns http 200" do
        get :show, id: @point.id, point: valid_attributes
        expect(response).to have_http_status(200)
      end
    end

    context "as non-user" do
      it "returns http 302" do
        get :show, id: @point.id, point: valid_attributes
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "POST #create" do

    context "with valid attributes" do
      context "as admin" do
        login_admin
        it "change the count by 2" do
          expect {
            @resource = FactoryGirl.create(:user)
            post :create, id: @resource.id, point: valid_attributes
          }.to change(Point, :count).by(2)
        end
      end

      context "as user" do
        login_user
        it "change the count by 2" do
          expect {
            @resource = FactoryGirl.create(:user)
            post :create, id: @resource.id, point: valid_attributes
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "as non-user" do
        it "returns http 302" do
          @resource = FactoryGirl.create(:user)
          post :create, id: @resource.id, point: valid_attributes
          expect(response).to have_http_status(302)
        end
      end
    end

    context "with invalid attributes" do
      context "as admin" do
        login_admin
        it "change the count by 2" do
            @resource = FactoryGirl.create(:user)
            post :create, id: @resource.id, point: invalid_attributes
            expect(response).to render_template(:new)
        end
      end

      context "as user" do
        login_user
        it "change the count by 2" do
          expect {
            @resource = FactoryGirl.create(:user)
            post :create, id: @resource.id, point: invalid_attributes
          }.to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "as non-user" do
        it "returns http 302" do
          @resource = FactoryGirl.create(:user)
          post :create, id: @resource.id, point: invalid_attributes
          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe "PUT #update" do
    # context "with valid params" do
    #   let(:new_attributes) {
    #     skip("Add a hash of attributes valid for your model")
    #   }

    #   it "updates the requested point" do
    #     point = Point.create! valid_attributes
    #     put :update, params: {id: point.to_param, point: new_attributes}, session: valid_session
    #     point.reload
    #     skip("Add assertions for updated state")
    #   end

    #   it "assigns the requested point as @point" do
    #     point = Point.create! valid_attributes
    #     put :update, params: {id: point.to_param, point: valid_attributes}, session: valid_session
    #     expect(assigns(:point)).to eq(point)
    #   end

    #   it "redirects to the point" do
    #     point = Point.create! valid_attributes
    #     put :update, params: {id: point.to_param, point: valid_attributes}, session: valid_session
    #     expect(response).to redirect_to(point)
    #   end
    # end

    # context "with invalid params" do
    #   it "assigns the point as @point" do
    #     point = Point.create! valid_attributes
    #     put :update, params: {id: point.to_param, point: invalid_attributes}, session: valid_session
    #     expect(assigns(:point)).to eq(point)
    #   end

    #   it "re-renders the 'edit' template" do
    #     point = Point.create! valid_attributes
    #     put :update, params: {id: point.to_param, point: invalid_attributes}, session: valid_session
    #     expect(response).to render_template("edit")
    #   end
    # end
  end

  describe "DELETE #destroy" do
    # it "destroys the requested point" do
    #   point = Point.create! valid_attributes
    #   expect {
    #     delete :destroy, params: {id: point.to_param}, session: valid_session
    #   }.to change(Point, :count).by(-1)
    # end

    # it "redirects to the points list" do
    #   point = Point.create! valid_attributes
    #   delete :destroy, params: {id: point.to_param}, session: valid_session
    #   expect(response).to redirect_to(points_url)
    # end
  end
end
