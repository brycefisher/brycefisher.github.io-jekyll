---
title: "Ditching Views For SQL, Part 2"
layout: "post"
excerpt: "In this follow up post, I cover how to go about writing your own SQL in Drupal instead of relying on Views. For philosophy of WHY to do this, check out the first post in the series. I'll cover the theming functions in a third part. I'm starting from the assumption that you're already comfortable with SQL."
---
I'm going to dive into some actual code in this post to demostrate Drupal without Views. I'm only going to cover how to write the SQL &mdash; I'll cover the theming functions in a third part. 

I'm starting from the assumption that you're already comfortable with SQL (particularly select statement and joins). If you don't understand what I just wrote, look up tutorials on those topics before trying to read here.

## Database Abstraction Layer in Drupal

The typical pattern for getting data out of the database using SQL is:

1. Examine the database structure
2. Write a working SQL query
3. "Drupalize" the sql syntax
4. Pass the query through `db_query()`
5. Retrieve query results using `while` and `db_fetch_object()`

For this article, we'll write a query that grabs the node ids, titles, and bodies for the last three blog posts. Let's imagine I'm rewriting my homepage view. So we'll want the blog posts in date order, starting with the most recent at the top of the list. At the end of this post, our code should return an array of three each objects with the properties `nid`, `title`, and `body` ordered by created date.

### 1. Examine the Database Structure

There's a lot of tables in Drupal. Usually finding the fields we want involving poking around in the database. **Never poke around the live database** since you could ruin your site. Instead, download a copy of the database to your own computer and look at the database in your favorite MySQL client. If don't have one already, I highly recommend HeidiSQL for windows. You could PhpMyAdmin, but I find it slow and complicated compared to a desktop application like HeidiSQL.

After poking around in my database, I found that the `node` table contained almost everything I needed: the content_type, title, nid (node id), and created. The only thing missing was the body field.

### 2. Write a Working SQL Query
Let's ignore the body field for a moment just get most of our query written:

         SELECT nid, title
            FROM  node
         WHERE type = "article"
            AND status = 1
     ORDER BY created DESC;

If you run that query in the "query" tab on HeidiSQL, you should see three results in the correct order with the nid and title fields. The only thing to explain here is that `status = 1` clause filters out unpublished nodes. So far so good! Okay, let's add in the body field now.

#### Body Field Drupal 6

If you're on Drupal 6, the body field is always stored in the `node_revision` table. Just join the `node` and `node_revision` tables on the vid field. Here's the SQL for Drupal 6:

         SELECT nid, title, body
            FROM node
              JOIN node_revision
                ON node.vid = node_revision.vid
        WHERE type = "article"
              AND status = 1
     ORDER BY created DESC;

#### Body Field Drupal 7

Drupal 7 is a little different. The body field is in the `field_data_body` table, and the field is called body_value. Here's the SQL Drupal 7:

        SELECT nid, title, body_value
            FROM node
              JOIN field_data_body
                ON node.nid = field_data_body.entity_id
         WHERE type = "article"
              AND status = 1
     ORDER BY created DESC;

### 3. Drupalize the SQL Syntax

Drupal's database abstraction layer allows you to automatically prefix your table names in the queries. (It also allows parameterized queries which is vital to security, but it doesn't apply to our situation). Doing this step makes your SQL more portable and is really easy. All we need to do is wrap curly braces around the table names. By convention, queries also use aliases for table names. Here's the SQL for Drupal 6:

         SELECT n.nid, n.title, r.body
            FROM {node} n
              JOIN {node_revision} r
                ON n.vid = r.vid
        WHERE n.type = "article"
              AND n.status = 1
     ORDER BY n.created DESC;

Here's the SQL for Drupal 7:

        SELECT n.nid, n.title, b.body_value
            FROM {node} n
              JOIN {field_data_body} b
                ON n.nid = b.entity_id
         WHERE n.type = "article"
              AND n.status = 1
     ORDER BY n.created DESC;

### 4. Pass the query through `db_query()`

For brevity's sake I'll show you the Drupal 7 version only:

    <?php
    $query = "SELECT n.nid, n.title, b.body_value
            FROM {node} n
              JOIN {field_data_body} b
                ON n.nid = b.entity_id
         WHERE n.type = \"article\"
              AND n.status = 1
     ORDER BY n.created DESC";
     $result = db_query($query);
     ?>

It's important to keep the return value of `db_query()` so that we can actually pull out the individual rows from the database. 

### 5. Retrieve Query Results Using `while` and `db_fetch_object()`

Here's how this bit works. `db_fetch_object` is given the $result of a previously run query. If there is another row among the results, `db_fetch_object` will return an object with each field of the SQL result as a property on the object. In our example, the object will have three properties: title, nid, and body. 

However, if there's no more results from the query, then `db_fetch_object()` returns false. In PHP, if you assign a "falsy" value to a variable, that whole expression evaluates to false. This is really handy in while loops. Again, I'm only showing the Drupal 7 version for brevity (`db_query()` and `db_fetch_object()` are pretty much the same in those versions of drupal). This code follows the code above:

    <?php
    //Store the results here.
    $nodes = array();
    
    //Continue pulling out result rows from the query we ran, but stop if there are no more
    while ($row = db_fetch_object($result)) {
        $nodes[] = $row;
    }
    
    //Output the result to the browser
    var_dump($nodes);
    ?>

Again, the only thing to really explain here is that when db_fetch_object reaches that last row in the result set, it will return false. Setting $row to false makes everything inside the while conditional evaluate to false. That kills the while loop. Simple and elegant!

## Conclusion

In this article, we've walked through some tools to help discover the layouts of tables in Drupal (don't be afraid to explore locally!), written a working SQL query in HeidiSQL, then ported this query to PHP/Drupal code. Ready to implement these features in the theme layer? Keep reading [part 3 in the Ditch Views for SQL saga](http://bryceadamfisher.com/blog/ditching-views-sql-part-3).