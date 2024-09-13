# Modular Structure of the Grapevine

## Modules and APIs

The Grapevine is divided into 4 categories of modules and three categories of APIs.
- Raw Data Source (e.g., a nostr relay) -- this is completely external to the Grapevine
- Interpretation Engine (maybe a DVM)
- Calculation Engine (back end to the UX front end)
- the Grapevine front end

![](https://i.nostr.build/CZpJxmS3xUrmdYg1.png)

### Raw Data Engine

### Interpretation Engine

A specialized service which sits between raw data and the Calculation Engine. 

## Calculation Engine

### Front End

Where the user goes to explore all available ScoreCards and GrapeRankRatings

## APIs

There are three categories of APIs:
- interface between Raw Data and Interpretation Engine
- interface between the Interpretation Engine and the Calculation Engine
- interface between the Calculation Engine and the front end

## Sources of Raw Data

Although we are nostr-focused, the Grapevine is designed to accept input from multiple sources and from multiple source types. One day, grapevine will grow beyond nostr.

![Multiple Sources of Input](https://i.nostr.build/TtZ2ByM3KJsyL17r.png)
