using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MySqlConnector;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class LocationController : ControllerBase
    {
        private readonly MySqlConnection _connection;

        // Inject MySqlConnection into the constructor
        public LocationController(MySqlConnection connection)
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
                List<Location> locations = new List<Location>();

                while (await reader.ReadAsync())
                {
                    // Create an instance of the Location class
                    var location = new Location
                    {
                        LocationId = reader.GetInt32(reader.GetOrdinal("Id")),
                        LocationName = reader.GetString(reader.GetOrdinal("Location")),
                    };

                    // Add the object to the list of locations
                    locations.Add(location);
                }

                return Ok(locations);
            }
            catch (Exception error)
            {
                return StatusCode(500, $"Internal server error: {error.Message}");
            }
        }
    }
}

record Location
{
    public int LocationId { get; set; }
    public string LocationName { get; set; }
}
