const std = @import("std");
const app = @import("app.zig");

const SocketConf = @import("config.zig");
const Http = @import("http.zig");

pub fn main() !void {
    const stdout = @import("std").io.getStdOut().writer();
    // const stdin = std.io.getStdIn().reader();

    const socket = try SocketConf.Socket.init([_]u8{ 0, 0, 0, 0 }, 80);

    // var buffer: [256]u8 = undefined;
    var req: Http.HttpRequest = undefined;

    // try stdout.print("Enter request >> ", .{});
    // if (try stdin.readUntilDelimiterOrEof(buffer[0..], '\n')) |input| {
    //     req = try http.HttpRequest.init(input);
    // }

    // try stdout.print("Parsed request --> method: {?}, url: {s}\n", .{ req._method, req._url });

    try stdout.print("{s}\nversion: {s}\n", .{ app.logo, app.version });

    try stdout.print("Server address --> {any}\n", .{socket._address});

    var server = try socket._address.listen(.{});

    const connection = try server.accept();
    //_ = connection;

    req = try Http.HttpRequest.init(connection);
    //try stdout.print("Request from connection --> {s}\n", .{conn_buffer});
    try stdout.print("http/0.9-ified request --> method: {?}, path: {s}\n", .{ req._method, req._path });
    try stdout.print("file check --> {any}\n", .{Http.HttpRequest.fileExists(req._path)});
}
