const std = @import("std");

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

    pub fn init(request: []const u8) !HttpRequest {
        return HttpRequest{
            ._method = try parseRequestMethod(request),
            ._url = try parseRequestUrl(request),
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
