require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  before(:example) do
    @booking = create(:booking)
  end

  let(:valid_params) { attributes_for(:booking) }
  let(:invalid_params) { { invalid: "value", client_email: nil } }
  let(:new_params) { { client_email: "new@email.com" } }
  let(:token) { "global_token" }

  describe "GET #index" do
    it "assigns all bookings as @bookings" do
      get :index, params: { token: token }
      expect(assigns(:bookings)).to eq(Booking.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested booking as @booking" do
      get :show, params: { id: @booking.id, token: token }
      expect(assigns(:booking)).to eq(@booking)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:example) do
        @rental = create(:rental)
      end

      it "creates a new Booking" do
        valid_params[:rental_id] = @rental.id
        expect do
          post :create, params: { booking: valid_params, token: token }
        end.to change(Booking, :count).by(1)
      end

      it "assigns a newly created booking as @booking" do
        valid_params[:rental_id] = @rental.id
        post :create, params: { booking: valid_params, token: token }
        expect(assigns(:booking)).to be_a(Booking)
        expect(assigns(:booking)).to be_persisted
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved booking as @booking" do
        post :create, params: { booking: invalid_params, token: token }
        expect(assigns(:booking)).to be_a_new(Booking)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested booking" do
        put :update, params: { id: @booking.id, booking: new_params, token: token }
        @booking.reload
        expect(@booking.client_email).to eq(new_params[:client_email])
      end

      it "assigns the requested booking as @booking" do
        put :update, params: { id: @booking.id, booking: valid_params, token: token }
        expect(assigns(:booking)).to eq(@booking)
      end
    end

    context "with invalid params" do
      it "assigns the booking as @booking" do
        put :update, params: { id: @booking.id, booking: invalid_params, token: token }
        expect(assigns(:booking)).to eq(@booking)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested booking" do
      expect do
        delete :destroy, params: { id: @booking.id, token: token }
      end.to change(Booking, :count).by(-1)
    end
  end
end
