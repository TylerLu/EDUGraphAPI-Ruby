class ObjectBase

    attr_accessor :prop_hash
    attr_accessor :custom_hash
    def initialize(prop_hash = {})
        self.prop_hash = prop_hash
        self.custom_hash = {}
    end

    def get_value(property_name)
        prop_hash[property_name]
    end
    
    def set_value(property_name, value)
        prop_hash[property_name] = value
    end

    def get_education_extension_value(property_name)
        extension_property_name = 'extension_fe2174665583431c953114ff7268b7b3_Education_' + property_name        
        prop_hash[extension_property_name]
    end

    def object_id
        get_value('objectId')
    end

    def education_object_type
        get_education_extension_value('ObjectType')
    end

    def custom_data
        custom_hash
    end   

end