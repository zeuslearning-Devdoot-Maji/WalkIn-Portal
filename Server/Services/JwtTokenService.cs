using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Server.Services
{
    public class JwtTokenService
    {
        public static string GenerateToken(string email, int userId)
        {
            // Your secret key for signing the token (keep it secure)
            var secretKey = "Senior Software Developer at Zeus Learning";

            // Create security key
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));

            // Create signing credentials
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            // Create claims
            var claims = new[]
            {
                new Claim("email", email),
                new Claim("userId", userId.ToString()),
            };

            // Create token
            var token = new JwtSecurityToken(
                issuer: "WalkInPortal",
                audience: "Applicants",
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1),
                signingCredentials: credentials
            );

            // Serialize token to a string
            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            return tokenString;
        }
    }
}