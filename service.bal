import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

configurable int PORT = ?;
configurable string DB = ?;
configurable string PASSWORD = ?;
configurable string USER = ?;
configurable string HOST = ?;


type policeData record {
    string nic;
    string isRecord;
};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    isolated resource function get getalldetails(string nic) returns json|error? {
        final mysql:Client mysqlEp = check new (host = HOST, user = USER, password = PASSWORD, database = DB, port = PORT);
        policeData[] policeDetail=[];
        boolean result;

        stream<policeData, error?> queryResponse = mysqlEp->query(sqlQuery = `SELECT * FROM userDetails where nic=${nic}`);
        check from policeData data in queryResponse
            do {
                policeDetail.push(data);
            };
        check queryResponse.close();
        error? e =  mysqlEp.close();
           if(e is error){
            return e;
         }

         if(policeDetail.length()==0){
             result = false;
         }

         else{
             result = true;
         }

         json response = {
        statusCode: 200,
        headers: {
            "Access-Control-Allow-Headers" : "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
        },
        body: result.toJsonString()
    };
        return response;



        //return policeDetail.length();

    }
}

