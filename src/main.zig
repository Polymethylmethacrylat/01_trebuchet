const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var algo = Algo{};

    while (stdin.readByte()) |char| {
        algo.feed(char);
    } else |_| {}

    const sum = algo.end();
    try stdout.print("{}", .{sum});
}

const Algo = struct {
    const Self = @This();
    const digits = .{
        "zero",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    };
    // current digit
    num: ?u8 = null,
    // sum untill now
    sum: usize = 0,
    // filter index
    digit_index: [digits.len]usize = .{0} ** digits.len,
    pub fn feed(self: *Self, char: u8) void {
        var c = char;
        inline for (digits, &self.digit_index, 0..) |d, *index, i| {
            const len = @field(d, "len");
            if (d[index.*] == char) {
                index.* += 1;
            } else if (d[0] == char) index.* = 1 else index.* = 0;

            if (index.* >= len) {
                c = i + '0';
                index.* = 0;
            }
        }
        if (c == '\n') {
            self.sum += self.num.?;
            self.num = null;
            return;
        }
        if (!(c >= '0' and c <= '9')) {
            return;
        }
        if (self.num == null) {
            self.sum += 10 * (c - '0');
        }
        self.num = c - '0';
    }
    pub fn end(self: *Self) usize {
        if (self.num) |n|
            self.sum += n;
        self.num = null;
        return self.sum;
    }
};

test "simple test" {
    const file =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;

    var algo = Algo{};

    for (file) |c|
        algo.feed(c);

    const sum = algo.end();
    try expect(sum == 142);
}

test "complex test" {
    const file =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;

    var algo = Algo{};

    for (file) |c|
        algo.feed(c);

    const sum = algo.end();
    try expect(sum == 281);
}
