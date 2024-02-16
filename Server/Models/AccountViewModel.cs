using System.ComponentModel.DataAnnotations;

namespace Server.Models
{
    public class AccountViewModel
    {
        [EmailAddress]
        public required string Email { get; set; }

        [DataType(DataType.Password)]
        public required string Password { get; set; }

        [Display(Name = "Remember Me")]
        public bool RememberMe { get; set; }
    }
}