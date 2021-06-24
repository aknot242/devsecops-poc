FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
RUN apt update && apt-get install -y net-tools curl

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["DotNetCoreWebApp.csproj", ""]
RUN dotnet restore "./DotNetCoreWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DotNetCoreWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetCoreWebApp.csproj" -c Release -o /app/publish

FROM base AS final
ENV ASPNETCORE_URLS=http://+:3000
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotNetCoreWebApp.dll"]
