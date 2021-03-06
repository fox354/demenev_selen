var webdriver = require('selenium-webdriver'),
    chrome = require('selenium-webdriver/chrome'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');

test.describe('Google Search', function() {
  var driver;

  test.before(function() {
    driver = new webdriver.Builder().forBrowser('chrome').build();
    //driver = new webdriver.Builder().forBrowser('ie').build();
    //driver = new webdriver.Builder().forBrowser('firefox').build();
  });

  test.it('should append query to title', function() {
    driver.get('http://www.google.com');
    driver.manage().timeouts().implicitlyWait(2000/*ms*/);
    driver.findElement(By.name('q')).sendKeys('webdriver');
    driver.findElement(By.name('btnG')).click();
    driver.wait(until.titleIs('webdriver - Поиск в Google'), 10000);
  });

  test.after(function() {
    driver.quit();
  });
});