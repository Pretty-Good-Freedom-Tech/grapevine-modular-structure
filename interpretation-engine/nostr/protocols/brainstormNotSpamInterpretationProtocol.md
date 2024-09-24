not spam
=====

### universalInterpretationProtocolID

`brainstormNotSpamInterpretationProtocol`

### name

not spam

### title

Not Spam

### description

This interpretation protocol receives an array of `pubkeys`, looks up the kind 3, kind 10000 and kind 1984 notes for each pubkey, and generates a rating for each follow, mute, and report with the `score` and `confidence` as provided in the parameters. This process is repeated (follows' follows, their follows, etc) as indicated by the `depth` parameter. 

By default, each rating will contain the string: `notSpam` into the context field. This can be overriden by inclusion of `context` in the input parameters.

#### edge cases

If Alice reports Bob more than once, only one rating will be included in the final R table.

If Alice follows AND mutes Bob, then no rating of Bob by Alice will be included in the final R table.

If Alice mutes AND reports Bob, then TWO ratings of Bob by Alice will be included, one for the mute and one for the report.

(Other edge cases?)

### naddr

The naddr that contains all relevant information for this protocol, most notably the json schema (below): in progress

### Parameters

Sample set of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

```
{
  follows: {
    score: 1.0,
    confidence: 0.05,
  },
  mutes: {
    score: 0.0,
    confidence: 0.1,
  },
  reports: {
    score: 0.0,
    confidence: 0.2,
    reportTypes: [ "all" ],
  },
  depth: 5,
  pubkeys: [...],
  context: notSpam,
}
```

The JSON Schema, against which the parameters must validate.

(work in progress)


