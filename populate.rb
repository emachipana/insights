require "pg"
require "csv"

DB = PG.connect(dbname: "insights")

def insert(table, data, unique_column = nil)
    entity = nil

    entity = find(table, unique_column, data[unique_column]) if (unique_column)

    entity ||=  DB.exec(%[INSERT INTO #{table} (#{data.keys.join(', ')})
        VALUES (#{data.values.map { |value| "'#{value.gsub("'","''")}'"}.join(", ")})
        RETURNING *;]).first
    entity
end

def find(table, column, value)
    DB.exec(%[SELECT * FROM #{table}
        WHERE #{column} = '#{value.gsub("'", "''")}';
        ]).first
end