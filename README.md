## 1. The goal of the project
a) Use publicly available data on Facebook in order to build a database with which it would later be possible to group Facebook users according to certain categories (e.g. find out which T-Com subscribers are satisfied or not satisfied with their operator's service), and later potentially use this data for marketing and sales purposes.

b) Simulate the process of database formation, data normalization, creation of current (SCD1) and hist (SCD2) tables, procedures for their filling, administration of the database and data, and creation of reports for analysis through BI tools. So, one of my goals was to gain as much practice as possible, to simulate a possible business case.

## 2. Database
### 2.1. Database "Stage"!

Using Python, the data from Facebook was inserted into the transaction database "Stage", which consisted of seven tables (like telco.FacebookPosts) in which the data was not normalized (raw data).

### 2.2. Database "RDL" (Relational Database Layer)

The "RDL" database is the one in which the data, i.e. the tables, will be normalized in accordance with the normalization norms.
After creating the ER diagram (showing all the tables and the connections between them) and the database itself, I started to create the tables, current, and hist. Current tables (SCD1) are those in which we do not need historical data, that is, we only want current data.

We created history tables according to the SCD2 rule, that is, we want to keep the history of a record in them, as it changed over time. This means that the hist table will have more columns than the current. We add special columns like Valid_From, Valid_To, and Current_Flag (to distinguish current and historical values).

When I created all the necessary basic current and hist tables (facebook.Posts, facebook.Comments, facebook.Replies, facebook.Users, facebook.Companies and facebook.Videos and their hist versions), it was necessary to create new so-called connection tables, that is, tables that will enable the creation of joins between all those tables! Apart from the so-called current, hist and connection tables had to be created as the so-called codebook of the facebook.CommentsReactionsTypes and facebook.RepliesReactionTypes tables, which were the simplest, i.e. they contained only the id column and types of reactions that can be placed on comments and replies to comments. !
