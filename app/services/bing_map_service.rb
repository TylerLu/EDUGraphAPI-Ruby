# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class BingMapService

    def initialize(bing_map_key)
        @bing_map_key = bing_map_key
    end

    def get_longitude_and_latitude_by_address(address)
        if address && Settings.BingMapKey
            url = build_bing_map_url(address, @bing_map_key)
            res = JSON.parse HTTParty.get(url).body
            latitude, longitude = res['resourceSets'].first['resources'].first['point']['coordinates']
            { latitude: latitude, longitude: longitude}
        else
            nil
        end
    end

    private
    def build_bing_map_url(address, key)
        URI.encode "http://dev.virtualearth.net/REST/v1/Locations/US/#{address}?output=json&key=#{key}"
    end
end