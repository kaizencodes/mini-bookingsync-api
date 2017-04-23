# Mini-BookingSync API

This is an example project for https://www.bookingsync.com/

## Rentals

Rental is something that you can book for a particular period of time.

### Attributes
* name:string
* daily_rate:integer

### API endpoints
* GET /rentals
* GET /rentals/:id
* POST /rentals
* PUT /rentals/:id
* DELETE /rentals/:id

## Bookings

Booking is a reservation for given Rental for a particular period of time.

### Attributes
* client_email:string
* price:integer start_at:datetime
* end_at:datetime

### Price calculation
reserved days * daily_rate. If the rental's daily price is equal to 100, the booking's price for 3 days is equal to 300, for 5 days it is 500 etc.

### API endpoints
* GET /bookings
* GET /bookings/:id
* POST /bookings
* PUT /bookings/:id
* DELETE /bookings/:id

All attributes for both Rentals and Bookings are required. Also:

* the dates for bookings don't overlap
* the price for given period is valid when creating a booking
* the reservation is only possible for at least one night stay

## Authentication
The API is authenticatable by a global token. In this example it is set to: global_token.

For more advanced setup OAuth2 can be used. [doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) is a great Rails implementation.
