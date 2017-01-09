require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart admin-menu clicker' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'clicker' do

    @driver.navigate.to 'http://localhost/litecart/admin/login.php'
    @driver.find_element(:name, 'username').send_keys'admin'
    @driver.find_element(:name, 'password').send_keys'admin'
    @driver.find_element(:name, 'login').click
    @wait.until { @driver.title == 'My Store'}

    @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'

    # Для решения задачи мы получим массив слов, потом сохраним его в сортированном виде в новый массив и сравним их
    #
    # Про упорядочивание массива:
    # Чтобы упорядочить массив, нужно вызвать метод .sort
    # Если нужно перезаписать существующий массив к методу необходимо добавить "!", т.е. получится .sort!
    #
    # Про сравнение массивов:
    # Для сравнения массивов служит метод экземпляра <=>
    # Он возвращает -1 (меньше), 0 (равно) или 1 (больше)


  end

  after(:each) do
    @driver.quit
  end
end