trigger ForceForecasting on User (before insert)
{
    for (User userInLoop : Trigger.new) {
        userInLoop.ForecastEnabled = true;
    }
}