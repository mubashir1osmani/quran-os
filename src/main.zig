const UART_BASE = 0x09000000;

fn mmio_write(comptime T: type, address: usize, value: T) void {
    const ptr = @as(*volatile T, @ptrFromInt(address));
    ptr.* = value;
}

fn uart_putchar(c: u8) void {
    mmio_write(u8, UART_BASE, c);
}

fn print(msg: []const u8) void {
    for (msg) |c| {
        uart_putchar(c);
    }
}

export fn _start() callconv(.C) noreturn {
    print("iPodOS ARM64 Bootloader v0.1\n");

    while (true) {
        asm volatile ("wfe");
    }
}

comptime {
    @export(_start, .{ .name = "_start", .section = ".text.boot" });
}
