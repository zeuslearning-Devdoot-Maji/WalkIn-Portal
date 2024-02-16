using Microsoft.AspNetCore.Mvc;
using MySqlConnector;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly MySqlConnection _connection;

        // Inject MySqlConnection into the constructor
        public LoginController(MySqlConnection connection)
        {
            _connection = connection;
        }

        [HttpGet]
        public async Task<IActionResult> GetLocationsAsync()
        {
            try
            {
                await _connection.OpenAsync();

                using var command = new MySqlCommand("SELECT * FROM Location;", _connection);
                using var reader = await command.ExecuteReaderAsync();

                // Create a list to store objects representing each row
                List<Login> locations = new List<Login>();

                while (await reader.ReadAsync())
                {
                    // Create an instance of the Location class
                    var location = new Login
                    {
                        LocationId = reader.GetInt32(reader.GetOrdinal("Id")),
                        LocationName = reader.GetString(reader.GetOrdinal("Location")),
                        // Add other property assignments for each column in your 'Location' table
                    };

                    // Add the object to the list of locations
                    locations.Add(location);
                }

                return Ok(locations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}

record Login
{
    public int LocationId { get; set; }
    public string LocationName { get; set; }
}
