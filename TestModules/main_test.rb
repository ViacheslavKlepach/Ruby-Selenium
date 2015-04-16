require_relative 'modules_all'
require_relative 'user'

class MainTest

  include ModulesAll

end

user = '2023'
password = '2023'
email = '2023@i.ua'
new_password = 'new_2023'
project = 'pr_2023'
subject = 'pr_2023'
new_member = '2010'
role = 'Developer'
version_name = 'Version_2023'

var = MainTest.new
var.open_browser

var.registration(user,password,email,'Your account has been activated. You can now log in.')

var.logout

var.login(user,password)

var.create_project(project,'Successful creation.')

var.add_member(project,new_member,role)

var.create_project_version(project,version_name,'Successful creation.')

var.add_issues(project,subject)

var.change_password(user,password,new_password,'Password was successfully updated.')