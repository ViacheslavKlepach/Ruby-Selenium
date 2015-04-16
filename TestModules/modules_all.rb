require 'selenium-webdriver'
module ModulesAll


  def open_browser
    @driver = Selenium::WebDriver.for :firefox
    @driver.manage.timeouts.implicit_wait = 10
  end

  # open_browser

  def registration(user,password,email,message)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'register').click
    @driver.find_element(id: 'user_login').send_keys user
    @driver.find_element(id: 'user_password').send_keys password
    @driver.find_element(id: 'user_password_confirmation').send_keys password
    @driver.find_element(id: 'user_firstname').send_keys "#{user}_firstname"
    @driver.find_element(id: 'user_lastname').send_keys "#{user}_lastname"
    @driver.find_element(id: 'user_mail').send_keys email
    @driver.find_element(name: 'commit').click
    check_message(message)
    if @driver.find_element(xpath: ".//*[@id='loggedas']/a").text == user.to_s
      puts 'registration = passed'
    else
      puts 'registration = failed'
    end
  end

  # Sign in as a registered user
  def login(user,password)
    @driver.get 'http://demo.redmine.org/'
    @driver.find_element(class: 'login').click
    @driver.find_element(id: 'username').send_keys user
    @driver.find_element(id: 'password').send_keys password
    @driver.find_element(name: 'login').click
    if @driver.find_element(xpath: ".//*[@id='loggedas']/a").text == user.to_s
      puts 'login = passed'
    else
      puts 'login = failed'
    end
  end

  # Log out
  def logout
    @driver.find_element(class: 'logout').click
    if @driver.find_element(class: 'login').text == 'Sign in'
      puts 'logout = passed'
    else
      puts 'logout = failed'
    end
  end

  def check_message(message)
    if @driver.find_element(id: 'flash_notice').text == message
      puts 'Message is correct.'
    else
      puts 'Message is wrong.'
    end
  end

  # Go to the user settings and Change password
  def change_password(user,password,new_password,message)
    @driver.find_element(class: 'my-account').click

    @driver.find_element(css: '.icon.icon-passwd').click
    @driver.find_element(id: 'password').send_keys password
    @driver.find_element(id: 'new_password').send_keys new_password
    @driver.find_element(id: 'new_password_confirmation').send_keys new_password
    @driver.find_element(name: 'commit').click
    check_message(message)
    logout
    login(user,new_password)
    puts 'change_password = passed'
  end

  # Create a Project
  def create_project(project,message)
    @driver.find_element(class: 'projects').click

    @driver.find_element(css: '.icon.icon-add').click
    @driver.find_element(id: 'project_name').send_keys project
    @driver.find_element(id: 'project_identifier').send_keys project
    @driver.find_element(name: 'commit').click
    check_message(message)
    @driver.find_element(class: 'projects').click
    @driver.find_element(link_text: project).click

    if @driver.find_element(css: '#header>h1').text == project
      puts 'create_project = passed'
    else
      puts 'create_project = failed'
    end
  end

  # Go to Projects and find your Project
  # Add a New Member to the Project
  def add_member(project,new_member,role)
    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: project).click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-members').click
    @driver.find_element(css: '.icon.icon-add').click
    @driver.find_element(id: 'principal_search').send_keys "#{new_member}_firstname"
    sleep 2
    @driver.find_element(xpath: ".//*[@id='principals']/label[1]/input").click

    case role
      when 'Manager'
        @driver.find_element(css: ".roles-selection input[value='3']").click
      when 'Developer'
        @driver.find_element(css: ".roles-selection input[value='4']").click
      else @driver.find_element(css: ".roles-selection input[value='5']").click
    end
    @driver.find_element(id: 'member-add-submit').click
    sleep 1
    if @driver.find_element(id: 'tab-content-members').text.include? "#{new_member}_firstname #{new_member}_lastname"
      puts 'add_member = passed'
    else
      puts 'add_member = failed'
    end
  end

  # Go to Projects and find your Project
  # Add a New Version to the Project
  def create_project_version(project,version_name,message)
    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: project).click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-versions').click
    @driver.find_element(link_text: 'New version').click
    @driver.find_element(name: 'version[name]').send_keys version_name
    @driver.find_element(name: 'commit').click
    check_message(message)

    if @driver.find_element(css: '.list.versions').text.include? version_name
      puts 'create_project_version = passed'
    else
      puts 'create_project_version = failed'
    end
  end

  # Go to Projects and find your Project
  # Add all types of issues to the Project
  def add_issues(project,subject)
    @driver.find_element(class: 'projects').click
    @driver.find_element(link_text: project).click

    @driver.find_element(class: 'new-issue').click
    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(id: 'issue_tracker_id'))
    option.select_by(:text, 'Support')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(id: 'issue_tracker_id'))
    option.select_by(:text, 'Feature')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(id: 'issue_tracker_id'))
    option.select_by(:text, 'Bug')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'commit').click

    @driver.find_element(class: 'issues').click

    if @driver.find_element(class: 'autoscroll').text.include? 'Bug' && 'Feature' && 'Support'
      puts 'add_member = passed'
    else
      puts 'add_member = failed'
    end
  end
end