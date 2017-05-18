# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

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