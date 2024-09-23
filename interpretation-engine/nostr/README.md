# Nostr Interpretation Engine 

## API

The Nostr Interpretation Engine communicates with the Calculation Engine via [API](../../APIs/calculationInterpretationAPIs.md)

## Functions

Upon receiving a request via API, the Interpretation Engine performs the following steps:
1. If interpretationProtocolSlug is in the local db, proceed to step 2. If not, throw an error: "Interpretation Protocol not recognized."
2. Validate protocolSchema against protocol json schema in the local db. If validates, proceed to step 3. If not, throw an error: "Protocol Parameters do not validate against the expected JSON Schema." (optional: provide naddr with the expected json schema.)
3. Execute the function which corresponds to the 

```
function processRequest = async (interpretationProtocolSlug, oParams) => {
  switch(interpretationProtocolSlug) {
    case "basicBrainstormFollowsOnlyProtocol"
      return await result = fxn1(params)
    case "basicdBrainstormMutesOnlyProtocol"
      return await result = fxn2(params)
    case "basicBrainstormReportsOnlyProtocol"
      return await result = fxn2(params)    
    case "recommendedBrainstormNotBotsProtocol" // follows, mutes, and reports (for now; may add more later)
      return await result = fxn2(params)    
    default
      return errorInterpretationProtocolNotRecognized
  }
}
```
