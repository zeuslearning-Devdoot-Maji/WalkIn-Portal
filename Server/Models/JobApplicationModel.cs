namespace Server.Models
{
    public class JobApplicationModel
    {
        public required int UserId { get; set; }
        public required int JobId { get; set; }
        public required List<int> RoleIds { get; set; }
        public required int TimeSlotId { get; set; }
    }
}