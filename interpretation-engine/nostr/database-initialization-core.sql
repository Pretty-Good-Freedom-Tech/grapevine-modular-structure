/*
Initialization of the core database for a Nostr Interpretation Engine

coreTable1: interpretationProtocols
Note that coreTable1 (of the interpretation engine) and coreTable5_nostr (of the calculation engine) are very similar, and that the slugs must match exactly. (Maybe replace slug with "universalId" which is also a string, and may be a slug, but could also be a non-slug string e.g. a nostr event id, naddr, or some other hash?)
*/

-- Create core database
GrapevineNostrInterpretationEngine_core.db

-- coreTable1
CREATE TABLE IF NOT EXISTS interpretationProtocols(
  ID SERIAL PRIMARY KEY,
  universalInterpretationProtocolID TEXT NOT NULL, -- used to communicate with the nostr calculation engine; might be the same as the slug
  name TEXT, -- optional
  title TEXT, -- optional
  description TEXT,
  parametersJsonSchema JSONB, -- stringified json that describes the object that holds parameters that must be communicated across the API
  -- OPTIONAL: use naddr to point to the jsonSchema in place of the parametersJsonSchema column
  parametersJsonSchemaNaddr TEXT, -- naddr that points to an event in which the json schema is stored (? stringified and placed in content; ? kind)
);

const followsParameters = <see protocol page for json schema>
const mutesParameters = <see protocol page for json schema>
const reportsParameters = <see protocol page for json schema>
const expandedReportsParameters = <see protocol page for json schema>
const brainstormNotSpamParameters = <see protocol page for json schema>
  
INSERT INTO interpretationProtocols (universalInterpretationProtocolID, parametersJsonSchema) VALUES ("basicFollowsInterpretationProtocol", sFollowsParameters);
INSERT INTO interpretationProtocols (universalInterpretationProtocolID, parametersJsonSchema) VALUES ("basicMutesInterpretationProtocol", sMutesParameters);
INSERT INTO interpretationProtocols (universalInterpretationProtocolID, parametersJsonSchema) VALUES ("basicReportsInterpretationProtocol", sReportsParameters);
INSERT INTO interpretationProtocols (universalInterpretationProtocolID, parametersJsonSchema) VALUES ("expandedReportsInterpretationProtocol", sExpandedReportsParameters );
INSERT INTO interpretationProtocols (universalInterpretationProtocolID, parametersJsonSchema) VALUES ("brainstormNotSpamInterpretationProtocol", sBrainstormNotSpamParameters );

