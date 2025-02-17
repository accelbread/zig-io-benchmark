// zig-io-benchmark -- Benchmark for Zig std readers/writers
// Copyright (C) 2024 Archit Gupta <archit@accelbread.com>
// SPDX-License-Identifier: MIT-0

const std = @import("std");

pub fn main() !void {
    std.debug.assert(std.os.argv.len == 3);
    var input = try std.fs.cwd().openFileZ(std.os.argv[1], .{});
    var output = try std.fs.cwd().createFileZ(std.os.argv[2], .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    var reader = std.json.Reader(4096, std.fs.File.Reader)
        .init(arena.allocator(), input.reader());
    const value = (try std.json.parseFromTokenSource(
        std.json.Value,
        arena.allocator(),
        &reader,
        .{},
    )).value;

    try std.json.stringify(
        value,
        .{ .whitespace = .indent_2 },
        output.writer(),
    );
}
