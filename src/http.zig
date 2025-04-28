pub const HttpRequest = struct {
    _method: []const u8,
    _url: []const u8,

    pub fn init(request: []const u8) HttpRequest {
        return HttpRequest{
            ._method = parseRequestMethod(request),
            ._url = parseRequestUrl(request),
        };
    }

    fn parseRequestMethod(request_string: []const u8) []const u8 {
        var split: u8 = 0;
        for (request_string) |c| {
            if (c == ' ') break;
            split += 1;
        }
        return request_string[0..split];
    }

    fn parseRequestUrl(request_string: []const u8) []const u8 {
        var split: u8 = 0;
        for (request_string) |c| {
            split += 1;
            if (c == ' ') break;
        }
        return request_string[split..];
    }
};
