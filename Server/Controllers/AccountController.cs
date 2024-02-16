using Microsoft.AspNetCore.Mvc;
using MySqlConnector;

namespace Server.Controllers
{
    [Route("api/[controller]")]
    public class AccountController : Controller
    {
        private readonly MySqlConnection _connection;

        public AccountController(MySqlConnection connection)
        {
            _connection = connection;
        }

        [HttpPost]
        // [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] Models.AccountViewModel model)
        {
            try
            {
                {
                    await _connection.OpenAsync();

                    // Use parameters to avoid SQL injection
                    var command = new MySqlCommand("SELECT * FROM User WHERE Email = @Email AND Password = @Password;", _connection);
                    command.Parameters.AddWithValue("@Email", model.Email);
                    command.Parameters.AddWithValue("@Password", model.Password);

                    var reader = await command.ExecuteReaderAsync();

                    if (reader.HasRows)
                    {
                        // Authentication successful, generate and return a JWT token.
                        await reader.ReadAsync();
                        var userId = reader.GetInt32(reader.GetOrdinal("Id"));
                        string token = Services.JwtTokenService.GenerateToken(model.Email, userId);

                        return Ok(new { Token = token });
                    }
                    else
                    {
                        // Authentication failed
                        return Unauthorized(new { Message = "Invalid credentials" });
                    }
                }
            }
            catch (Exception)
            {
                return StatusCode(500, new { Message = "Internal server error" });
            }
        }
    }
}