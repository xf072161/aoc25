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

    const bytes_read = try file.readAll(buf);
    const input = buf[0..bytes_read];

    var sum: u64 = 0;
    var range_iter = std.mem.tokenizeScalar(u8, std.mem.trim(u8, input, " \n\r"), ',');

    while (range_iter.next()) |range_str| {
        const trimmed_range = std.mem.trim(u8, range_str, " \n\r");
        if (trimmed_range.len == 0) continue;

        var dash_iter = std.mem.tokenizeScalar(u8, trimmed_range, '-');
        const start_str = dash_iter.next() orelse continue;
        const end_str = dash_iter.next() orelse continue;

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        var id = start;
        while (id <= end) : (id += 1) {
            if (isInvalidId(id)) {
                sum += id;
            }
        }
    }

    std.debug.print("{}\n", .{sum});
}

fn isInvalidId(id: u64) bool {
    var buf: [32]u8 = undefined;
    const id_str = std.fmt.bufPrint(&buf, "{}", .{id}) catch return false;

    if (id_str.len % 2 != 0) {
        return false;
    }

    const half_len = id_str.len / 2;
    const first_half = id_str[0..half_len];
    const second_half = id_str[half_len..];

    return std.mem.eql(u8, first_half, second_half);
}
