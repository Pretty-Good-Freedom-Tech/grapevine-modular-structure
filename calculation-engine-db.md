# GrapeRank Calculation Engine (GCE) Database (cache)

## CORE GCE DATABASE

MAIN DATABASE: GrapevineCalculationEngine_core.db

- table1: Raw Data Source Categories (e.g. nostr relay, AI, Amazon, etc) rawDataTypes -- rawDataSourceCategories
- table2: Raw Data Sources (e.g. wss://brainstorm.nostr1,com)  -- rawDataSources
- table3: Interp Engines for each raw data type -- interpretationEngines
- table4: available interpretation protocols for each Interp Engine -- interpretationProtocols
- table5: users (customers) -- users

initialization code: [SQLite](./init-calculation-engine-main-db.sql)

## NEW DATABASE FOR EACH CUSTOMER / USER

For each new user, spin up a new database, named something like: GrapevineCalculationEngine_<pk_Alice>.db

- userTable1: GrapeRank Ratings (r) -- grapeRankRatings
- userTable1b: GrapeRank Rating Table (R) -- grapeRankRatingTables
- userTable2: GrapeRank Scorecards (S) -- grapeRankScorecards
- userTable2b: GrapeRank Scorecards (G) -- grapeRankScorecardTables
- userTable3: standard Grapevine Calculation Parameters (attenFactor, rigor, defaults (?), etc) -- grapevineCalculationParams
- userTable4: protocol-specific parameters (score, confidence, etc) -- protocolParams
- userTable5: Grapevine Worldview tables -- worldviews

initialization code: [SQLite](./init-calculation-engine-single-user-db.sql)
