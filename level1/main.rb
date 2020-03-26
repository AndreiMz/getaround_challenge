require 'json'
require 'date'

def to_date(date_string)
    year, month, day = date_string.split('-')
    Date.new(year.to_i, month.to_i, day.to_i)
end

data = JSON.parse(File.read('data/input.json'))
cars = data['cars']
result = {
    "rentals" => []
}

data['rentals'].each do |rental|
    id, car_id, start_date, end_date, distance = rental.values
    car = cars.find { |c| c['id'] == car_id }
    day_price = car['price_per_day']
    distance_price = car['price_per_km']
    time_total = ((to_date(end_date) - to_date(start_date)).to_i + 1) * day_price
    distance_total = distance.to_i * distance_price


    result['rentals'] << {
        id: id,
        price: time_total + distance_total
    }
end

File.open('data/output.json', 'w') do |f|
    f << JSON.pretty_generate(result)
end