
# require_relative './school'
# require_relative './school_class'


module Education
  extend ActiveSupport::Autoload
  
  autoload :School
  autoload :SchoolClass
  autoload :User
end