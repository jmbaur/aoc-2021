const std = @import("std");

pub fn input_lines(input: []const u8, skip_empty_lines: bool) [][]const u8 {
    var split = std.mem.split(u8, input, "\n");
    var lines: [4096][]const u8 = undefined;
    var idx: u32 = 0;
    while (true) {
        const maybe = split.next();
        if (maybe) |yes| {
            if (skip_empty_lines and yes.len == 0) break;
            lines[idx] = yes;
            idx += 1;
        } else break;
    }
    return lines[0..idx];
}

test "input_lines" {
    try std.testing.expectEqual(input_lines(@embedFile("../inputs/day1.txt"), true).len, 2000);
    try std.testing.expectEqual(input_lines(@embedFile("../inputs/day1.txt"), false).len, 2001);
}
