# EDUGraphAPI - Office 365 Education Code Sample

In this sample, we show you how to integrate with school roles/roster data as well as O365 services available via the Graph API. 

School data is kept in sync in O365 Education tenants by [Microsoft School Data Sync](http://sds.microsoft.com).  

**Table of contents**

- [Sample Goals](#sample-goals)
- [Prerequisites](#prerequisites)
- [Register the application in Azure Active Directory](#register-the-application-in-azure-active-directory)
- [Run the sample locally](#run-the-sample-locally)
- [Deploy the sample to Azure](#deploy-the-sample-to-azure)
- [Understand the code](#understand-the-code)
- [Questions and comments](#questions-and-comments)
- [Contributing](#contributing)

## Sample Goals

The sample demonstrates:

- Calling Graph APIs, including:

  - [Microsoft Azure Active Directory Graph API](https://www.nuget.org/packages/Microsoft.Azure.ActiveDirectory.GraphClient/)
  - [Microsoft Graph API](https://www.nuget.org/packages/Microsoft.Graph/)

- Linking locally-managed user accounts and Office 365 (Azure Active Directory) user accounts. 

  After linking accounts, users can use either local or Office 365 accounts to log into the sample website and use it.

- Getting schools, sections, teachers, and students from Office 365 Education:

  - [Office 365 Schools REST API reference](https://msdn.microsoft.com/office/office365/api/school-rest-operations)

The sample is implemented with Ruby on Rail.

## Prerequisites

**Deploying and running this sample requires**:

- An Azure subscription with permissions to register a new application, and deploy the web app.

- An O365 Education tenant with Microsoft School Data Sync enabled

  - One of the following browsers: Edge, Internet Explorer 9, Safari 5.0.6, Firefox 5, Chrome 13, or a later version of one of these browsers.

  Additionally: Developing/running this sample locally requires the following:  

  - The [Ruby](https://www.ruby-lang.org/en/downloads) language version 2.2.2 or newer.
  - The [RubyGems](https://rubygems.org/) packaging system, which is installed with Ruby by default. To learn more about RubyGems, please read the [RubyGems Guides](http://guides.rubygems.org/).
  - The [Rails](http://rubyonrails.org/) web application development framework, version 5.0.0 or above
  - A working installation of the [SQLite3 Database](https://www.sqlite.org/).



## Register the application in Azure Active Directory

1. Sign into the new Azure portal: [https://portal.azure.com/](https://portal.azure.com/).

2. Choose your Azure AD tenant by selecting your account in the top right corner of the page:

   ![](Images/aad-select-directory.png)

3. Click **Azure Active Directory** -> **App registrations** -> **+Add**.

   ![](Images/aad-create-app-01.png)

4. Input a **Name**, and select **Web app / API** as **Application Type**.

   Input **Sign-on URL**: http://localhost:3000/

   ![](Images/aad-create-app-02.png)

   Click **Create**.

5. Once completed, the app will show in the list.

   ![](/Images/aad-create-app-03.png)

6. Click it to view its details. 

   ![](/Images/aad-create-app-04.png)

7. Click **All settings**, if the setting window did not show.

   - Click **Properties**, then set **Multi-tenanted** to **Yes**.

     ![](/Images/aad-create-app-05.png)

     Copy aside **Application ID**, then Click **Save**.

   - Click **Required permissions**. Add the following permissions:

     | API                            | Application Permissions | Delegated Permissions                    |
     | ------------------------------ | ----------------------- | ---------------------------------------- |
     | Microsoft Graph                |                         | Read directory data<br>Access directory as the signed in user<br>Sign users in<br> Have full access to all files user can access<br> Have full access to user files<br> Read users' class assignments without grades<br> Read and write users' class assignments without grades<br> Read users' class assignments and their grades<br> Read and write users' class assignments and their grades |
     | Windows Azure Active Directory |                         | Sign in and read user profile<br>Read and write directory data |

     ![](/Images/aad-create-app-06.png)

     - **Application Permissions**

       | Permission          | Description                              |
       | ------------------- | ---------------------------------------- |
       | Read directory data | Allows the app to read data in your organization's directory, such as users, groups and apps, without a signed-in user. |

       **Delegated Permissions**

       | Permission                             | Description                              |
       | -------------------------------------- | ---------------------------------------- |
       | Read all users' full profiles          | Allows the app to read the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user. |
       | Read directory data                    | Allows the app to read data in your organization's directory, such as users, groups and apps. |
       | Access directory as the signed in user | Allows the app to have the same access to information in the directory as the signed-in user. |
       | Sign users in                          | Allows users to sign in to the app with their work or school accounts and allows the app to see basic user profile information. |
       | Sign in and read user profile          | Allows users to sign-in to the app, and allows the app to read the profile of signed-in users. It also allows the app to read basic company information of signed-in users. |
       | Read and write directory data          | Allows the app to read and write data in your organization's directory, such as users, and groups.  It does not allow the app to delete users or groups, or reset user passwords. |

   - Click **Keys**, then add a new key:

     ![](Images/aad-create-app-07.png)

     Click **Save**, then copy aside the **VALUE** of the key. 

   Close the Settings window.

## Run the sample locally

You need to have some prerequisites installed:

- The [Ruby](https://www.ruby-lang.org/en/downloads) language version 2.3 or newer.
- The [RubyGems](https://rubygems.org/) packaging system, which is installed with Ruby by default. To learn more about RubyGems, please read the [RubyGems Guides](http://guides.rubygems.org/).
- The [rails](http://rubyonrails.org/) version 5.0.0 or above.
- A working installation of the [SQLite3 Database](https://www.sqlite.org/).

Run the **EDUGraphAPI**:

1. Configure the following **Environment Variables**:

   - **ClientId**: use the Client Id of the app registration you created earlier.
   - **ClientSecret**: use the Key value of the app registration you created earlier.
   - **SourceCodeRepositoryURL**: use the URL of this repository.

   Or update these values in `config/settings.yml` directly.

2. Open terminal and navigate to the source code folder. Execute the command below:

   ```shell
   bundle install
   rails db:schema:load
   rails db:seed
   rails s
   ```

3. Open http://localhost:3000 in a browser.

## Deploy the sample to Azure

**GitHub Authorization**

1. Generate Token

   - Open https://github.com/settings/tokens in your web browser.
   - Sign into your GitHub account where you forked this repository.
   - Click **Generate Token**
   - Enter a value in the **Token description** text box
   - Select the followings (your selections should match the screenshot below):
     - repo (all) -> repo:status, repo_deployment, public_repo
     - admin:repo_hook -> read:repo_hook

   ![](Images/github-new-personal-access-token.png)

   - Click **Generate token**
   - Copy the token

2. Add the GitHub Token to Azure in the Azure Resource Explorer

   - Open https://resources.azure.com/providers/Microsoft.Web/sourcecontrols/GitHub in your web browser.
   - Log in with your Azure account.
   - Selected the correct Azure subscription.
   - Select **Read/Write** mode.
   - Click **Edit**.
   - Paste the token into the **token parameter**.

   ![](Images/update-github-token-in-azure-resource-explorer.png)

   - Click **PUT**

**Deploy the Azure Components from GitHub**

1. Check to ensure that the build is passing VSTS Build.

2. Fork this repository to your GitHub account.

3. Click the Deploy to Azure Button:

   [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FOfficeDev%2FO365-EDU-Ruby-Samples%2Fmaster%2Fazuredeploy.json)

4. Fill in the values in the deployment page:

   ![](Images/azure-auto-deploy-01.png)

   > Note: This ARM Template will create a [Web App on Linux](https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-intro) which  is currently only available in the following regions:
   >
   > - West US
   > - West Europe
   > - Southeast Asia

   - **Resource group**: we suggest you create a new group.
   - **Location**: please do choose one of the region above.

   ![](Images/azure-auto-deploy-02.png)

   * **Site Name**: please input a name. Like EDUGraphAPICanviz or EDUGraphAPI993.

      > Note: If the name you input is taken, you will get some validation errors:
      >
      > ![](Images/azure-auto-deploy-validation-errors-01.png)
      >
      > Click it you will get more details like storage account is already in other resource group/subscription.
      >
      > In this case, please use another name.

   - **Hosting Plan Name**: the built-in Ruby 2.3 Docker image does not work well with the Kudu currently. Please use our customized image:  **tylerlu/ruby:2.3-0**.  Its source code is in the [Docker-ruby2.3-0](/Docker-ruby2.3-0) folder.
   - **Source Code Repository URL**: replace <YOUR REPOSITORY> with the repository name of your fork.
   - **Source Code Manual Integration**: choose **false**, since you are deploying from your own fork.
   - **Client Id**: use the Client Id of the app registration you created earlier.
   - **Client Secret**: use the Key value of the app registration you created earlier.

   ![](Images/azure-auto-deploy-03.png)

   - Check **I agree to the terms and conditions stated above**.

5. Click **Purchase**.

**Add REPLY URL to the app registration**

1. After the deployment, open the resource group:

   ![](Images/azure-resource-group.png)

2. Click the web app.

   ![](Images/azure-web-app.png)

   Copy the URL aside, change the schema to **https**, and add a trailing slash. This is the replay URL and will be used in next step.

3. Navigate to the app registration in the new Azure portal, then open the setting windows.

   Add the reply URL:

   ![](Images/aad-add-reply-url.png)

   > Note: to debug the sample locally, make sure that http://localhost:3000/ is in the reply URLs.

4. Click **SAVE**.

## Understand the code

### Introduction

**Solution Component Diagram**

![](Images/solution-component-diagram.png)

**Authentication Mechanisms**

[OmniAuth OAuth2](https://github.com/intridea/omniauth-oauth2) and a custom Azure OAuth2 strategy `lib/omniauth/azure_oauth2.rb` are used to enable O365 users login.

**Data Access**

[Active Record](http://guides.rubyonrails.org/active_record_basics.html) is used to access data from the database. 

The models are in the **app/models** folders, and the database schema is in the **db** folder.

Below are the main tables used in this sample:

| Table                          | Description                              |
| ------------------------------ | ---------------------------------------- |
| users                          | Contains the user's information: name, email, hashed password...<br>*o365_user_id* and *o365_email* are used to connect the local user with an O365 user. |
| user_roles                     | Contains users' role. Three roles are used in this sample: admin, teacher, and student. |
| organizations                  | A row in this table represents a tenant in AAD.<br>*IsAdminConsented* column records than if the tenant consented by an administrator. |
| token_caches                   | Contains the users' access/refresh tokens. |
| classroom_seating_arrangements | Contains the classroom seating arrangements. |

You may change the database settings in the **/config/database.yml** file. SQLite is used for the development environment.

**Libs**

In the **lib** folder, there are 2 libs.

| Lib       | Description                              |
| --------- | ---------------------------------------- |
| education | Contains EducationService and several model classes. They encapsulate education REST APIs. |
| omniauth  | Contains AzureOauth2 class which implemented Azure OAuth2 strategy for OmniAuth |

**Controllers**

In the **app/controllers** folder, there are 6 controllers:

| Controller            | Description                              |
| --------------------- | ---------------------------------------- |
| ApplicationController | The base controller of the other controllers. |
| AccountController     | Contains actions for user to register, login and logout. |
| LinkController        | Contains actions used for users to link accounts. |
| ManageController      | Contains the about me action.            |
| AdminController       | Contains administrative actions like consent tenant, manage linked accounts. |
| SchoolsController     | Contains actions used to show schools data. |
| ClassesController     | Contains actions used to show classes data. |

**Services**

Service classes are in the **app/services** folder. Below are the main services used in the sample:

| Service             | Description                              |
| ------------------- | ---------------------------------------- |
| MSGraphService      | Contains methods used to access MS Graph APIs |
| AADGraphService     | Contains methods used to access AAD Graph APIs |
| TokenCacheService   | Contains method used to get and update cache from the database |
| UserService         | Contains method used to manipulate users in the database |
| OrganizationService | Contains methods that operate organizations in the database |
| LinkService         | Contains methods used to link user accounts |

**Action filters**

In the ApplicationController, several action filters were created and used by itself and other controllers.

| Name                       | Type          | Description                              |
| -------------------------- | ------------- | ---------------------------------------- |
| require_login              | before_action | Redirects user to login page if the user is not logged in. |
| admin_only                 | before_action | Only allow admin users to access the protected actions. |
| linked_users_only          | before_action | Only allow linked users to access the protected actions. |
| handle_refresh_token_error | around_action | Rescue RefreshTokenError raised by TokenService when refresh token is missing or expired. It will redirect the user to page which explains the reason and instructs the user to re-login. |

**Multi-tenant app**

This web application is a **multi-tenant app**. In the AAD, we enabled the option:

![](Images/app-is-multi-tenant.png)

Users from any Azure Active Directory tenant can access this app. Some permissions used by this app require an administrator of the tenant to consent before users can use the app. Otherwise, users will see this error:

![](Images/app-requires-admin-to-consent.png)

For more information, see [Build a multi-tenant SaaS web application using Azure AD & OpenID Connect](https://azure.microsoft.com/en-us/resources/samples/active-directory-dotnet-webapp-multitenant-openidconnect/).

### Office 365 Education API

The [Office 365 Education APIs](https://msdn.microsoft.com/office/office365/api/school-rest-operations) return data from any Office 365 tenant which has been synced to the cloud by Microsoft School Data Sync. The APIs provide information about schools, sections, teachers, students, and rosters. The Schools REST API provides access to school entities in Office 365 for Education tenants.

In this sample, the **lib/education** lib encapsulates the Office 365 Education API. 

The **EducationService** is the core class of the library. It is used to easily get education data.

**Get schools**

~~~typescript
def get_all_schools
  get_objects(Education::School, 'education/schools')
end
~~~

~~~typescript
def get_school(id)
  get_object(Education::School, "education/schools/#{id}")
end
~~~

**Get classes**

~~~typescript
def get_classes(school_id, skip_token = nil, top = 12)
  get_paged_objects(Education::Class, "education/schools/#{school_id}/classes", {
        '$top': top,
        '$skiptoken': skip_token,
        '$expand': 'members'
      })
end
~~~

```typescript
def get_class(class_id)
   get_object(Education::Class, "education/classes/#{class_id}")
end
```
**Manage assignment**

```
def create_assignment(class_id, assignment_obj)
   request('post', "education/classes/#{class_id}/assignments", {}, assignment_obj.to_json)
end
```

```
def publish_assignment(class_id, assignment_id)
  request('post', "education/classes/#{class_id}/assignments/#{assignment_id}/publish", {}, nil)
end
```

```
 def add_assignment_resources(class_id, assignment_id,file_name, file_type,resource_url)
      data = {"resource":{"displayName":file_name, "@odata.type":file_type, "file":{"odataid":"#{@base_url}/#{resource_url}"}} }
      request('post', "education/classes/#{class_id}/assignments/#{assignment_id}/resources", {}, data.to_json)
 end
```

```
 def get_assignment_resources(class_id, assignment_id)
      get_objects(Education::EducationAssignmentResource, "education/classes/#{class_id}/assignments/#{assignment_id}/resources")
 end
```

Below are some screenshots of the sample app that show the education data.

![](Images/edu-schools.png)

![](Images/edu-class.png)

### Authentication Flows

There are 4 authentication flows in this project.

The first 2 flows (Local login_o365 Login) enable users to login in with either a local account or an Office 365 account, then link to the other type account. This procedure is implemented in the LinkController.

**Local Login Authentication Flow**

![](Images/auth-flow-local-login.png)

**O365 Login Authentication Flow**

![](Images/auth-flow-o365-login.png)

**Admin Login Authentication Flow**

This flow shows how an administrator logs into the system and performs administrative operations.

After logging into the app with an Office 365 account, the administrator will be asked to link to a local account. This step is not required and can be skipped. 

As mentioned earlier, the web app is a multi-tenant app which uses some application permissions, so tenant administrator must consent the app first.  

This flow is implemented in the AdminController. 

![](Images/auth-flow-admin-login.png)

### Two Kinds of Graph APIs

There are two distinct Graph APIs used in this sample:

|              | [Azure AD Graph API](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-graph-api) | [Microsoft Graph API](https://graph.microsoft.io/) |
| ------------ | ---------------------------------------- | ---------------------------------------- |
| Description  | The Azure Active Directory Graph API provides programmatic access to Azure Active Directory through REST API endpoints. Apps can use the Azure AD Graph API to perform create, read, update, and delete (CRUD) operations on directory data and directory objects, such as users, groups, and organizational contacts | A unified API that also includes APIs from other Microsoft services like Outlook, OneDrive, OneNote, Planner, and Office Graph, all accessed through a single endpoint with a single access token. |
| Client       | Install-Package [Microsoft.Azure.ActiveDirectory.GraphClient](https://www.nuget.org/packages/Microsoft.Azure.ActiveDirectory.GraphClient/) | Install-Package [Microsoft.Graph](https://www.nuget.org/packages/Microsoft.Graph/) |
| End Point    | https://graph.windows.net                | https://graph.microsoft.com              |
| API Explorer | https://graphexplorer.cloudapp.net/      | https://graph.microsoft.io/graph-explorer |

> **IMPORTANT NOTE:** Microsoft is investing heavily in the new Microsoft Graph API, and they are not investing in the Azure AD Graph API anymore (except fixing security issues).

> Therefore, please use the new Microsoft Graph API as much as possible and minimize how much you use the Azure AD Graph API.

Below is a piece of code shows how to get user photo from the Microsoft Graph API.

```typescript
def get_user_photo(o365_user_id)
  url = @base_url + "/users/#{o365_user_id}/photo/$value"
  HTTParty.get(url, headers: {
     "Authorization" => "Bearer #{@access_token}"
  })
end
```

Note that in the AAD Application settings, permissions for each Graph API are configured separately:

![](Images/aad-create-app-06.png) 

## Questions and comments

- If you have any trouble running this sample, please [log an issue](https://github.com/OfficeDev/O365-EDU-Ruby-Samples/issues).
- Questions about GraphAPI development in general should be posted to [Stack Overflow](http://stackoverflow.com/questions/tagged/office-addins). Make sure that your questions or comments are tagged with [ms-graph-api]. 

## Contributing

We encourage you to contribute to our samples. For guidelines on how to proceed, see [our contribution guide](/Contributing.md).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

 

**Copyright (c) 2017 Microsoft. All rights reserved.**