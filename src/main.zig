const std = @import("std");
const day1 = @import("./day1.zig");

const day1_part1_input = @embedFile("../inputs/day1/part1.txt");
const day1_part2_input = @embedFile("../inputs/day1/part2.txt");

fn get_number_list(a: *std.mem.Allocator, r: anytype) anyerror!std.ArrayList(i32) {
    var msg_buf: [4096]u8 = undefined;
    var list = std.ArrayList(i32).init(a);

    while (true) {
        var msg = try r.readUntilDelimiterOrEof(&msg_buf, '\n');
        if (msg) |m| {
            const t = try std.fmt.parseInt(i32, m, 0);
            try list.append(t);
        } else {
            break;
        }
    }

    return list;
}

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator;

    const day1_part1_list = try get_number_list(allocator, std.io.fixedBufferStream(day1_part1_input).reader());
    const day1_part1_sol = day1.num_of_increases(day1_part1_list.items);
    std.debug.print("day1 part1 solution: {d}\n", .{day1_part1_sol});

    const day1_part2_list = try get_number_list(allocator, std.io.fixedBufferStream(day1_part2_input).reader());
    const day1_part2_sol = day1.three_window_num_of_increases(day1_part2_list.items);
    std.debug.print("day1 part2 solution: {d}\n", .{day1_part2_sol});
}
