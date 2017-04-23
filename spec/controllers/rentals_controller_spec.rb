require "rails_helper"

RSpec.describe RentalsController, type: :controller do
  before(:example) { @rental = create(:rental) }

  let(:valid_params) { { name: "My rental", daily_rate: 30 } }
  let(:invalid_params) { { invalid: "value", daily_rate: nil } }
  let(:new_params) { { name: "New rental name", daily_rate: 50 } }
  let(:token) { "global_token" }

  describe "GET #index" do
    it "assigns all rentals as @rentals" do
      get :index, params: { token: token }
      expect(assigns(:rentals)).to eq(Rental.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested rental as @rental" do
      get :show, params: { id: @rental.to_param, token: token }
      expect(assigns(:rental)).to eq(@rental)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Rental" do
        expect do
          post :create, params: { rental: valid_params, token: token }
        end.to change(Rental, :count).by(1)
      end

      it "assigns a newly created rental as @rental" do
        post :create, params: { rental: valid_params, token: token }
        expect(assigns(:rental)).to be_a(Rental)
        expect(assigns(:rental)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved rental as @rental" do
        post :create, params: { rental: invalid_params, token: token }
        expect(assigns(:rental)).to be_a_new(Rental)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested rental" do
        put :update, params: { id: @rental.id, rental: new_params, token: token }
        @rental.reload
        expect(@rental.name).to eq(new_params[:name])
        expect(@rental.daily_rate).to eq(new_params[:daily_rate])
      end

      it "assigns the requested rental as @rental" do
        put :update, params: { id: @rental.id, rental: new_params, token: token }
        expect(assigns(:rental)).to eq(@rental)
      end
    end

    context "with invalid params" do
      it "assigns the rental as @rental" do
        put :update, params: { id: @rental.id, rental: invalid_params, token: token }
        expect(assigns(:rental)).to eq(@rental)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested rental" do
      expect do
        delete :destroy, params: { id: @rental.id, token: token }
      end.to change(Rental, :count).by(-1)
    end
  end
end
