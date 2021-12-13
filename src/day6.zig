const std = @import("std");

pub fn num_of_lanternfish(input: []const u8, daysToSimulate: u64) !u64 {
    var tokens = std.mem.tokenize(u8, std.mem.trim(u8, input, "\n"), ",");
    var ages: [9]u64 = [_]u64{0} ** 9;

    while (true) {
        if (tokens.next()) |next| {
            ages[(try std.fmt.parseInt(u64, next, 10))] += 1;
        } else break;
    }

    var solution: u64 = 0;
    for (simulate(daysToSimulate, ages)) |num| {
        solution += num;
    }

    return solution;
}

fn simulate(day: u64, ages: [9]u64) [9]u64 {
    if (day == 0) {
        return ages;
    }

    var new_ages = ages;
    var i: u64 = 8;
    while (i > 0) {
        new_ages[i - 1] = ages[i];
        i -= 1;
    }
    new_ages[6] += ages[0];
    new_ages[8] = ages[0];

    return simulate(day - 1, new_ages);
}

const test_input =
    \\3,4,3,1,2
    \\
;

test "num_of_lanternfish_80" {
    try std.testing.expectEqual(@as(u64, 5934), try num_of_lanternfish(test_input, 80));
}

test "num_of_lanternfish_256" {
    try std.testing.expectEqual(@as(u64, 26984457539), try num_of_lanternfish(test_input, 256));
}
