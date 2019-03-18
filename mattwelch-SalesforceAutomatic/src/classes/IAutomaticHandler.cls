public interface IAutomaticHandler
{
    Boolean handleWebhook(Map<String, Object> webhookRequestBody);
}