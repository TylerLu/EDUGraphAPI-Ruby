
module Education
  module School
    attr_accessor :me
    attr_accessor :roles

    def user_unlinked?
      account = Account.find_by_email(session[:current_user][:email]) || 
                Account.find_by_o365_email(cookies[:o365_login_email])

      if !account || account.o365_email.blank? || account.email.blank?
        return true
      else
        return false
      end
    end

    def set_tenant_name!(tenant_name)
      ENV['tenant_name'] = tenant_name
      Settings.tenant_name = ENV['tenant_name']
    end

    def get_user_info
      self.me ||= graph_request({
        host: 'graph.windows.net',
        tenant_name: Settings.tenant_name,
        resource_name: 'me',
        access_token: session[:gwn_access_token]
      })
    end

    def get_my_classes
      begin
        classes = graph_request({
          host: 'graph.microsoft.com',
          tenant_name: Settings.tenant_name,
          access_token: session[:gmc_access_token]
        }).me.member_of.map do |_class|
          next if _class.try(:role_template_id)
          _class.display_name
        end
      rescue => e
        classes = []
      end
      classes
    end

    def get_all_schools
      all_schools = graph_request({
        host: 'graph.windows.net',
        tenant_name: Settings.tenant_name,
        resource_name: 'administrativeUnits',
        access_token: session[:gwn_access_token]
      })['value']

      all_schools = (all_schools || []).map do |_school| 
        _school.merge(location: get_longitude_and_latitude_by_address("#{_school[Constant.get(:edu_state)]}/#{_school[Constant.get(:edu_city)]}/#{_school[Constant.get(:edu_address)]}"))
      end

      schools = []
      other_schools = []
      all_schools.reduce(schools) do |res, ele| 
        if ele[Constant.get(:edu_school_number)] == get_user_info[Constant.get(:edu_school_id)]
          res << ele
        else
          other_schools << ele
        end
        res
      end

      schools.concat other_schools.sort_by{|_| _['displayName'][0] }
    end

    def init_user_roles!
      self.roles = []
      if get_user_info['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:teacher_sku_id) || _['skuId'] == Constant.get(:teacher_pro_sku_id) }
        self.roles << 'Teacher'
      end

      if get_user_info['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:student_sku_id) || _['skuId'] == Constant.get(:student_pro_sku_id) }
        self.roles << 'Student'
      end

      myroles = graph_request({
        host: 'graph.windows.net',
        tenant_name: Settings.tenant_name,
        resource_name: 'directoryRoles',
        access_token: session[:gwn_access_token],
        query: {
          "$expand" => 'members'
        }
      })['value'].select{|_| _['displayName'] == Constant.get(:aad_company_admin_role_name) }

      myroles.each do |_role|
        if _role['members'].find{|_| _['objectId'] == get_user_info['objectId'] }
          self.roles << 'Admin'
        end
      end
    end
  end
end