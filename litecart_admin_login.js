var webdriver = require('selenium-webdriver'),
    chrome = require('selenium-webdriver/chrome'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');

test.describe('Google Search', function() {
  var driver;

  test.before(function() {
    //driver = new webdriver.Builder().forBrowser('chrome').build();
    //driver = new webdriver.Builder().forBrowser('ie').build();
    //driver = new webdriver.Builder().forBrowser('firefox').build();
  });

  test.it('should append query to title', function() {
    driver.get('http://localhost/litecart/admin/login.php');
    driver.manage().timeouts().implicitlyWait(2000/*ms*/);
    driver.findElement(By.name('username')).sendKeys('admin');
    driver.findElement(By.name('password')).sendKeys('admin');
    driver.findElement(By.name('login')).click()
    driver.wait(until.titleIs('My Store'), 10000);
  });

  test.after(function() {
    driver.quit();
  });
});