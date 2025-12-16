const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(contents);

    var total_joltage: u32 = 0;
    var lines = std.mem.splitScalar(u8, contents, '\n');

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const max_joltage = findMaxJoltage(line);
        total_joltage += max_joltage;
    }

    std.debug.print("{d}\n", .{total_joltage});
}

fn findMaxJoltage(line: []const u8) u32 {
    if (line.len < 2) return 0;

    var max_joltage: u32 = 0;

    for (0..line.len) |i| {
        for (i + 1..line.len) |j| {
            const digit1 = line[i] - '0';
            const digit2 = line[j] - '0';
            const joltage = digit1 * 10 + digit2;

            if (joltage > max_joltage) {
                max_joltage = joltage;
            }
        }
    }

    return max_joltage;
}
