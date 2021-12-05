const std = @import("std");

const ascii_newline = 10;
const ascii_space = 32;

pub fn submarine_position(input: []const u8) i32 {
    var depth: i32 = 0;
    var horizontal: i32 = 0;

    var line_iter = std.mem.split(u8, input, "\n");

    while (true) {
        const m_line = line_iter.next();
        if (m_line) |line| {
            var command_iter = std.mem.split(u8, line, " ");
            const m_direction = command_iter.next();
            if (m_direction) |direction| {
                var unit: i32 = 0;

                const m_unit = command_iter.next();
                if (m_unit) |str_unit| {
                    unit = std.fmt.parseInt(i32, str_unit, 0) catch continue;
                } else {
                    continue;
                }

                switch (direction[0]) {
                    'f' => {
                        horizontal += unit;
                    },
                    'u' => {
                        depth -= unit;
                    },
                    'd' => {
                        depth += unit;
                    },
                    else => {},
                }
            } else {
                continue;
            }
        } else {
            break;
        }
    }

    return horizontal * depth;
}

pub fn submarine_position_with_aim(input: []const u8) i32 {
    var depth: i32 = 0;
    var horizontal: i32 = 0;
    var aim: i32 = 0;

    var line_iter = std.mem.split(u8, input, "\n");

    while (true) {
        const m_line = line_iter.next();
        if (m_line) |line| {
            var command_iter = std.mem.split(u8, line, " ");
            const m_direction = command_iter.next();
            if (m_direction) |direction| {
                var unit: i32 = 0;

                const m_unit = command_iter.next();
                if (m_unit) |str_unit| {
                    unit = std.fmt.parseInt(i32, str_unit, 0) catch continue;
                } else {
                    continue;
                }

                switch (direction[0]) {
                    'f' => {
                        horizontal += unit;
                        depth += aim * unit;
                    },
                    'u' => {
                        aim -= unit;
                    },
                    'd' => {
                        aim += unit;
                    },
                    else => {},
                }
            } else {
                continue;
            }
        } else {
            break;
        }
    }

    return horizontal * depth;
}

const test_input =
    \\forward 5
    \\down 5
    \\forward 8
    \\up 3
    \\down 8
    \\forward 2
;

test "submarine_position" {
    try std.testing.expectEqual(@as(i32, 150), submarine_position(test_input.*[0..]));
}

test "submarine_position_with_aim" {
    try std.testing.expectEqual(@as(i32, 900), submarine_position_with_aim(test_input.*[0..]));
}
