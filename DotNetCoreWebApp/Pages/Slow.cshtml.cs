using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using System;

namespace DotNetCoreWebApp.Pages
{
    public class SlowModel : PageModel
    {
        private readonly ILogger<SlowModel> _logger;

        [BindProperty(SupportsGet = true)]
        public string LoadTime { get; set; }

        public SlowModel(ILogger<SlowModel> logger)
        {
            _logger = logger;
        }

        public void OnGet()
        {
            Random rnd = new Random();
            var time = rnd.Next(200, 2000);
            System.Threading.Thread.Sleep(time);
            this.LoadTime = time.ToString();
        }
    }
}
