const std = @import("std");
const builtin = @import("std").builtin;
const net = @import("std").net;
const posix = @import("std").posix;

pub const Socket = struct {
    _address: net.Address,
    _stream: net.Stream,

    pub fn init(socket_host: [4]u8, socket_port: u16) !Socket {
        const host = socket_host;
        const port = socket_port;

        const addr = net.Address.initIp4(host, port);

        const socket = try posix.socket(addr.any.family, posix.SOCK.STREAM, posix.IPPROTO.TCP);

        const stream = net.Stream{ .handle = socket };

        return Socket{ ._address = addr, ._stream = stream };
    }
};
