module Education
    
    class NextLink

        attr_accessor :value

        def initialize(value)
            self.value = value
        end

        def skip_token
            value.match(/(?<=skiptoken=)([^&]*)/)[0]
        end

    end
end