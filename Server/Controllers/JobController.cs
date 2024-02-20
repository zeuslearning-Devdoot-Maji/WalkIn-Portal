using System.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MySqlConnector;
using Server.Models;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobController : ControllerBase
    {
        private readonly MySqlConnection _connection;

        // Inject MySqlConnection into the constructor
        public JobController(MySqlConnection connection)
        {
            _connection = connection;
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> GetJobsAvailableForUser()
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
                        j.Id,
                        j.JobTitle,
                        j.StartDate,
                        j.SpecialOpportunity,
                        j.EndDate,
                        l.Location,
                        GROUP_CONCAT(DISTINCT jr.RoleName) AS RoleNames
                    FROM
                        Job j
                        INNER JOIN Location l ON j.LocationId = l.Id
                        LEFT JOIN UserJobApplication uja ON j.Id = uja.JobId AND uja.UserId = @UserId
                        LEFT JOIN JobRoleAssociation jra ON j.Id = jra.JobId
                        LEFT JOIN JobRole jr ON jra.JobRoleId = jr.Id
                    WHERE
                        j.StartDate <= CURRENT_DATE AND j.EndDate >= CURRENT_DATE
                        AND uja.JobId IS NULL
                    GROUP BY
                        j.Id,
                        j.JobTitle,
                        j.StartDate,
                        j.EndDate,
                        j.SpecialOpportunity,
                        l.Location
                    ORDER BY
                        j.StartDate, j.EndDate";

                var command = new MySqlCommand(query, _connection);
                command.Parameters.AddWithValue("@UserId", userId);
                var reader = await command.ExecuteReaderAsync();

                // Create a list to store the result
                List<JobsViewModel> jobs = new List<JobsViewModel>();

                while (await reader.ReadAsync())
                {
                    var job = new JobsViewModel
                    {
                        JobId = reader.GetInt32("Id"),
                        JobTitle = reader.GetString("JobTitle"),
                        StartDate = reader.GetDateOnly("StartDate"),
                        EndDate = reader.GetDateOnly("EndDate"),
                        LocationName = reader.GetString("Location"),
                        SpecialOpportunity = reader.IsDBNull(reader.GetOrdinal("SpecialOpportunity")) ? null : reader.GetString("SpecialOpportunity"),
                        RoleNames = reader.IsDBNull("RoleNames") ? new List<string>() : reader.GetString("RoleNames").Split(',').ToList()
                    };
                    jobs.Add(job);
                }
                return Ok(jobs);
            }
            catch (Exception error)
            {
                return StatusCode(500, $"Internal server error: {error.Message}");
            }
        }

        [HttpPost("Apply")]
        [Authorize]
        public async Task<IActionResult> ApplyForJob([FromBody] JobApplicationModel model)
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

                using (var transaction = await _connection.BeginTransactionAsync())
                {
                    try
                    {
                        // Check if the user has already applied for the job
                        var checkExistingApplicationQuery = @"
                            SELECT COUNT(*)
                            FROM UserJobApplication
                            WHERE UserId = @UserId AND JobId = @JobId
                        ";

                        using (var checkExistingApplicationCommand = new MySqlCommand(checkExistingApplicationQuery, _connection))
                        {
                            checkExistingApplicationCommand.Transaction = transaction; // Set the transaction for the command (https://fl.vu/mysql-trans)

                            checkExistingApplicationCommand.Parameters.AddWithValue("@UserId", userId);
                            checkExistingApplicationCommand.Parameters.AddWithValue("@JobId", model.JobId);

                            var existingApplicationCount = Convert.ToInt32(await checkExistingApplicationCommand.ExecuteScalarAsync());

                            if (existingApplicationCount > 0)
                            {
                                return BadRequest("You have already applied for the selected job.");
                            }
                        }

                        // Insert the new application
                        var insertApplicationQuery = @"
                            INSERT INTO UserJobApplication (UserId, JobId, JobRoleId, TimeSlotId, DateCreated, DateModified)
                            VALUES (@UserId, @JobId, @JobRoleId, @TimeSlotId, NOW(), NOW())
                        ";

                        foreach (var roleId in model.RoleIds)
                        {
                            using (var insertApplicationCommand = new MySqlCommand(insertApplicationQuery, _connection))
                            {
                                insertApplicationCommand.Transaction = transaction; // Set the transaction for the command (https://fl.vu/mysql-trans)

                                insertApplicationCommand.Parameters.AddWithValue("@UserId", userId);
                                insertApplicationCommand.Parameters.AddWithValue("@JobId", model.JobId);
                                insertApplicationCommand.Parameters.AddWithValue("@JobRoleId", roleId);
                                insertApplicationCommand.Parameters.AddWithValue("@TimeSlotId", model.TimeSlotId);

                                await insertApplicationCommand.ExecuteNonQueryAsync();
                            }
                        }

                        // Commit the transaction
                        await transaction.CommitAsync();

                        return Ok(new { Message = "Application submitted successfully." });
                    }
                    catch (Exception)
                    {
                        // Rollback the transaction in case of an exception
                        await transaction.RollbackAsync();
                        throw;
                    }
                }
            }
            catch (Exception error)
            {
                return StatusCode(500, $"Internal server error: {error.Message}");
            }
        }
    }
}