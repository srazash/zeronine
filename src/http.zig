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

        var i: u8 = 0;
        var tokens: [25][]const u8 = undefined;
        var iter = std.mem.splitAny(u8, &buffer, " ");
        while (iter.next()) |token| : (i += 1) {
            tokens[i] = token;
        }

        return HttpRequest{
            ._method = try parseRequestMethod(tokens[0]),
            ._url = try parseRequestUrl(tokens[1]),
        };
    }

    fn parseRequestMethod(request_string: []const u8) !HttpMethod {
        var split: u8 = 0;
        for (request_string) |c| {
            if (c == ' ') break;
            split += 1;
        }
        return try httpMethodFromString(request_string[0..split]);
    }

    fn parseRequestUrl(request_string: []const u8) ![]const u8 {
        var split: u8 = 0;
        for (request_string) |c| {
            split += 1;
            if (c == ' ') break;
        }
        const url = request_string[split..];
        try urlValidator(url);
        return url;
    }

    fn httpMethodFromString(method: []const u8) !HttpMethod {
        if (std.mem.eql(u8, method, "GET")) return HttpMethod.GET;
        return HttpError.InvalidMethod;
    }

    fn urlValidator(url: []const u8) !void {
        if (url[0] != '/') return HttpError.InvalidUrl;
    }
};
