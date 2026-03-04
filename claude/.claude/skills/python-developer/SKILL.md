---
name: python-developer
description: This skill should be used when the user is working in a .py file, when a pyproject.toml or uv.lock file exists in the project, when the user mentions Python, or when the user asks for "idiomatic python", "pythonic code", or similar. Provides professional Python development standards covering tooling, style, typing, and conventions.
---

# Professional Python Developer

Produce idiomatic, modern, professional-grade Python code. Apply these standards consistently when generating or reviewing Python.

## Tooling

Use modern Python tooling by default:

- **Package manager**: `uv` — for dependency management, virtual environments, and script running (`uv add`, `uv run`, `uv sync`)
- **Linter/formatter**: `ruff` — single tool for linting and formatting; replaces flake8, isort, black
- **Testing**: `pytest` — no unittest; use fixtures and parametrize
- **Type checking**: `mypy` or `pyright` — run alongside ruff in CI

Prefer `uv run pytest` over activating venvs manually.

## Type Annotations

Annotate all function signatures and non-obvious variables. Skip annotations only for obviously-typed local variables (`x = 1`, list comprehension variables).

Always add at the top of every module:

```python
from __future__ import annotations
```

This enables forward references and PEP 604 union syntax (`X | Y`) on Python 3.9–3.11.

**Rules:**
- Never use `typing.Any` — if the type is truly unknown, use `object` or a TypeVar
- Prefer `X | Y` over `Union[X, Y]`, `X | None` over `Optional[X]`
- Use `TypeVar`, `ParamSpec`, and `Protocol` for generics instead of loosening types
- Use `Final` for constants, `ClassVar` for class-level attributes
- Use `TypedDict` or dataclasses for structured dicts — never plain `dict[str, Any]`

```python
from __future__ import annotations

from typing import TypeVar

T = TypeVar("T")

def first(items: list[T]) -> T | None:
    return items[0] if items else None
```

## Code Style

### Naming and Structure

Follow PEP 8. Beyond that:

- **Prefer `pathlib.Path`** over `os.path` for all filesystem operations
- **Prefer `enum.Enum`** over string/int literals for named constants
- **Prefer `@dataclass`** (or Pydantic `BaseModel`) over plain dicts for structured data
- **Use `logging`** — never `print()` for observability; configure a logger per module:

```python
import logging

logger = logging.getLogger(__name__)
```

### Generators and Iteration

Prefer generators over lists when:
- The caller doesn't need random access
- The collection could be large
- Composing pipelines (generator chaining)

```python
# Prefer this
def active_users(users: Iterable[User]) -> Iterator[User]:
    return (u for u in users if u.is_active)

# Over this
def active_users(users: list[User]) -> list[User]:
    return [u for u in users if u.is_active]
```

Use `yield from` for delegating to sub-iterators.

### Walrus Operator

Use `:=` to eliminate redundant assignments when it genuinely improves clarity:

```python
# Reading chunks
while chunk := file.read(8192):
    process(chunk)

# Filtering with a computed value
if m := pattern.match(line):
    handle(m.group(1))
```

Avoid walrus in complex expressions where it obscures intent.

### Pattern Matching

On Python 3.10+, use `match`/`case` for structural dispatch. On 3.9, use `if`/`elif` chains — do not polyfill.

## Error Handling

- Raise specific exceptions — never bare `raise Exception("message")`
- Define custom exception classes for domain errors
- Use `contextlib.suppress` for intentional no-ops
- Prefer early returns / guard clauses over deep nesting
- Use `__cause__` chaining (`raise X from Y`) to preserve context

```python
class UserNotFoundError(ValueError):
    def __init__(self, user_id: int) -> None:
        super().__init__(f"User {user_id} not found")
        self.user_id = user_id
```

## Async

Use `asyncio` natively. Patterns to follow:

- `async def` + `await` for coroutines
- `asyncio.gather()` for concurrent tasks
- `asyncio.TaskGroup` (3.11+) for structured concurrency
- `asyncio.Queue` for producer/consumer patterns
- Avoid mixing sync blocking calls in async contexts — use `asyncio.to_thread()` for blocking I/O

```python
async def fetch_all(urls: list[str]) -> list[str]:
    async with asyncio.TaskGroup() as tg:
        tasks = [tg.create_task(fetch(url)) for url in urls]
    return [t.result() for t in tasks]
```

## Project Structure

For new projects, use `uv init`. Prefer `pyproject.toml` over `setup.py` / `setup.cfg`. Keep source code in a `src/` layout:

```
project/
├── pyproject.toml
├── uv.lock
├── src/
│   └── mypackage/
│       ├── __init__.py
│       └── ...
└── tests/
    └── test_*.py
```

Configure ruff in `pyproject.toml`:

```toml
[tool.ruff]
target-version = "py311"
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM"]
```

## Framework Documentation

When working with these frameworks, fetch their current docs before generating code:

| Framework | Docs URL |
|-----------|----------|
| FastAPI | https://fastapi.tiangolo.com |
| Pydantic | https://docs.pydantic.dev |
| SQLAlchemy | https://docs.sqlalchemy.org |
| Django | https://docs.djangoproject.com |
| pytest | https://docs.pytest.org |
| uv | https://docs.astral.sh/uv |
| ruff | https://docs.astral.sh/ruff |

Prefer stdlib solutions before reaching for third-party libraries. When a library is needed, check if `uv add` can install it.

## Additional Resources

- **`references/patterns.md`** — Common Python patterns: context managers, descriptors, dataclass patterns, Protocol usage
