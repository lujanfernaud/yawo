class Booking < ApplicationRecord
  belongs_to :flight

  has_many :passenger_bookings
  has_many :passengers, through: :passenger_bookings

  accepts_nested_attributes_for :passengers

  before_save :add_boarding_time, :add_gate, :add_seat

  private

    def add_boarding_time
      self.boarding_time = flight.departure_time - 1.hour
    end

    def add_gate
      self.gate = "#{[*"A".."F"].sample}#{[*1..48].sample}"
    end

    def add_seat
      self.seat = "#{[*1..300].sample}"
    end
end