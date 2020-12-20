using System;
using System.Linq;
using System.Collections.Generic;

namespace CSharp
{
    class Tile
    {
        public long ID;
        public List<string> lines;
        public List<string> sides;
        public int orientation = 0;
        public bool isFlipped = false;
        public Tile(List<string> tiledata)
        {
            ID = int.Parse(tiledata.ElementAt(0).Split(" ")[1].Split(":")[0]);
            tiledata.RemoveAt(0);
            lines = tiledata;
            var top = lines.First();
            var bottom = String.Join("", lines.Last().Reverse());
            var left = String.Join("", lines.Select((line) => line.First()).Reverse());
            var right = String.Join("", lines.Select((line) => line.Last()));
            sides = new List<string> { top, right, bottom, left };
        }

        public void rotateTile()
        {
            orientation = (orientation + 1) % 4;
            var side = sides[0];
            sides.RemoveAt(0);
            sides.Add(side);
        }

        public void flipTile()
        {
            isFlipped = !isFlipped;
            sides = sides.Select(x => String.Join("", x.Reverse())).ToList();
            var temp = sides[1];
            sides[1] = sides[3];
            sides[3] = temp;
        }
    }

    class Program
    {
        static List<string> readInput()
        {
            return new List<string>(System.IO.File.ReadAllLines("../../../../input.txt"));
        }

        static bool tryTile(Tile tile, (int, int) pos, Dictionary<(int, int), Tile> map)
        {
            for (int j = 0; j < 2; j++)
            {
                for (int i = 0; i < 4; i++)
                {
                    // Top
                    var top = String.Join("", tile.sides[0].Reverse());
                    Tile neightbour;
                    if (map.TryGetValue((pos.Item1 + 1, pos.Item2), out neightbour) && neightbour.sides[2] != top)
                    {
                        if (pos.Equals((0, 1)) && tile.ID == 3079)
                        {
                            Console.WriteLine(i);
                            Console.WriteLine(top);
                            Console.WriteLine(neightbour.ID);
                            Console.WriteLine(neightbour.sides[2]);
                            Console.WriteLine("===============");
                        }
                        tile.rotateTile();
                        continue;
                    }
                    // Right
                    var right = String.Join("", tile.sides[1].Reverse());
                    if (map.TryGetValue((pos.Item1, pos.Item2 + 1), out neightbour) && neightbour.sides[3] != right)
                    {
                        tile.rotateTile();
                        continue;
                    }
                    // Bottom
                    var bottom = String.Join("", tile.sides[2].Reverse());
                    if (map.TryGetValue((pos.Item1 - 1, pos.Item2), out neightbour) && neightbour.sides[0] != bottom)
                    {
                        tile.rotateTile();
                        continue;
                    }
                    // Left
                    var left = String.Join("", tile.sides[3].Reverse());
                    if (map.TryGetValue((pos.Item1, pos.Item2 - 1), out neightbour) && neightbour.sides[1] != left)
                    {
                        tile.rotateTile();
                        continue;
                    }
                    return true;
                }
                tile.flipTile();
            }
            return false;
        }

        static List<Tile> putTiles((int, int) pos, Dictionary<(int, int), Tile> map, List<Tile> unusedTiles)
        {
            if (unusedTiles.Count == 0)
            {
                return unusedTiles;
            }

            Tile t = null;
            foreach (var tile in unusedTiles)
            {
                if (tryTile(tile, pos, map))
                {
                    t = tile;
                    map.Add(pos, tile);
                    break;
                }
            }
            if (t == null)
            {
                return unusedTiles;
            }
            var newUnused = unusedTiles.Where(x => x.ID != t.ID).ToList();
            // Top
            if (!map.ContainsKey((pos.Item1 + 1, pos.Item2)))
            {
                newUnused = putTiles((pos.Item1 + 1, pos.Item2), map, newUnused);
            }
            // Right
            if (!map.ContainsKey((pos.Item1, pos.Item2 + 1)))
            {
                newUnused = putTiles((pos.Item1, pos.Item2 + 1), map, newUnused);
            }
            // Buttom
            if (!map.ContainsKey((pos.Item1 - 1, pos.Item2)))
            {
                newUnused = putTiles((pos.Item1 - 1, pos.Item2), map, newUnused);
            }
            // Left
            if (!map.ContainsKey((pos.Item1, pos.Item2 - 1)))
            {
                newUnused = putTiles((pos.Item1, pos.Item2 - 1), map, newUnused);
            }

            return newUnused;
        }

        static void Main(string[] args)
        {
            var lines = readInput();
            var tileData = new List<string>();
            var tiles = new List<Tile>();
            foreach (var line in lines)
            {
                if(String.IsNullOrWhiteSpace(line))
                {
                    var t = new Tile(tileData);
                    tiles.Add(t);
                    tileData = new List<string>();
                } else
                {
                    tileData.Add(line);
                }
            }

            var map = new Dictionary<(int, int), Tile>();
            var remaind = putTiles((0, 0), map, tiles);
            var top = map.Select(x => x.Key).Max(x => x.Item1);
            var right = map.Select(x => x.Key).Max(x => x.Item2);
            var bottom = map.Select(x => x.Key).Min(x => x.Item1);
            var left = map.Select(x => x.Key).Min(x => x.Item2);
            Tile topleft;
            Tile topright;
            Tile bottomleft;
            Tile bottomright;
            map.TryGetValue((top, left), out topleft);
            map.TryGetValue((top, right), out topright);
            map.TryGetValue((bottom, left), out bottomleft);
            map.TryGetValue((bottom, right), out bottomright);

            Console.WriteLine($"Task1 solution: {topleft.ID * topright.ID * bottomright.ID * bottomleft.ID}");
            Console.ReadKey();
        }
    }
}
