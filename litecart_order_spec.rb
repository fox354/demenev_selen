require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'Homework #09' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  context 'Авторизация в админке' do
    it 'Авторизация' do
      @driver.navigate.to 'http://localhost/litecart/admin/'
      @driver.find_element(:name, 'username').send_keys'admin'
      @driver.find_element(:name, 'password').send_keys'admin'
      @driver.find_element(:name, 'login').click
    end

    it 'Countries: список стран по алфовиту' do
      @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'

      countries_list = [] # Создаем массив, куда будем помещать названия стран
      rows = @driver.find_elements(:css, 'tr.row').size # Количество строк в таблице

      # Записываем имена стран в массив countries_list
      stp = 0
      for stp in stp...(rows)
        countr_focus = @driver.find_elements(:css, '.dataTable a:not([title="Edit"])')[stp]
        countr_name = countr_focus.attribute('innerText')
        countries_list[stp] = countr_name
      end

      # Сравниваем массив стран с собой же отсортированным
      # Если массивы идентичны, вернется 0
      # Иначе останавливаем тест с ошибкой
      if (countries_list <=> countries_list.sort)!=0
        raise
      end

      # it 'Zones: по алфавиту' do
      #   # @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'
      #   # rows = @driver.find_elements(:css, 'tr.row').size # Количество строк в таблице
      #
      #   zone_list = [] # Создаем массив, куда будем помещать названия стран
      #
      #   stp = 0
      #   for stp in stp...(rows)
      #     zone_value = @driver.find_elements(:css, 'tr.row > td:nth-child(6)')[stp].attribute('innerText')
      #
      #     if (zone_value != 0)
      #       @driver.find_elements(:css, '.dataTable a:not([title="Edit"])')[stp].click
      #
      #       sub_countr_table = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[3]")
      #       sstp = 0
      #       for sstp in sstp...(sub_countr_list.size)
      #         focus_sub_countr = sub_countr_list[stp]
      #         sub_countr_name = focus_sub_countr.attribute('innerText')
      #         sub_countr_list[stp] = sub_countr_name
      #       end
      #     end
      #     countries_list[stp] = countri_name
      #   end
      #
      #   # Сравниваем массив стран с собой же отсортированным
      #   # Если массивы идентичны, вернется 0
      #   # Иначе останавливаем тест с ошибкой
      #   if (countries_list <=> countries_list.sort)!=0
      #     raise
      #   end
      # end

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
  end

  after(:each) do
    @driver.quit
  end
end


# Опробованные селекторы:
# countries_css1 = @driver.find_elements(:css, '.dataTable a:not([title="Edit"])')
# countries_css2 = @driver.find_elements(:css, 'tr.row > td:nth-child(5)')
# countries_xpath = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[5]/a")