require "pg"
require "terminal-table"

class RestInsights
    def initialize
        @db = PG.connect(dbname: "insights")
    end

    def start
        puts "\n"
        welcome
        menu
        puts "\n"
        print "> "
        option, action = gets.chomp.split
        until option == "exit"
            case option
            when "menu" then menu
            when "1" then list_of_restaurants
            when "2" then puts "list of dishes here"
            when "3" then puts "distribution users here"
            when "4" then puts "top ten by visitors here"
            when "5" then puts "top ten by sales here"
            when "6" then puts "top ten by avg per user here"
            when "7" then puts "avg consumer expenses here"
            when "8" then puts "total sales by month here"
            when "9" then puts "best price for dish here"
            when "10" then puts "favorite dish here"
            else puts "Enter a valid option please"
            end
            print "> "
            option, action = gets.chomp.split
        end
    end

    def welcome
        puts [
            "Welcome to the Restaurants Insights!",
            "Write 'menu' at any moment to print the menu again and 'quit' to exit."
        ]
    end

    def menu
        puts "-" * 5
        puts [
            " 1. List of restaurants included in the research filter by ['' | category=string | city=string]",
            " 2. List of unique dishes included in the research",
            " 3. Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]",
            " 4. Top 10 restaurants by the number of visitors.",
            " 5. Top 10 restaurants by the sum of sales.",
            " 6. Top 10 restaurants by the average expense of their clients.",
            " 7. The average consumer expense group by [group=[age | gender | occupation | nationality]]",
            " 8. The total sales of all the restaurants group by month [order=[asc | desc]]",
            " 9. The list of dishes and the restaurant where you can find it at a lower price.",
            " 10. The favorite dish for [age=number | gender=string | occupation=string | nationality=string]",
            ]
        puts "-" * 5 
    end

    def generate_table(result_query, title)
        table = Terminal::Table.new
        table.title = title
        table.headings = result_query.fields
        table.rows = result_query.values
        puts table
    end

    # list of restaurants: start

    def list_of_restaurants(action = nil)
        result = list unless action
        generate_table(result, "List of restaurants")
    end

    def list
        @db.exec(
            "SELECT name, category, city
            FROM restaurants;"
        )
    end

    #list of restaurants: end
end

app = RestInsights.new
app.start