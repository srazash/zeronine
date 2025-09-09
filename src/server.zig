const std = @import("std");
const app = @import("app.zig");

pub const HttpServer = struct {
    ip: []const u8,
    port: u16,

    pub fn init(ip: []const u8, port: u16) HttpServer {
        return HttpServer{
            .ip = ip,
            .port = port,
        };
    }

    pub fn start(self: *HttpServer) !void {
        var readin: [1024]u8 = undefined;

        const address = try std.net.Address.resolveIp(self.ip, self.port);
        var server = try address.listen(.{ .reuse_address = true });
        defer server.deinit();

        std.log.info("starting zeronined v{s}", .{app.version});
        std.log.info("ctrl+c to kill zeronined", .{});
        std.log.info("listening on {s}:{d}", .{ self.ip, self.port });

        while (true) {
            const conn = try server.accept();

            _ = try conn.stream.read(&readin);

            std.log.info("<-REQ-IN--", .{});

            try conn.stream.writeAll("RECIEVED\n");

            std.log.info("-RES-OUT->", .{});

            conn.stream.close();
            continue;
        }
    }
};
