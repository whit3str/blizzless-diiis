FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

COPY ["src/DiIiS-NA/Blizzless.csproj", "src/DiIiS-NA/"]
RUN dotnet restore "src/DiIiS-NA/Blizzless.csproj"

COPY ["src/", "src/"]
WORKDIR "/app/src/DiIiS-NA"
RUN dotnet publish "Blizzless.csproj" -c Release \
    --runtime linux-x64 \
    --self-contained true \
    -o /app/publish

FROM mcr.microsoft.com/dotnet/runtime-deps:7.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

COPY src/DiIiS-NA/config.ini /app/config.ini
COPY src/DiIiS-NA/database.Account.config /app/database.Account.config
COPY src/DiIiS-NA/database.Worlds.config /app/database.Worlds.config

EXPOSE 83 1119 1345 2001 9800 9100

ENTRYPOINT ["./Blizzless"]