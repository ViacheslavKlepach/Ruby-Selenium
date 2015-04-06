  require 'selenium-webdriver'
  @driver = Selenium::WebDriver.for :firefox
  @driver.manage.timeouts.implicit_wait = 10

  # Register a user
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
    print_separator
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

  def print_separator(char='----')
    puts char*20
  end

  # Sign in as a registered user
  # Go to the user settings and Change password
  def change_password(user,password,new_password,message)
    @driver.find_element(class: 'my-account').click

    @driver.find_element(xpath: ".//*[@id='content']/div[1]/a[2]").click
    @driver.find_element(id: 'password').send_keys password
    @driver.find_element(id: 'new_password').send_keys new_password
    @driver.find_element(id: 'new_password_confirmation').send_keys new_password
    @driver.find_element(name: 'commit').click
    check_message(message)
    logout
    login(user,new_password)
    puts 'change_password = passed'
    print_separator
  end

  # Sign in as a registered user
  # Create a Project
  def create_project(project,message)
    @driver.find_element(class: 'projects').click

    @driver.find_element(xpath: ".//*[@id='content']/div[1]/a[1]").click
    @driver.find_element(id: 'project_name').send_keys project
    @driver.find_element(id: 'project_identifier').send_keys project
    @driver.find_element(name: 'commit').click
    check_message(message)
    @driver.find_element(class: 'projects').click
    @driver.find_element(link_text: project).click

      if @driver.find_element(xpath: ".//*[@id='header']/h1").text == project
        puts 'create_project = passed'
      else
        puts 'create_project = failed'
      end
    print_separator
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add a New Member to the Project
  def add_member(project,new_member,role)
    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: project).click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-members').click
    @driver.find_element(xpath: ".//*[@id='tab-content-members']/p/a").click
    @driver.find_element(id: 'principal_search').send_keys "#{new_member}_firstname"
    sleep 2
    @driver.find_element(xpath: ".//*[@id='principals']/label[1]/input").click

    case role
      when 'Manager'
        @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[1]/input").click
      when 'Developer'
        @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[2]/input").click
      else @driver.find_element(xpath: ".//*[@id='new_membership']/fieldset[2]/div/label[3]/input").click
    end
    @driver.find_element(id: 'member-add-submit').click

    if @driver.find_element(xpath: '/html/body/div[1]/div/div[1]/div[3]/div[2]/div[4]/table/tbody/tr[2]/td[1]/a').text == "#{new_member}_firstname #{new_member}_lastname"
      puts 'add_member = passed'
    else
      puts 'add_member = failed'
    end
    print_separator
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add a New Version to the Project
  # Then Log out
  def create_project_version(project,version_name,message)
    @driver.find_element(class: 'projects').click

    @driver.find_element(link_text: project).click
    @driver.find_element(class: 'settings').click
    @driver.find_element(id: 'tab-versions').click
    @driver.find_element(link_text: 'New version').click
    @driver.find_element(name: 'version[name]').send_keys version_name
    @driver.find_element(name: 'commit').click
    check_message(message)

    if @driver.find_element(xpath: '/html/body/div/div/div[1]/div[3]/div[2]/div[6]/table/tbody/tr/td[1]/a').text == version_name
      puts 'create_project_version = passed'
    else
      puts 'create_project_version = failed'
    end
    print_separator
  end

  # Sign in as a registered user
  # Go to Projects and find your Project
  # Add all types of issues to the Project
  # Then Log out
  def add_issues(project,subject)
    @driver.find_element(class: 'projects').click
    @driver.find_element(link_text: project).click

    @driver.find_element(class: 'new-issue').click
    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id => 'issue_tracker_id'))
    option.select_by(:text, 'Support')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id => 'issue_tracker_id'))
    option.select_by(:text, 'Feature')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'continue').click

    option = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id => 'issue_tracker_id'))
    option.select_by(:text, 'Bug')
    sleep 1
    @driver.find_element(id: 'issue_subject').send_keys subject
    @driver.find_element(name: 'commit').click

    @driver.find_element(class: 'issues').click

    bug = @driver.find_element(xpath: '/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[1]/td[3]').text
    feature = @driver.find_element(xpath: '/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[2]/td[3]').text
    support = @driver.find_element(xpath: '/html/body/div[1]/div/div[1]/div[3]/div[2]/form[2]/div/table/tbody/tr[3]/td[3]').text

    if (bug == 'Bug') && (feature == 'Feature') && (support == 'Support')
      puts 'add_issues = passed'
    else
      puts 'add_issues = failed'
    end
    print_separator
  end


  #registration(user,password,email,message)
  registration('2006','2006','2006@i.ua','Your account has been activated. You can now log in.')
  logout

  #login(user,password)
  login('2006','2006')

  #create_project(project,message)
  create_project('pr_2006','Successful creation.')

  #add_member(project,new_member,role)
  add_member('pr_2006','2005','Reporter')

  #create_project_version(project,version_name)
  create_project_version('pr_2006','Version_2006','Successful creation.')

  #add_issues(project,subject)
  add_issues('pr_2006','Subject_2006')

  #change_password(user,password,new_password)
  change_password('2006','2006','2006_1','Password was successfully updated.')