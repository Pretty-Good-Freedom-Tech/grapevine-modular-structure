# GrapeRank Calculation Engine

# Calculation Engine Database (cache)

The Calculation Engine cache is broken up into several relational databases:
- [initialization code](./database-initialization-core.sql) for the **Core GCE Database**
- [initialization code](./database-initialization-single-user.sql) for the database of an individual user
- [initialization code](./database-initialization-core-nostr.sql) for rawDataSourceCategory = nostr
- initialization code for rawDataSourceCategory = Amazon (in progress)
- initialization code for rawDataSourceCategory = AI (in progress)

## CORE GCE DATABASE

CREATE CORE DATABASE: GrapevineCalculationEngine_core.db

- coreTableA: ratingsTables - going to use this as a temporary replacement for userTable1 (ratings) and userTable2 (ratingsTables)

- coreTable1: users -- all customers for this service (free and paying)
- coreTable2: rawDataSourceCategories (e.g. nostrRelays, AI, eCommerce, socialMedia, etc)
- coreTable3: rawDataSources (e.g. wss://grapevine.nostr1.com, chatGPT, Amazon, Twitter, etc)
- coreTable4: interpretationEngines
- coreTable5: interpretationProtocols: used when calculating R. Includes one JSON with parameters (score, confidence, etc)
- coreTable6: grapeRankProtocols: used when calculating G. Each protocol includes one JSON with parameters (attenuation, rigor, etc)
- coreTable7: protocolParameterSelections: for each user, for each protocol in coreTable5 and coreTable6, record the user's selected params

OPTIONAL:
- coreTable8: contexts: a list of (recommended) contexts, each of which is a simple string, accompanied by a description of the context. Consider these contexts "recommended by the Calculation Engine."

### 3 new tables in the Core Database for each Data Source Category

FOR EACH ROW j IN coreTable2, THERE WILL BE AN ADDITIONAL coreTable3_j, coreTable4_j, and coreTable5_j, where j = rawDataSourceCategoryID or rawDataSourceCategorySlug

Raw Data Sources
- coreTable3_j: rawDataSourcesForCategory_j -- each supported rawDataSourceCategory will have its own table of supported Raw Data Sources
Examples:
- coreTable3_nostr: rawDataSourcesForCategory_nostr (e.g. wss://brainstorm.nostr1.com)
- coreTable3_Amazon: rawDataSourcesForCategory_Amazon
- coreTable3_AI: rawDataSourcesForCategory_AI

Interpretation Engines
- coreTable4_j: interpretationEnginesForCategory_j -- Interp Engines for an individual rawDataSourceCategory
Examples:
- coreTable4_nostr: interpretationEnginesForCategory_nostr (e.g. the Brainstorm Nostr Interpretation Engine)
- coreTable4_Amazon: interpretationEnginesForCategory_Amazon
- coreTable4_AI: interpretationEnginesForCategory_AI

Interpretation Protocols
- coreTable5_j: interpretationProtocolsForCategory_j -- available interpretation protocols for each rawDataSourceCategory (& for each Interp Engine)
Examples:
- coreTable5_nostr: interpretationProtocolsForCategory_nostr (e.g. the Brainstorm Follows Interpretation Protocol)
- coreTable5_Amazon: interpretationProtocolsForCategory_Amazon
- coreTable5_AI: interpretationProtocolsForCategory_AI

## NEW DATABASE FOR EACH CUSTOMER / USER

For each new user, spin up a new database, named something like: GrapevineCalculationEngine_<pk_Alice>.db

- userTable1: grapeRankRatings -- GrapeRank Ratings (r)
- userTable2: grapeRankRatingTables -- GrapeRank Rating Table (R)
- userTable3: grapeRankScorecards -- GrapeRank Scorecards (S) 
- userTable4: grapeRankScorecardTables -- GrapeRank Scorecards (G)
- userTable5: worldviews -- a collection of worldviewNodes and worldviewEdges
- userTable6: worldViewNodes: specifies one G, and includes into on how to (re)derive it: which dataSource, which protocol, which interpEngine
- userTable7: worldViewEdges: specifies an R and a P (GrapeRank parameters)

