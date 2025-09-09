const std = @import("std");
const app = @import("app.zig");
const httpserver = @import("server.zig").HttpServer;

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("{s}\n", .{app.logo});
    try stdout.flush();

    var server = httpserver.init("0.0.0.0", 8080);
    try server.start();
}
