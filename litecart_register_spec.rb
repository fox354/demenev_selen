require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart register' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'register' do
    # Находим поля ввода и вводим туда соответствующий пареметр из массива.
    # PS: Явно что-то перемудрил с массивами, но тут вообще надо менять концепцию и брать параметры авторизации извне, например из yaml. К сожалению сейчас разбираться в красивостях нет времени =(
    # Вход: Авторизация идет влоб, ибо так проще.
    # Выход: litecart_logout() - функция ищет ссылку выхода, но одну из двух, ибо так проще.

    def litecart_logout()
      @wait.until { @driver.find_element(:css, '#box-account a[href*="logout"]')} # ждем пока повится ссылка выхода
      @driver.find_element(:css, '#box-account a[href*="logout"]').click
      if @wait.until { @driver.find_element(:name, 'login')}
        puts 'Logout: Ok'
      else
        puts 'Logout: Fail'
        Raise
      end
    end

    mask = Time.now.to_i # добавим щипотку уникальности

    # фигачим кучу переменных
    firstname = 'F' + mask.to_s
    lastname = 'L' + mask.to_s
    address1 = 'Adr' + mask.to_s
    postcode = '000000'
    city = 'Test'
    email =  mask.to_s + '@mail.ru'
    phone = '+7' + mask.to_s
    password = 'Password'
    confirmed_password = password

    # из-за того что все в одной каше и языком владею только 2 недели, массивов два: 1 - название параметра, 2 - соответсвующие значения
    param_name = ['firstname', 'lastname', 'address1', 'postcode', 'city', 'email', 'phone', 'password', 'confirmed_password']
    param_value = [firstname, lastname, address1, postcode, city, email, phone, password, confirmed_password]

    # регистрируемся
    @driver.navigate.to 'http://localhost/litecart/en/create_account'
    @wait.until { @driver.find_element(:name, 'create_account')} # Ждем пока появится кнопка Creat
    stp = 0
    for stp in stp...param_name.size
      @driver.find_element(:name, param_name[stp]).click
      @driver.find_element(:name, param_name[stp]).send_keys(param_value[stp])
    end
    @driver.find_element(:name, 'create_account').click
    if @wait.until { @driver.find_element(:css, '#box-account a[href*="logout"]')}
      puts 'Register: Ok'
    else
      puts 'Register: Fail'
      Raise
    end

    # Выводим в консоль сгенерированный меил, если захочется авторизоваться вручную
    puts 'User email: ' + email

    # выходим
    litecart_logout()

    # входим
    @driver.find_element(:name, 'email').click
    @driver.find_element(:name, 'email').send_keys(email)
    @driver.find_element(:name, 'password').click
    @driver.find_element(:name, 'password').send_keys(password)
    @driver.find_element(:name, 'login').click
    if @wait.until { @driver.find_element(:css, '#box-account a[href*="logout"]')}
      puts 'Login: Ok'
    else
      puts 'Login: Fail'
      Raise
    end

    # выходим
    litecart_logout()
  end

  after(:each) do
    @driver.quit
  end
end