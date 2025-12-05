const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("./input.txt", .{});
    defer file.close();

    const stat = try file.stat();

    var buf = try allocator.alloc(u8, stat.size);
    defer allocator.free(buf);

    const bw = try file.readAll(buf);

    var ticks: u32 = 0;
    var pos: i32 = 50;

    var iter = std.mem.tokenizeAny(u8, buf[0..bw], "\n");
    while (iter.next()) |token| {
        if (token.len < 2) {
            break;
        }

        const direction = token[0];
        const rotation = try std.fmt.parseInt(i32, token[1..], 10);

        std.debug.print("direction: {c}, rotation: {}\n", .{ direction, rotation });
        std.debug.print("pos before: {}\n", .{pos});

        switch (direction) {
            'L' => pos = @mod(pos - rotation, 100),
            'R' => pos = @mod(pos + rotation, 100),
            else => {},
        }

        if (pos == 0) {
            ticks += 1;
        }
        std.debug.print("pos after: {}\n **** \n", .{pos});
    }

    std.debug.print("ticks: {}\n", .{ticks});
}
