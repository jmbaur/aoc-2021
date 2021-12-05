const std = @import("std");
const util = @import("./util.zig");

pub const Diags = enum {
    include,
    exclude,
};

const Map = struct {
    grid: [1000][1000]?u32 = undefined,

    fn inc(self: *Map, p1: usize, p2: usize) void {
        if (self.grid[p1][p2]) |*val| {
            val.* += 1;
        } else {
            self.grid[p1][p2] = 1;
        }
    }

    pub fn mark_all_between(self: *Map, x1: usize, y1: usize, x2: usize, y2: usize) !void {
        const m = slope(@intToFloat(f16, x1), @intToFloat(f16, y1), @intToFloat(f16, x2), @intToFloat(f16, y2));
        if (@fabs(m) == std.math.inf_f16) {
            std.debug.assert(x1 == x2);
            var y = y2;
            const diff = get_diff(y1, y2);
            const normal = @divFloor(diff, try std.math.absInt(diff));
            while (true) {
                self.inc(x1, y);
                if (y == y1) break;
                y = @intCast(usize, @intCast(i32, y) - normal);
            }
        } else {
            const bfloat = intercept(m, @intToFloat(f16, x1), @intToFloat(f16, y1));
            const b = @floatToInt(i32, bfloat);

            var x = x2;
            const diff = get_diff(x1, x2);
            const normal = @divFloor(diff, try std.math.absInt(diff));

            while (true) {
                const yfloat = next_y(m, @intToFloat(f16, x), @intToFloat(f16, b));
                const y = @floatToInt(usize, yfloat);
                self.inc(x, y);
                if (x == x1) break;
                x = @intCast(usize, @intCast(i32, x) - normal);
            }
        }

        if (line_is_diagonal(x1, y1, x2, y2)) return;
    }

    pub fn total(self: *Map) u32 {
        var tot: u32 = 0;
        for (self.grid) |row| {
            for (row) |m_cell| {
                if (m_cell) |cell| {
                    if (cell > 1) {
                        tot += 1;
                    }
                }
            }
        }
        return tot;
    }
};

fn get_diff(n1: usize, n2: usize) i32 {
    if (n1 > n2) {
        return -1 * @intCast(i32, n1 - n2);
    } else if (n2 > n1) {
        return @intCast(i32, n2 - n1);
    }
    return 0;
}

fn line_is_diagonal(x1: usize, y1: usize, x2: usize, y2: usize) bool {
    return x1 != x2 and y1 != y2;
}

pub fn avoid_vents(comptime diags: Diags, input: []const u8) !u32 {
    const lines = util.input_lines(input, true);

    var map = Map{};

    for (lines) |line| {
        var split = std.mem.split(u8, line, " -> ");

        const from = split.next().?;
        const to = split.next().?;

        var from_split = std.mem.split(u8, from, ",");
        var to_split = std.mem.split(u8, to, ",");

        const x1 = try std.fmt.parseInt(usize, from_split.next().?, 10);
        const y1 = try std.fmt.parseInt(usize, from_split.next().?, 10);
        const x2 = try std.fmt.parseInt(usize, to_split.next().?, 10);
        const y2 = try std.fmt.parseInt(usize, to_split.next().?, 10);

        switch (diags) {
            .exclude => {
                if (line_is_diagonal(x1, y1, x2, y2)) continue;
            },
            else => {},
        }

        try map.mark_all_between(x1, y1, x2, y2);
    }

    return map.total();
}

pub fn avoid_vents_w_diags() void {}

fn slope(x1: f16, y1: f16, x2: f16, y2: f16) f16 {
    return (y2 - y1) / (x2 - x1);
}

fn intercept(m: f16, x: f16, y: f16) f16 {
    return y - (m * x);
}

fn next_y(m: f16, x: f16, b: f16) f16 {
    return m * x + b;
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
    try std.testing.expectEqual(@as(u32, 5), try avoid_vents(Diags.exclude, test_input.*[0..]));
}

test "avoid_vents_with_diagonal_lines" {
    try std.testing.expectEqual(@as(u32, 12), try avoid_vents(Diags.include, test_input.*[0..]));
}
