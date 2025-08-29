import subprocess
from pathlib import Path
from time import sleep

import pytest
from fsfe_website_build.lib.misc import (
    delete_file,
    get_basename,
    get_basepath,
    get_version,
    keys_exists,
    lang_from_filename,
    run_command,
    sort_dict,
    touch_if_newer_dep,
    update_if_changed,
)


def keys_exists_test() -> None:
    nested = {"a": {"b": {"c": 42}}}
    assert keys_exists(nested, "a", "b", "c") is True
    assert keys_exists(nested, "a", "missing") is False


def keys_exists_bad_input_test() -> None:
    with pytest.raises(TypeError):
        keys_exists([], "a")
    assert keys_exists({}, "a") is False


def sort_dict_test() -> None:
    src = {"b": 2, "a": 1, "c": 3}
    assert sort_dict(src) == {"a": 1, "b": 2, "c": 3}


def update_if_changed_test(tmp_path: Path) -> None:
    file = tmp_path / "foo.txt"
    content = "hello"
    update_if_changed(file, content)
    assert file.read_text() == content

    update_if_changed(file, content)  # no change -> no write
    assert file.read_text() == content

    new_content = "world"
    update_if_changed(file, new_content)
    assert file.read_text() == new_content


# ---------- touch_if_newer_dep ----------
def touch_if_newer_dep_test(tmp_path: Path) -> None:
    target = tmp_path / "target"
    target.write_text("target")
    # Ensure mtime of dep is later
    sleep(1)
    dep = tmp_path / "dep"
    dep.write_text("dep")
    mtime_before = target.stat().st_mtime
    touch_if_newer_dep(target, [dep])
    mtime_after = target.stat().st_mtime
    assert mtime_after > mtime_before


def delete_file_test(tmp_path: Path) -> None:
    f = tmp_path / "gone.txt"
    f.write_text("bye")
    delete_file(f)
    assert not f.exists()


def lang_from_filename_test() -> None:
    assert lang_from_filename(Path("index.en.html")) == "en"
    assert lang_from_filename(Path("index.nolang.html")) == "nolang"


def lang_from_filename_bad_test() -> None:
    with pytest.raises(RuntimeError):
        lang_from_filename(Path("index.eng.html"))


def run_command_test() -> None:
    with pytest.raises(subprocess.CalledProcessError):
        run_command(["false"])


def run_command_ok_test() -> None:
    out = run_command(["echo", "success"])
    assert out == "success"


def get_version_valid_test(tmp_path: Path) -> None:
    xml_file = tmp_path / "page.xml"
    version = 3
    xml_file.write_text(f"<root><version>{version}</version></root>")

    assert get_version(xml_file) == version


def get_version_no_version_test(tmp_path: Path) -> None:
    xml_file = tmp_path / "page.xml"
    xml_file.write_text("<root/>")
    assert get_version(xml_file) == 0


def get_basepath_test() -> None:
    assert get_basepath(Path("a.b.c")) == Path("a")
    assert get_basepath(Path("a/b.c.d")) == Path("a/b")


def get_basename_test() -> None:
    assert get_basename(Path("a.b.c")) == "a"
    assert get_basename(Path("a/b.c.d")) == "b"
