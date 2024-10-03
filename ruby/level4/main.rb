require 'json'
require_relative 'rental'
require_relative 'car'
require_relative 'rental_pricing'


def generate_output(input_file_path, output_file_path)
  file = File.read(input_file_path)
  input_data = JSON.parse(file, symbolize_names: true)
  rentals = input_data[:rentals].map { |rental| Rental.new(rental) }
  cars = input_data[:cars].map { |car| Car.new(car) }

  output_data = { rentals: [] }

  rentals.each do |rental|
    car = cars.find { |car| car.id == rental.car_id }
    rental_pricing = RentalPricing.new(rental: rental, car: car)
    output_data[:rentals] << {
      id: rental.id,
      actions: rental_pricing.fee_repartion
    }
  end

  File.open(output_file_path, 'wb') do |file|
    file.write(JSON.generate(output_data))
  end
end

generate_output(File.join(__dir__, 'data', 'input.json'), File.join(__dir__, 'data', 'output.json'))
