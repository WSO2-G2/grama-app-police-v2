import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;



type policeData record {
    string nic;
    string isRecord;
};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    isolated resource function get getalldetails(string nic) returns boolean|error? {
        final mysql:Client mysqlEp = check new (host = "workzone.c6yaihe9lzwl.us-west-2.rds.amazonaws.com", user = "admin", password = "Malithi1234", database = "gramaPoliceCheck", port = 3306);
        policeData[] policeDetail=[];

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
             return  true;
         }

         else{
             return  false;
         }



        //return policeDetail.length();

    }
}

