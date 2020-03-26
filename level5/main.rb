require 'json'
require './rental.rb'


class Engine
    def make_output(data)
        File.open('data/output.json', 'w') do |f|
            f << JSON.pretty_generate({rentals: data})
        end
    end

    def initialize
        raw = JSON.parse(File.read('data/input.json'))
        @options = raw['options']
        @cars = raw['cars']
        @rentals = raw['rentals']
    end


    def compute_level2
        result =[]
        @rentals.each do |r|
            car = @cars.find { |c| c['id'] == r.values[1] }
            raise ArgumentError, 'Invalid car id, does not exist' if car.nil?

            rental = Rental.new(*r.values[2..-1], car.values)
            result << rental.to_initial_price_hash
        end
        make_output(result)
    end

    def compute_level3
        result =[]
        @rentals.each do |r|
            car = @cars.find { |c| c['id'] == r.values[1] }
            raise ArgumentError, 'Invalid car id, does not exist' if car.nil?

            rental = Rental.new(*r.values[2..-1], car.values)
            result << rental.to_commission_price_hash
        end
        make_output(result)
    end

    def compute_level4
        result =[]
        @rentals.each do |r|
            car = @cars.find { |c| c['id'] == r.values[1] }
            raise ArgumentError, 'Invalid car id, does not exist' if car.nil?

            rental = Rental.new(*r.values[2..-1], car.values)
            result << rental.to_credit_debit_hash
        end
        make_output(result)
    end

    def compute_level5
        result =[]
        @rentals.each do |r|
            car = @cars.find { |c| c['id'] == r.values[1] }
            raise ArgumentError, 'Invalid car id, does not exist' if car.nil?

            options = @options.select {|e| e['rental_id'] == r['id']}.map {|e| e.values.last}

            rental = Rental.new(*r.values[2..-1], car.values, options)
            result << rental.to_options_hash
        end
        make_output(result)
    end

    attr_accessor :options, :cars, :rentals
end


Engine.new.compute_level5