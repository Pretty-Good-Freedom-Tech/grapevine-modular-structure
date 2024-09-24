# Nostr Interpretation Engine 

The Nostr Interpretation Engine communicates with the Calculation Engine via an [API](../../APIs/calculationInterpretationAPI.md) in a two-step process:
1. The Calculation Engine sends a `request` object to the Interpretation Engine.
2. The Interpretation Engine sends a `response` object to the Calculation Engine.

To generate the `response`, the Interpretation Engine must execute one of a list of known [nostr interpretation protocols](./protocols/README.md). For each protocol, there will be a single governing function which executes that protocol. These functions will communication with one or more nostr relays in the usual fashion. Beginner protocols will be limited to a single nostr event kind, but advanced protocols may request multiple event kinds.

## Functions

The top-level function of the nostr Interpretation Engine is `processRequest`. `processRequest` takes the `request` object as input and outputs the `response` object, which is ready to be sent back to the Calculation Engine.

Upon receiving a request via API, the Interpretation Engine performs the following steps:
1. Make sure the `request` object validates against the `nostr interpretation engine request json schema`.
2. If `universalInterpretationProtocolID` is in the local db, proceed to step 2. If not, throw an error with the message: "universalInterpretationProtocolID not recognized."
3. Validate `parameters` against protocol json schema in the local db. If validates, proceed to step 3. If not, throw an error with the message: "parameters do not validate against the expected JSON Schema." (optional: provide naddr with the expected json schema.)
4. Execute the function which corresponds to the interpretation protocol. 

```
const processRequest = async (request) => {

  \\ 1. validate the request object. If invalid
  \\ return result = errorInvalidRequest()



  const universalInterpretationProtocolID = request.universalInterpretationProtocolID
  const parameters = universalInterpretationProtocolID.paremeters
  \\ 2. 

  switch(universalInterpretationProtocolID) {
    case "basicBrainstormFollowsOnlyInterpretationProtocol":
      return result = await returnFollowsOnlyTable(params)
    case "basicdBrainstormMutesOnlyInterpretationProtocol":
      return result = await returnMutesOnlyTable(params)
    case "basicBrainstormReportsOnlyInterpretationProtocol":
      return result = await returnReportsOnlyTable(params)    
    case "recommendedBrainstormNotBotsInterpretationProtocol": // follows, mutes, and reports (may add zaps, other sources of data later)
      return result = await returnNotBotsTable(params)    
    default
      return result = errorInterpretationProtocolNotRecognized()
  }
}

const response = await processRequest(request)
```

Follows:

```
const returnFollowsOnlyTable = async (params) => {
  const aRatings = []

  /* build the aRatings table from follows */

  const response = {
    success: true,
    ratingsTable: aRatings
  }
  return response;
} 
```

Mutes:

```
const returnMutesOnlyTable = async (params) => {
  const aRatings = []

  /* build the aRatings table from mutes */

  const response = {
    success: true,
    ratingsTable: aRatings
  }
  return response;
} 
```

### Error functions 

```
const errorInterpretationProtocolNotRecognized = () => {
  const response = { success: false; message: "universalInterpretationProtocolID not recognized." }
  \\ optional: include a list of all recognized protocols
  return response;
}
```

```
const errorInvalidRequest = () => {
  const response = { success: false; message: "The request object does not validate." }
  \\ optional: include naddr or some other pointer to the json schema against which the request must validate
  return response;
}
```
