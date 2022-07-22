require "capybara/cucumber"
require "selenium/webdriver"
require "testingbot"

Capybara.default_max_wait_time = 10
Capybara.default_driver = :selenium

Before do | scenario |
  jobname = "#{scenario.name}"

  Capybara.register_driver :selenium do | app|
    capabilities = Selenium::WebDriver::Options.chrome
    capabilities.browser_version = ENV['version']
    capabilities.platform_name = ENV['platform']
    tb_options = {}
    tb_options[:name] = jobname
    tb_options['selenium-version'] = '3.14.0'
    capabilities.add_option('tb:options', tb_options)
    url = "https://#{ENV['TB_KEY']}:#{ENV['TB_SECRET']}@hub.testingbot.com/wd/hub".strip

    Capybara::Selenium::Driver.new(app,
                                   :browser => :remote, :url => url,
                                   :capabilities => capabilities)
  end

  Capybara.session_name = "#{jobname} - #{ENV['platform']} - " +
    "#{ENV['browserName']} - #{ENV['version']}"

  @driver = Capybara.current_session.driver

  @session_id = @driver.browser.session_id
  puts "TestingBotSessionId=#{@session_id} job-name=#{jobname}"
end

After do | scenario |
  @driver.quit
  api = TestingBot::Api.new(ENV['TB_KEY'], ENV['TB_SECRET'])
  if scenario.exception
    api.update_test(@session_id, { :success => false })
  else
    api.update_test(@session_id, { :success => true })
  end
  Capybara.use_default_driver
end
