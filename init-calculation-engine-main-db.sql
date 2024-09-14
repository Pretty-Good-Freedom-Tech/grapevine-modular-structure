/*
SQLITE

MAIN DATABASE: GrapevineCalculationEngine.db

ONE SET OF TABLES PER ENGINE:

table1: Raw Data Source Categories (e.g. nostr relay, AI, Amazon, etc) rawDataTypes -- rawDataSourceCategories
table2: Raw Data Sources (e.g. wss://brainstorm.nostr1,com)  -- rawDataSources
table3: Interp Engines for each raw data type -- interpretationEngines
table4: available interpretation protocols for each Interp Engine -- interpretationProtocols
table5: users (customers) -- users

*/

----------------- MAIN DATABASE, 5 tables

-- Create main database
GrapevineCalculationEngine.db

-- table1
CREATE TABLE rawDataSourceCategories(
  ID INT PRIMARY KEY NOT NULL,
  SLUG TEXT NOT NULL,
  NAME TEXT NOT NULL,
  -- ?? rawDataSourceTable TEXT NOT NULL,
  DESCRIPTION TEXT,
);

INSERT INTO rawDataSourceCategories [(slug, name, rawDataSourceTable, description)] VALUES ("nostrRelay", "nostr relay", "rawDataSources_nostrRelays", "lorem ipsum"); -- id: 0
INSERT INTO rawDataSourceCategories [(slug, name, rawDataSourceTable, description)] VALUES ("chatGPT", "Chat GPT", "rawDataSources_chatGPT", "lorem ipsum"); -- id: 1
INSERT INTO rawDataSourceCategories [(slug, name, rawDataSourceTable, description)] VALUES ("Amazon", "Amazon", "rawDataSources_Amazon", "lorem ipsum"); -- id: 2

/* table2 MIGHT BELONG INSIDE THE INTERPRETATION ENGINE, BC IT'S STRUCTURE WILL DEPEND ON THE RAW DATA TYPE. */
-- table2
CREATE TABLE rawDataSources_nostrRelays(
  ID INT PRIMARY KEY NOT NULL,
  -- rawDataSourceCategoryID INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  supportedProtocols TEXT, -- a stringified array of protocolSlugs
);
/*
May also want other columns like: uptime or other performance measures, free vs paid, etc)
*/

INSERT INTO rawDataSources_nostrRelays [(name, url)] VALUES ("cloudfodder's Awesome Grapevine Relay", "wss://brainstorm.nostr1.com");

-- table3
CREATE TABLE interpretationEngines(
  ID INT PRIMARY KEY NOT NULL,
  rawDataSourceCategories INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  supportedProtocols TEXT NOT NULL,
);

INSERT INTO interpretationEngines [(rawDataSourceCategories, slug, name)] VALUES (0, "ManiMeNostrInterpEngine", "ManiMe's Awesome Nostr Interpretation Engine");

-- table4a
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
  rawDataSourceCategories INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  parameterSchema TEXT NOT NULL, -- naddr pointer to a JSON Schema which specifies the required parameters
);

INSERT INTO interpretationProtocols [(rawDataSourceCategories, name)] VALUES (0, "Follows Interpretation"); -- params required fields: score, confidence
INSERT INTO interpretationProtocols [(rawDataSourceCategories, name)] VALUES (1, "Mutes Interpretation"); -- params required fields: score, confidence
INSERT INTO interpretationProtocols [(rawDataSourceCategories, name)] VALUES (2, "Standard Reports Interpretation"); -- params required fields: score, confidence (all reportTypes are treated the same)
INSERT INTO interpretationProtocols [(rawDataSourceCategories, name)] VALUES (3, "Expanded Reports Interpretation"); -- params score & confidence; can vary according to reportType

-- table4b
CREATE TABLE defaultInterpretationProtocolSolutions(
  ID INT PRIMARY KEY NOT NULL,
  interpretationProtocolId INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  parameterSchema TEXT NOT NULL, -- naddr pointer to a JSON Schema which specifies the required parameters
);

INSERT INTO defaultInterpretationProtocolSolutions [(interpretationProtocolId, name)] VALUES (0, "Standard Brainstorm Follows Interpretation"); -- params: score = 1, confidence = 0.05
INSERT INTO defaultInterpretationProtocolSolutions [(interpretationProtocolId, name)] VALUES (1, "Standard Brainstorm Mutes Interpretation"); -- params: score = 0, confidence = 0.1
INSERT INTO defaultInterpretationProtocolSolutions [(interpretationProtocolId, name)] VALUES (2, "Standard Brainstorm Reports Interpretation"); -- params: score = 0, confidence = 0.2 regardless of reportType
INSERT INTO defaultInterpretationProtocolSolutions [(interpretationProtocolId, name)] VALUES (3, "Alternate Brainstorm Reports Interpretation"); -- params: score = 0, confidence = 0.2 for all reportTypes except nudity, which is ignored

-- table4c
CREATE TABLE userInterpretationProtocolSolutions(
  ID INT PRIMARY KEY NOT NULL,
  interpretationProtocolId INT NOT NULL,
  userId INT NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  parameterSchema TEXT NOT NULL, -- naddr pointer to a JSON Schema which specifies the required parameters
);

INSERT INTO userInterpretationProtocolSolutions [(interpretationProtocolId, userId, name)] VALUES (0, AlicdId, "My Usual Brainstorm Follows Interpretation"); -- params: score = 1, confidence = 0.05
INSERT INTO userInterpretationProtocolSolutions [(interpretationProtocolId, userId, name)] VALUES (0, AlicdId, "My Alternate Brainstorm Follows Interpretation"); -- params: score = 1, confidence = 0.08

-- table5
CREATE TABLE users(
  ID INT PRIMARY KEY NOT NULL,
  pubkey TEXT NOT NULL,
);


