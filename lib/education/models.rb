




        # TODO
    #  @property
    #  def photo(self):
    #      photo = '/Photo/UserPhoto/%s' % self.object_id
    #      return photo




# class EduUser(GraphObjectBase):
#     def __init__(self, prop_dict={}):
#         super(EduUser, self).__init__(prop_dict)
    


# class Document(GraphObjectBase):
#     def __init__(self, prop_dict={}):
#         super(Document, self).__init__(prop_dict)

#     @property
#     def web_url(self):
#         return self.get_value('webUrl')
    
#     @property
#     def name(self):
#         return self.get_value('name')
    
#     @property
#     def last_modified_date_time(self):
#         return self.get_value('lastModifiedDateTime')

#     @property
#     def last_modified_user_name(self):
#         last_modified_user_name = ''
#         last_modified_by = self.get_value('lastModifiedBy')
#         if last_modified_by:
#             last_modified_user_name = last_modified_by['user']['displayName']
#         return last_modified_user_name

# class Conversation(GraphObjectBase):
#     def __init__(self, prop_dict={}):
#         super(Conversation, self).__init__(prop_dict)

#     @property
#     def id(self):
#         return self.get_value('id')

#     @property
#     def mail(self):
#         return self.get_value('mail')

#     @property
#     def topic(self):
#         return self.get_value('topic')
