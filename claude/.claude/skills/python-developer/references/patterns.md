# Python Patterns Reference

## Context Managers

Prefer `contextlib.contextmanager` for simple context managers over full `__enter__`/`__exit__` classes:

```python
from contextlib import contextmanager
from collections.abc import Generator

@contextmanager
def managed_resource(path: Path) -> Generator[Resource, None, None]:
    resource = Resource(path)
    try:
        yield resource
    finally:
        resource.close()
```

Use `contextlib.AsyncExitStack` when managing a dynamic number of async context managers.

## Dataclass Patterns

```python
from __future__ import annotations

from dataclasses import dataclass, field
from typing import ClassVar

@dataclass(frozen=True)
class Point:
    x: float
    y: float

    def distance_to(self, other: Point) -> float:
        return ((self.x - other.x) ** 2 + (self.y - other.y) ** 2) ** 0.5

@dataclass
class Registry:
    _instances: ClassVar[dict[str, Registry]] = {}
    name: str
    items: list[str] = field(default_factory=list)
```

Use `frozen=True` for value objects. Use `field(default_factory=...)` — never mutable defaults.

## Enum Patterns

```python
from enum import Enum, auto

class Status(Enum):
    PENDING = auto()
    ACTIVE = auto()
    CLOSED = auto()

# Use in type annotations
def process(status: Status) -> None:
    match status:
        case Status.PENDING:
            ...
        case Status.ACTIVE:
            ...
        case Status.CLOSED:
            ...
```

Use `StrEnum` (3.11+) when string serialization is needed:

```python
from enum import StrEnum

class Color(StrEnum):
    RED = "red"
    GREEN = "green"
```

## Protocol for Structural Subtyping

Use `Protocol` instead of ABCs when duck typing is sufficient:

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Drawable(Protocol):
    def draw(self) -> None: ...
    def bounding_box(self) -> tuple[float, float, float, float]: ...

def render(items: list[Drawable]) -> None:
    for item in items:
        item.draw()
```

## PathLib Patterns

```python
from pathlib import Path

# Reading
text = Path("config.toml").read_text(encoding="utf-8")

# Writing
Path("output.json").write_text(json.dumps(data), encoding="utf-8")

# Traversal
for py_file in Path("src").rglob("*.py"):
    process(py_file)

# Safe mkdir
Path("output/reports").mkdir(parents=True, exist_ok=True)
```

## Generator Pipelines

```python
from collections.abc import Iterator, Iterable

def read_lines(path: Path) -> Iterator[str]:
    with path.open() as f:
        yield from f

def strip_comments(lines: Iterable[str]) -> Iterator[str]:
    return (line for line in lines if not line.startswith("#"))

def parse_records(lines: Iterable[str]) -> Iterator[dict[str, str]]:
    for line in lines:
        key, _, value = line.partition("=")
        yield {"key": key.strip(), "value": value.strip()}

# Compose pipeline — nothing is read until consumed
records = parse_records(strip_comments(read_lines(Path("config.ini"))))
```

## Logging Setup

```python
import logging
import sys

def configure_logging(level: str = "INFO") -> None:
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(name)s %(levelname)s %(message)s",
        stream=sys.stderr,
    )

# Per-module logger — always do this
logger = logging.getLogger(__name__)

# Structured context with LoggerAdapter
logger = logging.LoggerAdapter(
    logging.getLogger(__name__),
    extra={"request_id": request_id},
)
```

## TypeVar and Generics

```python
from __future__ import annotations

from typing import TypeVar, Generic, overload

T = TypeVar("T")
T_co = TypeVar("T_co", covariant=True)

class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()
```

## Pydantic (when used)

```python
from __future__ import annotations

from pydantic import BaseModel, Field, model_validator

class UserCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    email: str
    age: int | None = None

    @model_validator(mode="after")
    def validate_adult(self) -> UserCreate:
        if self.age is not None and self.age < 18:
            raise ValueError("Must be 18+")
        return self
```

## SQLAlchemy (when used)

Prefer the 2.0 style with `select()` and `Session.execute()`:

```python
from sqlalchemy import select
from sqlalchemy.orm import Session

def get_active_users(session: Session) -> list[User]:
    stmt = select(User).where(User.is_active == True)  # noqa: E712
    return list(session.scalars(stmt))
```

Use `DeclarativeBase` (2.0) over `declarative_base()` (legacy).
