require "rails_helper"

RSpec.describe "Bookings", type: :request do
  before(:example) do
    @booking = create(:booking)
  end

  let(:valid_params) { attributes_for(:booking) }
  let(:invalid_params) { { client_email: nil } }
  let(:new_params) { { client_email: "foo@bar.com", price: 10 } }
  let(:token) { "global_token" }

  describe "GET /bookings" do
    it "responds with json" do
      get bookings_path, params: { token: token }
      expect(response.content_type).to eq("application/json")
    end

    it "responds with status ok" do
      get bookings_path, params: { token: token }
      expect(response).to have_http_status(:ok)
    end

    it "responds with all bookings" do
      get bookings_path, params: { token: token }
      expect(response.body).to eql(Booking.all.to_json)
    end

    context "without token" do
      it "responds with status unauthorized" do
        get bookings_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /bookings/:id" do
    it "responds with json" do
      get booking_path(@booking), params: { token: token }
      expect(response.content_type).to eq("application/json")
    end

    it "responds with status ok" do
      get booking_path(@booking), params: { token: token }
      expect(response).to have_http_status(:ok)
    end

    context "without token" do
      it "responds with status unauthorized" do
        get booking_path(@booking)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /bookings" do
    context "with valid params" do
      before(:example) do
        @rental = create(:rental)
      end

      it "responds with json" do
        valid_params[:rental_id] = @rental.id
        post bookings_path, params: { booking: valid_params, token: token }
        expect(response.content_type).to eq("application/json")
      end

      it "responds with status created" do
        valid_params[:rental_id] = @rental.id
        post bookings_path, params: { booking: valid_params, token: token }
        expect(response).to have_http_status(:created)
      end

      it "responds with created booking" do
        valid_params[:rental_id] = @rental.id
        post bookings_path, params: { booking: valid_params, token: token }
        expect(response.body).to eql(Booking.last.to_json)
      end
    end

    context "with invalid params" do
      it "responds with status unprocessable_entity" do
        post bookings_path, params: { booking: invalid_params, token: token }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with error message" do
        invalid_booking = Booking.create(invalid_params)
        post bookings_path, params: { booking: invalid_params, token: token }
        expect(response.body).to eql(invalid_booking.errors.messages.to_json)
      end
    end

    context "without token" do
      it "responds with status unauthorized" do
        post bookings_path, params: { booking: valid_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /bookings/:id" do
    it "responds with json" do
      put booking_path(@booking), params: { booking: new_params, token: token }
      expect(response.content_type).to eq("application/json")
    end

    context "with valid params" do
      it "responds with status ok" do
        put booking_path(@booking), params: { booking: new_params, token: token }
        expect(response).to have_http_status(:ok)
      end

      it "responds with updated booking" do
        put booking_path(@booking), params: { booking: new_params, token: token }
        @booking.reload
        expect(response.body).to eql(@booking.to_json)
      end
    end

    context "with invalid params" do
      it "responds with status unprocessable_entity" do
        put booking_path(@booking), params: { booking: invalid_params, token: token }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with error message" do
        @booking.update_attributes(invalid_params)
        put booking_path(@booking), params: { booking: invalid_params, token: token }
        expect(response.body).to eql(@booking.errors.messages.to_json)
      end
    end

    context "without token" do
      it "responds with status unauthorized" do
        put booking_path(@booking), params: { booking: new_params }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /bookings/:id" do
    it "responds with status no_content" do
      delete booking_path(@booking.id), params: { token: token }
      expect(response).to have_http_status(:no_content)
    end

    context "without token" do
      it "responds with status unauthorized" do
        delete booking_path(@booking.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
