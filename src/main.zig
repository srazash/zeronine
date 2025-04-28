const std = @import("std");
const stdout = @import("std").io.getStdOut().writer();
const soccnf = @import("config.zig");

pub fn main() !void {
    const socket = try soccnf.Socket.init([4]u8{ 0, 0, 0, 0 }, 8080);

    try stdout.print("Server address --> {any}\n", .{socket._address});

    var server = try socket._address.listen(.{});

    const connection = try server.accept();
    _ = connection;
}
