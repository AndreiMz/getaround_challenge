class Car
    @@id = 1

    def initialize(_id, price_per_day, price_per_km)
        @id = @@id
        @price_per_day = price_per_day
        @price_per_km = price_per_km
        @@id += 1
    end

    attr_accessor :id, :price_per_day, :price_per_km
end
