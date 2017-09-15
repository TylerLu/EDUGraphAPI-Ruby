class UnifiedUser

  attr_accessor :local_user
  attr_accessor :o365_user

  def initialize(local_user, o365_user)
    self.local_user = local_user
    self.o365_user = o365_user
  end

  def is_authenticated?
    self.o365_user || self.local_user
  end
  
  def display_name
    user = self.o365_user || self.local_user
    if user
      if user.first_name.blank? || user.last_name.blank?
        return user.email
      else
        return "#{user.first_name} #{user.last_name}"
      end
    end
  end
end