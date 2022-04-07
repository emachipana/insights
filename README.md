# Insights

![https://images.all-free-download.com/images/graphicthumb/insight_propaganda_marketing_126027.jpg](https://images.all-free-download.com/images/graphicthumb/insight_propaganda_marketing_126027.jpg)

Insights is a local, global-oriented measurement and data analytics startup that
(in our opinion) provides (almost) the most complete and trusted view available
of consumers and markets.

For more than 30 days, Insights has provided data and analytics based on
scientific rigor and innovation (sort of), continually developing new ways to
answer the most important questions facing the media, advertising, retail and
fast-moving consumer goods industries. As an S&P 500 company wannabe, Insights
has operations in over 3 or 4 bedrooms with access to the whole world
information through the internet.

Our self-awarded team of analysts works untiringly to process and share insights
of all kinds of data collected (or generated) by committed volunteer(s).

Our research team has acquired a large dataset on the consumption of 500 people
in 100 restaurants around the world for a set of 50 specific dishes during the
year 2019.

The data has come on a raw [CSV file](https://drive.google.com/file/d/1FAwitP9JY9r9mynhme_U7hKxhA77df1c/view) with this form:

![https://p-vvf5mjm.t4.n0.cdn.getcloudapp.com/items/YEuBdPb5/6dc01c0f-8290-46b3-ab6e-31302ab5e4ff.jpg?source=viewer&v=5699773fe79c17fad1f0379643e1798b](https://p-vvf5mjm.t4.n0.cdn.getcloudapp.com/items/YEuBdPb5/6dc01c0f-8290-46b3-ab6e-31302ab5e4ff.jpg?source=viewer&v=5699773fe79c17fad1f0379643e1798b)

<aside> 💡 On December 06, 2019, Jewel Daniel, a physicist Romanian man, 28
years old, visited "Fat Pizza", an "Italian" restaurant located in Haleyport
city (790 Corrine Prairie), and ordered a Lasagna which cost him $34.</aside>

As the developer/analyst team of Insights, your job is to transform this raw
data into a clean and manageable relational database and answer the deep
questions the research team have come up with.

---

## Tasks

### Create an Entity Relationship Diagram (ERD)

At this point, it should be quite obvious that the current CSV file is not
normalized. It is just one single table with a lot of repeated data.

Take a moment with your team to analyze and normalize this table and prepare an
ERD which shows `tables`, `columns`, `columns_types`, `constrains`, and
`relationships`. You can use any software you want for this. Even pencil and
paper would be enough.

You should include an image of your ERD (png, jpg, pdf) on your solution.

### Create the database and tables

Using Data Definition Language (DDL) statements, create the database and tables
according to your Entity Relationship Diagram.

Put all your SQL code inside a file named `create.sql`. Check the order of your
commands! For example, you can't `REFERENCES clients(id)` if the table "clients"
doesn't exist yet.

If your `create.sql` file works well, you should be able to delete your entire
database and create it again doing something similar to:

```bash
$ dropdb insights
$ createdb insights
$ psql -d insights < create.sql
CREATE TABLE
CREATE TABLE
...
CREATE TABLE
$ 
```

Include the `create.sql` file on your solution.

### Populate your tables

The `data.csv` file has more than 85K records. Inserting that amount of data
manually is not an option. Create a ruby application to upload all the records
to your database.

The program should be called `insert_data.rb` and should take two arguments
`database_name` and `csv_file_path`.

Include the `insert_data.rb` file on your solution.

### CLI app to interact with the database

Now we have the database ready to start receiving queries. The research team has
required the development of a CLI app to share some insights about the
Restaurant consumption data with our users.

<aside> 💡 All the example tables are using dummy data. Their numbers do not
represent the expected result, just the expected format.

</aside>

**Client can see a menu**

As a client, I want to run the application and see a menu with a list of options
so that I could choose the topic I am most interested in.

- When I run the command `ruby restaurant-insights.rb` I see a welcome message
- And below the welcome message, I see a list with 10 options
- And I'm prompted to choose one option with the message
  `Pick a number from the list and an [option] if necessary`
- And when I write 'menu' the Welcome message and menu are printed again.
- And when I write 'quit' the program ends.

```bash
$ ruby restaurant-insights.rb
Welcome to the Restaurants Insights!
Write 'menu' at any moment to print the menu again and 'quit' to exit.
---
1. List of restaurants included in the research filter by ['' | category=string | city=string]
2. List of unique dishes included in the research
3. Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]
4. Top 10 restaurants by the number of visitors.
5. Top 10 restaurants by the sum of sales.
6. Top 10 restaurants by the average expense of their clients.
7. The average consumer expense group by [group=[age | gender | occupation | nationality]]
8. The total sales of all the restaurants group by month [order=[asc | desc]]
9. The list of dishes and the restaurant where you can find it at a lower price.
10. The favorite dish for [age=number | gender=string | occupation=string | nationality=string]
---
Pick a number from the list and an [option] if necessary
>
```

**User can see the list of restaurants**

As a user, I want to use option #1 of the menu so that I can see the list of
restaurants filter by category or city.

Usage:

```bash
# Without filter option
> 1
+-----------------------------------------------------+
|                 List of restaurants                 |
+----------------------+------------+-----------------+
| name                 | category   | city            |
+----------------------+------------+-----------------+
| Blue Plate Brasserie | Assian     | Belvastad       |
+----------------------+------------+-----------------+
| Fast Curry           | Italian    | Rohanberg       |
+----------------------+------------+-----------------+
| Golden Bar & Grill   | Burgers    | South Saranstad |
+----------------------+------------+-----------------+
| ...                  | ...        | ...             |
+----------------------+------------+-----------------+

# With filter category
> 1 category=Italian
+-------------------------------------------------+
|               List of restaurants               |
+--------------------+----------+-----------------+
| name               | category | city            |
+--------------------+----------+-----------------+
| Golden Bar & Grill | Italian  | South Saranstad |
+--------------------+----------+-----------------+
| Blue Plate Diner   | Italian  | South Hilde     |
+--------------------+----------+-----------------+
| Salty Bar & Grill  | Italian  | Rohanberg       |
+--------------------+----------+-----------------+
| ...                | ...      | ...             |
+--------------------+----------+-----------------+
# With filter city
	>1 city='South Hilde'
+------------------------------------------+
|            List of restaurants           |
+---------------+------------+-------------+
| name          | category   | city        |
+---------------+------------+-------------+
| Orange BBQ    | Italian    | South Hilde |
+---------------+------------+-------------+
| Golden Burger | Burgers    | South Hilde |
+---------------+------------+-------------+
| Big Eats      | Thai       | South Hilde |
+---------------+------------+-------------+
| ...           | ...        | ...         |
+---------------+------------+-------------+
```

**User can see the list of unique dishes**

As a user, I want to use option #2 of the menu so that I can see the list of
unique dishes included.

Usage:

```bash
> 2
+-----------------------------+
|        List of dishes       |
+-----------------------------+
| name                        |
+-----------------------------+
| Arepas                      |
+-----------------------------+
| Pasta with Tomato and Basil |
+-----------------------------+
| Sushi                       |
+-----------------------------+
| ...                         |
+-----------------------------+
```

**User can see the number and distribution of clients**

As a user I want to use option #3 of the menu so that I can see the list with
the number and distribution of clients group by age, gender, occupation or
nationality.

Usage:

```bash
## group by age
> 3 group=age
+----------------------------------+
| Number and Distribution of Users |
+--------+----------+--------------+
| age    | count    | percentage   |
+--------+----------+--------------+
| 18     | 25       | 5%           |
+--------+----------+--------------+
| 19     | 50       | 10%          |
+--------+----------+--------------+
| 20     | 75       | 15%          |
+--------+----------+--------------+
| ...    | ...      | ...          |
+--------+----------+--------------+

## group by gender
> 3 group=gender
+----------------------------------+
| Number and Distribution of Users |
+----------+---------+-------------+
| gender   | count   | percentage  |
+----------+---------+-------------+
| Male     | 250     | 50%         |
+----------+---------+-------------+
| Female   | 250     | 50%         |
+----------+---------+-------------+

## group by occupation
> 3 group=occupation
+--------------------------------------+
|   Number and Distribution of Users   |
+-----------------+-------+------------+
| occupation      | count | percentage |
+-----------------+-------+------------+
| Artist          | 25    | 5%         |
+-----------------+-------+------------+
| Attorney at Law | 50    | 10%        |
+-----------------+-------+------------+
| Bartender       | 75    | 15%        |
+-----------------+-------+------------+
| ...             | ...   | ...        |
+-----------------+-------+------------+

## group by nationality
> 3 group=nationality
+-----------------------------------+
|  Number and Distribution of Users |
+--------------+-------+------------+
| nationality  | count | percentage |
+--------------+-------+------------+
| Albanians    | 25    | 5%         |
+--------------+-------+------------+
| Argentines   | 50    | 10%        |
+--------------+-------+------------+
| Bangladeshis | 75    | 15%        |
+--------------+-------+------------+
| ...          | ...   | ...        |
+--------------+-------+------------+
```

**User can see the top 10 restaurants by the number of visitors**

As a user I want to use option #4 of the menu so that I can see the top 10
restaurants by the number of visitors.

Usage

```bash
> 4
+--------------------------------+
| Top 10 restaurants by visitors |
+--------------------+-----------+
| name               | visitors  |
+--------------------+-----------+
| Orange BBQ         | 350       |
+--------------------+-----------+
| Blue Plate Diner   | 300       |
+--------------------+-----------+
| Smokestack Dragon  | 250       |
+--------------------+-----------+
| ...                | ...       |
+--------------------+-----------+
```

**User can see the top 10 restaurants by the sum of sales**

As a user I want to use option #5 of the menu so that I can see the top 10
restaurants by the sum of sales.

Usage:

```bash
> 5
+-----------------------------+
| Top 10 restaurants by sales |
+--------------------+--------+
| name               | sales  |
+--------------------+--------+
| Smokestack Dragon  | 9500   |
+--------------------+--------+
| Blue Plate Diner   | 7500   |
+--------------------+--------+
| Fat Pizza          | 5500   |
+--------------------+--------+
| ...                | ...    |
+--------------------+--------+
```

**User can see the top 10 restaurants by the average expense of their clients**

As a user I want to use option #6 of the menu so that I can see the top 10
restaurants by the average expense of their clients.

Usage:

```bash
> 6
+------------------------------------------------+
| Top 10 restaurants by average expense per user |
+---------------------------+--------------------+
| name                      | avg expense        |
+---------------------------+--------------------+
| Big Eats                  | 50.5               |
+---------------------------+--------------------+
| Smokestack Dragon         | 48.3               |
+---------------------------+--------------------+
| Orange BBQ                | 45.6               |
+---------------------------+--------------------+
| ...                       | ...                |
+---------------------------+--------------------+
```

**User can see the average consumer expense**

As a user I want to use option #7 of the menu so that I can see the average
consumer expense group by age, gender, occupation or nationality

Usage:

```bash
## group by age
> 7 group=age
+---------------------------+
| Average consumer expenses |
+---------+-----------------+
| age     | avg expense     |
+---------+-----------------+
| 30      | 50.5            |
+---------+-----------------+
| 25      | 48.3            |
+---------+-----------------+
| 45      | 45.6            |
+---------+-----------------+
| ...     | ...             |
+---------+-----------------+

## group by gender
> 7 group=gender
+---------------------------+
| Average consumer expenses |
+-----------+---------------+
| gender    | avg expense   |
+-----------+---------------+
| Male      | 50.5          |
+-----------+---------------+
| Female    | 48.3          |
+-----------+---------------+

## group by occupation
> 7 group=occupation
+---------------------------+
| Average consumer expenses |
+-------------+-------------+
| occupation  | avg expense |
+-------------+-------------+
| Electrician | 50.5        |
+-------------+-------------+
| Businessman | 48.3        |
+-------------+-------------+
| Hairdresser | 45.2        |
+-------------+-------------+
| ...         | ...         |
+-------------+-------------+

## group by nationality
> 7 group=nationality
+---------------------------+
| Average consumer expenses |
+-------------+-------------+
| nationality | avg expense |
+-------------+-------------+
| Colombians  | 50.5        |
+-------------+-------------+
| Quebecers   | 48.3        |
+-------------+-------------+
| Ukrainians  | 45.2        |
+-------------+-------------+
| ...         | ...         |
+-------------+-------------+
```

**User can see the total sales of all the restaurants grouped by month**

As a user I want to use option #8 of the menu so that I can see the total sales
of all the restaurants grouped by month.

Usage

```bash
## ascendant order
> 8 order=asc
+----------------------+
| Total sales by month |
+-------------+--------+
| month       | sales  |
+-------------+--------+
| May         | 35000  |
+-------------+--------+
| October     | 38000  |
+-------------+--------+
| September   | 40000  |
+-------------+--------+
| ...         | ...    |
+-------------+--------+
## descendant order
> 8 order=desc
+----------------------+
| Total sales by month |
+------------+---------+
| month      | sales   |
+------------+---------+
| June       | 100000  |
+------------+---------+
| April      | 85000   |
+------------+---------+
| December   | 70000   |
+------------+---------+
| ...        | ...     |
+------------+---------+

```

**Optional: User can see the best deal for a dish**

As a user I want to use option #9 of the menu so that I can see the list of
dishes and the restaurant where you can find it at a lower price.

Usage:

```bash
> 9
+---------------------------------------------------+
|                Best price for dish                |
+------------------------+------------------+-------+
| dish                   | restaurant       | price |
+------------------------+------------------+-------+
| Arepas                 | Orange BBQ       | 18    |
+------------------------+------------------+-------+
| Barbecue Ribs          | Silver Brasserie | 20    |
+------------------------+------------------+-------+
| Bruschette with Tomato | Golden Curry     | 19    |
+------------------------+------------------+-------+
| ...                    | ...              | ...   |
+------------------------+------------------+-------+
```

**Optional: User can see favorite dish for a group of clients**

As a client I want to use option #10 of the menu so that I can see the favorite
dish filter by a specific age, gender, occupation or nationality

Usage:

```bash
## filter by age
> 10 age=35
+----------------------+
|     Favorite dish    |
+-----+--------+-------+
| age | dish   | count |
+-----+--------+-------+
| 35  | Arepas | 18    |
+-----+--------+-------+

## filter by gender
> 10 gender=Female
+-------------------------+
|      Favorite dish      |
+--------+--------+-------+
| gender | dish   | count |
+--------+--------+-------+
| Female | Arepas | 18    |
+--------+--------+-------+

## filter by occupation
> 10 occupation=Electrician
+------------------------------+
|         Favorite dish        |
+-------------+--------+-------+
| occupation  | dish   | count |
+-------------+--------+-------+
| Electrician | Arepas | 18    |
+-------------+--------+-------+

## filter by nationality
> 10 nationality=Colombians
+------------------------------+
|         Favorite dish        |
+-------------+--------+-------+
| nationality | dish   | count |
+-------------+--------+-------+
| Colombians  | Arepas | 18    |
+-------------+--------+-------+
```
