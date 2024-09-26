the Calculation / Interpretation API
=====

The Calculation Engine sends a `request` to the nostr Interpretation Engine, which returns a `response`.

## Request

The `request` is an object with three properties: `source`, `universalInterpretationProtocolID` and `parameters`, each of which is a string.

The request must validate against the `nostr interpretation engine request json schema`:

```
{
  required: [ "source", "universalInterpretationProtocolID", "parameters" ],
  properties: {
    source: {
      type: string,
      enum: [ " nostr" ]
    },
    universalInterpretationProtocolID: {
      type: string
    },
    parameters: {
      type: string
    },
  }
}
```
where: 
- `universalInterpretationProtocolID` must be recognized, i.e. must be in the Interpretation Engine's database of supported protocols
- `parameters` is a stringified version of an object, the schema of which is protocol-specific.

An example request is the following:

```
{
  source: nostr
  universalInterpretationProtocolID: basicFollowsInterpretationProtocol
  parameters: ... (see below)
}
```

where `parameters` is the stringified object:

```
{
  score: 1.0,
  confidence: 0.05,
  depth: 5,
  pubkeys: [...],
  context: notSpam
}
```

## Response

The Interpretation Engine sends a response back to the Calculation Engine.

### success

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

### Error responses

```
{
  success: false,
  message: ...
}
```

(work in progress to specify the error messages)
