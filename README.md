# libmaxminddb

[![CI][ci-shd]][ci-url]
[![LC][lc-shd]][lc-url]

## Zig build of [libmaxminddb library](https://github.com/maxmind/libmaxminddb).

### :rocket: Usage

- Add `libmaxminddb` dependency to `build.zig.zon`.

```sh
zig fetch --save https://github.com/allyourcodebase/libmaxminddb/archive/<git_tag_or_commit_hash>.tar.gz
```

- Use `libmaxminddb` dependency in `build.zig`.

```zig
const libmaxminddb_dep = b.dependency("libmaxminddb", .{
    .target = target,
    .optimize = optimize,
});
const maxminddb_mod = libmaxminddb_dep.module("maxminddb");
<compile>.root_module.addImport("maxminddb", maxminddb_mod);
```

<!-- MARKDOWN LINKS -->

[ci-shd]: https://img.shields.io/github/actions/workflow/status/allyourcodebase/libmaxminddb/ci.yaml?branch=main&style=for-the-badge&logo=github&label=CI&labelColor=black
[ci-url]: https://github.com/allyourcodebase/libmaxminddb/blob/main/.github/workflows/ci.yaml
[lc-shd]: https://img.shields.io/github/license/allyourcodebase/libmaxminddb.svg?style=for-the-badge&labelColor=black
[lc-url]: https://github.com/allyourcodebase/libmaxminddb/blob/main/LICENSE
