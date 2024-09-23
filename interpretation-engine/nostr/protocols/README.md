Nostr Interpretation Protocols
=====

Each nostr Interpretation Engine maintains a table of nostr interpretation protocols. Salient features of each protocol include:
- universalInterpretationProtocolID (could be a slug, e.g. `basicFollowsInterpretation`)
- description: human readable; needs to specifiy in sufficient detail so that a developer could create the engine without ambiguity
- a json schema which describes the structure of the object of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

## Example Protocols

[basicFollowsInterpretation](./basicFollowsInterpretation.md)

[basicMutesInterpretation](./basicMutesInterpretation.md)

[basicReportsInterpretation](./basicReportsInterpretation.md)

[expandedReportsInterpretation](./expandedReportsInterpretation.md)

[brainstormNotSpam](./brainstormNotSpam.md)

