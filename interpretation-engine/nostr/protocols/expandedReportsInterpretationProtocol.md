Expanded reports
=====

### universalInterpretationProtocolID

`expandedReportsInterpretationProtocol`

### name

expanded reports

### title

Expanded Reports

### description

This interpretation protocol follows [NIP-56](https://github.com/nostr-protocol/nips/blob/master/56.md).

This interpretation protocol receives an array of `pubkeys`, looks up all kind 1984 notes for each pubkey, and generates a rating for each report with the `score` and `confidence` as provided in the parameters. Note that unlike the `follows` protocol, the `depth` parameter is not expected in the `parameters` object of the `request`.

Unlike the more simple version of the reports protocol, the user must specify which NIP-56 `reportTypes` to turn into ratings. All other report types will be ignored (but could be handled via a separate API call).

By default, each rating will contain the string: `notSpam` into the context field. This can be overriden by inclusion of the optional `context` in the input parameters.

### naddr

The naddr that contains all relevant information for this protocol, most notably the json schema (below): in progress

### Parameters

Sample set of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

```
{
      score: 0.0,
      confidence: 0.2,
      pubkeys: [...],
      reportTypes: [],
      context: notSpam,
}
```

The JSON Schema, against which the parameters must validate.

```
{
      required: [ "score", "confidence", "pubkeys", "reportTypes" ],
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
                  default: 0.2,
            },
            pubkeys: {
                  type: array,
                  contains: {
                        type: string,
                  },
                  minContains: 1,
            },
            reportTypes: {
                  type: array,
                  contains: {
                        type: string,
                  },
                  enum: [ "nudity", "malware", "profanity", "illegal", "spam", "impersonization", "other" ],
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

