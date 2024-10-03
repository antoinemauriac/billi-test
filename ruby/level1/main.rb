require 'json'
require 'date'

def time_price(rental, car)
  start_date = Date.parse(rental['start_date'])
  end_date = Date.parse(rental['end_date'])
  number_of_days = (end_date - start_date).to_i + 1
  price_per_day = car['price_per_day']
  number_of_days * price_per_day
end

def distance_price(rental, car)
  distance = rental['distance']
  price_per_km = car['price_per_km']
  distance * price_per_km
end

def total_price(rental, car)
  time_price = time_price(rental, car)
  distance_price = distance_price(rental, car)
  time_price + distance_price
end

def generate_output(input_file_path, output_file_path)
  file = File.read(input_file_path)
  input_data = JSON.parse(file)
  rentals = input_data['rentals']
  cars = input_data['cars']

  output_data = { rentals: [] }

  rentals.each do |rental|
    car = cars.find { |car| car['id'] == rental['car_id'] }
    rental_price = total_price(rental, car)
    output_data[:rentals] << { id: rental['id'], price: rental_price }
  end

  File.open(output_file_path, 'wb') do |file|
    file.write(JSON.generate(output_data))
  end
end

generate_output(File.join(__dir__, 'data', 'input.json'), File.join(__dir__, 'data', 'output.json'))
