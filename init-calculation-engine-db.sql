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

userTable1: GrapeRank Ratings (R) -- grapeRankRatings
userTable2: GrapeRank Scorecards (G) -- grapeRankScorecards
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
CREATE TABLE grapeRankRatings(
  ID INT PRIMARY KEY NOT NULL,
  rater TEXT NOT NULL,
  ratee TEXT NOT NULL,
  context TEXT NOT NULL,
  score FLOAT NOT NULL,
  confidence DECIMAL(5,4) NOT NULL,
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

-- userTable3
CREATE TABLE grapevineCalculationParams(
  ID INT PRIMARY KEY NOT NULL,
);

-- userTable4
CREATE TABLE protocolParams(
  ID INT PRIMARY KEY NOT NULL,
);


