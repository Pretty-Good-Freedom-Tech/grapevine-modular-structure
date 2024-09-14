-- Create user-specific database
GrapeRankCalculationEngine_<pk_Alice>.db;

-- Create tables 

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

-- userTable3
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

-- userTable4
CREATE TABLE grapeRankScorecardTables(
  ID INT PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  aScorecards TEXT NOT NULL, -- a stringified array of IDs from the grapeRankScorecards table
);

-- userTable5
CREATE TABLE grapeRankCalculationParams(
  ID INT PRIMARY KEY NOT NULL,
  attenuation FLOAT(3,2) NOT NULL,
  rigor FLOAT(3,2) NOT NULL,
);

-- userTable6
CREATE TABLE worldviews(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  nodes TEXT NOT NULL, -- a stringified array of nodes (by worldviewNodes ID)
  edges TEXT NOT NULL, -- a stringified array of edges (by worldviewEdges ID)
);

-- userTable6a
CREATE TABLE worldviewNodes(
  ID INT PRIMARY KEY NOT NULL,
  slug TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
);

-- userTable6b
CREATE TABLE worldviewEdges(
  ID INT PRIMARY KEY NOT NULL,
  node_start INT NOT NULL, -- a stringified array of nodes
  node_end INT NOT NULL, -- a stringified array of edges
  grapeRankRatingsSpecificationType TEXT NOT NULL, -- query or dataset
  grapeRankRatingsQuery TEXT NOT NULL, -- a query of the Ratings database (which will be variable)
  grapeRankRatingsDataset TEXT NOT NULL, -- a fixed list of Ratings (by rating id)?
  grapeRankCalculationParamSpecs TEXT NOT NULL, -- stringified JSON; specify attenuationFactor, rigor, etc.
);

-- userTable7_0; for interpretationProtocol with Id = 0
CREATE TABLE protocol0Params(
  ID INT PRIMARY KEY NOT NULL,
  userId INT NOT NULL,
  params TEXT NOT NULL
);
/*
This table stores the preferred parameters for any given protocol for any given user
*/

