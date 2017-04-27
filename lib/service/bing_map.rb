
module Service
  module BingMap
    def get_longitude_and_latitude_by_address(address)
      if address.blank?
        return {}
      else
        res = JSON.parse HTTParty.get(build_bing_map_url(address, Settings.bing_map_key)).body
        lat, lon = res['resourceSets'].first['resources'].first['point']['coordinates']
      end
      {lat: lat, lon: lon}
    end

    private
    def build_bing_map_url(address, key)
      URI.encode "http://dev.virtualearth.net/REST/v1/Locations/US/#{address}?output=json&key=#{key}"
    end
    
  end
end