

module Service
  module Education
    class School
      include Service::BingMap

      attr_accessor :graph

      def initialize(graph)
        self.graph = graph
      end

      def get_all_schools
        all_schools = self.graph.get_administrative_units

        all_schools = (all_schools || []).map do |_school| 
          _school.merge(location: get_longitude_and_latitude_by_address("#{_school[Constant.get(:edu_state)]}/#{_school[Constant.get(:edu_city)]}/#{_school[Constant.get(:edu_address)]}"))
        end

        schools = []
        other_schools = []
        all_schools.reduce(schools) do |res, ele| 
          if ele[Constant.get(:edu_school_number)] == graph.get_current_user[Constant.get(:edu_school_id)]
            res << ele
          else
            other_schools << ele
          end
          res
        end

        schools.concat other_schools.sort_by{|_| _['displayName'][0] }
      end
    end
  end
end