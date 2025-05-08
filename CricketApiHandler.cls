public class CricketApiHandler {
    public static string apikey='bc392fad-1df2-4483-a7e9-bf62daf04979';
    public class cric{
        @AuraEnabled public String series;
    @AuraEnabled public String matchType;
    @AuraEnabled public String status;
    @AuraEnabled public String t1;
    @AuraEnabled public String t2;
    @AuraEnabled public String t1s;
    @AuraEnabled public String t2s;
    @AuraEnabled public String t1img;
    @AuraEnabled public String t2img;
    @AuraEnabled public Date dateTimeGMT;
    @AuraEnabled public String score;
    }
    @AuraEnabled(cacheable=true)
    public static list<cric> handler(){
         
         List<cric> matchList = new List<cric>();
        httpRequest req=new httpRequest();
        http http=new http();
        req.setEndpoint('https://api.cricapi.com/v1/cricScore?apikey='+apikey);
        req.setMethod('GET');
        httpResponse res=new httpResponse();
        res=http.send(req);
        if(res.getStatusCode()==200){
            system.debug(res.getBody());
            string responseBody=res.getBody();
            Map<String, Object> fullResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            
            if(fullResponse.containsKey('data')){
               list<object> cricketData=(list<object>) fullResponse.get('data');
                if(!cricketData.isempty()){
                    for(object we:cricketData){
                      map<string,object> cricInfo=(map<string,object>)we; 
                        cric matchData = new cric();
                          matchData.series = (String) cricInfo.get('series');
                    matchData.matchType = (String) cricInfo.get('matchType');
                    matchData.status = (String) cricInfo.get('status');
                    matchData.t1 = (String) cricInfo.get('t1');
                    matchData.t2 = (String) cricInfo.get('t2');
                    matchData.t1s = (String) cricInfo.get('t1s');
                    matchData.t2s = (String) cricInfo.get('t2s');
                    matchData.t1img = (String) cricInfo.get('t1img');
                    matchData.t2img = (String) cricInfo.get('t2img');

                        
                         String dateTimeStr = (String) cricInfo.get('dateTimeGMT');
                    if (dateTimeStr != null && dateTimeStr.length() >= 10) {
                        matchData.dateTimeGMT=(Date.valueOf(dateTimeStr.substring(0, 10)));
                    } 

                    // Construct score string (optional - based on what's available)
                     matchData.score = 'Score: ' + matchData.t1s + ' vs ' + matchData.t2s;

                    matchList.add(matchData);
                    }
                    
                    
                }
            }
            
        }
        return matchList;
    }
}