require "capybara/cucumber"
require "selenium/webdriver"

Capybara.default_max_wait_time = 10
Capybara.default_driver = :selenium

Before do | scenario |
  jobname = "#{scenario.feature.name} - #{scenario.name}"

  Capybara.register_driver :selenium do | app|
    capabilities = {
      :version => ENV['version'],
      :browserName => ENV['browserName'],
      :platform => ENV['platform'],
      :name => jobname
    }
    url = "https://#{ENV['TB_KEY']}:#{ENV['TB_SECRET']}@hub.testingbot.com/wd/hub".strip

    Capybara::Selenium::Driver.new(app,
                                   :browser => :remote, :url => url,
                                   :desired_capabilities => capabilities)
  end

  # Capybara.current_driver = :remote
  Capybara.session_name = "#{jobname} - #{ENV['platform']} - " +
    "#{ENV['browserName']} - #{ENV['version']}"

  @driver = Capybara.current_session.driver

  @session_id = @driver.browser.session_id
  puts "TestingBotSessionId=#{@session_id} job-name=#{jobname}"
end

After do | scenario |
  @driver.quit
  Capybara.use_default_driver
end
