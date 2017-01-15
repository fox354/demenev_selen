require 'rspec'
require 'selenium-webdriver'
require 'pp'

describe 'litecart price control' do
  before(:each) do
    @driver = Selenium::WebDriver.for(:chrome)
    puts PP.pp(@driver.capabilities)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)


  end

  it 'price control' do
    # Возвращает объекты цены: regular, campaign
    def price_elements(space)
      regular = space.find_element(class: 'regular-price')
      campaign = space.find_element(class: 'campaign-price')
      return [regular, campaign]
    end

    # Значение цены: regular, campaign
    def price_value(prices)
      price_value_list = []
      stp = 0
      for stp in stp...prices.size
        price_value_list[stp] = prices[stp].attribute('innerText')
      end
      return price_value_list
    end

    # Оформление: regular - зачеркнута, campaign - жирная
    # decor: если да = 1, иначе = 0
    def decor_control(prices)
      decor_model = ["s", "strong"]
      decor_list = []
      stp = 0
      for stp in stp...prices.size
        decor_list[stp] = prices[stp].attribute('localName')
      end
      if (decor_list <=> decor_model) != 0
        decor = 0
      else
        decor = 1
      end

      return decor
    end

    # Цвет: regular - серый, campaign - красный
    # color: если да = 1, иначе = 0
    def color_control(prices)
      color_model = ["gray", "red"]
      color_list = []
      # Далее мой велосипед, как получить значения rgb, для определения цвета
      # PS: Очевидно, что оно работает только в Chrome. Надеюсь мне никогда не придется этим заниматься в работе о_О
      stp = 0
      for stp in stp...prices.size
        rgba_txt = prices[stp].style("color").to_s
        rgba = rgba_txt[5...rgba_txt.size].split(', ')
        rgba_r = rgba[0]
        rgba_g = rgba[1]
        rgba_b = rgba[2]
        # Получив значения будем сравнивать их с интересующими нас цветами: серый и красный
        if (rgba_r == rgba_b and  rgba_b == rgba_g) # если r=g=b - значит серый
          rgba_color = 'gray'
        elsif (rgba_r != '0' and rgba_g == rgba_b and rgba_b == '0') # если r!=0 и g=b=0 - значит красный
          rgba_color = 'red'
        else
          rgba_color = 'error'
        end
        color_list[stp] = rgba_color
      end

      if (color_list <=> color_model) != 0
        color = 0
      else
        color = 1
      end

      return color
    end

    # Размер шрифта: regular - маленький, campaign - большой
    # font_size: если да = 1, иначе = 0
    def font_size_control(prices)
      size_list = []
      stp = 0
      for stp in stp...prices.size
        size = prices[stp].style("font-size")
        size_list[stp] = size
      end
      if size_list[stp] <= size_list[stp-1]
        font_size = 0
      else
        font_size = 1
      end

      return font_size
    end

    # Product list
    @driver.navigate.to 'http://localhost/litecart/'
    @wait.until { @driver.find_element(:css, '#box-campaigns h3')}
    box_campaigns = @driver.find_element(:css, '#box-campaigns a.link:first-child')

    product_list_element = price_elements(box_campaigns)
    list_name = box_campaigns.attribute('title')

    list_price_value = price_value(product_list_element)
    list_style = [decor_control(product_list_element), color_control(product_list_element), font_size_control(product_list_element)]

    # Product page
    @driver.find_element(:css, '#box-campaigns a.link:first-child').click
    @wait.until { @driver.find_element(:css, '#box-product h1')}
    box_product = @driver.find_element(:css, '#box-product .price-wrapper')

    product_page_element = price_elements(box_product)
    page_name = @driver.find_element(:css, '#box-product h1').attribute('innerText')

    page_price_value = price_value(product_page_element)
    page_style = [decor_control(product_page_element), color_control(product_page_element), font_size_control(product_page_element)]

    # Name control
    if list_name == page_name
      puts 'Title: Ok'
    else
      puts 'Title: Differ'
      raise
    end

    # Price value control
    if (list_price_value <=> page_price_value) != 0
      puts 'Price: Differ'
      raise
    else
      puts 'Price: Ok'
    end

    # Style control finish
    if list_style == [1, 1, 1] and  page_style == [1, 1, 1]
      puts 'Style: Ok'
    elsif list_style == [1, 1, 1]
      puts'Style: Error in product PAGE'
      raise
    elsif page_style == [1, 1, 1]
      puts 'Style: Error in product LIST'
      raise
    else
      puts 'Style: Error in product LIST and PAGE'
      raise
    end

  end


  after(:each) do
    @driver.quit
  end
end
