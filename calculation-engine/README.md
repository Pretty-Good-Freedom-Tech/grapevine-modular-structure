# GrapeRank Calculation Engine (GCE) Database (cache)

## CORE GCE DATABASE

CREATE CORE DATABASE: GrapevineCalculationEngine_core.db

- coreTable1: users -- all customers for this service (free and paying)
- coreTable2: rawDataSourceCategories (e.g. nostrRelays, AI, eCommerce, socialMedia, etc)
- coreTable3: rawDataSources (e.g. wss://grapevine.nostr1.com, chatGPT, Amazon, Twitter, etc)
- coreTable4: interpretationEngines
- coreTable5: interpretationProtocols: used when calculating R. Includes one JSON with parameters (score, confidence, etc)
- coreTable6: grapeRankProtocols: used when calculating G. Each protocol includes one JSON with parameters (attenuation, rigor, etc)
- coreTable7: protocolParameterSelections: for each user, for each protocol in coreTable5 and coreTable6, record the user's selected params

initialization code for the above: [SQLite](./database-initialization-core.sql)

FOR EACH ROW j IN coreTable2, THERE WILL BE AN ADDITIONAL coreTable3_j, coreTable4_j, and coreTable5_j, where j = rawDataSourceCategoryID or rawDataSourceCategorySlug

We will only build out in detail for j = nostrRelays for now.

Raw Data Sources
- coreTable3_j: rawDataSourcesForCategory_j -- each supported rawDataSourceCategory will have its own table of supported Raw Data Sources
Examples:
- coreTable3_nostrRelays: rawDataSourcesForCategory_nostr (e.g. wss://brainstorm.nostr1.com)
- coreTable3_AI: rawDataSourcesForCategory_AI

Interpretation Engines
- coreTable4_j: interpretationEnginesForCategory_j -- Interp Engines for an individual rawDataSourceCategory
Examples:
- coreTable4_nostrRelays: interpretationEnginesForCategory_nostrRelays
- coreTable4_AI: interpretationEnginesForCategory_AI

Interpretation Protocols
- coreTable5_j: interpretationProtocolsForCategory_j -- available interpretation protocols for each rawDataSourceCategory (& for each Interp Engine)
Examples:
- coreTable5_nostrRelays: interpretationProtocolsForCategory_nostrRelays
- coreTable5_AI: interpretationProtocolsForCategory_AI

initialization code for rawDataSourceCategory = nostrRelays: [SQLite](./database-initialization-core.sql)

initialization code for rawDataSourceCategory = AI: [SQLite](./database-initialization-core.sql)

## NEW DATABASE FOR EACH CUSTOMER / USER

For each new user, spin up a new database, named something like: GrapevineCalculationEngine_<pk_Alice>.db

- userTable1: grapeRankRatings -- GrapeRank Ratings (r)
- userTable2: grapeRankRatingTables -- GrapeRank Rating Table (R)
- userTable3: grapeRankScorecards -- GrapeRank Scorecards (S) 
- userTable4: grapeRankScorecardTables -- GrapeRank Scorecards (G)
- userTable5: worldviews -- a collection of worldviewNodes and worldviewEdges
- userTable6: worldViewNodes: specifies one G, and includes into on how to (re)derive it: which dataSource, which protocol, which interpEngine
- userTable7: worldViewEdges: specifies an R and a P (GrapeRank parameters)

initialization code: [SQLite](./database-initialization-single-user.sql)
