GrapeRank Interpretation Engine 
=====

## [nostr interpretation engine](./nostr/README.md)

## Amazon interpretation engine 

(in progress)

## AI interpretation engine 

(in progress)

# Nostr Interpretation Engine Database (cache)

An Interpretation Engine receives a request via API with:
- interpretationProtocolSlug
- a set of parameters in JSON, stringified

Upon receiving a request via API, the Interpretation Engine performs the following steps:
1. If interpretationProtocolSlug is in the local db, proceed to step 2. If not, throw an error: "Interpretation Protocol not recognized."
2. Validate protocolSchema against protocol json schema in the local db. If validates, proceed to step 3. If not, throw an error: "Protocol Parameters do not validate against the expected JSON Schema." (optional: provide naddr with the expected json schema.)
3. Execute the function which corresponds to the 


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

SQL table of interpretationProtocols, descriptions, and their JSON Schema

col1: interpretationProtocolSlug
col2: description
col3: params-JSON-schema (stringified)
col4: naddr-for-params-json-schema
?? col5: default-params ?? (maybe pull these from the json-schema??)
