require "pg"

class RestInsights
    def initialize
        @db = PG.connect(dbname: "insights")
    end

    def start
        welcome
    end

    def welcome
        message = ["Welcome to the Restaurants Insights!",
        "Write 'menu' at any moment to print the menu again and 'quit' to exit."]
        puts message
    end
end

app = RestInsights.new
app.start