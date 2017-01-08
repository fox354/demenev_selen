// ЛОКАТОРЫ
// var form1 = driver.findElement(By.id("login-form"));
// var form2 = driver.findElement(By.tagName("form"));
// var form3 = driver.findElement(By.className("login"));
// var form4 = driver.findElement(By.css("form.login"));
// var form5 = driver.findElement(By.css("#login-form"));
// var field1 = driver.findElement(By.name("username"));
// var field2 = driver.findElement(By.xpath("//input[@name='username']"));
// var link = driver.findElement(By.linkText("Logout"));
// var links = driver.findElements(By.tagName("a"));

// ОЖИДАНИЕ ЭЛЕМЕНТА
// ! настройка неявных ожиданий
// driver.manage().timeouts().implicitlyWait(10000/*ms*/);
// var element = driver.findElement(By.name("q"));
// ! явное ожидание появления элемента
// var element = driver.wait(until.elementLocated(By.name('q')), 10000/*ms*/);


var webdriver = require('selenium-webdriver'),
    chrome = require('selenium-webdriver/chrome'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');
    // count = 1;

test.describe('Google Search', function() {
  var driver;

  test.before(function() {
    driver = new webdriver.Builder().forBrowser('chrome').build();
    //driver = new webdriver.Builder().forBrowser('ie').build();
    //driver = new webdriver.Builder().forBrowser('firefox').build();
  });

  test.it('authorization', function() {
    driver.get('http://localhost/litecart/admin/login.php');
    driver.manage().timeouts().implicitlyWait(2000/*ms*/);
    driver.findElement(By.name('username')).sendKeys('admin');
    driver.findElement(By.name('password')).sendKeys('admin');
    driver.findElement(By.name('login')).click();
    driver.wait(until.titleIs('My Store'), 5000);
  });

  test.it('clicker', function() {
    driver.findElements(By.id('app-')).then(function(items) {
      for (var i = 1; i < items.length; i++) {
        driver.findElement(By.css('#sidebar ul li#app-:nth-child('+i+') .name')).click();
        driver.findElements(By.css('[id*=doc]')).then(function (subItems) {
          for (var j = 0; j < subItems.length; j++) {
            console.log(i + " " + j);
            driver.findElement(By.xpath('//li[' + (i + 1) + ']/ul/li[' + (j + 1) + ']/a')).click();
            };
          });
        }
      });
    // for (i=1;;i++) {
      // driver.findElement(By.css('ul li#app-:nth-child('+i+') .name')).click();
      // driver.wait(until.elementLocated(By.css('h1')), 5000/*ms*/);
    // }

    // for (count=1; presentElement.length===0;) {
    //   menuForm.findElement(By.css('ul li#app-:nth-child('+count+') .name')).click();
    //   driver.wait(until.elementLocated(By.css('h1')), 5000/*ms*/);

    //   count=count+1;
    //   presentElement = menuForm.findElements(By.css('ul li#app-:nth-child('+count+') .name'));
    // };

    // while (menuForm.findElements(By.css('ul li#app-:nth-child('+count+')')).length > 0) {
    //   menuElement.click();
    //   driver.wait(until.elementLocated(By.css('h1')), 5000/*ms*/);

    //   count++;
    // };

  });

  // test.after(function() {
  //   driver.quit();
  // });
});