FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["TestApp/TestApp.vbproj", "TestApp/"]
RUN dotnet restore "TestApp/TestApp.vbproj"
COPY . .
WORKDIR "/src/TestApp"
RUN dotnet build "TestApp.vbproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestApp.vbproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestApp.dll"]