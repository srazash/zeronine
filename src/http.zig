const std = @import("std");
const Connection = std.net.Server.Connection;

pub const HttpMethod = enum {
    GET, // http/0.9 only has the GET method!
};

pub const HttpError = error{
    InvalidMethod,
    InvalidUrl,
};

pub const HttpRequest = struct {
    _method: HttpMethod,
    _url: []const u8,

    pub fn init(conn: Connection) !HttpRequest {
        var buffer: [1024]u8 = undefined;
        for (0..buffer.len) |i| buffer[i] = 0;

        const reader = conn.stream.reader();
        _ = try reader.read(&buffer);

        std.debug.print("request --> {s}\n", .{buffer});

        var i: u8 = 0;
        var tokens: [25][]const u8 = undefined;
        var iter = std.mem.splitAny(u8, &buffer, " \n");
        while (iter.next()) |token| : (i += 1) {
            std.debug.print("token {d} --> {s}\n", .{ i, token });
            tokens[i] = token;
        }

        std.debug.print("tokens[0] --> {s}, tokens[1] --> {s}\n", .{ tokens[0], tokens[1] });

        return HttpRequest{
            ._method = try httpMethodFromString(tokens[0]),
            ._url = try urlValidator(tokens[1]),
        };
    }

    fn httpMethodFromString(method: []const u8) !HttpMethod {
        if (std.mem.eql(u8, method, "GET")) return HttpMethod.GET;
        return HttpError.InvalidMethod;
    }

    fn urlValidator(url: []const u8) ![]const u8 {
        return if (url[0] != '/') HttpError.InvalidUrl else url;
    }
};
