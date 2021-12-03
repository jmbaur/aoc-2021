const std = @import("std");
const print = std.debug.print;
const day1 = @import("./day1.zig");
const day2 = @import("./day2.zig");

const day1_input = @embedFile("../inputs/day1/input.txt");
const day2_input = @embedFile("../inputs/day2/input.txt");

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    // Day 1
    const day1_part1_sol = try day1.num_of_increases(allocator, day1_input);
    print("day1 part1 solution: {d}\n", .{day1_part1_sol});
    const day1_part2_sol = try day1.three_window_num_of_increases(allocator, day1_input);
    print("day1 part2 solution: {d}\n", .{day1_part2_sol});

    // Day 2
    const day2_part1_sol = day2.submarine_position(day2_input);
    print("day2 part1 solution: {d}\n", .{day2_part1_sol});
    const day2_part2_sol = day2.submarine_position_with_aim(day2_input);
    print("day2 part2 solution: {d}\n", .{day2_part2_sol});
}