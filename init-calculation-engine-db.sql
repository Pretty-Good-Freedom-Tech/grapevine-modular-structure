/*
SQLITE

MAIN DATABASE: GrapevineCalculationEngine.db

ONE SET OF TABLES PER ENGINE:

table1: Raw Data types (nostr, AI, Amazon, etc) rawDataTypes -- rawDataTypes
table2: Interp Engines for each raw data type -- interpretationEngines
table3: raw data Engine for each type  -- rawDataEngines
table4: available interpretation protocols for each Interp Engine -- interpretationProtocols
table5: users (customers) -- users

for each new user, make a new database:
SINGLE USER DATABASE: <pk_Alice>_GCE.db

userTable1: GrapeRank Scorecards (G) -- grapeRankScorecards
userTable2: GrapeRank Ratings (R) -- grapeRankRatings
userTable3: standard Grapevine Calculation Parameters (attenFactor, rigor, defaults (?), etc) -- grapevineCalculationParams
userTable4: protocol-specific parameters (score, confidence, etc) -- protocolParams
userTable4: worldviews Grapevine Worldview tables

*/

----------------- MAIN DATABASE, 5 tables

-- Create main database
GrapevineCalculationEngine.db

-- table1
CREATE TABLE rawDataTypes(
  ID INT PRIMARY KEY NOT NULL,
  SLUG TEXT NOT NULL,
  NAME TEXT NOT NULL,
  DESCRIPTION TEXT,
);

INSERT INTO rawDataTypes [(slug, name, description)] VALUES ("nostrRelay", "nostr relay", "lorem ipsum"); -- id: 0
INSERT INTO rawDataTypes [(slug, name, description)] VALUES ("chatGPT", "Chat GPT", "lorem ipsum"); -- id: 1
INSERT INTO rawDataTypes [(slug, name, description)] VALUES ("Amazon", "Amazon", "lorem ipsum"); -- id: 2

-- table2
CREATE TABLE interpretationEngines(
  ID INT PRIMARY KEY NOT NULL,
  rawDataTypeID INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
);

INSERT INTO interpretationEngines [(rawDataTypeID, slug, name)] VALUES (0, "ManiMeNostrInterpEngine", "ManiMe's Awesome Nostr Interpretation Engine");

/* table3 MIGHT BELONG INSIDE THE INTERPRETATION ENGINE, BC IT'S STRUCTURE WILL DEPEND ON THE RAW DATA TYPE. */
-- table3
CREATE TABLE rawDataEngines_nostrRelays(
  ID INT PRIMARY KEY NOT NULL,
  rawDataTypeID INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
);

INSERT INTO rawDataEngines_nostrRelays [(rawDataTypeID, name)] VALUES (0, "cloudfodder's Awesome Grapevine Relay", "wss://brainstorm.nostr1.com");

-- table4
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
);

-- table5
CREATE TABLE users(
  ID INT PRIMARY KEY NOT NULL,
);

------------- ONE DATABASE PER USER, 4 tables

-- Create user-specific database
<pk_Alice>_GCE.db;

-- userTable1
CREATE TABLE grapeRankScorecards(
  ID INT PRIMARY KEY NOT NULL,
);

-- userTable2
CREATE TABLE grapeRankRatings(
  ID INT PRIMARY KEY NOT NULL,
);

-- userTable3
CREATE TABLE grapevineCalculationParams(
  ID INT PRIMARY KEY NOT NULL,
);

-- userTable4
CREATE TABLE protocolParams(
  ID INT PRIMARY KEY NOT NULL,
);


