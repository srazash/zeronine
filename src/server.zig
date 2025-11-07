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

            const eos = try conn.stream.read(&readin);

            const req = requestCleaner(readin[0..eos]);

            std.log.info("<-REQ-IN-- {s} {s}", .{ req.method, req.url });

            try conn.stream.writeAll("RECIEVED\n");

            std.log.info("-RES-OUT-> RECIEVED", .{});

            conn.stream.close();
            continue;
        }
    }

    fn requestCleaner(request: []u8) struct { method: []const u8, url: []const u8 } {
        var itr = std.mem.tokenizeAny(u8, request, " ");

        var method: []const u8 = undefined;
        if (itr.peek() != null) {
            method = itr.next().?;
        }

        var url: []const u8 = undefined;
        if (itr.peek() != null) {
            url = itr.next().?;
        }

        return .{
            .method = method,
            .url = url,
        };
    }
};
