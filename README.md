HashList
========

Unordered, managed/unique/reusable/integer-based index key-value storage for Elixir.

###Just `push/2` your data

`push(hashlist, value)` -> `{key, hashlist}`:
Add `value` to `hashlist`; returns the `key` it's been assigned.

You don't need to check for a suitable key, HashList does that for you while keeping them unique in three (selectable) ways:

- **randomizes them** (2^32, `:random_indexes`);
- **reuses freed ones or increments the last** (`:reuse_indexes`, default);
- **just increments the last** (`:no_reuse_indexes`).

---
Currently, `:random_indexes` and `:no_reuse_indexes` are both implemented but not yet tested, thus you can't set them via `HashList.new/1` yet.
You can, however, set them manually by creating the HashList using the struct form:

```elixir
hashlist = %HashList{random_indexes: true, reuse_indexes: false}
```
---
