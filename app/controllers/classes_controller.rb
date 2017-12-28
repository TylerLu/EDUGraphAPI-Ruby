# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  
#

class ClassesController < ApplicationController

  before_action :require_login
  before_action :linked_users_only

  def index
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

    @school = education_service.get_school(params[:school_id])
    @my_classes = education_service.get_my_classes(@school.id)
    @classes = education_service.get_classes(@school.id, 12)
    
    @classes.value.each do |c| 
      c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.id == c.id}
    end
  end

  def more
    school_id = params[:school_id]
    skip_token = params[:skip_token]

    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    
    @my_classes = education_service.get_my_classes(school_id)  
    @classes = education_service.get_classes(school_id, 12, skip_token)
    @classes.value.each do |c| 
      c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.id == c.id}
    end

    render json: {
      skip_token: @classes.next_link ? @classes.next_link.skip_token: nil,
      values: @classes.value.map do |c|
        {
          is_my: c.custom_data[:is_my],
          id: c.id,
          display_name: c.display_name,
          code: c.code,
          teachers: c.teachers.map{ |t| { display_name: t.display_name } },
          description: c.description,
          term_name: c.term.display_name,
          term_start_time: c.term.start_date.getlocal.strftime('%B %-d %Y'),
          term_end_time: c.term.end_date.getlocal.strftime('%B %-d %Y')
        }
      end
    }
  end

  def show
    
    #aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    ms_graph_servcie = MSGraphService.new(ms_access_token)

    class_object_id = params[:id];
    @school = education_service.get_school(params[:school_id])
    @class = education_service.get_class(class_object_id)
    @class.members = education_service.get_class_members(class_object_id)

    @conversations = ms_graph_servcie.get_conversations(class_object_id)
    @documents = ms_graph_servcie.get_documents(class_object_id)
    @documents_web_url = ms_graph_servcie.get_documents_web_url(class_object_id)
    user_service = UserService.new    
    seating_position_hash = user_service.get_seating_position_hash(class_object_id)
    favorite_color_hash = user_service.get_favorite_color_hash(@class.members.map{ |m| m.id })

    @class.members.each do |m|
      m.custom_data[:position] = seating_position_hash[m.id]
      m.custom_data[:favorite_color] = favorite_color_hash[m.id]
    end

    school_teachers = education_service.get_teachers(@school.number);
    @schoolTeachers = school_teachers.select do |teacher|
      @class.teachers.select{|classteacher| classteacher.id == teacher.id}.length == 0
    end

    @teacher_favorite_color = current_user.favorite_color ? current_user.favorite_color : "#2F19FF"

    @assignments = education_service.get_assignments_by_class_id(class_object_id)
  end
  def add_coteacher
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    result = education_service.add_user_to_class_as_member(params[:id], params[:user_id])
    education_service.add_user_to_class_as_owner(params[:id], params[:user_id])
    render json: {status: 'success'}
  end

  def new_assignment_submission_resource
    if params[:newResource] and params[:newResource].length > 0
      ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
      education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
      ids = self.get_ids_from_resource_folder(params[:submissionResourcesFolderUrl]);
      params[:newResource].each do |fileupload|
        driveItem = Education::DriveItem.new(education_service.upload_File(ids, URI.encode(fileupload.original_filename),fileupload.read))
        education_service.add_submission_resource(
          params[:classId], 
          params[:assignmentId], 
          params[:submissionId],
          driveItem.name, 
          self.get_file_type(driveItem.name),
          "drives/#{driveItem.parent_reference.drive_id}/items/#{driveItem.id}")
      end
    end
    redirect_to :back
  end
  
  def update_assignment
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    if params[:assignmentOriginalStatus] == "draft" and params[:assignmentStatus] == "assigned"
      education_service.publish_assignment(params[:classId], params[:assignmentId])
    end

    if params[:newResource] and params[:newResource].length > 0
       resourceFolder = education_service.get_assignment_resource_folder_URL(params[:classId], params[:assignmentId])
       ids = self.get_ids_from_resource_folder(resourceFolder.resource_folder_URL);
       params[:newResource].each do |fileupload|
         driveItem = Education::DriveItem.new(education_service.upload_File(ids, URI.encode(fileupload.original_filename),fileupload.read))
         education_service.add_assignment_resources(
          params[:classId], 
          params[:assignmentId], 
          driveItem.name, 
          self.get_file_type(driveItem.name),
          "drives/#{driveItem.parent_reference.drive_id}/items/#{driveItem.id}")
       end
    end
    #redirect_to "/schools/#{params[:schoolId]}/classes/#{params[:classId]}"
    redirect_to :back
  end

  def new_assignment
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

    dateArray = (params[:duedate]).split("/");
    dueDateTime = ("#{dateArray[2]}-#{dateArray[0]}-#{dateArray[1]} #{params[:duetime]}").to_time.getutc.strftime("%Y-%m-%dT%H:%M:%SZ")
    assignment = {
                  "displayName":params[:name],
                  "dueDateTime":dueDateTime,
                  "allowStudentsToAddResourcesToSubmission":true,
                  "status":"draft",
                  "assignTo":{"@odata.type":"#microsoft.graph.educationAssignmentClassRecipient"}
                }
    assignment = Education::Assignment.new(education_service.create_assignment(params[:classId], assignment))
    if params[:status] == "assigned"
      education_service.publish_assignment(params[:classId], assignment.id)
    end

    resourceFolder = education_service.get_assignment_resource_folder_URL(params[:classId], assignment.id)
    ids = self.get_ids_from_resource_folder(resourceFolder.resource_folder_URL);
 
    if  params[:fileUpload] and params[:fileUpload].length > 0
       params[:fileUpload].each do |fileupload|
        driveItem = Education::DriveItem.new(education_service.upload_File(ids, URI.encode(fileupload.original_filename),fileupload.read))
        education_service.add_assignment_resources(
          params[:classId], 
          assignment.id, 
          driveItem.name, 
          self.get_file_type(driveItem.name),
          "drives/#{driveItem.parent_reference.drive_id}/items/#{driveItem.id}")
       end
    end
    #redirect_to "/schools/#{params[:schoolId]}/classes/#{params[:classId]}"
    redirect_to :back
  end

  def get_assignment_submissions
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    ms_graph_servcie = MSGraphService.new(ms_access_token)

    retArray = Array.new;
    submissions = education_service.get_assignment_submissions(params[:classId], params[:assignmentId])
    submissions.each do |submission|
      if submission.submitted_By.user && submission.submitted_By.user.id
        displayname = ms_graph_servcie.get_user_name(submission.submitted_By.user.id)
        retArray.push({SubmittedBy: {User:{DisplayName:displayname}}, 
                        SubmittedDateTime: (submission.submitted_dateTime and submission.submitted_dateTime.length > 0) ? DateTime.parse(submission.submitted_dateTime).getlocal.strftime('%m/%d/%Y') : "",
                        Resources:submission.resources.map{|resource| { Resource: { DisplayName: resource.resource.display_name }}}})
      end
    end
    render json: retArray
  end

  def get_assignment_resources
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

    resources = education_service.get_assignment_resources(params[:classId], params[:assignmentId])
    retArray = Array.new;

    resources.each do |resource|
      retArray.push({ Id:resource.id, Resource: { DisplayName: resource.resource.display_name } })
    end
    render json: retArray

  end

  def get_assignment_resources_submission
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

    resources = education_service.get_assignment_resources(params[:classId], params[:assignmentId])
    submissions = education_service.get_assignment_submission_by_user(params[:classId], params[:assignmentId], current_user.o365_user_id)

    if submissions and submissions.length > 0
      render json: {resources: resources.map{|resource| { Id:resource.id, Resource: { DisplayName: resource.resource.display_name }}},
                    submission:{Id:submissions[0].id, ResourcesFolderUrl:submissions[0].resources_folder_Url , Resources: submissions[0].resources.map { |res| { Id:res.id, Resource: { DisplayName: res.resource.display_name } }}}}
    else
      render json: {resources: resources.map{|resource| { Id:resource.id, Resource: { DisplayName: resource.resource.display_name }}},
                    submission:nil}
    end
  end
 
  def get_ids_from_resource_folder(resource_folder)
    array = resource_folder.split("/")
    result = Array.new
    if array.length >=3
      result.push(array[array.length - 3])
      result.push(array[array.length - 1])
    end
  end

  def get_file_type(file_name)
    if file_name.downcase.end_with?(".docx")
      "#microsoft.graph.educationWordResource"
    elsif file_name.downcase.end_with?(".xlsx")
      "#microsoft.graph.educationExcelResource"
    else
      "#microsoft.graph.educationFileResource"
    end
  end

  def save_seating_positions
    user_service = UserService.new
    user_service.save_seating_positions(params[:id], params['_json'])
    render json: {status: 'success'}
  end

  class << self
    attr_accessor :current_user_course_ids
  end
end