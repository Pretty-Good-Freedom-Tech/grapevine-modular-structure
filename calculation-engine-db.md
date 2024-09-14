# GrapeRank Calculation Engine (GCE) Database (cache)

## CORE GCE DATABASE

CREATE CORE DATABASE: GrapevineCalculationEngine_core.db

- coreTable1: users -- all customers for this service (free and paying)
- coreTable2: rawDataSourceCategories -- Raw Data Source Categories (e.g. nostrRelays, chatGPT, Amazon, etc)
- coreTable3: rawDataSources
- coreTable4: interpretationEngines
- coreTable5: interpretationProtocols

FOR EACH ROW IN coreTable2, THERE WILL BE AN ADDITIONAL coreTable3_j, coreTable4_j, and coreTable5_j, where j = rawDataSourceCategoryID or rawDataSourceCategorySlug

Raw Data Sources
- coreTable3_j: rawDataSourcesForCategory_j -- each supported rawDataSourceCategory will have its own table of supported Raw Data Sources
Examples:
- coreTable3_nostr: rawDataSourcesForCategory_nostr (e.g. wss://brainstorm.nostr1.com)
- coreTable3_chatGPT: rawDataSourcesForCategory_chatGPT

Interpretation Engines
- coreTable4_j: interpretationEnginesForCategory_j -- Interp Engines for an individual raw data type
Examples:
- coreTable4_nostr: interpretationEnginesForCategory_nostr
- coreTable4_chatGPT: interpretationEnginesForCategory_chatGPT

Interpretation Protocols
- coreTable5_j: interpretationProtocolsForCategory_j -- available interpretation protocols for each Interp Engine
Examples:
- coreTable5_nostr: interpretationProtocolsForCategory_nostr
- coreTable5_chatGPT: interpretationProtocolsForCategory_chatGPT

initialization code: [SQLite](./init-calculation-engine-main-db.sql)

## NEW DATABASE FOR EACH CUSTOMER / USER

For each new user, spin up a new database, named something like: GrapevineCalculationEngine_<pk_Alice>.db

- userTable1: grapeRankRatings -- GrapeRank Ratings (r)
- userTable2: grapeRankRatingTables -- GrapeRank Rating Table (R)
- userTable3: grapeRankScorecards -- GrapeRank Scorecards (S) 
- userTable4: grapeRankScorecardTables -- GrapeRank Scorecards (G)
- userTable5: grapeRankCalculationParams -- standard GrapeRank Calculation Parameters (attenFactor, rigor, defaults (?), etc)
- userTable6: worldviews -- Grapevine Worldview tables
- userTable7_j: protocolParams_j -- each supported protocol (each entry in coreTable4; j = interpretationProtocolID) will have its own table of protocol-specific parameters (follow/mute/report score & confidence, how to handle different reportTypes, etc)

initialization code: [SQLite](./init-calculation-engine-single-user-db.sql)
