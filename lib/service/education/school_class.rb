

module Service
  module Education
    class SchoolClass
      attr_accessor :myclasses
      attr_accessor :graph
      attr_accessor :school_number

      def initialize(graph, school_number)
        self.school_number = school_number
        self.graph = graph
      end

      def get_my_classes_by_school_number(current_user)
        self.myclasses ||= if current_user[:school_number] == school_number
          self.graph.get_user_classes(current_user[:o365_email])
        else
          []
        end
      end

      def get_class_info(class_id)
        self.graph.get_class_info(class_id)
      end

      def get_class_members(class_id)
        self.graph.get_class_members(class_id)
      end

      def get_conversations_by_class_id(class_id)
        self.graph.get_conversations_by_class_id(class_id)
      end

      def get_documents_by_class_id(class_id)
        self.graph.get_documents_by_class_id(class_id)
      end

      def get_classes_by_school_number(skip_token = nil)
        self.graph.get_classes_by_school_number(school_number)
      end

      def get_my_cleasses_teacher_mapping
        class_teacher_mapping = {}
        self.myclasses.each do |_class|
          res = self.graph.get_classes_with_members(_class["objectId"])
          _teacher = res['members'].select do |_member|
            _member[Constant.get(:edu_object_type)] == "Teacher"
          end.first

          class_teacher_mapping[res['objectId'].to_s] = _teacher['displayName']
        end
        class_teacher_mapping
      end
    end
  end
end