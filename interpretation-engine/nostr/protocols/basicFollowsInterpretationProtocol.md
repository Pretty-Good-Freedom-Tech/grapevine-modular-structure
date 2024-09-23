follows
=====

### universalInterpretationProtocolID

`basicFollowsInterpretationProtocol`

### name

follows

### title

Follows

### description

This interpretation protocol receives an array of `pubkeys`, looks up the kind 3 note for each pubkey, and generates a rating for each follow with the `score` and `confidence` as provided in the parameters. This process is repeated (follows' follows, their follows, etc) as indicated by the `depth` parameter.

Each rating puts the string: `notSpam` into the context field.

### naddr

The naddr that contains all relevant information for this protocol, most notably the json schema (below): in progress

### Parameters

Sample set of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

```
{
      score: 1.0,
      confidence: 0.05,
      depth: 5,
      pubkeys: [...],
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
            depth: {
                  type: integer,
                  min: 1,
                  default: 5,
            },
            pubkeys: {
                  type: array,
                  contains: {
                        type: string,
                  },
                  minContains: 1,
            },
      }
}
```
