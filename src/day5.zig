const std = @import("std");
const util = @import("./util.zig");

pub fn avoid_vents(input: []const u8) u32 {
    const lines = util.input_lines(input, true);
    std.debug.print("\nlines: {any}\n", .{lines});
    return 0;
}

const test_input =
    \\0,9 -> 5,9
    \\8,0 -> 0,8
    \\9,4 -> 3,4
    \\2,2 -> 2,1
    \\7,0 -> 7,4
    \\6,4 -> 2,0
    \\0,9 -> 2,9
    \\3,4 -> 1,4
    \\0,0 -> 8,8
    \\5,5 -> 8,2
    \\
;

test "avoid_vents" {
    const expect: u32 = 5;
    try std.testing.expectEqual(expect, avoid_vents(test_input.*[0..]));
}
