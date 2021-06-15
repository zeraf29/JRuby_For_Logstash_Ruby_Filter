#Ruby Filter source for JDBC ExecuteUpdate
#06.08.21 zeraf29
#You can use this by calling on Logstash ruby filter
#
#This file designed for jdbc executeUpdate(ex:Delete, Update)
#on Logstash Filter step.
#
#For using this plugin, you must put jdbc library file 
#in logstash lib/jars directory
#ex)/logstash/logstash-core/lib/jars/ojdbc7.jar 

require 'java'

java_import 'oracle.jdbc.OracleDriver'
java_import 'java.sql.DriverManager'

#example call ruby filter on logstash
#filter {
#     ruby {
#       path => "/etc/logstash/drop_percentage.rb"
#       script_params => { 
#           "query" =>  [
#              "DELETE FROM TABLE WHERE column1="
#              ,"::Event_Field_Name" #For calling input event value
#              ," AND ROWNUM <=10"
#          ]
#           "jdbc_url" => "10.0.0.1:1521/SID"
#           "jdbc_user" => "DB_USER"
#           "jdbc_pw" => "DB_PW"
#      }
#    }
#  }
#

def register(params)
    logger.info("Init JDBC ExecuteUpdate Ruby filter")
    @originQueryArr = params["query"]
    @driverManager = java.sql.DriverManager
    @jdbcUrl = params["jdbc_url"]
    @jdbcUser = params["jdbc_user"]
    @jdbcPw = params["jdbc_pw"]
end

def filter(event)
    query = ""
    begin
        @orginQueryArr.each do |str|
            if str.include?"::"
                query += event.get(str.tr('::',''))
            else
                query += str
            end
        end
        conn = @driverManager.getConnection(@jdbcUrl, @jdbcUser, @jdbcPw)
        stmt = conn.createStatement
        logger.info("Query: "+query)
        rs = stmt.executeUpdate(query)
        logger.info("Execute Update - return: "+rs.to_s)
    rescue Exception => e
        conn.close()
        logger.error("JDBC ExecuteUpdate got Exception.: {"+e.class+"}"+e.message)
    ensure
        stmt.close
        conn.close()
        logger.info("JDBC ExecuteUpdate Run Complete")
    end
    return [event]
end