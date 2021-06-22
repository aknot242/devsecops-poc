FROM mcr.microsoft.com/dotnet/core/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:5.0-buster AS build
WORKDIR /src
COPY ["DotNetCoreWebApp.csproj", ""]
RUN dotnet restore "./DotNetCoreWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetCoreWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetCoreWebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetCoreWebApp.dll"]
