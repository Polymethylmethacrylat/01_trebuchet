const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;
const print = std.debug.print;

pub fn main() !void {
}

test "simple test" {
    const file =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
        ;

    var num: ?u8 = null;
    var sum: usize = 0;
    for (file) |c| {
        if (c == '\n') {
            sum += num.? - '0';
            num = null;
            continue;
        }
        if (!(c >= '0' and c <= '9'))
            continue;
        if (num == null) {
            sum += 10 * (c - '0');
        }
        num = c;
    } else sum += num.? - '0';

    print("{}", .{sum});
    try expect(sum == 142);
}
