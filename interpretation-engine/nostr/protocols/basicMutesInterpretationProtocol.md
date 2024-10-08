mutes
=====

### universalInterpretationProtocolID

`basicMutesInterpretationProtocol`

### name

mutes

### title

Mutes

### description

This interpretation protocol receives an array of `pubkeys`, looks up the kind 10000 note for each pubkey, and generates a rating for each mute with the `score` and `confidence` as provided in the parameters. Note that unlike the `follows` protocol, the `depth` parameter is not expected in the `parameters` object of the `request`.

By default, each rating will contain the string: `notSpam` into the context field. This can be overriden by inclusion of the optional `context` in the input parameters.

### naddr

The naddr that contains all relevant information for this protocol, most notably the json schema (below): in progress

### Parameters

Sample set of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

```
{
      score: 0.0,
      confidence: 0.1,
      pubkeys: [...],
      context: notSpam,
}
```

The JSON Schema, against which the parameters must validate.

```
{
      required: [ "score", "confidence", "pubkeys" ],
      properties: {
            score: {
                  type: float,
                  min: 0.0,
                  max: 1.0,
                  default: 0.0,
            },
            confidence: {
                  type: float,
                  min: 0.0,
                  max: 1.0,
                  default: 0.1,
            },
            pubkeys: {
                  type: array,
                  contains: {
                        type: string,
                  },
                  minContains: 1,
            },
            context: {
                  type: string,
                  default: notSpam,
            },
      }
}
```

Note that the `context` property is not required, and that the `depth` property is absent.

