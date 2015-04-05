  require 'selenium-webdriver'
  @driver = Selenium::WebDriver.for :firefox
  @driver.manage.timeouts.implicit_wait = 10

  # Register a user
  # Then Log out
  def registration(user,password,email)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'register').click
    @driver.find_element(id: 'user_login').send_keys "#{user}"
    @driver.find_element(id: 'user_password').send_keys "#{password}"
    @driver.find_element(id: 'user_password_confirmation').send_keys "#{password}"
    @driver.find_element(id: 'user_firstname').send_keys "#{user}_firstname"
    @driver.find_element(id: 'user_lastname').send_keys "#{user}_lastname"
    @driver.find_element(id: 'user_mail').send_keys "#{email}"
    @driver.find_element(name: 'commit').click
    puts 'registration = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Then Log out
  def login_logout(user,password)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click
    @driver.find_element(class: 'logout').click
    puts 'login_logout = passed'
  end

  # Sign in as a registered user
  # Go to the user settings and Change password
  # Then Log out
  def change_password(user,password,new_password)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'my-account').click

    @driver.find_element(xpath: ".//*[@id='content']/div[1]/a[2]").click
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(id: 'new_password').send_keys "#{new_password}"
    @driver.find_element(id: 'new_password_confirmation').send_keys "#{new_password}"
    @driver.find_element(name: 'commit').click
    puts 'change_password = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Create a Project
  # Then Log out
  def create_project(user,password,project)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'projects').click

    @driver.find_element(xpath: ".//*[@id='content']/div[1]/a[1]").click
    @driver.find_element(id: 'project_name').send_keys "#{project}"
    @driver.find_element(id: 'project_identifier').send_keys "#{project}"
    @driver.find_element(name: 'commit').click
    puts 'create_project = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add a New Member to the Project
  # Then Log out
  def add_member(user,password,project,new_member,role)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: "#{project}").click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-members').click
    @driver.find_element(xpath: ".//*[@id='tab-content-members']/p/a").click
    @driver.find_element(id: 'principal_search').send_keys "#{new_member}"
    sleep 1
    @driver.find_element(xpath: ".//*[@id='principals']/label[1]/input").click
    case "#{role}"
      when 'Manager'
        @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[1]/input").click
      when 'Developer'
        @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[2]/input").click
      else @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[3]/input").click
    end
    @driver.find_element(id: 'member-add-submit').click
    puts 'add_member = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add a New Version to the Project
  # Then Log out
  def create_project_version(user,password,project,version_name)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: "#{project}").click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-versions').click
    @driver.find_element(link_text: 'New version').click
    @driver.find_element(name: 'version[name]').send_keys "#{version_name}"
    @driver.find_element(name: 'commit').click
    puts 'create_project_version = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add all types of issues to the Project
  # Then Log out
  def add_issues(user,password,project,subject)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: "#{project}").click

    @driver.find_element(class: 'new-issue').click
    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath => ".//*[@id='issue_tracker_id']"))
    option.select_by(:text, 'Support')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys "#{subject}"
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath => ".//*[@id='issue_tracker_id']"))
    option.select_by(:text, 'Feature')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys "#{subject}"
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:xpath => ".//*[@id='issue_tracker_id']"))
    option.select_by(:text, 'Bug')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys "#{subject}"
    @driver.find_element(name: 'commit').click
    puts 'add_issues = passed'
    @driver.find_element(class: 'logout').click
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Ensure all types of issues are visible on "Issues" tab
  # Then Log out
  def confirm_issues(user,password,project)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys "#{user}"
    @driver.find_element(id: 'password').send_keys "#{password}"
    @driver.find_element(name: 'login').click

    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: "#{project}").click

    @driver.find_element(class: 'issues').click

    @driver.find_element(xpath: "/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[1]/td[3]").text == 'Bug'
    @driver.find_element(xpath: "/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[2]/td[3]").text == 'Feature'
    @driver.find_element(xpath: "/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[3]/td[3]").text == 'Support'
    puts 'confirm_issues = passed'

    @driver.find_element(class: 'logout').click
    @driver.quit
  end

  #registration(user,password,email)
  registration(1006,1006,'1006@i.ua')

  #login_logout(user,password)
  login_logout(1006,1006)

  #change_password(user,password,new_password)
  change_password(1006,1006,'ch_1006')

  #create_project(user,password,project)
  create_project(1006,'ch_1006','pr_1006')

  #add_member(user,password,project,new_member,role)
  add_member(1006,'ch_1006','pr_1006','1005','Reporter')

  #create_project_version(user,password,project,version_name)
  create_project_version(1006,'ch_1006','pr_1006','Version_006')

  #add_issues(user,password,project,subject)
  add_issues(1006,'ch_1006','pr_1006','Subject_006')

  #confirm_issues(user,password,project)
  confirm_issues(1006,'ch_1006','pr_1006')