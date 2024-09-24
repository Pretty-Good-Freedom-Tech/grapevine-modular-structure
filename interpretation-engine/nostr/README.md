# Nostr Interpretation Engine 

The Nostr Interpretation Engine communicates with the Calculation Engine via an [API](../../APIs/calculationInterpretationAPI.md) in a two-step process:
1. The Calculation Engine sends a `request` object to the Interpretation Engine.
2. The Interpretation Engine sends a `response` object to the Calculation Engine.

To generate the `response`, the Interpretation Engine must execute one of a list of known [nostr interpretation protocols](./protocols/README.md). For each protocol, there will be a single `governing function` which executes that protocol. These "second level" functions will communication with one or more nostr relays in the usual fashion. Beginner protocols will be limited to a single nostr event kind per protocol, but advanced protocols may request multiple event kinds.

## Functions

### Top level function

The top-level function of the nostr Interpretation Engine is `processRequest`. `processRequest` takes the `request` object as input and outputs the `response` object, which is ready to be sent back to the Calculation Engine.

Upon receiving a request via API, the Interpretation Engine performs the following steps:
1. Make sure the `request` object validates against the `nostr interpretation engine request json schema` (see [API](../../APIs/calculationInterpretationAPI.md).)
2. If `universalInterpretationProtocolID` is in the `interpretationProtocols` table of the [local database](./database-initialization-core.sql), proceed to the next step. If not, throw an error with the message: "universalInterpretationProtocolID not recognized."
3. Validate `parameters` against protocol json schema in the `interpretationProtocols` table of the local database. For example, see the json schema for the [beginner follows protocol](./protocols/basicFollowsInterpretationProtocol.md). If it validates, proceed to the next step. If not, throw an error with the message: "Parameters do not validate against the expected JSON Schema." (optional: provide naddr with the expected json schema.)
4. Execute the function which corresponds to the interpretation protocol. 

```
const processRequest = async (request) => {

  \\ Validate the request object. If invalid
  \\ return result = errorInvalidRequest()

  const universalInterpretationProtocolID = request.universalInterpretationProtocolID
  const parameters = universalInterpretationProtocolID.paremeters

  \\ Validate parameters. If invalid, throw an error:
  \\ return result = errorInvalidParameters()
  \\ Alternatively, process errors of this type individually inside each governing protocol function.

  const aRatings = []

  switch(universalInterpretationProtocolID) {
    case "basicBrainstormFollowsOnlyInterpretationProtocol":
      aRatings = await returnFollowsOnlyTable(parameters)
      break
    case "basicdBrainstormMutesOnlyInterpretationProtocol":
      aRatings = await returnMutesOnlyTable(parameters)
      break
    case "basicBrainstormReportsOnlyInterpretationProtocol":
      aRatings = await returnReportsOnlyTable(parameters)
      break
    case "expandedBrainstormReportsOnlyInterpretationProtocol":
      aRatings = await returnExpandedReportsOnlyTable(parameters)
      break
    case "recommendedBrainstormNotBotsInterpretationProtocol": // follows, mutes, and reports (may add zaps, other sources of data later)
      aRatings = await returnNotBotsTable(parameters)
      break
    /*
    // alternate: return here instead of break
    case "recommendedBrainstormNotBotsInterpretationProtocol": // follows, mutes, and reports (may add zaps, other sources of data later)
      return response = await returnNotBotsTable(parameters)
    */
    default
      return response = errorInterpretationProtocolNotRecognized()
  }

  const response = {
    success: true,
    ratingsTable: aRatings
  }
  return response
  // I'm not sure how to make sure to delay this return until after aRatings is returned. Maybe in place of each break above, return result
}

const response = await processRequest(request)
```

### Second level functions (i.e., the protocol-specific _governing functions_)

Follows:

```
const returnFollowsOnlyTable = async (params) => {
  const aRatings = []
  /* build the aRatings table from follows */
  return aRatings;
} 
```

Mutes:

```
const returnMutesOnlyTable = async (params) => {
  const aRatings = []
  /* build the aRatings table from mutes */
  return aRatings;
} 
```

Reports:

```
const returnReportsOnlyTable = async (params) => {
  const aRatings = []
  /* build the aRatings table from reports */
  return aRatings;
} 
```

Expanded Reports:

```
const returnExpandedReportsOnlyTable = async (params) => {
  const aRatings = []
  /* build the aRatings table from reports, limited to the indicated report types */
  return aRatings;
} 
```

Brainstorm Not Spam:

```
const returnMutesOnlyTable = async (params) => {
  const aRatings = []
  /* build the aRatings table from follows, mutes, and reports */
  return aRatings;
} 
```

### Error functions 

```
const errorInvalidRequest = () => {
  const response = { success: false; message: "The request object does not validate." }
  \\ optional: include naddr or some other pointer to the json schema against which the request must validate
  return response;
}
```

```
const errorInterpretationProtocolNotRecognized = () => {
  const response = { success: false; message: "universalInterpretationProtocolID not recognized." }
  \\ optional: include a list of all recognized protocols
  return response;
}
```

```
const errorInvalidParameters = () => {
  const response = { success: false; message: "Parameters do not validate against the expected JSON Schema." }
  \\ optional: include naddr or some other pointer to the json schema against which the request must validate
  \\ another option: each governing function could have its own bespoke error response
  return response;
}
```

