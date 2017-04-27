

module Service
  module Education
    class SchoolUser
      attr_accessor :graph
      attr_accessor :school_number

      def initialize(graph, school_number)
        self.graph = graph
        self.school_number = school_number
      end

      def get_users(skip_token=nil)
        self.graph.get_users(self.school_number, skiptoken: skip_token)
      end

      def get_teachers(skip_token=nil)
        self.graph.get_users(self.school_number, role: 'Teacher', skiptoken: skip_token)
      end

      def get_students(skip_token=nil)
        self.graph.get_users(self.school_number, role: 'Student', skiptoken: skip_token)
      end
    end
  end
end