const std = @import("std");

pub fn main() void {
    std.debug.print(
        \\To get answers for a given day, run:
        \\  `zig test ./src/main.zig --test-filter dayX`
        \\
    , .{});
}

test "day1" {
    const day1 = @import("./day1.zig");
    const day1_input = @embedFile("../inputs/day1.txt");
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator();
    try std.testing.expectEqual(@as(i32, 1446), try day1.num_of_increases(allocator, day1_input));
    try std.testing.expectEqual(@as(i32, 1486), try day1.three_window_num_of_increases(allocator, day1_input));
}

test "day2" {
    const day2 = @import("./day2.zig");
    const day2_input = @embedFile("../inputs/day2.txt");
    try std.testing.expectEqual(@as(i32, 1507611), day2.submarine_position(day2_input));
    try std.testing.expectEqual(@as(i32, 1880593125), day2.submarine_position_with_aim(day2_input));
}

test "day3" {
    const day3 = @import("./day3.zig");
    const day3_input = @embedFile("../inputs/day3.txt");
    try std.testing.expectEqual(@as(u32, 749376), try day3.power_consumption(day3_input));
    try std.testing.expectEqual(@as(u32, 2372923), try day3.life_support_rating(day3_input));
}

test "day4" {
    const day4 = @import("./day4.zig");
    const day4_input = @embedFile("../inputs/day4.txt");
    try std.testing.expectEqual(@as(i32, 44088), day4.bingo(day4.BingoType.winner, day4_input));
    try std.testing.expectEqual(@as(i32, 23670), day4.bingo(day4.BingoType.loser, day4_input));
}

test "day5" {
    const day5 = @import("./day5.zig");
    const day5_input = @embedFile("../inputs/day5.txt");
    try std.testing.expectEqual(@as(u32, 5835), try day5.avoid_vents(day5.Diags.exclude, day5_input));
    try std.testing.expectEqual(@as(u32, 17013), try day5.avoid_vents(day5.Diags.include, day5_input));
}
