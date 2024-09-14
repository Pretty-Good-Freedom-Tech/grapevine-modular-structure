/*
SQLITE

MAIN DATABASE: GrapevineCalculationEngine.db

ONE SET OF TABLES PER ENGINE:

table1: Raw Data Source Categories (e.g. nostr relay, AI, Amazon, etc) rawDataTypes -- rawDataSourceCategories
table2: Raw Data Sources (e.g. wss://brainstorm.nostr1,com)  -- rawDataSources
table3: Interp Engines for each raw data type -- interpretationEngines
table4: available interpretation protocols for each Interp Engine -- interpretationProtocols
table5: users (customers) -- users

for each new user, make a new database:
SINGLE USER DATABASE: <pk_Alice>_GCE.db

userTable1: GrapeRank Ratings (r) -- grapeRankRatings
userTable1b: GrapeRank Rating Table (R) -- grapeRankRatingTables
userTable2: GrapeRank Scorecards (S) -- grapeRankScorecards
userTable2b: GrapeRank Scorecards (G) -- grapeRankScorecardTables
userTable3: standard Grapevine Calculation Parameters (attenFactor, rigor, defaults (?), etc) -- grapevineCalculationParams
userTable4: protocol-specific parameters (score, confidence, etc) -- protocolParams
userTable5: Grapevine Worldview tables -- worldviews

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

------------- ONE DATABASE PER USER, 4 tables

-- Create user-specific database
<pk_Alice>_GCE.db;

-- userTable1
CREATE TABLE grapeRankRatings(
  ID INT PRIMARY KEY NOT NULL,
  rater TEXT NOT NULL,
  ratee TEXT NOT NULL,
  context TEXT NOT NULL,
  score FLOAT NOT NULL,
  confidence DECIMAL(5,4) NOT NULL,
  lastUpdated TIMESTAMP NOT NULL,
);

-- userTable1b
CREATE TABLE grapeRankRatingsTables(
  ID INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  rawDataSourceCategoryId INT NOT NULL,
  interpretationEngineId INT NOT NULL,
  protocolParamSpecsId INT NOT NULL,
  aRatingsIds TEXT NOT NULL, -- a stringified array of entries in the grapeRankRatings table
  lastUpdated TIMESTAMP NOT NULL,
);

-- userTable2
CREATE TABLE grapeRankScorecards(
  ID INT PRIMARY KEY NOT NULL,
  observer TEXT NOT NULL,
  observee TEXT NOT NULL,
  context TEXT NOT NULL,
  influence FLOAT NOT NULL,
  average FLOAT NOT NULL,
  confidence DECIMAL(5,4) NOT NULL,
  weights FLOAT NOT NULL,
  lastUpdated TIMESTAMP NOT NULL,
  CONSTRAINT atom_id UNIQUE (observer, observee, context)
  -- ??? protocol, parameters, etc? Or should these be absorbed somehow into "context"??
  -- ??? source, which could be an Interpretation Engine or another user. If another user, it may or may not be the observer.
);
/*
An "atom" refers to the 3-tuple: observer, observee, context, which together uniquely specify an individual Scorecard.

For many but not all entries, the observer will (probably) be the user-owner of this database. But atoms from other observers (with or without signature? whose signature? ideally sig of the observer, but maybe the sig of the GrapeRank Calculation Engine? how about the sig of a user-as-atom-reseller?) can be purchased on the open market.

Note on the atom reseller market:
If Alice sells an atom to Bob, and Alice is the observer, then Bob will pay a higher fee if he gets Alice's signature (and arguably may not purchase it at all without her sig). BUT: Alice hopes that Bob will not resell her atom, bc she wants to be the one to make money from the sale. How does she guarantee this? 1) Ask nicely. Ha! or: 2) She encrypts the atom so that only Bob can decrypt it, and she signs the ENCRYPTED atom. That way, if Bob resells the atom to Charlie, then Charlie has no way of verifying the veracity of the sig, unless Bob is willing to reveal his private key to Charlie (which of course he will not do). Ta da!

Queries will typically make use of the three atomic fields: observer, observee, and context.

To return an individual GrapeRank Scorecard using its atom, run the query:
SELECT * FROM grapeRankScorecards WHERE (observer == pk_observer, observee == pK_observee, context == context)

To produce a GrapeRank Scorecard Table (G) that returns all info about Alice in context1, run the query:
SELECT * FROM grapeRankScorecards WHERE (observee == pK_observee, context == context1)

And so on. 
*/

-- userTable2b
CREATE TABLE grapeRankScorecardTables(
  ID INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  aScorecards TEXT NOT NULL, -- a stringified array of IDs from the grapeRankScorecards table
);

-- userTable3
CREATE TABLE grapevineCalculationParams(
  ID INT PRIMARY KEY NOT NULL,
);

-- userTable4_0; for protocol with Id = 0
CREATE TABLE protocol0Params(
  ID INT PRIMARY KEY NOT NULL,
  userId INT NOT NULL,
  params TEXT NOT NULL
);
/*
This table stores the preferred parameters for any given protocol for any given user
*/

-- userTable5
CREATE TABLE worldviews(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  nodes TEXT NOT NULL, -- a stringified array of nodes (by worldviewNodes ID)
  edges TEXT NOT NULL, -- a stringified array of edges (by worldviewEdges ID)
);

-- userTable5a
CREATE TABLE worldviewNodes(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
);

-- userTable5b
CREATE TABLE worldviewEdges(
  ID INT PRIMARY KEY NOT NULL,
  node_start INT NOT NULL, -- a stringified array of nodes
  node_end INT NOT NULL, -- a stringified array of edges
  grapeRankRatingsSpecificationType TEXT NOT NULL, -- query or dataset
  grapeRankRatingsQuery TEXT NOT NULL, -- a query of the Ratings database (which will be variable)
  grapeRankRatingsDataset TEXT NOT NULL, -- a fixed list of Ratings (by rating id)?
  grapeRankCalculationParamSpecs TEXT NOT NULL, -- stringified JSON; specify attenuationFactor, rigor, etc.
);



