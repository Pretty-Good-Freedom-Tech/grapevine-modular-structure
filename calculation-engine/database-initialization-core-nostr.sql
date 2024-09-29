/***************
initialization code for coreTable3_j, coreTable4_j, and coreTable5_j where j = rawDataSourceCategory = nostr
These tables belong to the core database (not the user database)
***************/

-- coreTable3_nostr
CREATE TABLE rawDataSources_nostr(
  ID INT PRIMARY KEY NOT NULL,
  rawDataSourceSlug TEXT NOT NULL, -- points to coreTable3, rawDataSources.slug; alternate: rawDataSourceID INT NOT NULL, pointing to rawDataSources.id
  
  --  nostr-specific columns
  url TEXT NOT NULL,
);
/*
May also want other columns like: uptime or other performance measures, free vs paid, etc)
*/

INSERT INTO rawDataSources_nostr [(rawDataSourceSlug, url)] VALUES ("brainstormNostrRelay", "wss://brainstorm.nostr1.com");

-- coreTable4_nostr
CREATE TABLE interpretationEngines_nostr(
  ID INT PRIMARY KEY NOT NULL,
  interpretationEngineSlug TEXT NOT NULL, -- points to coreTable4, interpretationEngines.slug (alternate: use id, not slug)

  -- nostr-specific columns
  aSupportedInterpretationProtocolSlugs TEXT NOT NULL, -- stringified array of interpretationProtocolSlugs (each item points to interpretationProtocols.slug (coreTable5))
);

INSERT INTO interpretationEngines_nostr [(interpretationEngineSlug, aSupportedInterpretationProtocolSlugs)] VALUES ("BrainstormNostrInterpEngine", "[ 'basicFollowsInterpretation', 'basicMutesInterpretation', 'basicReportsInterpretation' ]");


-- coreTable5_nostr
CREATE TABLE interpretationProtocols_nostr(
  ID INT PRIMARY KEY NOT NULL,
  universalInterpretationProtocolID TEXT UNIQUE NOT NULL, -- used to communicate with nostr interpretation engines; might be the same as the slug

  -- nostr-specific columns
  parametersJsonSchema TEXT NOT NULL, -- stringified JSON schema (json-schema.org) template for all required and optional parameters, which may be very different for each protocol. This may or may not include default values.
  
  -- ALTERNATE to parametersSchema:
  parametersJsonSchemaNaddr TEXT NOT NULL, -- naddr to an event with the JSON Schema, managed by Brainstorm. Advantage: multiple (competing) services can point to this naddr and ensure compatibility with the wider community
  
  
  -- might deprecate (replace with universalInterpretationProtocolID)
  slug TEXT NOT NULL, -- points to coreTable5, interpretationProtocols.slug; alternate: interpretationProtocolID INT NOT NULL, pointing to interpretationProtocols.id

);

INSERT INTO interpretationProtocols_nostr [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicFollowsInterpretation", "{ properties: { score: { type: float, default: 1.0 }, confidence: { type: float, default: 0.05 } }");
INSERT INTO interpretationProtocols_nostr [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicMutesInterpretation", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.10 } }");
INSERT INTO interpretationProtocols_nostr [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicReportsInterpretation", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.20 } }");
INSERT INTO interpretationProtocols_nostr [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("expandedReportsInterpretation", <more complex JSON handling multiple reportTypes> );

