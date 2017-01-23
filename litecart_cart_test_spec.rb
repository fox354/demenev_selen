require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart cart test' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  # Для некоторого упрощения при первом заходе в litecart мы получаем пулл сыллок на товары из списка Latest Products.
  # Такой ход позволит нам избежать цикла который при переходе на главную страницу каждый раз собирал массив ссылок и выбирал из него с номером +1.
  # Я позволил себе это упрощение, так как данный ход никак не был связан с темой лекции и позволил сосредоточиться на самой задаче.
  # Также не было понятно, нужно ли авторизоваться в системе, но так как это упрощало процесс отладки, было решено добавить тестового пользователя и необязателный блок авторизации(закомментирован).

  it 'litecart_cart_test' do

    # Работаем с кнопкой span на карточке продукта, до тех пор пока он есть
    def span_detector()
      if @driver.find_elements(:css, '[name="options[Size]"] option').size != 0
        @driver.find_elements(:css, '[name="options[Size]"] option')[1].click # По скольку 0 элемент - текст "select"
      end
    end

    # Работаем с кнопкой Remove на Cart, до тех пор пока она есть
    def remove_detector()
      table_range = @driver.find_elements(:css, '#box-checkout-summary td.item').size # Фиксируем количество строк с товарами в таблице
      if @driver.find_elements(:name, 'remove_cart_item').size != 0
        @driver.find_element(:name, 'remove_cart_item').click
        @wait.until { @driver.find_elements(:css, '#box-checkout-summary td.item').size != table_range } # Дожидаемся изменения количества строк с товарами в таблице
      end
    end

    # Открываем страницу магазина
    @driver.navigate.to 'http://localhost/litecart/en/'

    # # входим
    # @driver.find_element(:name, 'email').send_keys('test@mail.ru')
    # @driver.find_element(:name, 'password').send_keys('12345')
    # @driver.find_element(:name, 'login').click
    # @wait.until { @driver.find_element(:css, '#box-account a[href*="logout"]')} # Проверка успешной авторизации

    # получаем пулл ссылок на продукты
    products_fotm = @driver.find_elements(:css, '#box-latest-products a.link') # ограничиваемся формой Latest Products
    products_link = [] # готовим массив для пулла ссылок
    stp_product=0
    for stp_product in stp_product...products_fotm.size
      products_link[stp_product] = products_fotm[stp_product].attribute('href') # сохраняем ссылку в пулл
    end

    # Переход на страницу продукта
    stp_link = 0
    for stp_link in 0..2
      @driver.navigate.to products_link[stp_link]
      cart_count = @driver.find_element(:css, '#cart .quantity').attribute('innerText') # Фиксируем количество товаров в корзине
      span_detector()
      @driver.find_element(:name, 'add_cart_product').click
      @wait.until { @driver.find_element(:css, '#cart .quantity').attribute('innerText') != cart_count } # Дожидаемся изменения количества товаров в корзине
    end

    # переходим в корзину
    @driver.find_element(:css, '#cart .link').click

    cart_range = @driver.find_elements(:css, '.shortcuts li') # Определяем количество товаров в корзине

    # поочереди удаляем товары
    stp_cart = 0
    for stp_cart in stp_cart...cart_range.size
      remove_detector
    end

    puts 'Ducks ended'
  end

  after(:each) do
    @driver.quit
  end
end