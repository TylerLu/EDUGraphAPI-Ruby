require_relative 'object_base.rb'

module Education

    class Section < ObjectBase

        def initialize(prop_hash = {})
            super(prop_hash)
        end

        def school_id
           get_education_extension_value('SyncSource_SchoolId')
        end

        def course_id
            get_education_extension_value('SyncSource_CourseId')
        end

        def mail
            return self.get_value('mail')
        end

        def display_name
            return self.get_value('displayName')
        end

        def course_description
            get_education_extension_value('CourseDescription')
        end

        def course_name
            get_education_extension_value('CourseName')
        end

        def course_number
            get_education_extension_value('CourseNumber')
        end
    
        def term_name
            get_education_extension_value('TermName')
        end

        def term_start_date
            get_education_extension_value('TermStartDate')
        end

        def term_end_date
            get_education_extension_value('TermEndDate')
        end

        def period
            get_education_extension_value('Period')
        end

        def combined_course_number
            "#{course_name[0..2].upcase()}#{course_number}"
            # <%= c['extension_fe2174665583431c953114ff7268b7b3_Education_CourseName'][0..2].upcase rescue '' %><%= c['extension_fe2174665583431c953114ff7268b7b3_Education_CourseNumber'] %>
            # # TODO
            # # combined_course_number = ''
            # # if self.course_name and self.course_number:
            # #     combined_course_number = self.course_name[0:3].upper() + re.match('\d+', self.course_number).group()
            # return combined_course_number
        end




        # def term_start_date
        #     out_start_date = ''
        #     if self.start_date:
        #         convert_date = datetime.datetime.strptime(self.start_date, '%m/%d/%Y')
        #         out_start_date = convert_date.strftime('%Y-%m-%dT%H:%M:%S')
        #     return out_start_date
        # end


        # def course_termstartdate
        #     return self.term_start_date
        # end


        # def TermStartDate
        #     return self.term_start_date
        # end


        # def term_end_date
        #     out_end_date = ''
        #     if self.end_date:
        #         convert_date = datetime.datetime.strptime(self.end_date, '%m/%d/%Y')
        #         out_end_date = convert_date.strftime('%Y-%m-%dT%H:%M:%S')
        #     return out_end_date
        # end
    

        # def course_termenddate
        #     return self.term_end_date
        # end





        def members
            return self.get_value('members')
        end

        def members=(value)
            self.set_value('members', value)
        end

        def teachers
            if members
                members.select{ | m | m.education_object_type == 'Teacher' }
            else
                nil
            end
        end

        def students
            if members
                members.select{ | m | m.education_object_type == 'Student' }
            else
                nil
            end
        end

    end
end