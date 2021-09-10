using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;

namespace DotNetCoreWebApp.Pages
{
    public class IllegalModel : PageModel
    {
        private readonly ILogger<IllegalModel> _logger;

        public IllegalModel(ILogger<IllegalModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
            this.Response.StatusCode = 451;
        }
    }
}
