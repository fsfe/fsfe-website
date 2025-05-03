# Contributing
## Build Process Code

### Tooling
We check the validity of python code in the repo using [ruff](https://astral.sh/ruff). We use it for both checking and formatting, with `ruff check` enabled in CI.

### Overview Stuff
We try to keep to some design patterns to keep things manageable.

Firstly, each phase as described in [the overview](./overview.md) should handle a meaningfully different kind of interaction. Each phase should be structured, to the greatest degree possible, as a sequence of steps. We consider that each phase should have a `run.py` file that exposes a `ipahse_*run` function that takes the arguments needed for its phase.

Each run function then calls a sequence of functions that are defined in the other files in the `phase*` folder. Each other file in the folder should expose one function, with the same name as the file, minus file extension. For example, `create_files.py` should expose the function `create_files`. It is a common pattern for the first expose function to generate a list of files or things to act on, and then multithread this using another function. 

Each step function should use `logger.info` at the top of its function to declare what it is doing.

### Best Practices
This is a little bit of a mesys list of things we have found that are not perhaps entirely obvious.


- When doing manipulation of stuff, have a look in the lib functions to see if it is already present. If you find a common pattern, perhaps functionise it.
- In phase 1, only update files using the `update_if_changed` function. This function will, as expected, take a file path and a string, and only update the file with the string if there is a difference. Not doing this means a file will always be updated, and hence anything depending on it will always be rebuild, even if the file has not actually changed.
- When generating lists that end up in files, take care that they are stable to prevent unnecessary rebuilding.
- All steps are largely considered to be synchronous, and must be finished before the next step can start. Therefore, async must unfortunately be avoided. There are some steps where performance benefits could be achieved by allowing the next step to run concurrently, but the design complications make this unattractive.
- We use a single process pool to multithread with. This gives a small performance benefit over making and deleting pools continuously.
- All paths are to be handled with `pathlib`, not as strings.
- XML code should be generated with LXML instead of string templating. This is to ensure that we generate valid XML every time, and prevents issues with escaping, etc. 
- Where possibly, type hint stuff. We try and keep the codebase reasonably typed to make it comprehensible 


