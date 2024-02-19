using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.Models
{
    public class JobsViewModel
    {
        public required int JobId { get; set; }
        public required string JobTitle { get; set; }
        public required DateOnly StartDate { get; set; }
        public required DateOnly EndDate { get; set; }
        public required string LocationName { get; set; }
        public string? SpecialOpportunity { get; set; }
        public required List<string> RoleNames { get; set; }
    }
}