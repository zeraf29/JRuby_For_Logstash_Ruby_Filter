#Ruby Filter source for Combine value to One string
#06.08.21 zeraf29
#You can use this by calling on Logstash ruby filter

#example call ruby filter on logstash
#filter {
#     ruby {
#       path => "/etc/logstash/drop_percentage.rb"
#       script_params => {
#           "max_run" => 10     
#           "target_event" => "target_event" #logstash event field name what you want to combine
#       }
#    }
#  }

def register(params)
    #total event count(how many event values to one string
    MAX_RUN = params["max_run"]
    TARGET_EVENT = params["target_event"]
    @combinedString = ''
    @runCount = 0 #check now running count 
end

def filter(event)
    if !event.get(TARGET_EVENT).nil? && event.get(TARGET_EVENT)!=''
        @combinedString += (@combinedString != '' ? ',' : '') + event.get(TARGET_EVENT)
    end
    @runCount += 1
    if MAX_RUN == @runCount
        event.set('combined_string', @combinedString)
    end
    @runCount = 0
    @combinedString = ''
    return [event]
end
    