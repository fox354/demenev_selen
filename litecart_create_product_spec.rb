require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart create product' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'create product' do

    def cart_tab_analysis(tabs, name)
      pull_list = ['General', 'Information', 'Prices']
      stp =0
      for stp in stp...tabs.size
        if pull_list.include?(tabs[stp].attribute('innerText'))
          if tabs[stp].attribute('innerText') ==  pull_list[0]
            cart_general(name)
          elsif tabs[stp].attribute('innerText') ==  pull_list[1]
            cart_information()
          elsif tabs[stp].attribute('innerText') ==  pull_list[2]
            cart_prices()
          end
        end
      end
    end

    def cart_general(name)
      puts "General: Start"

      @driver.find_element(:css, '[href="#tab-general"]').click # Переключаемся на вкладку (На случай если эту вкладку надо будет вызвать еще раз).
      fotm_general = @driver.find_element(:id, 'tab-general') # ограничиваемся содержимым вкладки General

      fotm_general.find_elements(:css, 'input[type=radio]')[0].click # Ставим статус Enabled

      fotm_general.find_element(:css, '.input-wrapper > input').send_keys(name) # Пишем CODE статус

      fotm_general.find_element(:css, '[data-name="Root"]').click # снимаем корневую категорию
      fotm_general.find_element(:css, '[data-name="Rubber Ducks"]').click # ставим нужную категорию

      fotm_general.find_element(:name, 'quantity').clear() # Очищаем поле с ценой
      fotm_general.find_element(:name, 'quantity').send_keys('30') # Вводим стоимость в поле с ценой

      fotm_general.find_element(:name, 'new_images[]').send_keys('d:\Users\Snull\Pictures\wQi5wsW2M4Y.jpg') # Вставляем картинку

      fotm_general.find_element(:name, 'date_valid_from').send_keys(:home, '10102017') # Дата начала размещения
      fotm_general.find_element(:name, 'date_valid_to').send_keys(:home, '10102020')  # Дата окончания размещения

      puts "General: Ok!"
    end

    def cart_information()
      puts "Information: Start"

      @driver.find_element(:css, '[href="#tab-information"]').click # Переключаемся на вкладку
      fotm_information = @driver.find_element(:id, 'tab-information') # ограничиваемся содержимым вкладки Information

      span_manufacturer = fotm_information.find_elements(:css, '[name="manufacturer_id"] > option') # Собираем массив из значений span Manufacturer
      span_manufacturer[1].click # Выбираем первый "живой" элемент массива

      fotm_information.find_element(:name, 'short_description[en]').send_keys('TEST')

      fotm_information.find_element(:class, 'trumbowyg-editor').send_keys('TEST')

      puts "Information: Ok!"

    end

    def cart_prices()
      puts "Prices: Start"

      @driver.find_element(:css, '[href="#tab-prices"]').click # Переключаемся на вкладку
      fotm_prices = @driver.find_element(:id, 'tab-prices') # ограничиваемся содержимым вкладки Information

      fotm_prices.find_element(:name, 'purchase_price').clear() # Очищаем поле с ценой
      fotm_prices.find_element(:name, 'purchase_price').send_keys('10') # Вводим стоимость в поле с ценой

      fotm_prices.find_element(:name, 'prices[USD]').send_keys('20') # Вводим стоимость в поле с ценой

      fotm_prices.find_element(:id, 'add-campaign').click

      fotm_prices.find_element(:name, 'campaigns[new_1][percentage]').clear()
      fotm_prices.find_element(:name, 'campaigns[new_1][percentage]').send_keys('10')

      fotm_prices.find_element(:name, 'campaigns[new_1][USD]').clear()
      fotm_prices.find_element(:name, 'campaigns[new_1][USD]').send_keys('18')

      puts "Prices: Ok"
    end

    # Авторизация админом в catalog
    @driver.navigate.to 'http://localhost/litecart/admin/?app=catalog&doc=catalog'
    @driver.find_element(:name, 'username').send_keys'admin'
    @driver.find_element(:name, 'password').send_keys'admin'
    @driver.find_element(:name, 'login').click

    product_name = 'TEST_' + Time.now.to_i.to_s

    # Кликаем по Add New Product
    @wait.until { @driver.find_element(:css, '.button + a[href*="edit_product"]')}
    @driver.find_element(:css, '.button + a[href*="edit_product"]').click

    # Работаем со вкладками
    tabs_list = @driver.find_elements(:css, '.tabs li a')
    cart_tab_analysis(tabs_list, product_name)

    # Сохраняем продукт
    @driver.find_element(:name, 'save').click
    puts "Save: Ok"

    # Проверяем наличие пордукта в каталоге
    @driver.navigate.to 'http://localhost/litecart/admin/?app=catalog&doc=catalog'

    @driver.find_element(:css, 'a[href*="category_id=1"]:not([title="Edit"])').click
    product_name_list = @driver.find_elements(:css, 'a[href*="product_id"]:not([title="Edit"])')

    stp = 0
    for stp in stp...product_name_list.size
      if product_name_list[stp].attribute('innerText') == product_name
        puts '>>Create: ' + product_name
        puts '>>Search: ' + product_name_list[stp].attribute('innerText')
        puts '>>> ADD product: Ok!'
        break # Нужный продукт найден. Прекращаем дальнейший перебор продуктов
      end
    end

  end

  after(:each) do
    @driver.quit
  end
end