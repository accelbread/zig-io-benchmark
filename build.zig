// zig-io-benchmark -- Benchmark for Zig std readers/writers
// Copyright (C) 2024 Archit Gupta <archit@accelbread.com>
// SPDX-License-Identifier: MIT-0

const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{ .cpu_model = .baseline },
    });
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseFast,
    });

    const exe_opts = std.Build.ExecutableOptions{
        .name = "io-benchmark",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    };

    const exe = b.addExecutable(exe_opts);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_opts = std.Build.TestOptions{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    };

    const unit_tests = b.addTest(test_opts);
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    const exe_check = b.addExecutable(exe_opts);
    const test_check = b.addTest(test_opts);
    const check_step = b.step("check", "Check if app compiles");
    check_step.dependOn(&exe_check.step);
    check_step.dependOn(&test_check.step);
}
