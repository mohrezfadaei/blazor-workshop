FROM mcr.microsoft.com/dotnet/sdk:7.0 AS builder
WORKDIR /app

COPY . .
COPY hack/appsettings.json ./src/BlazingPizza.Server/appsettings.json

WORKDIR /app/src

RUN dotnet build
RUN dotnet publish ./BlazingPizza.Server/BlazingPizza.Server.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final

WORKDIR /app

# Copy cert (optional, for IdentityServer signing)
# COPY certs/identity.pfx /https/identity.pfx

COPY --from=builder /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "BlazingPizza.Server.dll"]
