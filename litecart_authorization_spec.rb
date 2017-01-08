require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart authorization' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'authorization' do
    @driver.navigate.to 'http://localhost/litecart/admin/login.php'
    @driver.find_element(:name, 'username').send_keys'admin'
    @driver.find_element(:name, 'password').send_keys'admin'
    @driver.find_element(:name, 'login').click
    @wait.until { @driver.title == 'My Store'}
  end


  after(:each) do
    @driver.quit
  end
end