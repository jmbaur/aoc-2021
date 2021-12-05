const std = @import("std");

const ascii_space = 32;

pub fn bingo_winner(input: []const u8) u32 {
    var input_split = std.mem.split(u8, input, "\n");
    const draw = input_split.next().?;
    std.debug.print("\ndraw: {s}\n", .{draw});

    var i: u32 = 0;
    while (true) {
        _ = input_split.next();
        const m_line1 = input_split.next();
        // Break the loop when there are multiple linefeeds in a row.
        if (m_line1 == null) break;
        const line1 = m_line1.?;
        const line2 = input_split.next().?;
        const line3 = input_split.next().?;
        const line4 = input_split.next().?;
        const line5 = input_split.next().?;

        std.debug.print("\nget_line_nums(line1): {any}\n", .{get_line_nums(line1)});
        std.debug.print("\nget_line_nums(line2): {any}\n", .{get_line_nums(line2)});
        std.debug.print("\nget_line_nums(line3): {any}\n", .{get_line_nums(line3)});
        std.debug.print("\nget_line_nums(line4): {any}\n", .{get_line_nums(line4)});
        std.debug.print("\nget_line_nums(line5): {any}\n", .{get_line_nums(line5)});

        i += 1;
    }

    return 0;
}

fn get_line_nums(line: []const u8) [5]u32 {
    var in_word = false;
    var line_replacement: [4096]u8 = undefined;
    var replacement_idx: u32 = 0;
    for (line) |char| {
        if (char == ascii_space and in_word) {
            in_word = false;
            line_replacement[replacement_idx] = ' ';
            replacement_idx += 1;
        }
        if (char != ascii_space) {
            in_word = true;
            line_replacement[replacement_idx] = char;
            replacement_idx += 1;
        }
    }

    var line_split = std.mem.split(u8, line_replacement[0..replacement_idx], " ");
    const num1 = std.fmt.parseInt(u32, line_split.next().?, 10) catch unreachable;
    const num2 = std.fmt.parseInt(u32, line_split.next().?, 10) catch unreachable;
    const num3 = std.fmt.parseInt(u32, line_split.next().?, 10) catch unreachable;
    const num4 = std.fmt.parseInt(u32, line_split.next().?, 10) catch unreachable;
    const num5 = std.fmt.parseInt(u32, line_split.next().?, 10) catch unreachable;

    return [_]u32{ num1, num2, num3, num4, num5 };
}

const test_input =
    \\7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
    \\
    \\22 13 17 11  0
    \\ 8  2 23  4 24
    \\21  9 14 16  7
    \\ 6 10  3 18  5
    \\ 1 12 20 15 19
    \\
    \\ 3 15  0  2 22
    \\ 9 18 13 17  5
    \\19  8  7 25 23
    \\20 11 10 24  4
    \\14 21 16 12  6
    \\
    \\14 21 17 24  4
    \\10 16 15  9 19
    \\18  8 23 26 20
    \\22 11 13  6  5
    \\ 2  0 12  3  7
    \\
;

test "bingo_winner" {
    const expect: u32 = 4512;
    try std.testing.expectEqual(expect, bingo_winner(test_input.*[0..]));
}
