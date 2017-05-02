
module Education
  class School
    include Education

    attr_accessor :tenant_name
    attr_accessor :aad_token

    def initialize(tenant_name, token)
      self.tenant_name = tenant_name
      self.aad_token = token
    end

    def get_all_schools
      all_schools = graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: 'administrativeUnits',
        access_token: aad_token
      })['value']

      all_schools = (all_schools || []).map do |_school|
        _school.merge(location: get_longitude_and_latitude_by_address("#{_school[Constant.get(:edu_state)]}/#{_school[Constant.get(:edu_city)]}/#{_school[Constant.get(:edu_address)]}"))
      end

      schools = []
      other_schools = []
      all_schools.reduce(schools) do |res, ele|
        if ele[Constant.get(:edu_school_number)] == get_my_school_id
          res << ele
        else
          other_schools << ele
        end
        res
      end

      schools.concat other_schools.sort_by{|_| _['displayName'][0] }
    end

    def get_my_school_id
      me = graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: 'me',
        access_token: aad_token
      })
      me[Constant.get(:edu_school_id)]
    end

    private
    def get_longitude_and_latitude_by_address(address)
      if address.blank?
        return {}
      else
        res = JSON.parse HTTParty.get(build_bing_map_url(address, Settings.BingMapKey)).body
        lat, lon = res['resourceSets'].first['resources'].first['point']['coordinates']
      end
      {lat: lat, lon: lon}
    end

    def build_bing_map_url(address, key)
      URI.encode "http://dev.virtualearth.net/REST/v1/Locations/US/#{address}?output=json&key=#{key}"
    end
  end
end
