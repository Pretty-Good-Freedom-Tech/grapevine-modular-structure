
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
  description TEXT,
  rawDataSourceCategorySlug TEXT NOT NULL, -- points to coreTable2, rawDataSourceCategories.slug (alternate: rawDataSourceCategoryID INT NOT NULL, points to rawDataSourceCategories.id)
);

INSERT INTO rawDataSources [(slug, name, rawDataSourceCategorySlug)] VALUES ("brainstormNostrRelay", "The Awesome Brainstorm Nostr Relay", "nostr" );

-- coreTable4
CREATE TABLE interpretationEngines(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,  
  aSupportedRawDataSourceCategorySlugs TEXT NOT NULL, -- a stringified array of rawDataSourceCategorySlugs pointing to coreTable2, rawDataSourceCategories.slug (alternate: id instead of slug)

  -- should this be removed and placed in the coreTable4_j ?
  aSupportedInterpretationProtocolSlugs TEXT NOT NULL, -- a stringified array of interpretationProtocolSlugs
);

INSERT INTO interpretationEngines [(slug, name, aSupportedRawDataSourceCategorySlugs, aSupportedInterpretationProtocolSlugs )] VALUES ("BrainstormNostrInterpEngine", "The Awesome Brainstorm Nostr Interpretation Engine", [ "nostr" ], [] );

-- coreTable5
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  aSupportedRawDataSourceCategorySlugs TEXT NOT NULL, -- a stringified array of rawDataSourceCategorySlugs pointing to coreTable2, rawDataSourceCategories.slug (alternate: id instead of slug)
  
  rawDataSourceCategories INT NOT NULL,
  parameterSchema TEXT NOT NULL, -- naddr pointer to a JSON Schema which specifies the required parameters
);

INSERT INTO interpretationProtocols [(slug, name, aSupportedRawDataSourceCategorySlugs )] VALUES ("basicFollowsInterpretation", "the Standard Follows Interpretation", [ "nostr" ] );
INSERT INTO interpretationProtocols [(slug, name, aSupportedRawDataSourceCategorySlugs )] VALUES ("basicMutesInterpretation", "the Standard Mutes Interpretation", [ "nostr" ] );
INSERT INTO interpretationProtocols [(slug, name, aSupportedRawDataSourceCategorySlugs )] VALUES ("basicReportsInterpretation", "the Standard Reports Interpretation", [ "nostr" ] );
INSERT INTO interpretationProtocols [(slug, name, aSupportedRawDataSourceCategorySlugs )] VALUES ("expandedReportsInterpretation", "the Expanded Reports Interpretation", [ "nostr" ] );




/***************
initialization code for rawDataSourceCategory = nostrRelays:
***************/

-- coreTable3_nostr
CREATE TABLE rawDataSources_nostr(
  ID INT PRIMARY KEY NOT NULL,
  rawDataSourceSlug TEXT NOT NULL, -- points to coreTable3, rawDataSources.slug; alternate: rawDataSourceID INT NOT NULL, pointing to rawDataSources.id
  url TEXT NOT NULL,
);
/*
May also want other columns like: uptime or other performance measures, free vs paid, etc)
*/

INSERT INTO rawDataSources_nostr [(rawDataSourceSlug, url)] VALUES ("brainstormNostrRelay", "wss://brainstorm.nostr1.com");

-- coreTable4_nostr
CREATE TABLE interpretationEngines_nostr(
  ID INT PRIMARY KEY NOT NULL,
  interpretationEngineSlug TEXT NOT NULL, -- points to coreTable4, interpretationEngines.slug; alternate: interpretationEngineID INT NOT NULL, pointing to interpretationEngines.id
  aSupportedInterpretationProtocolSlugs TEXT NOT NULL, -- stringified array of interpretationProtocolSlugs (each item points to interpretationProtocols.slug (coreTable5))
);

INSERT INTO interpretationEngines_nostr [(interpretationEngineSlug, aSupportedInterpretationProtocolSlugs)] VALUES ("BrainstormNostrInterpEngine", "[ 'basicFollowsInterpretation', 'basicMutesInterpretation', 'basicReportsInterpretation' ]");


-- coreTable5_nostr
CREATE TABLE interpretationProtocols_nostr(
  ID INT PRIMARY KEY NOT NULL,
  interpretationProtocolSlug TEXT NOT NULL, -- points to coreTable5, interpretationProtocols.slug; alternate: interpretationProtocolID INT NOT NULL, pointing to interpretationProtocols.id
  requiredParametersSchema TEXT NOT NULL, -- 
);

INSERT INTO interpretationProtocols_nostr [(interpretationProtocolSlug, requiredParametersSchema)] VALUES ("basicFollowsInterpretation", "{ properties: { score: { type: float, default: 1.0 }, confidence: { type: float, default: 0.05 } }");
INSERT INTO interpretationProtocols_nostr [(interpretationProtocolSlug, requiredParametersSchema)] VALUES ("basicMutesInterpretation", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.10 } }");
INSERT INTO interpretationProtocols_nostr [(interpretationProtocolSlug, requiredParametersSchema)] VALUES ("basicReportsInterpretation", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.20 } }");
INSERT INTO interpretationProtocols_nostr [(interpretationProtocolSlug, requiredParametersSchema)] VALUES ("expandedReportsInterpretation", <more complex JSON handling multiple reportTypes> );








-- coreTable4b
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



