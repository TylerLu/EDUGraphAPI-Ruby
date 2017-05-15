class UnifiedUser

    attr_accessor :local_user
    attr_accessor :o365_user

    def initialize(local_user, o365_user)
        self.local_user = local_user
        self.o365_user = o365_user
    end

    def is_authenticated
        self.o365_user || self.local_user
    end

    def are_linked?
        self.o365_user && self.local_user
    end  

    def is_admin?
        self.o365_user && (self.o365_user.roles.include? Constant::Roles::Admin)
    end

    def is_teacher?
        self.o365_user && (self.o365_user.roles.include? Constant::Roles::Faculty)
    end

    def is_student?
        self.o365_user && (self.o365_user.roles.include? Constant::Roles::Student)
    end

    def main_role
        if o365_user && o365_user.roles
            for role in [Constant::Roles::Admin, Constant::Roles::Faculty, Constant::Roles::Student]
                if o365_user.roles.include? role
                    return role
                end
            end
        end
        return nil     
    end

    def email
        local_user ? local_user.email : nil
    end

    def o365_email
        o365_user ? o365_user.email : nil
    end

    def o365_user_id
        o365_user ? o365_user.id : nil
    end

    def user_id
        local_user ? local_user.id : nil
    end

    def tenant_id
        o365_user ? o365_user.tenant_id : nil
    end

    def is_local?
        o365_user.nil?
    end

    def is_o365?
        local_user.nil?
    end

    def display_name
        user = self.o365_user || self.local_user
        user ? "#{user.first_name} #{user.last_name}" : ""
    end

end