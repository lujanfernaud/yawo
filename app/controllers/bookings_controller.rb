class BookingsController < ApplicationController
  def show
    @booking = Booking.find(params[:id]).decorate
    find_flight
  end

  def new
    @flight_id = params[:flight_id]

    unless @flight_id
      flash[:danger] = "You need to select a flight from the list."
      return redirect_to root_path
    end

    @booking    = Booking.new.decorate
    @passengers = params[:passengers].to_i
    @passengers.times { @booking.passengers.build }
    find_flight
  end

  def create
    @booking = Booking.new(booking_params).decorate
    find_flight

    if @booking.save
      flash[:success] = "Congratulations! " \
                        "You have successfully booked this flight!"
      send_new_booking_email
      redirect_to booking_path(@booking)
    else
      render :new
    end
  end

  private

    def find_flight
      flight  = @booking.flight || Flight.find(@flight_id)
      @flight = flight.decorate
    end

    def booking_params
      params.require(:booking).permit(:flight_id,
                                      passengers_attributes: [:first_name,
                                                              :last_name,
                                                              :email])
    end

    def send_new_booking_email
      passenger = @booking.passengers[0]
      PassengerMailer.booking_details(passenger).deliver
    end
end
