# Modular Structure of the Grapevine

The Grapevine is divided into 5 categories of modules and 4 categories of APIs. (See the Figure below.)

Categories of Modules:
- **Raw Data Source** (e.g., a nostr relay)
- [**Interpretation Engine**](./interpretation-engine/README.md): this is where GrapeRank-formatted Ratings are created (maybe a DVM)
- [**Calculation Engine**](./calculation-engine/README.md): runs the GrapeRank Equation and serves as the back end to the user interface
- the **Grapevine front end**
- the [**Personalized Grapevine WoT Relay**](./grapevine-relay/README.md): stores Grapevine-specific data, including G (and R) tables in the form of NIP-51 lists

Categories of APIs:
1. interface between Raw Data and Interpretation Engine
2. the [**Calculation / Interpretation API**](./APIs/calculationInterpretationAPI.md): interface between the Interpretation Engine and the Calculation Engine
3. the [**Endpoint API**](./APIs/endpointAPI.md): interface between the Calculation Engine and the front end
4. the [**Client API**](./APIs/clientAPI.md): interface between the Calculation Engine and the third party nostr client, e.g. Coracle

![](https://i.nostr.build/dlAb0Dikfx0zNEI8.png)

## Modules

### Module type 1: Raw Data Source

This is completely external to the Grapevine. 

Examples: **nostr relays** (our focus of course), google, AI (Grok, ChatGPT), any legacy tech source of ratings: Amazon, Yelp, etc.

* QUESTION: Can the raw data source be ANY nostr relay? Or does it need to be a specialized relay? 
* ANSWER: **Any relay should work**, but _some relays may specialize in Grapevine services_. What this means, exactly, is yet to be determined. It might mean (for example) efficient lookup of common Interpretation Engine queries, e.g. all follows and followers. It could mean full-blown pairing of the relay with the Interpretation Engine. Somewhere in-between: changes to the nostr filter API?

### Module type 2: Interpretation Engine

A specialized service which sits between raw data and the Calculation Engine. It talks to the outside world, fetches data, turns it into a list R of GrapeRank-formatted ratings r, and passes R onto the Calculation Engine.

The Interpretation Engine may operate as a DVM.

### Module type 3: Calculation Engine

This receives GrapeRank-formatted Ratings from Interpretation Engines and runs the GrapeRank equation to produce GrapeRank Scorecards. It stores Ratings, Scorecards, and individual user settings (several categories of parameters).

### Module type 4: Front End

Where the user goes to explore all available ScoreCards and GrapeRankRatings

## APIs

There are three categories of APIs:
- interface between Raw Data and Interpretation Engine
- interface between the Interpretation Engine and the Calculation Engine
- interface between the Calculation Engine and the front end

### API type 1: Raw Data Source <--> Interpretation Engine

The structure of this API will of course be entirely dependent on the type of data source. 

If the data source type = nostr:

- Interpretation Engine receives a request that consists of protocolType (string) and parameters (JSON)
- The Interpretation Engine builds a standard nostr filter and uses it to query one or more relays (relays may or may not be specified within the parameters)
- The Interpretation Engine receives a stream of events from the relay
- The Interpretation Engine runs a function that inputs raw events, protocolName, and parameters and outputs a GrapeRank-formatted Ratings Table (R)

### API type 2: Interpretation Engine <--> Calculation Engine

- Interpretation Engine receives a request from the Calculation Engine which must contain:
    - protocolType (string)
    - parameters (JSON [? stringified]), the structure of which is dependent upon the 
- Intepretation Engine interacts with the Raw Data Source.
- Interpretation Engine returns data to the Calculation Engine
    - GrapeRank-formatted Ratings Table (R)

Each protocolType will have its own set of parameters. The "observer" may or may not be a required parameter, depending on the protocol.

The Interpretation Engine may also handle the following query:
- a request to provide a list of all supported protocolTypes (and the schema of the requisite protocol for each protocolType)

### API type 3: Calculation Engine <--> front end

The user can:
- view the user's canonical Grapevine Network
- view and update all parameters
- create, view, and update Worldviews
- update services at the subscription page
- calculate or update GrapeRank Ratings Tables (R); this will generally initiate an interaction with an Interpretation Engine
- calculate or update GrapeRank Scorecard Tables (G)
- buy or sell Scorecards, either individually or as a list, from other users

(list may be incomplete)

### API type 4: Calculation Engine <--> nostr clients



## Sources of Raw Data

Although we are nostr-focused, the Grapevine is designed to accept input from multiple sources and from multiple source types. One day, grapevine will grow beyond nostr. (See Figure.)

![Multiple Sources of Input](https://i.nostr.build/TtZ2ByM3KJsyL17r.png)
