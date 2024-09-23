/*
Initialization of the core database for a Nostr Interpretation Engine

coreTable1: interpretationProtocols
Note that coreTable1 (of the interpretation engine) and coreTable5_nostr (of the calculation engine) are very similar, and that the slugs must match exactly. (Maybe replace slug with "universalId" which is also a string, and may be a slug, but could also be a non-slug string e.g. a nostr event id, naddr, or some other hash?)
*/

-- Create core database
GrapevineNostrInterpretationEngine_core.db

-- coreTable1
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  universalInterpretationProtocolID TEXT NOT NULL, -- used to communicate with the nostr calculation engine; might be the same as the slug
  name TEXT, -- optional
  title TEXT, -- optional
  description TEXT NOT NULL,
  parametersJsonSchema TEXT, -- stringified json that describes the object that holds parameters that must be communicated across the API
  naddr TEXT, -- naddr that points to an event in which the json schema is stored (stringified and placed in content; kind?)
);

INSERT INTO interpretationProtocols [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicFollowsInterpretationProtocol", "{ properties: { score: { type: float, default: 1.0 }, confidence: { type: float, default: 0.05 } }");
INSERT INTO interpretationProtocols [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicMutesInterpretationProtocol", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.10 } }");
INSERT INTO interpretationProtocols [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("basicReportsInterpretationProtocol", "{ properties: { score: { type: float, default: 0.0 }, confidence: { type: float, default: 0.20 } }");
INSERT INTO interpretationProtocols [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("expandedReportsInterpretationProtocol", <more complex JSON handling multiple reportTypes> );
INSERT INTO interpretationProtocols [(universalInterpretationProtocolID, parametersJsonSchema)] VALUES ("brainstormNotSpamInterpretationProtocol", <more complex JSON handling multiple reportTypes> );

