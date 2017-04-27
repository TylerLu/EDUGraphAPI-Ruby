
module Service
  class User
    attr_accessor :aad_graph
    attr_accessor :ms_graph

    def initialize(aad_graph, ms_graph)
      self.aad_graph = aad_graph
      self.ms_graph = ms_graph
    end

    def get_current_user
      current_user = self.aad_graph.get_current_user
      {
        user_identify: current_user[Constant.get(:edu_object_type)],
        display_name: current_user[Constant.get(:given_name)],
        school_number: current_user[Constant.get(:edu_school_id)],
        surname: current_user[Constant.get(:surname)],
        photo: get_user_photo_url(current_user[Constant.get(:object_id)]),
        user_identify_id:  current_user[Constant.get(:edu_object_type)] == "Teacher" ? 
                           current_user[Constant.get(:edu_teacher_id)] : 
                           current_user[Constant.get(:edu_student_id)]
      }
    end

    def get_user_photo_url(objectId)
      if File.exist? "#{Rails.root}/public/photos/#{objectId}.jpg"
        photo_url = "/photos/#{objectId}.jpg"
      else
        photo = self.ms_graph.get_user_photo(objectId)

        photo_url = "/Images/header-default.jpg"
        begin
          JSON.parse photo
        rescue
          if photo.nil? || photo.empty?
            photo_url = "/Images/header-default.jpg"
          else
            File.open("#{Rails.root}/public/photos/#{objectId}.jpg", "wb") do |f|
              f.write photo
            end
            photo_url = "/photos/#{objectId}.jpg"         
          end
        end
      end

      return photo_url
    end
  end
end