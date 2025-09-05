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

    // test server code
    const ipv4 = "0.0.0.0";
    const port: u16 = 8080;

    var conn_buffer: [1024]u8 = undefined;
    var readin: [1024]u8 = undefined;

    const address = try std.net.Address.resolveIp(ipv4, port);
    var server = try address.listen(.{ .reuse_address = true });
    defer server.deinit();

    std.log.info("listening on {s}:{d}", .{ ipv4, port });

    while (true) {
        const conn = try server.accept();
        var reader = conn.stream.reader(&conn_buffer).file_reader;

        const end = try reader.read(&readin);

        std.log.info("read->{s}", .{readin[0..end]});

        conn.stream.close();
        continue;
    }
}
