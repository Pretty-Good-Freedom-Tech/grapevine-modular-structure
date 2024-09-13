-- SQLITE

-- DATABASE: GrapevineCalculationEngine.db

-- ONE SET OF TABLES PER ENGINE:
-- table1: Raw Data types (nostr, AI, Amazon, etc)
-- table2: raw data Engine for each type 
-- table3: Interp Engines for each raw data type
-- table4: available protocols for each Interp Engine
-- table5: users (customers)

-- ONE SET OF BELOW TABLES FOR EACH USER (perhaps make a new database for each user??)
-- DATABASE: <pk_Alice>_GCE.db
-- userTable1: GrapeRankScorecards tables (G)
-- userTable2: ? GrapeRankRatings tables (R)
-- userTable3: various param tables
-- userTable4: Grapevine Worldview tables

-- Create main database

GrapevineCalculationEngine.db

-- create table1 and insert some rows
CREATE TABLE rawDataTypes(
  ID INT PRIMARY KEY NOT NULL,
  NAME TEXT NOT NULL,
  DESCRIPTION TEXT,
);

INSERT INTO rawDataTypes [(name, description)] VALUES ("nostr relay", "lorem ipsum");
INSERT INTO rawDataTypes [(name, description)] VALUES ("ChatGPT", "lorem ipsum");
INSERT INTO rawDataTypes [(name, description)] VALUES ("Amazon", "lorem ipsum");
