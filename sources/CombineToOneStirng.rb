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
    @maxRun = params["max_run"]
    @targetEvent = params["target_event"]
    @combinedString = ''
    @runCount = 0 #check now running count 
end

def filter(event)
    if !event.get(@targetEvent).nil? && event.get(@targetEvent)!=''
        @combinedString += (@combinedString != '' ? ',' : '') + event.get(@targetEvent)
    end
    @runCount += 1
    if @maxRun == @runCount
        event.set('combined_string', @combinedString)
    end
    @runCount = 0
    @combinedString = ''
    return [event]
end
    