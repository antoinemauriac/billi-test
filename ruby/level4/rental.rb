require 'date'

class Rental
  attr_reader :id, :car_id, :distance, :options

  def initialize(attr = {}, options = [])
    @id = attr[:id]
    @car_id = attr[:car_id]
    @start_date = Date.parse(attr[:start_date])
    @end_date = Date.parse(attr[:end_date])
    @distance = attr[:distance]
    @options = options

    validate_dates
  end

  def number_of_days
    (@end_date - @start_date).to_i + 1
  end

  private

  def validate_dates
    raise ArgumentError, 'La date de fin doit être supérieure ou égale à la date de début' if @end_date < @start_date
  end
end
