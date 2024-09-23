# Nostr Interpretation Engine 

## API

The Nostr Interpretation Engine communicates with the Calculation Engine via [API](../../APIs/calculationInterpretationAPI.md).

It communicates with a nostr relay in the usual fashion.

## Functions

The function `processRequest` takes the request object as input and outputs the response object, which is ready to be sent back to the Calculation Engine.

Upon receiving a request via API, the Interpretation Engine performs the following steps:
1. If `universalInterpretationProtocolID` is in the local db, proceed to step 2. If not, throw an error with the message: "universalInterpretationProtocolID not recognized."
2. Validate `parameters` against protocol json schema in the local db. If validates, proceed to step 3. If not, throw an error with the message: "parameters do not validate against the expected JSON Schema." (optional: provide naddr with the expected json schema.)
3. Execute the function which corresponds to the interpretation protocol. 

```
const processRequest = async (request) => {
  const universalInterpretationProtocolID = request.universalInterpretationProtocolID
  const parameters = universalInterpretationProtocolID.paremeters
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

```
const errorInterpretationProtocolNotRecognized = () => {
  const response = { success: false; message: "universalInterpretationProtocolID not recognized." }
  return response;
}
```
