# cache

Put reusable intermediate outputs here.

Cache files are not paper evidence by themselves and should normally stay out of
Git. If a cached artifact becomes important for reproducibility, promote it to a
documented result under `result/<case>/` and register it in
`01_IDEA/evidence_map.md`.

Never make an existing cache file a required input for a first formal run. Before
project submission or handoff, temporarily clear or rename this directory and
verify that the runnable entries can rebuild needed cache artifacts from code and
`data/`.
