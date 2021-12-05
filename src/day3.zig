const std = @import("std");
const print = std.debug.print;

const BadInput = error{
    nan,
};

pub fn power_consumption(input: []const u8) anyerror!u32 {
    var len: u5 = 0;
    var sums: [4096]u32 = undefined;
    var lines: u32 = 0;

    var input_iter = std.mem.split(u8, input, "\n");
    while (true) {
        const m_bits = input_iter.next();
        if (m_bits) |bits| {
            if (len == 0) {
                len = @intCast(u5, bits.len);
                for (sums[0..len]) |*sum| {
                    sum.* = 0;
                }
            } else if (bits.len != len) {
                continue; // just skip
            }
            for (bits) |_, i| {
                sums[i] += std.fmt.parseInt(u32, bits[i .. i + 1], 0) catch {
                    return BadInput.nan;
                };
            }
            lines += 1;
        } else {
            break;
        }
    }

    var gamma_rate_sums: [4096]u32 = undefined;

    const threshold = lines / @as(u32, 2);
    for (sums[0..len]) |sum, i| {
        if (sum > threshold) {
            gamma_rate_sums[i] = 1;
        } else {
            gamma_rate_sums[i] = 0;
        }
    }

    var gamma_rate: u32 = 0;
    for (gamma_rate_sums[0..len]) |sum, i| {
        if (sum == 1) {
            const dec = std.math.pow(u32, 2, @intCast(u32, len - 1 - i));
            gamma_rate += dec;
        }
    }

    const shift_base: u32 = 1;
    var mask = (shift_base << len) - 1;
    return gamma_rate * (~gamma_rate & mask);
}

test "power_consumption" {
    const test_input =
        \\00100
        \\11110
        \\10110
        \\10111
        \\10101
        \\01111
        \\00111
        \\11100
        \\10000
        \\11001
        \\00010
        \\01010
    ;
    const expect: u32 = 198;
    try std.testing.expectEqual(expect, try power_consumption(test_input.*[0..]));
}
