trigger ForceForecasting on User(before insert)
{
    for (User uname : Trigger.new)
        {
            uname.ForecastEnabled=True;
        }
}