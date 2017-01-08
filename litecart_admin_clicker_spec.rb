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

    menu_length = @driver.find_elements(:css, '#sidebar #app-').length # Длина массива основного меню
    menu_step=1
    submenu_step=1

    while menu_step < menu_length # Цикл кликов по основному меню; сравниваем выбранный элемент с длинной меню
      @driver.find_elements(:css, '#sidebar #app-')[menu_step].click
      @wait.until { @driver.find_element(:css => 'h1') } # Перед продолжением дожидаемся появления элемента H1
      menu_step+=1
      if @driver.find_elements(:css, '#sidebar [id*=doc]').size > 0 # Проверка наличия вложенного меню
        submenu_length = @driver.find_elements(:css, '#sidebar [id*=doc]').size # Длина массива вложенного меню
        while submenu_step < submenu_length # Цикл кликов по вложенному меню; сравниваем выбранный элемент с длинной меню
          @driver.find_elements(:css, '#sidebar [id*=doc]')[submenu_step].click
          @wait.until { @driver.find_element(:css => 'h1') } # Перед продолжением дожидаемся появления элемента H1
          submenu_step+=1
        end
        submenu_step=1 # Обнуляем шаги по вложенному меню
      end
    end
  end

  after(:each) do
    @driver.quit
  end
end