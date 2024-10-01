const std = @import("std");
const input = @embedFile("input.txt");
const split = std.mem.splitSequence;
const endsWith = std.mem.endsWith;
const parseInt = std.fmt.parseInt;

pub fn main() !void {
    var splits = split(u8, input, "\n");

    var possible_games: u16 = 0;
    var games_power: u128 = 0;

    var current_game: u16 = 1;

    while (splits.next()) |line| {
        const data_start_idx = std.mem.indexOf(u8, line, ":").? + 2;
        const game_data = line[data_start_idx..line.len];

        var sets = split(u8, game_data, "; ");

        var current_game_possible = true;

        var red_min: u16 = 0;
        var green_min: u16 = 0;
        var blue_min: u16 = 0;

        while (sets.next()) |set| {
            var cubes = split(u8, set, ", ");

            var red: u16 = 0;
            var green: u16 = 0;
            var blue: u16 = 0;

            while (cubes.next()) |cube| {
                const space_loc = std.mem.indexOf(u8, cube, " ");

                const value = try parseInt(u8, cube[0..space_loc.?], 10);

                if (endsWith(u8, cube, "green")) {
                    green += value;
                } else if (endsWith(u8, cube, "red")) {
                    red += value;
                } else if (endsWith(u8, cube, "blue")) {
                    blue += value;
                }
            }

            if (red > red_min) {
                red_min = red;
            }

            if (blue > blue_min) {
                blue_min = blue;
            }

            if (green > green_min) {
                green_min = green;
            }

            if (red <= 12 and green <= 13 and blue <= 14) {
                std.debug.print("#{d}: red: {d} | green: {d} | blue: {d} is possible\n", .{ current_game, red, green, blue });
            } else {
                std.debug.print("#{d}: red: {d} | green: {d} | blue: {d} is not possible\n", .{ current_game, red, green, blue });
                current_game_possible = false;
            }
        }
        std.debug.print("#{d}: Minimums are -> red: {d} | green: {d} | blue: {d}\n\n", .{ current_game, red_min, green_min, blue_min });

        if (current_game_possible) {
            possible_games += current_game;
        }

        games_power += (red_min * blue_min * green_min);
        current_game += 1;
    }
    std.debug.print("Possible games: {d}\n", .{possible_games});
    std.debug.print("Power: {d}\n", .{games_power});
}
