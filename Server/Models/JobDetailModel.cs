namespace Server.Models
{
    public class JobDetailModel
    {
        public int JobId { get; set; }
        public required string JobTitle { get; set; }
        public DateOnly StartDate { get; set; }
        public string? SpecialOpportunity { get; set; }
        public DateOnly EndDate { get; set; }
        public required string LocationName { get; set; }
        public required List<RoleViewModel> Roles { get; set; }
        public required List<TimeSlotViewModel> TimeSlot { get; set; }
        public required PreRequisiteApplicationProcessViewModel PreRequisiteApplicationProcess { get; set; }
    }

    public class RoleViewModel
    {
        public int JobRoleId { get; set; }
        public required string RoleName { get; set; }
        public decimal JobPackage { get; set; }
        public string? Requirements { get; set; }
        public string? RoleDescription { get; set; }
    }

    public class TimeSlotViewModel
    {
        public int Id { get; set; }
        public TimeSpan SlotStartTime { get; set; }
        public TimeSpan SlotEndTime { get; set; }
    }

    public class PreRequisiteApplicationProcessViewModel
    {
        public string? GeneralInstructions { get; set; }
        public string? ExamInstructions { get; set; }
        public string? SystemRequirements { get; set; }
        public string? Process { get; set; }
    }
}