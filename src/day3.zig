const std = @import("std");

const BadInput = error{
    nan,
};

const CompType = enum {
    co2,
    oxygen,
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

    var mask = (@as(u32, 1) << len) - 1;
    return gamma_rate * (~gamma_rate & mask);
}

pub fn life_support_rating(input: []const u8) anyerror!u32 {
    var input_split = std.mem.split(u8, input, "\n");
    var nums_arr: [4096]u32 = undefined;
    var lines: usize = 0;
    var bits: u5 = 0;

    while (true) {
        const m_in = input_split.next();
        if (m_in) |in| {
            if (bits == 0) {
                bits = @intCast(u5, in.len);
            }
            const num = std.fmt.parseInt(u32, in, 2) catch continue;
            nums_arr[lines] = num;
            lines += 1;
        } else {
            break;
        }
    }

    const oxygen_generator_rating = get_number(CompType.oxygen, bits, nums_arr[0..lines]);
    const co2_scrubber_rating = get_number(CompType.co2, bits, nums_arr[0..lines]);

    return oxygen_generator_rating * co2_scrubber_rating;
}

fn get_number(ct: CompType, bit: u5, list: []u32) u32 {
    if (list.len == 1) return list[0];
    if (bit == 0) return 0;

    var sum_for_nth_bit: u32 = 0;

    var sig_bits_arr: [4096]u32 = undefined;
    for (list) |num, idx| {
        const nth_significant_bit = (num & (@as(u32, 1) << bit - 1)) >> bit - 1;
        sig_bits_arr[idx] = nth_significant_bit;
        sum_for_nth_bit += nth_significant_bit;
    }
    var sig_bits = sig_bits_arr[0..list.len];

    var buff: [4096]u32 = undefined;
    var buff_idx: u32 = 0;

    const look_for_zeroes = switch (ct) {
        .co2 => 100 * sum_for_nth_bit >= 100 * list.len / 2,
        .oxygen => 100 * sum_for_nth_bit < 100 * list.len / 2,
    };

    if (look_for_zeroes) {
        for (list) |num, idx| {
            if (sig_bits[idx] == 0) {
                buff[buff_idx] = num;
                buff_idx += 1;
            }
        }
    } else {
        for (list) |num, idx| {
            if (sig_bits[idx] == 1) {
                buff[buff_idx] = num;
                buff_idx += 1;
            }
        }
    }

    return get_number(ct, bit - 1, buff[0..buff_idx]);
}

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

test "power_consumption" {
    const expect: u32 = 198;
    try std.testing.expectEqual(expect, try power_consumption(test_input.*[0..]));
}

test "life_support_rating" {
    const expect: u32 = 230;
    try std.testing.expectEqual(expect, try life_support_rating(test_input.*[0..]));
}
