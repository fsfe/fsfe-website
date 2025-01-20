import logging
import multiprocessing
from pathlib import Path
import subprocess

logger = logging.getLogger(__name__)


def _process_dir(languages: list[str], target: Path, dir: Path) -> None:
    for basename in set(
        map(lambda path: path.with_suffix("").with_suffix(""), dir.glob("*.??.xhtml"))
    ):
        for lang in languages:
            source_file = basename.with_suffix(f".{lang}.xhtml")
            target_file = target.joinpath(source_file).with_suffix(".html")
            if not target.exists() or any(
                [
                    (file is None or file.stat().st_mtime > target.stat().st_mtime)
                    for file in [
                        (
                            source_file
                            if source_file.exists()
                            else basename.with_suffix(".en.xhtml")
                            if basename.with_suffix(".en.xhtml").exists()
                            else None
                        ),
                        (
                            basename.with_suffix(".xsl")
                            if basename.parent.joinpath(
                                f".{basename.stem}.xsl"
                            ).exists()
                            else basename.parent.joinpath(".default.xsl")
                        ),
                        (
                            target_file.with_suffix("").with_suffix(".xmllist")
                            if target_file.with_suffix("")
                            .with_suffix(".xmllist")
                            .exists()
                            else None
                        ),
                        Path(f"global/data/texts/.texts.{lang}.xml"),
                        Path(f"global/data/topbanner/.topbanner.{lang}.xml"),
                        Path("global/data/texts/texts.en.xml"),
                    ]
                ]
            ):
                result = subprocess.run(
                    [
                        "build/process_file.sh",
                        "--build-env",
                        "development",
                        "--source",
                        "./",
                        "process_file",
                        source_file,
                    ],
                    capture_output=True,
                )
                target_file.parent.mkdir(parents=True, exist_ok=True)
                target_file.write_bytes(result.stdout)


def process_xhtml_files(languages: list[str], target: Path) -> None:
    """
    Create the generated xhtml files from xml sources
    """
    logger.info("Processing xhtml files")

    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.starmap(
            _process_dir,
            [
                (languages, target, dir)
                for dir in set(
                    map(lambda path: path.parent, Path("").glob("*?.?*/**/*.*.xhtml"))
                )
            ],
        )
