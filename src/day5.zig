const std = @import("std");
const util = @import("./util.zig");

const Map = struct {
    grid: [1000][1000]?u32 = undefined,

    fn inc(self: *Map, p1: usize, p2: usize) void {
        if (self.grid[p1][p2]) |*val| {
            val.* += 1;
        } else {
            self.grid[p1][p2] = 1;
        }
    }

    pub fn mark(self: *Map, x1: usize, y1: usize, x2: usize, y2: usize) !void {
        if (x1 == x2) {
            const diff = get_diff(y1, y2);
            var i = y1;
            const normal = @divFloor(diff, try std.math.absInt(diff));
            while (i != y2) {
                self.inc(x1, i);
                i = @intCast(usize, @intCast(i32, i) + normal);
            }
            self.inc(x1, y2);
        } else if (y1 == y2) {
            const diff = get_diff(x1, x2);
            var i = x1;
            const normal = @divFloor(diff, try std.math.absInt(diff));
            while (i != x2) {
                self.inc(i, y1);
                i = @intCast(usize, @intCast(i32, i) + normal);
            }
            self.inc(x2, y1);
        } else {
            std.debug.print("\ntodo\n", .{});
        }
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

pub fn avoid_vents(input: []const u8) !u32 {
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

        if (line_is_diagonal(x1, y1, x2, y2)) continue;

        try map.mark(x1, y1, x2, y2);
    }

    return map.total();
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
    try std.testing.expectEqual(expect, try avoid_vents(test_input.*[0..]));
}
