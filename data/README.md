# data

Put raw input data, case files, and small template examples here.

This directory is the complete reproducibility input set. A submitted project should
be able to start its full formal computation from the code plus files in
`data/`, after `../cache/` has been removed or renamed.

Do not make files under `cache/` required startup inputs. If a computation needs
an artifact before it can begin, keep that artifact here or make the code rebuild
it from files kept here.

Keep large or private datasets out of Git unless the project author explicitly
decides they are publishable and lightweight enough for the repository.
When public Git omits large or private inputs, the final submission or handoff
package should include the complete `data/` tree needed for reproduction.

By default, generic `.mat` files outside `data/` are ignored, while files under
`data/` are allowed so curated reproduction inputs can travel with a specific
research project. Add explicit ignore rules only for data files that must stay
private or intentionally omitted from a public Git mirror.
