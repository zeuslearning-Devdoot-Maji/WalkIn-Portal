using System.Data;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MySqlConnector;
using Server.Models;

namespace Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobsController(MySqlConnection connection) : ControllerBase
    {
        private readonly MySqlConnection _connection = connection;

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

        [HttpGet("{jobId}")]
        [Authorize]
        public async Task<IActionResult> GetJobDetails(string jobId)
        {
            try
            {
                // Get userId from the JWT token claim
                var userIdClaim = User.FindFirst("userId");
                if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
                {
                    return BadRequest("Invalid or missing userId in the JWT token.");
                }

                // Fetch Job details
                JobDetailModel jobDetail = await GetJobDetailsAsync(jobId);

                // Fetch Roles
                await GetRolesAsync(jobId, jobDetail);

                // Fetch TimeSlots
                await GetTimeSlotsAsync(jobId, jobDetail);

                return Ok(jobDetail);
            }
            catch (Exception error)
            {
                return StatusCode(500, $"Internal server error: {error.Message}");
            }
        }

        [HttpPost("{jobId}/Apply")]
        [Authorize]
        public async Task<IActionResult> ApplyForJob(string jobId, [FromBody] JobApplicationModel model)
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
                            checkExistingApplicationCommand.Parameters.AddWithValue("@JobId", jobId);

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
                                insertApplicationCommand.Parameters.AddWithValue("@JobId", jobId);
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

        /*
         * Helper Functions
         */
        private async Task<JobDetailModel> GetJobDetailsAsync(string jobId)
        {
            using var connection = new MySqlConnection(_connection.ConnectionString);

            await connection.OpenAsync();

            var jobQuery = @"
                SELECT
                    j.Id,
                    j.JobTitle,
                    j.StartDate,
                    j.SpecialOpportunity,
                    j.EndDate,
                    l.Location,
                    JSON_OBJECT(
                        'GeneralInstructions', pap.GeneralInstructions,
                        'ExamInstructions', pap.ExamInstructions,
                        'SystemRequirements', pap.SystemRequirements,
                        'Process', pap.Process
                    ) AS PreRequisiteApplicationProcess
                FROM
                    Job j
                    INNER JOIN Location l ON j.LocationId = l.Id
                    LEFT JOIN PreRequisiteApplicationProcess pap ON j.PreRequisiteApplicationProcessId = pap.Id
                WHERE
                    j.Id = @JobId
            ";

            var jobCommand = new MySqlCommand(jobQuery, connection);
            jobCommand.Parameters.AddWithValue("@JobId", jobId);
            var jobReader = await jobCommand.ExecuteReaderAsync();

            if (!jobReader.Read())
            {
                throw new InvalidOperationException("Job not found");
            }

            return new JobDetailModel
            {
                JobId = jobReader.GetInt32("Id"),
                JobTitle = jobReader.GetString("JobTitle"),
                StartDate = jobReader.GetDateOnly("StartDate"),
                EndDate = jobReader.GetDateOnly("EndDate"),
                LocationName = jobReader.GetString("Location"),
                SpecialOpportunity = jobReader.IsDBNull(jobReader.GetOrdinal("SpecialOpportunity")) ? null : jobReader.GetString("SpecialOpportunity"),
                Roles = new List<RoleViewModel>(),
                TimeSlot = new List<TimeSlotViewModel>(),
                PreRequisiteApplicationProcess = jobReader != null
                    ? JsonSerializer.Deserialize<PreRequisiteApplicationProcessViewModel>(jobReader.GetString("PreRequisiteApplicationProcess")) ?? new PreRequisiteApplicationProcessViewModel()
                    : new PreRequisiteApplicationProcessViewModel()
            };
        }

        private async Task GetRolesAsync(string jobId, JobDetailModel jobDetail)
        {
            using var connection = new MySqlConnection(_connection.ConnectionString);

            await connection.OpenAsync();

            var rolesQuery = @"
                SELECT
                    jra.JobRoleId,
                    jr.RoleName,
                    jra.JobPackage,
                    jra.RoleDescription,
                    jra.Requirements
                FROM
                    JobRoleAssociation jra
                    LEFT JOIN JobRole jr ON jra.JobRoleId = jr.Id
                WHERE
                    jra.JobId = @JobId
            ";

            var rolesCommand = new MySqlCommand(rolesQuery, connection);
            rolesCommand.Parameters.AddWithValue("@JobId", jobId);
            var rolesReader = await rolesCommand.ExecuteReaderAsync();

            while (await rolesReader.ReadAsync())
            {
                var role = new RoleViewModel
                {
                    JobRoleId = rolesReader.GetInt32("JobRoleId"),
                    RoleName = rolesReader.GetString("RoleName"),
                    JobPackage = rolesReader.GetInt32("JobPackage"),
                    Requirements = rolesReader.IsDBNull(rolesReader.GetOrdinal("Requirements")) ? null : rolesReader.GetString("Requirements"),
                    RoleDescription = rolesReader.IsDBNull(rolesReader.GetOrdinal("RoleDescription")) ? null : rolesReader.GetString("RoleDescription")
                };

                jobDetail.Roles.Add(role);
            }
        }

        private async Task GetTimeSlotsAsync(string jobId, JobDetailModel jobDetail)
        {
            using var connection = new MySqlConnection(_connection.ConnectionString);

            await connection.OpenAsync();

            var timeSlotsQuery = @"
                SELECT
                    ts.Id,
                    ts.SlotStartTime,
                    ts.SlotEndTime
                FROM
                    JobTimeSlot jts
                    LEFT JOIN TimeSlot ts ON jts.TimeSlotId = ts.Id
                WHERE
                    jts.JobId = @JobId
            ";

            var timeSlotsCommand = new MySqlCommand(timeSlotsQuery, connection);
            timeSlotsCommand.Parameters.AddWithValue("@JobId", jobId);
            var timeSlotsReader = await timeSlotsCommand.ExecuteReaderAsync();

            while (await timeSlotsReader.ReadAsync())
            {
                var timeSlot = new TimeSlotViewModel
                {
                    Id = timeSlotsReader.GetInt32("Id"),
                    SlotStartTime = timeSlotsReader.GetTimeSpan("SlotStartTime"),
                    SlotEndTime = timeSlotsReader.GetTimeSpan("SlotEndTime")
                };

                jobDetail.TimeSlot.Add(timeSlot);
            }
        }

    }
}