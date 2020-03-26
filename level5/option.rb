class Option
    attr_accessor :type

    # all modifiers apply per DAY

    @@gps_modifier = 500
    @@baby_seat_modifier = 200
    @@additional_insurance_modifier = 1000

    def initialize(type)
        @type = type
    end

    def compute_modifier_and_target
        case @type.downcase
        when 'gps'
            [@@gps_modifier, 'owner']
        when 'baby_seat'
            [@@baby_seat_modifier, 'owner']
        when 'additional_insurance'
            [@@additional_insurance_modifier, 'drivy']
        else
            raise ArgumentError, 'Unknown option for rental'
        end
    end
end