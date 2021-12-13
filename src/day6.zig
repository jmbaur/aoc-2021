const std = @import("std");

pub fn num_of_lanternfish(a: std.mem.Allocator, input: []const u8, daysToSimulate: u64) !u64 {
    var tokens = std.mem.tokenize(u8, std.mem.trim(u8, input, "\n"), ",");
    var list = std.ArrayList(u64).init(a);
    defer list.deinit();
    while (true) {
        if (tokens.next()) |next| {
            const int = try std.fmt.parseInt(u64, next, 10);
            try list.append(int);
        } else break;
    }

    var fishToAdd: u64 = 0;
    var days: u64 = 0;
    while (days <= daysToSimulate) {
        while (fishToAdd > 0) {
            try list.append(8);
            fishToAdd -= 1;
        }
        // std.debug.print("\ndays: {}\n", .{days});
        // std.debug.print("\nlist: {any}\n", .{list});
        for (list.items) |*item| {
            if (item.* == 0) {
                item.* = 6;
                fishToAdd += 1;
                continue;
            }
            item.* -= 1;
        }
        days += 1;
    }

    // std.debug.print("\nlist.items.len: {}\n", .{list.items.len});
    return list.items.len;
}

const test_input =
    \\3,4,3,1,2
    \\
;

test "num_of_lanternfish" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();
    try std.testing.expectEqual(try num_of_lanternfish(allocator, test_input, 80), 5934);
}
