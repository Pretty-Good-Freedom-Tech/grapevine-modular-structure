Grapevine Front End Module
=====

It is probably not essential to separate the Calculation Engine and the Front End Module in the early stages. In the long run, it may be a good idea to separate them for several reasons:
- Modularity invites members of the community to innovate in focused areas. Expertise, interest and ability to innovate on the calculation engine vs on the front end are two very different things.
- In the long run, computational demands of the calculation engine will become rate limiting. We would like to avoid these computational demands to affect UX.

Therefore, for the short run, the calculation engine and the front end will be merged.

## database

There will be significant overlap with the calculation engine db. (Or much of the calculation engine db will simply be moved to the front end?)

CREATE CORE DATABASE: GrapevineCalculationEngine_core.db

TABLES:

tbd
