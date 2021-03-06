require "pg"
require "csv"

DB = PG.connect(dbname: "insights")

def insert(table, data, unique_column = nil)
  entity = nil

  entity = find(table, unique_column, data[unique_column]) if unique_column

  entity ||= DB.exec(%[INSERT INTO #{table} (#{data.keys.join(', ')})
        VALUES (#{data.values.map { |value| "'#{value.gsub("'", "''")}'" }.join(', ')})
        RETURNING *;]).first
  entity
end

def find(table, column, value)
  DB.exec(%(SELECT * FROM #{table}
        WHERE #{column} = '#{value.gsub("'", "''")}';
        )).first
end

CSV.foreach("data.csv", headers: true) do |row|
  clients_data = {
    "name" => row["client_name"],
    "age" => row["age"],
    "gender" => row["gender"],
    "occupation" => row["occupation"],
    "nationality" => row["nationality"]
  }

  clients = insert("clients", clients_data, "name")

  restaurants_data = {
    "name" => row["restaurant_name"],
    "category" => row["category"],
    "adress" => row["address"],
    "city" => row["city"]
  }

  restaurants = insert("restaurants", restaurants_data, "name")

  dishes_data = {
    "name" => row["dish"]
  }

  dishes = insert("dishes", dishes_data, "name")

  restaurant_dishes_data = {
    "restaurant_id" => restaurants["id"],
    "dish_id" => dishes["id"],
    "price" => row["price"]
  }

  restaurant_dishes = insert("restaurant_dishes", restaurant_dishes_data)

  clients_restaurant_data = {
    "client_id" => clients["id"],
    "restaurant_dishes_id" => restaurant_dishes["id"],
    "visit_date" => row["visit_date"]
  }

  insert("clients_restaurant", clients_restaurant_data)
end
