import logging
import multiprocessing
import textwrap
from pathlib import Path

import lxml.etree as etree

from build.lib import get_basepath

logger = logging.getLogger(__name__)


def _write_localmenus(
    dir: str, files_by_dir: dict[str, list[Path]], languages: list[str]
) -> None:
    """
    Write localmenus for a given directory
    """
    base_files = sorted(
        list(
            set(
                map(
                    lambda filter_file: get_basepath(filter_file),
                    files_by_dir[dir],
                )
            )
        )
    )
    for lang in languages:
        file = Path(dir).joinpath(f".localmenu.{lang}.xml")
        logger.debug(f"Creating {file}")
        file.write_text(
            textwrap.dedent("""\
                        <?xml version="1.0"?>

                        <feed>
                       """)
        )
        with file.open("a") as working_file:
            for base_file in base_files:
                tmpfile = (
                    base_file.with_suffix(f".{lang}").with_suffix(".xhtml")
                    if base_file.with_suffix(f".{lang}").with_suffix(".xhtml").exists()
                    else base_file.with_suffix(".en.xhtml")
                    if base_file.with_suffix(".en.xhtml").exists()
                    else None
                )
                if not tmpfile:
                    continue
                xslt_root = etree.parse(tmpfile)
                for localmenu in xslt_root.xpath("//localmenu"):
                    working_file.write(
                        '\n<localmenuitem set="'
                        + (
                            str(localmenu.xpath("./@set")[0])
                            if localmenu.xpath("./@set") != []
                            else "default"
                        )
                        + '" id="'
                        + (
                            str(localmenu.xpath("./@id")[0])
                            if localmenu.xpath("./@id") != []
                            else "default"
                        )
                        + f'" link="/{Path(*Path(base_file).parts[1:])}.html">'
                        + localmenu.text
                        + "</localmenuitem>"
                    )

            working_file.write(
                textwrap.dedent("""\
                        \n
                        </feed>
                       """)
            )


def update_localmenus(languages: list[str]) -> None:
    """
    Update all the .localmenu.*.xml files containing the local menus.
    """
    logger.info("Updating local menus")
    # Get a dict of all source files containing local menus
    files_by_dir = {}
    for file in filter(
        lambda path: etree.parse(path).xpath("//localmenu")
        and "-template" not in str(path),
        Path(".").glob("*?.?*/**/*.??.xhtml"),
    ):
        xslt_root = etree.parse(file)
        dir = xslt_root.xpath("//localmenu/@dir")
        dir = dir[0] if dir else str(file.parent.relative_to(Path(".")))
        if dir not in files_by_dir:
            files_by_dir[dir] = set()
        files_by_dir[dir].add(file)
    for dir in files_by_dir:
        files_by_dir[dir] = sorted(list(files_by_dir[dir]))

    # If any of the source files has been updated, rebuild all .localmenu.*.xml
    dirs = filter(
        lambda dir: (
            any(
                (
                    (not Path(dir).joinpath(".localmenu.en.xml").exists())
                    or (
                        file.stat().st_mtime
                        > Path(dir).joinpath(".localmenu.en.xml").stat().st_mtime
                    )
                )
                for file in files_by_dir[dir]
            )
        ),
        files_by_dir,
    )
    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.starmap(
            _write_localmenus, [(dir, files_by_dir, languages) for dir in dirs]
        )
