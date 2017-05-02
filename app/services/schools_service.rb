
class SchoolsService
  attr_accessor :edu_school
  attr_accessor :edu_section
  attr_accessor :edu_section_user
  attr_accessor :tenant_name
  attr_accessor :token_obj
  attr_accessor :school_number

  def initialize(tenant_name, token_obj, school_number)
    self.tenant_name = tenant_name
    self.token_obj = token_obj
    self.school_number = school_number
    self.edu_school   = Education::School.new(tenant_name, token_obj.get_aad_token)
    self.edu_section  = Education::Section.new(tenant_name, token_obj.get_aad_token, school_number)
    self.edu_section_user = Education::SectionUser.new(tenant_name, token_obj.get_aad_token, school_number)
  end

  def get_conversations_by_class_id(class_id)
    ms_graph = Graph::MSGraph.new(token_obj.get_ms_token, tenant_name)
    ms_graph.get_conversations_by_class_id(class_id)
  end

  def get_documents_by_class_id(class_id) 
    ms_graph = Graph::MSGraph.new(token_obj.get_ms_token, tenant_name)
    ms_graph.get_documents_by_class_id(class_id)
  end

  def get_all_schools
    edu_school.get_all_schools
  end

  def get_my_school_id
    edu_school.get_my_school_id
  end

  def get_my_classes_by_school_number(current_user)
    edu_section.get_my_classes_by_school_number(current_user)
  end

  def get_class_info(class_id)
    edu_section.get_class_info(class_id)
  end

  def get_class_members(class_id)
    edu_section.get_class_members(class_id)
  end

  def get_classes_by_school_number(skip_token = nil)
    edu_section.get_classes_by_school_number(skip_token)
  end

  def get_my_cleasses_teacher_mapping
    edu_section.get_my_cleasses_teacher_mapping
  end

  def get_users(role: nil, skiptoken: nil)
    edu_section_user.get_users(role: role, skiptoken: skiptoken)
  end

  def get_teachers(skip_token=nil)
    edu_section_user.get_teachers(skip_token: skip_token)
  end

  def get_students(skip_token=nil)
    edu_section_user.get_students(skip_token: skip_token)
  end
end