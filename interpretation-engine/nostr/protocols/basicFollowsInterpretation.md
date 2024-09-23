basicFollowsInterpretation
=====

### universalInterpretationProtocolID

basicFollowsInterpretation
      
### description

### naddr

The naddr that contains all relevant information for this protocol, most notably the json schema (below): in progress

### Parameters

Sample set of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

```
{
  score: 1.0,
  confidence: 0.05,
}
```

The JSON Schema, against which the parameters must validate.

```
{
  properties: {
    score: {
      type: float,
      min: 0.0,
      max: 1.0,
      default: 1.0,
    },
    confidence: {
      type: float,
      min: 0.0,
      max: 1.0,
      default: 0.05,
    },
  }
}
```
