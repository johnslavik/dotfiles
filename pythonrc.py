import importlib.util
import inspect
import os
import sys
from collections.abc import Callable
from functools import partial
from typing import Any

if importlib.util.find_spec("pythonrc_manager") is None:
    sys.path.append(os.path.expanduser("~"))

from pythonrc_manager import DisplayHookPatcher as _DisplayHookPatcher
from pythonrc_manager import init_rc_script as _init_rc_script
from pythonrc_manager import project_rc_path as _project_rc_path


def pdir(o: object) -> list[str]:
    return [o for o in dir(o) if not o.startswith("_")]


def pvars(o: object) -> dict[str, object]:
    return {k: v for k, v in inspect.getmembers_static(o) if not k.startswith("_")}


def quiet_flag() -> bool:
    return "-q" in sys.orig_argv and "-q" not in sys.argv  # good enough heuristic


def report(
    *args: object,
    stack_offset: int = 1,
    print_fn: Callable[..., None] = print,
    add_location: bool = True,
    important: bool = False,
    **kwargs: Any,
) -> None:
    if (
        not int(os.environ.get("PYTHONRC_VERBOSE", "0"))
        and not important
        or quiet_flag()
    ):
        return
    kwargs.setdefault("file", sys.stderr)
    caller = sys._getframe(stack_offset)
    if add_location:
        location = f"{os.path.relpath(caller.f_code.co_filename)}:{caller.f_lineno}"
        args = (f"[{location}]",) + args
    print_fn(*args, **kwargs)


try:
    from rich.pretty import pprint as rich_pprint

    do_pprint = rich_pprint
except ImportError:
    from pprint import pprint as pprint_pprint

    do_pprint = partial(pprint_pprint, sort_dicts=False)

_dp = _DisplayHookPatcher(do_pprint)  # 🦈
_dp.start()
d = sys.displayhook

if __name__ == "__main__" and os.getenv("PYTHONRC_MANAGER"):
    _rc = _project_rc_path()
    if _rc and os.path.exists(_rc):
        _init_rc_script(_rc, globals())
