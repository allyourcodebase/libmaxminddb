const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/lib.zig");
    const version = std.SemanticVersion{ .major = 1, .minor = 10, .patch = 0 };

    // Dependencies
    const libmaxminddb_dep = b.dependency("libmaxminddb", .{});
    const libmaxminddb_src_path = libmaxminddb_dep.path("src/");
    const libmaxminddb_inc_path = libmaxminddb_dep.path("include/");

    // Library
    const lib_step = b.step("lib", "Install library");

    const lib = b.addStaticLibrary(.{
        .name = "maxminddb",
        .target = target,
        .version = version,
        .optimize = optimize,
    });
    lib.root_module.addCMacro("PACKAGE_VERSION", b.fmt("\"{}\"", .{version}));
    lib.addCSourceFiles(.{ .root = libmaxminddb_src_path, .files = &SOURCES, .flags = &FLAGS });
    lib.installHeader(libmaxminddb_inc_path.path(b, "maxminddb.h"), "");
    lib.addConfigHeader(b.addConfigHeader(.{
        .style = .{ .cmake = libmaxminddb_inc_path.path(b, "maxminddb_config.h.cmake.in") },
        .include_path = "maxminddb_config.h",
    }, VALUES));
    lib.addIncludePath(libmaxminddb_inc_path);
    lib.linkLibC();

    if (target.result.cpu.arch.endian() == .little) {
        lib.root_module.addCMacro("MMDB_LITTLE_ENDIAN", "1");
    }

    const lib_install = b.addInstallArtifact(lib, .{});
    lib_step.dependOn(&lib_install.step);
    b.default_step.dependOn(lib_step);

    // Bindings module
    const mod = b.addModule("maxminddb", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = root_source_file,
    });
    mod.linkLibrary(lib);

    // Formatting checks
    const fmt_step = b.step("fmt", "Run formatting checks");

    const fmt = b.addFmt(.{
        .paths = &.{
            "src/",
            "build.zig",
        },
        .check = true,
    });
    fmt_step.dependOn(&fmt.step);
    b.default_step.dependOn(fmt_step);
}

const HEADERS = .{
    "data-pool.h",
    "maxminddb-compat-util.h",
};

const SOURCES = .{
    "data-pool.c",
    "maxminddb.c",
};

const FLAGS = .{
    "-std=c99",
    "-O2",
    "-g",
    "-fsanitize=undefined",
    "-fsanitize-trap=undefined",
};

const VALUES = .{
    .MMDB_UINT128_USING_MODE = 0,
    .MMDB_UINT128_IS_BYTE_ARRAY = if (@sizeOf(u128) == 16) 0 else 1,
};
