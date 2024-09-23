Nostr Interpretation Protocols
=====

Each nostr-enabled Calculation Engine and nostr Interpretation Engine maintain a table of nostr interpretation protocols. Salient features of each protocol include:
- `universalInterpretationProtocolID` (could be a slug, e.g. `basicFollowsInterpretation`) _must match exactly across modules so they can communicate unambiguously with each other_.
- `name` and `title` which do not need to match exactly across modules.
- `description`: human readable; needs to specify in sufficient detail so that a developer could create the engine without ambiguity
- a json schema which describes the structure of the object of parameters that are communicated via API from the Calculation Engine to the Interpretation Engine

## Starter Protocols

[follows](./basicFollowsInterpretationProtocol.md)

[mutes](./basicMutesInterpretationProtocol.md)

[reports](./basicReportsInterpretationProtocol.md)

[expanded reports](./expandedReportsInterpretationProtocol.md)

Like reports, but treat e.g. nudity differently than spam

[full brainstorm not spam](./brainstormNotSpamInterpretationProtocol.md)

follows, mutes, and reports all in one interpretation protocol
