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

        static public List<string> flipList(List<string> li)
        {
            return li.Select(x => String.Join("", x.Reverse())).ToList();
        }

        static public List<string> rotateListCCW(List<string> li)
        {
            var newL = new List<string>();
            for (int j = li[0].Length - 1; j >= 0; j--)
            {
                newL.Add(String.Join("", li.Select(x => x.ElementAt(j))));
            }
            return newL;
        }

        public List<string> GetOrientedLinesWithOutBorder()
        {
            var res = lines.GetRange(1, lines.Count - 2)
                .Select(x => x.Substring(1, x.Length - 2))
                .ToList();
            if (isFlipped)
            {
                res = flipList(res);
            }
            for (int i = 0; i < orientation; i++)
            {
                res = rotateListCCW(res);
            }
            return res;
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
            return new List<string>(System.IO.File.ReadAllLines("../../input.txt"));
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

        static int matchPattern(List<string> pattern, List<string> map)
        {
            int found = 0;
            for (int i = 0; i < map[0].Length - pattern[0].Length + 1; i++)
            {
                for (int j = 0; j < map.Count - pattern.Count + 1; j++)
                {
                    bool valid = true;
                    for (int pj = 0; pj < pattern.Count; pj++)
                    {
                        for (int pi = 0; pi < pattern[0].Length; pi++)
                        {
                            if (pattern[pj][pi] == '#' && map[j+pj][i+pi] != '#')
                            {
                                valid = false;
                            }
                            if (!valid)
                            {
                                break;
                            }
                        }
                        if (!valid)
                        {
                            break;
                        }
                    }
                    if (valid)
                    {
                        found += 1;
                    }
                }

            }

            return found;
        }

        static public int count(List<string> li, char ch)
        {
            return li.Select(x => x.Select(c => c == ch ? 1 : 0).Sum()).Sum();
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

            // Part two
            var sea = new List<string>();
            for (int y = top; y >= bottom ; y--)
            {
                var tileLines = new List<List<string>>();
                for (int x = left; x <= right ; x++)
                {
                    var t = map[(y, x)];
                    tileLines.Add(t.GetOrientedLinesWithOutBorder());
                }
                for (int i = 0; i < tileLines[0].Count; i++)
                {
                    string row = "";
                    foreach (var tileLine in tileLines)
                    {
                        row += tileLine[i];
                    }
                    sea.Add(row);
                }
            }


            var pattern = new List<string> {
                "                  # ",
                "#    ##    ##    ###",
                " #  #  #  #  #  #   "
            };
            var pCount = count(pattern, '#');
            var seaCount = count(sea, '#');
            var seaMonsterCount = 0;

            sea.Reverse();
            for (int i = 0; i < 2; i++)
            {
                for (int j = 0; j < 4; j++)
                {
                    var smc = matchPattern(pattern, sea);
                    if (smc > 0)
                    {
                        seaMonsterCount = smc;
                    }
                    sea = Tile.rotateListCCW(sea);
                }
                sea = Tile.flipList(sea);
            }

            Console.WriteLine($"Task1 solution: {topleft.ID * topright.ID * bottomright.ID * bottomleft.ID}");
            Console.WriteLine($"Task2 solution: {seaCount - pCount * seaMonsterCount}");
            Console.ReadKey();
        }
    }
}
