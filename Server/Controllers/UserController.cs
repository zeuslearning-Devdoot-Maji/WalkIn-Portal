using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MySqlConnector;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : Controller
    {
        private readonly MySqlConnection _connection;

        // Inject MySqlConnection into the constructor
        public UserController(MySqlConnection connection)
        {
            _connection = connection;
        }

        [HttpGet("DisplayPicture")]
        [Authorize]
        public async Task<IActionResult> GetUserProfilePicture()
        {
            try
            {
                // Get userId from the JWT token claim
                var userIdClaim = User.FindFirst("userId");
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
                {
                    return BadRequest("Invalid or missing userId in the JWT token.");
                }

                await _connection.OpenAsync();

                // Get available jobs for the user
                var query = @"
                    SELECT
                        FirstName,
                        LastName,
                        DisplayPicture
                    FROM
                        User
                    WHERE
                        Id = @UserId";

                var command = new MySqlCommand(query, _connection);
                command.Parameters.AddWithValue("@UserId", userId);
                var reader = await command.ExecuteReaderAsync();

                if (reader.Read())
                {
                    string firstName = reader.GetString("FirstName");
                    string lastName = reader.GetString("LastName");
                    string? displayPicture = reader["DisplayPicture"] as string;

                    // If DisplayPicture is null, generate the URL using ui-avatars.com
                    if (string.IsNullOrEmpty(displayPicture))
                    {
                        displayPicture = $"https://ui-avatars.com/api/?name={firstName}+{lastName}&background=random";
                    }

                    return Ok(new { DisplayPicture = displayPicture });
                }

                return NotFound("User not found");

            }
            catch (Exception error)
            {
                return StatusCode(500, $"Internal server error: {error.Message}");
            }
        }
    }
}