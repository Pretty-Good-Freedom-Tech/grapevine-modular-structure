the Calculation / Interpretation API
=====

# Request

The Calculation Engine sends a request to the nostr Interpretation Engine. 

An example request is the following:

```
{
  universalInterpretationProtocolID: basicFollowsInterpretationProtocol
  parameters: ...
}
```

Where `parameters` is a stringified version of an object, the schema of which is protocol-specific.

Example of parameters before stringification:

```
{
  score: 1.0,
  confidence: 0.05,
  depth: 5,
  pubkeys: [...],
}
```

# Response

The Interpretation Engine sends a response back to the Calculation Engine.

## success

An example success response:

```
{
  success: true,
  ratingsTable: ...
}
```

The `ratingsTable` is a stringified (or should we leave this as an array?) array of individual ratings. Example:

```
[
  {
    rater: pk_Bob,
    ratee: pk_Alice,
    context: notSpam,
    score: 1.0,
    confidence: 0.05
  },
  {
    rater: pk_Bob,
    ratee: pk_Charlie,
    context: notSpam,
    score: 1.0,
    confidence: 0.05
  }
]
```

## Error responses

```
{
  success: false,
  message: ...
}
```

(work in progress to specify the error messages)
