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
        option, action = gets.chomp.split(" ", 2)
        until option == "exit"
            case option
            when "menu" then menu
            when "1" then list_of_restaurants(action)
            when "2" then list_of_dishes
            when "3" then num_dist_user(action)
            when "4" then puts "top ten by visitors here"
            when "5" then puts "top ten by sales here"
            when "6" then puts "top ten by avg per user here"
            when "7" then puts "avg consumer expenses here"
            when "8" then puts "total sales by month here"
            when "9" then puts "best price for dish here"
            when "10" then favorite_dish(action)
            else puts "Enter a valid option please"
            end
            print "> "
            option, action = gets.chomp.split(" ", 2)
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

    def list_of_restaurants(action)
        result = list unless action
        result = list_with_filter(action) if action
        generate_table(result, "List of restaurants")
    end

    def list
        @db.exec(
            "SELECT name, category, city
            FROM restaurants;"
        )
    end

    def list_with_filter(action)
        type, value = action.split("=")
        case type
        when "category"
            result = @db.exec(%[
               SELECT name, category, city
               FROM restaurants
               WHERE category LIKE '%#{value}%'; 
            ])
        when "city"
            result = @db.exec(%[
                SELECT name, category, city
                FROM restaurants
                WHERE city = #{value};
            ])
        end
        result
    end

    #list of restaurants: end

    #list of dishes: start

    def list_of_dishes
        result = @db.exec(
            "SELECT name FROM dishes;"
        )
        generate_table(result, "List of dishes")
    end

    #list of dishes: end

    #num and distribution of users: start
    
    def num_dist_user(action)
        type, value = action.split("=")
        result = @db.exec(%[
            SELECT #{value}, COUNT(*),
            CONCAT((COUNT(*) * 100 / (SELECT COUNT(*) FROM clients)), '%')
            AS percentage
            FROM clients GROUP BY #{value};
        ])
        generate_table(result, "Number and Distribution of Users")
    end
    
    #num and distribution of users: end

    #favorite_dish: start

    def favorite_dish(action)
    type, value = action.split("=")
    result = @db.exec(%[
        SELECT c.#{type}, d.name AS dish , COUNT(*)
        FROM clients AS c
        JOIN clients_restaurant AS cr
        ON cr.client_id = c.id
        JOIN restaurant_dishes AS rd
        ON cr.restaurant_dishes_id = rd.id
        JOIN dishes AS d
        ON rd.dish_id = d.id
        WHERE c.#{type} = '#{value}'
        GROUP BY #{type}, dish
        ORDER BY count 
        DESC LIMIT 1;
    ])
    generate_table(result, "Favorite dish")
    end

    #favorite_dish: end
end

app = RestInsights.new
app.start
