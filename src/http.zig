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
    _path: []const u8,

    pub fn init(conn: Connection) !HttpRequest {
        var buffer: [1024]u8 = undefined;
        for (0..buffer.len) |i| buffer[i] = 0;

        const reader = conn.stream.reader();
        _ = try reader.read(&buffer);

        var i: u8 = 0;
        var tokens: [100][]const u8 = undefined;
        var iter = std.mem.splitAny(u8, &buffer, " \n");

        std.debug.print("request tokenization:\n", .{});
        while (iter.next()) |token| : (i += 1) {
            std.debug.print("token {d} --> {s}\n", .{ i, token });
            tokens[i] = token;
        }
        std.debug.print("\n", .{});

        return HttpRequest{
            ._method = try httpMethodFromString(tokens[0]),
            ._path = try urlValidator(tokens[1]),
        };
    }

    fn httpMethodFromString(method: []const u8) !HttpMethod {
        if (std.mem.eql(u8, method, "GET")) return HttpMethod.GET;
        return HttpError.InvalidMethod;
    }

    fn urlValidator(url: []const u8) ![]const u8 {
        if (url.len == 0) return "/";
        return if (url[0] != '/') HttpError.InvalidUrl else url;
    }

    pub fn fileExists(path: []const u8) !bool {
        const root_dir = try std.fs.cwd().openDir("htroot", .{});

        const normalised_path: []const u8 = if (std.mem.eql(u8, path, "/")) "/index.html" else path;
        var result: bool = false;

        _ = root_dir.openFile(normalised_path, .{}) catch |e| switch (e) {
            std.posix.OpenError.FileNotFound => result = false,
            else => result = true,
        };

        const file = try root_dir.openFile(normalised_path, .{});
        defer file.close();

        return result;
    }
};
