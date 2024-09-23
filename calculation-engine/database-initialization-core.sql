
-- Create core database
GrapevineCalculationEngine_core.db

-- coreTable1
CREATE TABLE users(
  ID INT PRIMARY KEY NOT NULL,
  pubkey TEXT UNIQUE NOT NULL,
  whenSignedUp TIMESTAMP NOT NULL,
  subscriptionPlan TEXT NOT NULL, -- will need to flesh out later what this means

  -- might be deprecating this:
  grapeRankCalculationProtocolCustomizations TEXT, -- stringified JSON with user's preferred parameters, eg attentuation = 0.75; must validate against the relevant JSON Schema; 
);

-- coreTable2
CREATE TABLE rawDataSourceCategories(
  ID INT PRIMARY KEY NOT NULL,
  SLUG TEXT UNIQUE NOT NULL,
  NAME TEXT,
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
  name TEXT,
  title TEXT,
  description TEXT,  
  rawDataSourceCategorySlug TEXT NOT NULL, -- points to coreTable2, rawDataSourceCategories.slug (alternate: rawDataSourceCategoryID INT NOT NULL, points to rawDataSourceCategories.id)
  
  -- DEPRECATED: moved to coreTable4_j
  aSupportedInterpretationProtocolSlugs TEXT NOT NULL, -- a stringified array of interpretationProtocolSlugs
  -- DEPRECATED: changed to single value
  aSupportedRawDataSourceCategorySlugs TEXT NOT NULL, -- a stringified array of rawDataSourceCategorySlugs pointing to coreTable2, rawDataSourceCategories.slug (alternate: id instead of slug)
);

INSERT INTO interpretationEngines [(slug, name, rawDataSourceCategorySlug )] VALUES ("BrainstormNostrInterpEngine", "The Awesome Brainstorm Nostr Interpretation Engine", "nostr" );

-- coreTable5
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  rawDataSourceCategorySlug TEXT NOT NULL, -- points to coreTable2, rawDataSourceCategories.slug (alternate: rawDataSourceCategoryID INT NOT NULL, points to rawDataSourceCategories.id)

  ---?????????:
  parametersSchema TEXT NOT NULL, -- stringified JSON schema (json-schema.org) template for all required and optional parameters, which may be very different for each protocol. This may or may not include default values.
  
  -- ALTERNATE to parametersSchema:
  parametersSchemaNaddr TEXT NOT NULL, -- naddr to an event with the JSON Schema, managed by Brainstorm. Advantage: multiple (competing) services can point to this naddr and ensure compatibility with the wider community
  ----??????

  
  -- DEPRECATED: 
  aSupportedRawDataSourceCategorySlugs TEXT NOT NULL, -- a stringified array of rawDataSourceCategorySlugs pointing to coreTable2, rawDataSourceCategories.slug (alternate: id instead of slug)
);

-- universal (rawDataSourceCategorySlug is null or "all" or "GrapeRank")
-- DEPRECATING INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("grapeRank", "GrapeRank", "grapeRank" );

-- specific to rawDataSourceCategorySlug
INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("basicFollowsInterpretation", "the Standard Follows Interpretation", "nostr" );
INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("basicMutesInterpretation", "the Standard Mutes Interpretation", "nostr" );
INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("basicReportsInterpretation", "the Standard Reports Interpretation", "nostr" );
INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("expandedReportsInterpretation", "the Expanded Reports Interpretation", "nostr" );

INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("standardGrapevineNetworkInterpretation", "the Standard Grapevine Network Interpretation", "nostr" ); -- this is a combo of follows, mutes, and reports all in one

INSERT INTO interpretationProtocols [(slug, name, rawDataSourceCategorySlug )] VALUES ("basicAmazonInterpretation", "Amazon Product Ratings Interpretation", "Amazon" );

-- coreTable6
CREATE TABLE grapeRankProtocols(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  
  -- nostr-specific columns
  parametersSchema TEXT NOT NULL, -- stringified JSON schema (json-schema.org) template for all required and optional parameters, which may be very different for each protocol. This may or may not include default values.
  
  -- ALTERNATE to parametersSchema:
  parametersSchemaNaddr TEXT NOT NULL, -- naddr to an event with the JSON Schema, managed by Brainstorm. Advantage: multiple (competing) services can point to this naddr and ensure compatibility with the wider community
);

INSERT INTO grapeRankProtocols [(slug, parametersSchema )] VALUES ("basicGrapevineNetwork", "{ properties: { attenuation: { type: float, min: 0, max: 1, default: 0.8 }, rigor: { type: float, min: 0, max: 1, default: 0.25 }, defaultUserScore: { type: float, min: 0, max: 1, default: 0.0 }, defaultUserScoreConfidence: { type: float, min: 0, max: 1, default: 0.01} } }" );
INSERT INTO grapeRankProtocols [(slug, parametersSchema )] VALUES ("basic5StarProductCalculation", "{ properties: { defaultProductScore: { type: float, min: 0, max: 5, default: 0.0 }, defaultProductScoreConfidence: { type: float, min: 0, max: 1, default: 0.05 } }}" );

-- coreTable7
CREATE TABLE protocolParameterSelections(
  ID INT PRIMARY KEY NOT NULL,
  userID ID UNIQUE NOT NULL,
  protocolCategoryTableName TEXT NOT NULL, -- "interpretationProtocols" or "grapeRankProtocols" or (coreTable5 or coreTable6) 
  protocolSlug TEXT NOT NULL, [protocolCategoryTableName].slug
  
  selectedParameters TEXT NOT NULL, -- stringified JSON that contains the parameters with selected values
  
  -- ALTERNATE to selectedParameters:
  selectedParametersNaddr TEXT NOT NULL, -- naddr to an event with the JSON Schema, managed by Brainstorm. Advantage: multiple (competing) services can point to this naddr and ensure compatibility with the wider community

  -- OPTIONAL, if we want to give the user the ability to save multiple parameter settings
  name TEXT, 
);

-- defaults
INSERT INTO protocolParameterSelections (userID, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES ("default", "interpretationProtocols", "basicFollowsInterpretation", "{ score: 1, confidence: 0.05 }" );
INSERT INTO protocolParameterSelections (userID, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES ("default", "interpretationProtocols", "basicMutesInterpretation", "{ score: 0, confidence: 0.10 }" );
INSERT INTO protocolParameterSelections (userID, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES ("default", "interpretationProtocols", "basicReportsInterpretation", "{ score: 0, confidence: 0.20 }" );
INSERT INTO protocolParameterSelections (userID, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES ("default", "interpretationProtocols", "expandedReportsInterpretation", "{ reportTypesGroupA: { reportTypes: [ malware, illegal, spam, impersonation ], score: 1, confidence: 0.5 }, reportTypesGroupB: { reportTypes: [ profanity, nudity ], score: 1, confidence: 0.02 }, reportTypesGroupC: { reportTypes: [ other ], score: 1, confidence: 0.1 }, }" );
INSERT INTO protocolParameterSelections (userID, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES ("default", "grapeRankProtocols", "basicGrapevineNetwork", "{ attenuation: 0.8, rigor: 0.25, defaultUserScore: 0, defaultUserScoreConfidence: 0.01 }" );

-- for new user Alice:
INSERT INTO protocolParameterSelections (userPubkey, protocolCategoryTableName, protocolSlug, selectedParameters ) VALUES (<pk_Alice>, "interpretationProtocols", "basicFollowsInterpretation", "{ score: 1, confidence: 0.05 }" );

-- when Alice updates her parameter selections:

UPDATE protocolParameterSelections SET selectedParameters = newParams WHERE userID = AliceId AND protocolCategoryTableName = protocolCategoryTableName AND protocolSlug = protocolSlug
  
/*
"{ attenuation: 0.8, rigor: 0.25, defaultUserScore: 0, defaultUserScoreConfidence: 0.01 }"
"{ defaultProductScore: 0, defaultProductScoreConfidence: 0.05 }"
*/




/*
REVIEW: coreTable4b and coreTable4c are completely deprecated and fully replaced with coreTable7 (I think)
*/

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



