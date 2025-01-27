import logging
import multiprocessing
from pathlib import Path

from build.process_file import process_file

logger = logging.getLogger(__name__)


def _process_stylesheet(languages: list[str], target: Path, source_xsl: Path) -> None:
    base_file = source_xsl.with_suffix("").with_suffix("")
    destination_base = target.joinpath(base_file)
    for lang in languages:
        target_file = destination_base.with_suffix(
            f".{lang}{source_xsl.with_suffix('').suffix}"
        )
        source_xhtml = base_file.with_suffix(f".{lang}.xhtml")
        if not target_file.exists() or any(
            # If any source file is newer than the file to be generated
            [
                (file.exists() and file.stat().st_mtime > target_file.stat().st_mtime)
                for file in [
                    (
                        source_xhtml
                        if source_xhtml.exists()
                        else base_file.with_suffix(".en.xhtml")
                    ),
                    source_xsl,
                    Path(f"global/data/texts/.texts.{lang}.xml"),
                    Path("global/data/texts/texts.en.xml"),
                ]
            ]
        ):
            logger.debug(f"Building {target_file}")
            result = process_file(source_xhtml, source_xsl)
            target_file.parent.mkdir(parents=True, exist_ok=True)
            target_file.write_text(result)


def process_rss_ics_files(languages: list[str], target: Path) -> None:
    """
    Build .rss files from .xhtml sources
    """
    logger.info("Processing rss files")
    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.starmap(
            _process_stylesheet,
            [
                (languages, target, source_xsl)
                for source_xsl in Path("").glob("*?.?*/**/*.rss.xsl")
            ],
        )
    logger.info("Processing ics files")
    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.starmap(
            _process_stylesheet,
            [
                (languages, target, source_xsl)
                for source_xsl in Path("").glob("*?.?*/**/*.ics.xsl")
            ],
        )
