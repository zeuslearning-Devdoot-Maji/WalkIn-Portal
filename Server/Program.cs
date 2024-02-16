using MySqlConnector;
using Server.Controllers;

var policyName = "_myAllowSpecificOrigins";
var builder = WebApplication.CreateBuilder(args);

// CORS Configuration
builder.Services.AddCors(options =>
{
    options.AddPolicy(name: policyName, builder =>
        {
            builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
        });
});

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpContextAccessor();
builder.Services.AddMySqlDataSource(builder.Configuration.GetConnectionString("DefaultConnection")!);

// Register your controllers
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors(policyName);

var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast")
.WithOpenApi();

// app.MapGet("/locations", async() =>
// {
//     using var connection = new MySqlConnection("Server=127.0.0.1;User=root;Password=admin;Port=3306;Database=walkin");
//     await connection.OpenAsync();

//     using var command = new MySqlCommand("SELECT * FROM Location;", connection);
//     using var reader = await command.ExecuteReaderAsync();

//     // Create a list to store objects representing each row
//     List<Location> locations = new List<Location>();

//     while (await reader.ReadAsync())
//     {
//         // Create an instance of the Location class
//         var location = new Location
//         {
//             LocationId = reader.GetInt32(reader.GetOrdinal("Id")),
//             LocationName = reader.GetString(reader.GetOrdinal("Location")),
//             // Add other property assignments for each column in your 'Location' table
//         };

//         // Add the object to the list of locations
//         locations.Add(location);
//     }

//     return locations;
// })
// .WithName("GetLocations")
// .WithOpenApi();

// Map the controller routes
app.MapControllers();

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
