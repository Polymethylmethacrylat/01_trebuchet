const std = @import("std");
const testing = std.testing;
const print = std.debug.print;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var algo = Algo{};

    while (stdin.readByte()) |char| {
        algo.feed(char);
    } else |_| { }

    const sum = algo.end();
    try stdout.print("{}", .{sum});
}

const Algo = struct {
    const Self = @This();
    // current digit
    num: ?u8 = null,
    // sum untill now
    sum: usize = 0,
    pub fn feed(self: *Self, char: u8) void {
        if (char == '\n') {
            self.sum += self.num.?;
            self.num = null;
            return;
        }
        if (!(char >= '0' and char <= '9'))
            return;
        if (self.num == null) {
            self.sum += 10 * (char - '0');
        }
        self.num = char - '0';
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
    try testing.expectEqual(sum, 142);
}

