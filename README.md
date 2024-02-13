# Angular 16 and .NET 8 Base Repository

Welcome to the Angular 16 and .NET 8 Base Repository! This repository serves as a starting point for your web development projects, combining the power of Angular 16 for the frontend and .NET 8 for the backend.

## Prerequisites

Before you get started, make sure you have the following installed:

- Node.js and npm (https://nodejs.org/)
- Angular CLI (https://angular.io/cli)
- .NET SDK 8 (https://dotnet.microsoft.com/download)

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Devdoot-Maji/Angular16-DotNet-Base-Repository.git
   cd your-project
   ```

2. Install the Angular dependencies:

   ```bash
   cd Client
   npm install
   ```

3. Install the .NET dependencies:

   ```bash
   cd ..
   cd Server
   dotnet restore
   ```

4. Build the Angular application:

   ```bash
   cd Client
   ng build
   ```

5. Run the .NET application:

   ```bash
   cd ..
   cd Server
   dotnet run
   ```

   The application will be accessible on your localhost.

## Development Workflow

1. Use the Angular CLI to generate components, services, and other Angular elements:

   ```bash
   ng generate component components/example
   ```

2. Define your API endpoints in the .NET.

3. Communicate between the frontend and backend by making HTTP requests.

Happy coding!