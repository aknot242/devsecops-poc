from seleniumbase import BaseCase


class MyTestClass(BaseCase):
    def test_basics(self):
        url = "https://devsecops-stage.hazy.beer/"
        self.open(url)
        self.assert_title("Home page - DotNetCoreWebApp")
        self.assert_exact_text("Welcome to DevSecOps at the NGINX Sprint 2.0 conference", "h1")
        self.type('input[name="SearchString"]', "my search string")
        self.click('input[value="Search"]')
        self.open("https://devsecops-stage.hazy.beer/Privacy")
        self.assert_title("Privacy Policy - DotNetCoreWebApp")
        self.assert_exact_text("Privacy Policy", "h1")
