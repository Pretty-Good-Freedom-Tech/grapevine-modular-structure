
-- Create core database
GrapevineCalculationEngine_core.db

-- coreTable1
CREATE TABLE users(
  ID INT PRIMARY KEY NOT NULL,
  pubkey TEXT UNIQUE NOT NULL,
  whenSignedUp TIMESTAMP NOT NULL,
  subscriptionPlan TEXT NOT NULL, -- will need to flesh out later what this means
);

-- coreTable2
CREATE TABLE rawDataSourceCategories(
  ID INT PRIMARY KEY NOT NULL,
  SLUG TEXT UNIQUE NOT NULL,
  NAME TEXT NOT NULL,
  DESCRIPTION TEXT,
);

INSERT INTO rawDataSourceCategories [(slug, name)] VALUES ("nostr", "nostr relays"); -- id: 0
INSERT INTO rawDataSourceCategories [(slug, name)] VALUES ("chatGPT", "Chat GPT"); -- id: 1
INSERT INTO rawDataSourceCategories [(slug, name)] VALUES ("Amazon", "Amazon"); -- id: 2

-- coreTable3
CREATE TABLE rawDataSources(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  rawDataSourceCategorySlug TEXT NOT NULL, -- alternate: rawDataSourceCategoryID INT NOT NULL,
);

INSERT INTO rawDataSources [(slug, name, rawDataSourceCategorySlug)] VALUES ("brainstormNostrRelay", "the Awesome Brainstorm nostr relay", "nostr" ); -- id: 0

-- coreTable4
CREATE TABLE interpretationEngines(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  rawDataSourceCategorySlug INT NOT NULL, -- alternate: rawDataSourceCategoryID
  aSupportedInterpretationProtocols TEXT NOT NULL, -- a stringified array of protocolSlugs
);

INSERT INTO interpretationEngines [(slug, name, rawDataSourceCategorySlug )] VALUES ("BrainstormNostrInterpEngine", "Brainstorm's Awesome Nostr Interpretation Engine", "nostr" );

-- coreTable5
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



/***************
initialization code for rawDataSourceCategory = nostrRelays:
***************/


-- coreTable3_nostrRelays
CREATE TABLE rawDataSources_nostrRelays(
  ID INT PRIMARY KEY NOT NULL,
  rawDataSourceID INT NOT NULL, -- points to coreTable3
  url TEXT NOT NULL,
);
/*
May also want other columns like: uptime or other performance measures, free vs paid, etc)
*/

INSERT INTO rawDataSources_nostrRelays [(name, url, aSupportedInterpretationProtocols)] VALUES ("cloudfodder's Awesome Grapevine Relay", "wss://brainstorm.nostr1.com", "[ 'basicFollow', 'basicMute', 'basicReport' ]");


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



