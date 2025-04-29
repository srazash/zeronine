const std = @import("std");
const SocketConfig = @import("config.zig");
const http = @import("http.zig");

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    const socket = try SocketConfig.Socket.init([_]u8{ 0, 0, 0, 0 }, 8080);

    var buffer: [100]u8 = undefined;

    try stdout.print("Enter request >> ", .{});
    _ = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
    try stdout.print("\n", .{});

    const req = try http.HttpRequest.init(&buffer);
    try stdout.print("Parsed request --> method: {?}, url: {s}\n", .{ req._method, req._url });

    try stdout.print("Server address --> {any}\n", .{socket._address});

    var server = try socket._address.listen(.{});

    const connection = try server.accept();
    _ = connection;
}
