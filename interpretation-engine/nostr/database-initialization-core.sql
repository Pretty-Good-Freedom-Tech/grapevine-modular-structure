/*
Initialization of the core database for a Nostr Interpretation Engine

coreTable1: interpretationProtocols
Note that coreTable1 (of the interpretation engine) and coreTable4_nostr (of the calculation engine) are very similar, and that the slugs must match exactly. (Maybe replace slug with "universalId" which is also a string, and may be a slug, but could also be a non-slug string e.g. a nostr event id, naddr, or some other hash?)
*/

-- Create core database
GrapevineNostrInterpretationEngine_core.db

-- coreTable1
CREATE TABLE interpretationProtocols(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  name TEXT, -- optional
  title TEXT, -- optional
  description TEXT NOT NULL,
  jsonSchema TEXT, -- stringified json that describes the object that holds parameters that must be communicated across the API
  naddr TEXT, -- naddr that points to an event in which the json schema is stored (stringified and placed in content; kind?)
);
