namespace Server.Models
{
    public class JobApplicationModel
    {
        public required List<int> RoleIds { get; set; }
        public required int TimeSlotId { get; set; }
    }
}