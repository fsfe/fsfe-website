import logging
import multiprocessing
from pathlib import Path

logger = logging.getLogger(__name__)


def _copy_file(target: Path, source_file: Path) -> None:
    target_file = target.joinpath(source_file)
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug(f"Copying {source_file} to {target_file}")
        target_file.parent.mkdir(parents=True, exist_ok=True)
        target_file.write_bytes(source_file.read_bytes())


def copy_files(target: Path) -> None:
    """
    Copy images, docments etc
    """
    logger.info("Copying over media and misc files")
    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.starmap(
            _copy_file,
            [
                (target, file)
                for file in filter(
                    lambda path: path.is_file()
                    and path.suffix
                    not in [
                        ".md",
                        ".yml",
                        ".gitignore",
                        ".sources",
                        ".xmllist",
                        ".xhtml",
                        ".xsl",
                        ".xml",
                        ".less",
                    ]
                    and path.name not in ["Makefile"],
                    Path("").glob("*?.?*/**/*?.*"),
                )
            ],
        )


# # Copy images, docments etc
# # -----------------------------------------------------------------------------

# # All files which should just be copied over
# COPY_SRC_FILES := \$(shell find -L "\$(INPUTDIR)" -type f \
#   -regex "\$(INPUTDIR)/[a-z\.]+\.[a-z]+/.*" \
#   -not -name '.drone.yml' \
#   -not -name '.gitignore' \
#   -not -name 'README*' \
#   -not -name 'Makefile' \
#   -not -name '*.sources' \
#   -not -name "*.xmllist" \
#   -not -name '*.xhtml' \
#   -not -name '*.xml' \
#   -not -name '*.xsl' \
#   -not -name '*.nix' \
# ) \$(INPUTDIR)/fsfe.org/order/data/items.en.xml

# # The same as above, but moved to the output directory
# COPY_DST_FILES := \$(sort \$(patsubst \$(INPUTDIR)/%,\$(OUTPUTDIR)/%,\$(COPY_SRC_FILES)))

# all: \$(COPY_DST_FILES)
# \$(COPY_DST_FILES): \$(OUTPUTDIR)/%: \$(INPUTDIR)/%
# 	echo "* Copying file \$*"
# 	rsync -l "\$<" "\$@"
