# -----------------------------------------------------------------------------
# script for FSFE website build, phase 1
# -----------------------------------------------------------------------------
# This script is a shim to import and run the phase1 function defined in the build repo.
# This script is called by the bash build script in
# Once that bash is replaced by python this function call can be moved to the toplevel build.py or similar
import argparse
import logging
from os import environ

from build.phase1.run import phase1_run

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("languages")
    args = parser.parse_args()
    # Read the log level from the LOGLEVEL environment variable and default to INFO
    logging.basicConfig(
        format="*   %(message)s", level=environ.get("LOGLEVEL", "INFO").upper()
    )
    languages = args.languages.split()
    phase1_run(languages)
