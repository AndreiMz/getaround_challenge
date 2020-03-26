require 'json'
require 'date'
require 'awesome_print'

def to_date(date_string)
    year, month, day = date_string.split('-')
    Date.new(year.to_i, month.to_i, day.to_i)
end

def recursive_price(remaining_days, price, sum, days_passed)
    return sum if remaining_days.zero?
    
    case days_passed
    when 0
        sum += price
    when 1..3
        sum += price * 9/10
    when 4..9
        sum += price * 7/10
    else
        sum += price * 1/2
    end

    recursive_price(remaining_days-1, price, sum, days_passed+1)
end

def calculate_time_total(start_date, end_date, price)
    total_days = (end_date - start_date).to_i + 1
    [recursive_price(total_days, price, 0, 0), total_days]
end

def make_output(data)
    File.open('data/output.json', 'w') do |f|
        f << JSON.pretty_generate(data)
    end
end

def compute_rentals_price
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
        
        time_total, days = calculate_time_total(to_date(start_date), to_date(end_date), day_price)
        distance_total = distance.to_i * distance_price


        result['rentals'] << {
            id: id,
            price: time_total + distance_total,
            days: days
        }
    end

    result['rentals']
end


def split_commision(rentals)
    result_with_commisions = {
        rentals: []
    }

    rentals.each do |rental|
        commision = rental[:price] * 3/10
        insurance = commision / 2
        assistance = rental[:days] * 100
        drivy = commision - insurance - assistance

        result_with_commisions[:rentals] << {
            id: rental[:id],
            price: rental[:price],
            commission: {
                insurance_fee: insurance,
                assistance_fee: assistance,
                drivy_fee: drivy
            }
        }
    end

    make_output(result_with_commisions)
    result_with_commisions
end

rentals = compute_rentals_price
split_commision(rentals)