const std = @import("std");
const SocketConfig = @import("config.zig");
const http = @import("http.zig");

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    const socket = try SocketConfig.Socket.init([_]u8{ 0, 0, 0, 0 }, 8080);

    try stdout.print("Server address --> {any}\n", .{socket._address});

    const req = try http.HttpRequest.init("GET /index.html");
    try stdout.print("Parsed request --> method: {?}, url: {s}\n", .{ req._method, req._url });

    var server = try socket._address.listen(.{});

    const connection = try server.accept();
    _ = connection;
}
