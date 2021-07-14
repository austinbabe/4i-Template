public class QueueableGetAccessToken implements Queueable, Database.AllowsCallouts {
  public void execute(QueueableContext context) {
    HttpResponse response = RefreshAccessTokenCallout.GetResponseOfRefreshToken();
    //parse response to wrapper
    RefreshTokenResponseWrapper wrapper = RefreshTokenResponseWrapper.parseJson(response.getBody());
    List<Token__c> tokens = [SELECT Name, Value__c FROM Token__c WHERE Name = 'access_token' LIMIT 1];
    if (tokens.size() <= 0) {
      Token__c new_token = new Token__c();
      new_token.Name = 'access_token';
      new_token.Value__c = wrapper.access_token;
      insert new_token;
    } else {
      tokens[0].Value__c = wrapper.access_token;
      update tokens;
    }
  }
}