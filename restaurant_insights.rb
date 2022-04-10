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
      when "4" then top_ten_visitors
      when "5" then top_ten_sales
      when "6" then top_ten_average_expense
      when "7" then avg_consumer_expenses(action)
      when "8" then sales_by_month(action)
      when "9" then best_price_dish
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
      " 10. The favorite dish for [age=number | gender=string | occupation=string | nationality=string]"
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
      result = @db.exec(%(
               SELECT name, category, city
               FROM restaurants
               WHERE category LIKE '%#{value}%';
            ))
    when "city"
      result = @db.exec(%(
                SELECT name, category, city
                FROM restaurants
                WHERE city = #{value};
            ))
    end
    result
  end

  # list of restaurants: end

  # list of dishes: start

  def list_of_dishes
    result = @db.exec(
      "SELECT name FROM dishes;"
    )
    generate_table(result, "List of dishes")
  end

  # list of dishes: end

  # num and distribution of users: start

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

  # num and distribution of users: end

  # favorite_dish: start

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

  # favorite_dish: end

  # avg_consumer_expenses: start

  def avg_consumer_expenses(action)
    type, value = action.split("=")
    result = @db.exec(%[
            SELECT #{value}, ROUND(AVG(rd.price),3) AS "avg expense" FROM clients AS c
            JOIN clients_restaurant AS cr ON c.id = cr.client_id
            JOIN restaurant_dishes AS rd ON cr.restaurant_dishes_id = rd.id
            GROUP BY c.#{value}
            ORDER BY c.#{value};
        ])
    generate_table(result, "Average consumer expenses")
  end

  # avg_consumer_expenses: end

  # sales_by_month: start

  def sales_by_month(action)
    type, value = action.split("=")
    result = @db.exec(%[
            SELECT TO_CHAR(visit_date,'Month') AS month ,COUNT(*) AS sales
            FROM clients_restaurant
            GROUP BY TO_CHAR(visit_date,'Month')
            ORDER BY sales #{value};
        ])

    generate_table(result, "Total sales by month")
  end

  # sales_by_month: end

  # best_price_dish: start

  def best_price_dish
    result = @db.exec(%[
            SELECT DISTINCT ON (d.name) d.name AS dish ,
            r.name AS restaurant ,
            rd.price AS price FROM dishes AS d
            JOIN restaurant_dishes AS rd ON d.id = rd.dish_id
            JOIN restaurants AS r ON r.id = rd.restaurant_id
            ORDER BY d.name ,rd.price ASC;
        ])
    generate_table(result, "Best price for dish")
  end

  # best_price_dish: end

  # top ten restaurants by visitors: start

  def top_ten_visitors
    result = @db.exec(%[
            SELECT r.name , COUNT(cr.id) AS visitors
            FROM restaurants AS r
            JOIN restaurant_dishes AS rd ON r.id=rd.restaurant_id
            JOIN clients_restaurant AS cr ON rd.id=cr.restaurant_dishes_id
            GROUP BY r.name
            ORDER BY visitors DESC
            LIMIT 10;
        ])
    generate_table(result, "Top 10 restaurants by visitors")
  end

  # top ten restaurants by visitors: end

  # top ten restaurants by sales: start

  def top_ten_sales
    result = @db.exec(%[
            SELECT r.name , SUM(rd.price) AS sales
            FROM restaurants AS r
            JOIN restaurant_dishes AS rd ON r.id=rd.restaurant_id
            GROUP BY r.name
            ORDER BY sales DESC
            LIMIT 10;
        ])
    generate_table(result, "Top 10 restaurants by sales")
  end

  # top ten restaurants by sales: end

  # top ten restaurants by average expenses: start

  def top_ten_average_expense
    result = @db.exec(%[
            SELECT r.name , ROUND(AVG(rd.price), 1) AS "avg expense" FROM clients AS c
            JOIN clients_restaurant AS cr ON cr.client_id=c.id
            JOIN restaurant_dishes AS rd ON rd.id=cr.restaurant_dishes_id
            JOIN restaurants as r ON r.id =rd.restaurant_id
            GROUP BY r.name
            ORDER BY "avg expense" DESC 
            LIMIT 10;
        ])
    generate_table(result, "Top 10 restaurants by average expense per user")
  end

  # top ten restaurants by average expenses: end
end

app = RestInsights.new
app.start
