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
    # Сценарий должен проверять, что у каждого товара имеется ровно один стикер.
    # По этому мы будем перебирать по одному элементы товары, и проверять для каждого список элементов стикер.
    # Длина списка должна быть <= 1 , иначе следует выкинуть сообщение о продукте с ошибкой и завершить тест с ошибкой.

    @driver.navigate.to 'http://localhost/litecart/'

    products_sum = @driver.find_elements(:css, 'li[class*=product] .link').size
    product_number = 0
    puts 'Cell products:'

    while product_number < products_sum
      product_form =  @driver.find_elements(:css, 'li[class*=product]')[product_number]
      product_name = product_form.find_element(:css, 'li[class*=product] div.name').text
      stickers = product_form.find_elements(:class, 'sticker')
      sticker_name = product_form.find_element(:class, 'sticker').text
      if stickers.size > 1
        puts ('#' + (product_number+1).to_s + ' | ' + 'PRODUCT: ' + product_name + ' | ' + 'STICKERS. Sum: ' + stickers.size.to_s + ' (!) ERROR: Too many stickers!')
        raise
      else
        puts ('#' + (product_number+1).to_s + ' | ' + 'PRODUCT: ' + product_name + ' | ' + 'STICKERS. Sum: ' + stickers.size.to_s + ' Name: ' + sticker_name)
      end
      product_number+=1
    end
  end

  after(:each) do
    @driver.quit
  end
end