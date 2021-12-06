const std = @import("std");
const print = std.debug.print;

fn get_number_list(a: *std.mem.Allocator, input: []const u8) anyerror!std.ArrayList(i32) {
    var line_iter = std.mem.split(u8, input, "\n");

    var list = std.ArrayList(i32).init(a.*);

    while (true) {
        const m_line = line_iter.next();
        if (m_line) |line| {
            try list.append(std.fmt.parseInt(i32, line, 0) catch break);
        } else {
            break;
        }
    }

    return list;
}

pub fn num_of_increases(a: *std.mem.Allocator, input: []const u8) anyerror!i32 {
    const list = try get_number_list(a, input);
    defer list.deinit();

    var increases: i32 = 0;
    const items = list.items;

    for (items) |depth, i| {
        if (i == 0) {
            continue;
        }
        if (depth > items[i - 1]) {
            increases += 1;
        }
    }
    return increases;
}

pub fn three_window_num_of_increases(a: *std.mem.Allocator, input: []const u8) anyerror!i32 {
    const list = try get_number_list(a, input);
    defer list.deinit();

    var increases: i32 = 0;
    var sum: i32 = 0;

    const items = list.items;
    for (items) |elem, i| {
        if (items.len <= i + 2) {
            break;
        }
        if (sum == 0 or i == 0) {
            sum = elem + items[i + 1] + items[i + 2];
        } else {
            const tmpsum = elem + items[i + 1] + items[i + 2];
            if (tmpsum > sum) {
                increases += 1;
            }
            sum = tmpsum;
        }
    }
    return increases;
}

const test_input =
    \\199
    \\200
    \\208
    \\210
    \\200
    \\207
    \\240
    \\269
    \\260
    \\263
;

test "num_of_increases" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator();
    try std.testing.expectEqual(@as(i32, 7), try num_of_increases(allocator, test_input[0..]));
}

test "three_window_num_of_increases" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = &arena.allocator();
    try std.testing.expectEqual(@as(i32, 5), try three_window_num_of_increases(allocator, test_input[0..]));
}
