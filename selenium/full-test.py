from seleniumbase import BaseCase


class MyTestClass(BaseCase):
    def test_basics(self):
        url = "http://edgar-devsecopspoc-staging.westus2.azurecontainer.io/"
        self.open(url)
        self.assert_title("Home page - DotNetCoreWebApp")
        self.assert_exact_text("Welcome to DevSecOps", "h1")
        self.type('input[name="SearchString"]', "my search string")
        self.click('input[value="Search"]')
        # self.assert_text("xkcd: volume 0", "h3")
        self.open("http://edgar-devsecopspoc-staging.westus2.azurecontainer.io/Privacy")
        self.assert_title("Privacy Policy - DotNetCoreWebApp")
        # self.assert_element('img[alt="Python"]')
        self.assert_exact_text("Privacy Policy", "h1")
