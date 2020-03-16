db.createUser(
    {
        user: "SupWeather",
        pwd: "SupWeatherPass",
        roles: [
            {
                role: "readWrite",
                db: "SupWeather"
            }
        ]
    }
);