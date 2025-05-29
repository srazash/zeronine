```
                                                  ##\                     
                                                  \__|                    
########\  ######\   ######\   ######\  #######\  ##\ #######\   ######\  
\____##  |##  __##\ ##  __##\ ##  __##\ ##  __##\ ## |##  __##\ ##  __##\ 
  #### _/ ######## |## |  \__|## /  ## |## |  ## |## |## |  ## |######## |
 ##  _/   ##   ____|## |      ## |  ## |## |  ## |## |## |  ## |##   ____|
########\ \#######\ ## |      \######  |## |  ## |## |## |  ## |\#######\ 
\________| \_______|\__|       \______/ \__|  \__|\__|\__|  \__| \_______|
T H E  S I N G L E  T H R E A D E D  H T T P / 0 . 9  W E B  S E R V E R !
```

# zeronine

__zeronine__ is a reimplementation of CERN's original HTTP web server, developed by Tim Berners-Lee in late 1980s and early 1990s.

Aiming to emulate TBL's work as closely as possible, zeronine is written in Zig (a modern analogue for C) and implements the single threaded, "single line protocol" that defined the pre-HTTP/1.0 web (typically referred to as HTTP/0.9).

When built the zeronine project will produce a binary caleld `zeronined`, a nod to the name of the original HTTP server daemon: `httpd`.

# ...but, why?

Historical and technical curiosity for one, writing a HTTP server from scratch is a fantastic way to learn more about how the HTTP protocol works, and starting with the earliest version is a great way to learn how the protocol evolved. Plus it's a great way to learn about socket programming, learn how to work with Zig's standard library and get better at programming in general.

# Is this even useful?

Not really. Technically it will be a fully working HTTP server, albeit one that no modern web browsers will support, can only handle one request at a time and cannot support multiple websites or domains.

It's pretty interesting if you have a copy of the original WorldWideWeb <1.0 running on NeXTStep (I do).

Once HTTP/0.9 is fully working I do plan to add HTTP/1.0 and then HTTP/1.1 support, but again not intended for production web server purposes, it's a great way to learn how the HTTP protocol evolved in the early days.
