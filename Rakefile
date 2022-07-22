def run_tests(platform, browser, version, junit_dir)
  system("platform=\"#{platform}\" browserName=\"#{browser}\" version=\"#{version}\" JUNIT_DIR=\"#{junit_dir}\" parallel_cucumber features -n 20")
end

task :windows_10_chrome_latest do
  run_tests('Windows 10', 'chrome', 'latest', 'junit_reports/windows_10_chrome_latest')
end

task :bigsur_chrome_latest do
  run_tests('BIGSUR', 'chrome', 'latest', 'junit_reports/bigsur_chrome_latest')
end

multitask :test_testingbot => [
    :windows_10_chrome_latest,
    :bigsur_chrome_latest,
  ] do
    puts 'Running automation'
end

