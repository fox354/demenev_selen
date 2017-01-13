require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'Homework 09' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    def litecart_where()
      # Определяем страницу где обитаем
      space = @driver.find_element(:css => 'h1').attribute('innerText')
      if space == ' Edit Country'
        space =  @driver.find_element(:xpath, "//input[@name='name']").attribute('value')
        puts ('Зона: ' + space)
      elsif space == ' Edit Geo Zone'
        space =  @driver.find_element(:xpath, "//input[@name='name']").attribute('value')
        puts ('Геозона: ' + space)
      else
        puts ('ВКЛАДКА:' + space)
      end
    end

    def litecart_sort(array) # Сравниваем array с arra.sort: 0 - хорошо; иначе останавливаем тест с ошибкой
      if (array <=> array.sort)!=0
        puts ('> Сортировка по алфавиту: ОШИБКА!')
        raise
      else
        puts ('> Сортировка по алфавиту: Ок')
      end
    end

  end

  it 'lists sort' do

    @driver.navigate.to 'http://localhost/litecart/admin/'
    @driver.find_element(:name, 'username').send_keys'admin'
    @driver.find_element(:name, 'password').send_keys'admin'
    @driver.find_element(:name, 'login').click
    @wait.until { @driver.title == 'My Store'}

    # Задание 1
    @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'
    litecart_where()
    puts 'Список стран:'
    countr_name_list = [] # Создаем массив под countries:name
    countrzone_link = [] # Создаем массив под countries:link имеюие вложенные zone

    countr_list = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[5]/a")
    puts ('> Количество элементов: ' + countr_list.size.to_s)

    # Построчным перебором записываем countries:name в массив countr_name_list
    stp = 0
    link_stp = 0
    for stp in stp...(countr_list.size)
      countr_name_list[stp] = countr_list[stp].attribute('innerText')
      zone_value = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[6]")[stp].attribute('innerText')
      if (zone_value != '0') # Если есть вложенные зоны
        countrzone_link[link_stp] = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[5]/a")[stp].attribute('href')
        link_stp += 1
      end
    end

    litecart_sort(countr_name_list) # Проверка сортировку

    # Перебором проверяем zone_value
    link_stp = 0
    for link_stp in link_stp...(countrzone_link.size)
      @driver.navigate.to (countrzone_link[link_stp]) # Перебираем пулл ссылок
      litecart_where()

      zone_name_list = [] # Создаем массив под zone:name

      zone_list = @driver.find_elements(:css, '.dataTable tr a')
      puts ('> Количество элементов: ' + zone_list.size.to_s)

      # Построчным перебором записываем zone:name в массив zone_name_list
      zone_stp = 0
      for zone_stp in zone_stp...(zone_list.size)
        zone_name_list[zone_stp] = zone_list[zone_stp].attribute('innerText')
      end

      litecart_sort(zone_name_list) # Проверка сортировки
    end

    # Задание 2
    @driver.navigate.to 'http://localhost/litecart/admin/?app=geo_zones&doc=geo_zones'
    litecart_where()

    geozone = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[3]/a")

    geozone_link = []

    # Получаем пулл ссылок доступных зон
    stp = 0
    for stp in stp...(geozone.size)
      geozone_link[stp] = @driver.find_elements(:xpath, "//*[@class='dataTable']//td[3]/a")[stp].attribute('href')
    end

    # Берем ссылку из geozone_link, и построчным перебором записываем subzone:name в массив geo_name_list
    stp = 0
    for stp in stp...(geozone.size)
      @driver.navigate.to (geozone_link[stp]) # Перебираем пулл ссылок
      @wait.until { @driver.find_element(:xpath, "//input[@name='name']") }

      litecart_where()

      subgeozone_list = @driver.find_elements(:css, '.dataTable tr #remove-zone') # Количество зон
      puts ('> Количество элементов: ' + subgeozone_list.size.to_s)

      subgeo_name_list = [] # Создаем массив под geozone:name

      # Построчным перебором записываем subzone:name в массив geo_name_list
      subgeo_stp = 0
      for geo_stp in subgeo_stp...(subgeozone_list.size)
        subgeozone_selected = @driver.find_elements(:css, '.dataTable td:nth-child(3) > select > option[selected=selected]')
        subgeo_name_list[geo_stp] = subgeozone_selected[geo_stp].attribute('textContent')
      end

      litecart_sort(subgeo_name_list) # Проверка сортировки
    end

  end

  after(:each) do
    @driver.quit
  end
end