# Change the SDK version to .NET 8.0
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory
WORKDIR /app

# Copy the project file and restore dependencies
COPY ./ApiGatewaySolution/ApiGatewaySolution.csproj ./ApiGatewaySolution/
RUN dotnet restore ApiGatewaySolution/ApiGatewaySolution.csproj

# Copy the rest of the code
COPY . ./

# Build the application
RUN dotnet publish ApiGatewaySolution/ApiGatewaySolution.csproj -c Release -o /app/publish

# Use the runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the build output from the build stage
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "ApiGatewaySolution.dll"]

