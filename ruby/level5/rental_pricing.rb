class RentalPricing

  OPTIONS_COST = {
    gps: 500,
    baby_seat: 200,
    additional_insurance: 1000
  }

  def initialize(attr = {})
    @rental = attr[:rental]
    @car = attr[:car]
    @total_price = calculate_total_price
    @owner_fee = @total_price * 0.7
    other_fees = @total_price * 0.3
    @insurance_fee = other_fees * 0.5
    @assistance_fee = @rental.number_of_days * 100
    @drivy_fee = other_fees - @insurance_fee - @assistance_fee

    manage_options if @rental.options.any?

    modify_fees if invalid_fees?
  end

  def manage_options
    options = @rental.options
    options.each do |option|
      case option
      when 'gps'
        @owner_fee += @rental.number_of_days * OPTIONS_COST[:gps]
      when 'baby_seat'
        @owner_fee += @rental.number_of_days * OPTIONS_COST[:baby_seat]
      when 'additional_insurance'
        @drivy_fee += @rental.number_of_days * OPTIONS_COST[:additional_insurance]
      end
      @total_price += @rental.number_of_days * OPTIONS_COST[option.to_sym]
    end
  end

  def fee_repartion
    [
      { who: 'driver', type: 'debit', amount: @total_price },
      { who: 'owner', type: 'credit', amount: @owner_fee },
      { who: 'insurance', type: 'credit', amount: @insurance_fee },
      { who: 'assistance', type: 'credit', amount: @assistance_fee },
      { who: 'drivy', type: 'credit', amount: @drivy_fee }
    ]
  end

  private

  def time_price
    number_of_days = @rental.number_of_days
    price_per_day = @car.price_per_day
    time_price = 0

    time_price += price_per_day if number_of_days >= 1
    time_price += [number_of_days - 1, 3].min * price_per_day * 0.9 if number_of_days >= 2
    time_price += [number_of_days - 4, 6].min * price_per_day * 0.7 if number_of_days >= 5
    time_price += (number_of_days - 10) * price_per_day * 0.5 if number_of_days > 10

    time_price
  end

  def distance_price
    distance = @rental.distance
    price_per_km = @car.price_per_km
    distance * price_per_km
  end

  def calculate_total_price
    time_price + distance_price
  end

  def invalid_fees?
    @insurance_fee + @assistance_fee > @total_price * 0.3
  end

  def modify_fees
    ratio = (@total_price * 0.3) / (@insurance_fee + @assistance_fee)
    @insurance_fee *= ratio
    @assistance_fee *= ratio
    @drivy_fee = 0
  end
end
