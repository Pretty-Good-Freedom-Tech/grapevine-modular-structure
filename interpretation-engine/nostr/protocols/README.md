Nostr Interpretation Protocols
=====

Each nostr Interpretation Engine maintains a table of nostr interpretation protocols. Salient features of each protocol include:
- universalInterpretationProtocolID (could be a slug, e.g. `basicFollowsInterpretation`)
- description: human readable; needs to specifiy in sufficient detail so that a developer could create the engine without ambiguity
- a json schema which describes the structure of the object of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

## Example Protocols

[follows](./basicFollowsInterpretationProtocol.md)

[mutes](./basicMutesInterpretationProtocol.md)

[reports](./basicReportsInterpretationProtocol.md)

[expanded reports](./expandedReportsInterpretationProtocol.md)

Like reports, but treat e.g. nudity differently than spam

[full brainstorm not spam](./brainstormNotSpamInterpretationProtocol.md)

follows, mutes, and reports all in one interpretation protocol
