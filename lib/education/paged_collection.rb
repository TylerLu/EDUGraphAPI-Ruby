module Education
    
    class PagedCollection

        attr_accessor :value
        attr_accessor :next_link

        def initialize(value, next_link)
            self.value = value
            self.next_link = next_link
        end
        
    end
end