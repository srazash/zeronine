const std = @import("std");
const app = @import("app.zig");

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("{s}\n", .{app.logo});
    try stdout.flush();

    std.log.info("starting zeronined v{s}", .{app.version});
    std.log.info("ctrl+c to kill zeronined", .{});

    while (true) {
        // do http-y stuff
    }
}
