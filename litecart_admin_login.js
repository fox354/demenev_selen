const {Builder, By, until} = require('selenium-webdriver');
const test = require('selenium-webdriver/testing');

test.describe('litecart:admin:login', function() {
  let driver;

  //Before
  test.before(function *() {
    driver = yield new Builder().forBrowser('chrome').build();
  });

  //Test
  test.it('works with generators', function*() {
    yield driver.get('http://localhost/litecart/admin/login.php');
    yield driver.findElement(By.name('username')).sendKeys('admin');
    yield driver.findElement(By.name('password')).sendKeys('admin');
    yield driver.findElement(By.name('login')).click()
    yield driver.wait(until.titleIs('My Store'), 10000);
  });

  //After
  test.after(() => driver.quit());
});