require "rails_helper"

RSpec.describe "Rentals", type: :request do
  before(:example) { @rental = create(:rental) }

  let(:valid_params) { attributes_for(:rental) }
  let(:invalid_params) { { name: nil } }
  let(:new_params) { { name: "New rental name", daily_rate: 50 } }

  describe "GET /rentals" do
    it "responds with json" do
      get rentals_path
      expect(response.content_type).to eq("application/json")
    end

    it "responds with status ok" do
      get rentals_path
      expect(response).to have_http_status(200)
    end

    it "responds with all rentals" do
      get rentals_path
      expect(response.body).to eql(Rental.all.to_json)
    end
  end

  describe "GET /rentals/:id" do
    it "responds with json" do
      get rental_path(@rental)
      expect(response.content_type).to eq("application/json")
    end

    it "responds with status ok" do
      get rental_path(@rental)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /rentals" do
    it "responds with json" do
      get rentals_path
      expect(response.content_type).to eq("application/json")
    end

    context "with valid params" do
      it "responds with status created" do
        post rentals_path, params: { rental: valid_params }
        expect(response).to have_http_status(:created)
      end

      it "responds with created rental" do
        post rentals_path, params: { rental: valid_params }
        expect(response.body).to eql(Rental.last.to_json)
      end
    end

    context "with invalid params" do
      it "responds with status unprocessable_entity" do
        post rentals_path, params: { rental: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with error message" do
        invalid_rental = Rental.create(invalid_params)
        post rentals_path, params: { rental: invalid_params }
        expect(response.body).to eql(invalid_rental.errors.messages.to_json)
      end
    end
  end

  describe "PUT /rentals/:id" do
    it "responds with json" do
      put rental_path(@rental), params: { rental: new_params }
      expect(response.content_type).to eq("application/json")
    end

    context "with valid params" do
      it "responds with status ok" do
        put rental_path(@rental), params: { rental: new_params }
        expect(response).to have_http_status(:ok)
      end

      it "responds with updated rental" do
        put rental_path(@rental), params: { rental: new_params }
        expect(response.body).to eql(Rental.find(@rental.id).to_json)
      end
    end

    context "with invalid params" do
      it "responds with status unprocessable_entity" do
        put rental_path(@rental), params: { rental: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with error message" do
        @rental.update_attributes(invalid_params)
        put rental_path(@rental), params: { rental: invalid_params }
        expect(response.body).to eql(@rental.errors.messages.to_json)
      end
    end
  end

  describe "DELETE /rentals/:id" do
    it "responds with status no_content" do
      delete rental_path(@rental)
      expect(response).to have_http_status(:no_content)
    end
  end
end
