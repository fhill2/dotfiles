from promnesia.common import Source
from promnesia.sources import auto, vcs


from pathlib import Path
import os
home = str(Path.home())



# these are indexed when running promnesia index
SOURCES = [
    Source(
        auto.index,
        # just some arbitrary directory with plaintext files
        os.path.join(home, "dev", "notes"),
        name="notes"
    ),

    # retrieves all files from a git repo and indexes them as if they were passed in to auto.index
    # Source(
    #     vcs.index, # you could also use 'vcs.index', but auto can handle it anyway
    #     'https://github.com/karlicoss/exobrain',
    #     name='exobrain',
    # )
]
