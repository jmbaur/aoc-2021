const std = @import("std");
const print = std.debug.print;

pub fn num_of_increases(input: []const i32) i32 {
    var increases: i32 = 0;
    for (input) |depth, i| {
        if (i == 0) {
            continue;
        }
        if (depth > input[i - 1]) {
            increases += 1;
        }
    }
    return increases;
}

test "num_of_increases" {
    const input = [_]i32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    const expect: i32 = 7;
    try std.testing.expectEqual(expect, num_of_increases(input[0..]));
}

fn ring_idx(size: usize, idx: usize, push: usize) usize {
    const potential = idx + push;
    if (potential >= size) {
        return potential - size;
    } else {
        return potential;
    }
}

pub fn three_window_num_of_increases(input: []const i32) i32 {
    var increases: i32 = 0;
    var sum: i32 = 0;
    for (input) |elem, i| {
        if (input.len <= i + 2) {
            break;
        }
        if (sum == 0 or i == 0) {
            sum = elem + input[i + 1] + input[i + 2];
        } else {
            const tmpsum = elem + input[i + 1] + input[i + 2];
            if (tmpsum > sum) {
                increases += 1;
            }
            sum = tmpsum;
        }
    }
    return increases;
}

test "three_window_num_of_increases" {
    const input = [_]i32{ 199, 200, 208, 210, 200, 207, 240, 269, 260, 263 };
    const expect: i32 = 5;
    try std.testing.expectEqual(expect, three_window_num_of_increases(input[0..]));
}
