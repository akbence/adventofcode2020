#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
using namespace std;

vector<string> readInput(string path) {
	vector<string> lines;
	string line;
	ifstream myfile(path);
	if (myfile.is_open())
	{
		while (myfile >> line)
		{
			lines.push_back(line);
		}
		myfile.close();
	}
	return lines;
}

struct Pos3d {
	int x, y, z;
	Pos3d(int _x, int _y, int _z): x(_x), y(_y), z(_z) {}
	friend ostream& operator<<(ostream& os, const Pos3d& pos);
	bool operator==(const Pos3d &other) const {
		return (x == other.x
			&& y == other.y
			&& z == other.z);
	}
};
ostream& operator<<(ostream& os, const Pos3d& pos) {
	os << "x=" << pos.x << ", y=" << pos.y << ", z=" << pos.z;
	return os;
}

namespace std {
	template <>
	struct hash<Pos3d> {
		std::size_t operator()(const Pos3d& k) const {
			using std::size_t;
			using std::hash;

			return ((hash<int>()(k.x)
				^ (hash<int>()(k.y) << 1)) >> 1)
				^ (hash<int>()(k.z) << 1);
		}
	};
}

struct Pos4d {
	int x, y, z, w;
	Pos4d(int _x, int _y, int _z, int _w): x(_x), y(_y), z(_z), w(_w) {}
	friend ostream& operator<<(ostream& os, const Pos4d& pos);
	bool operator==(const Pos4d &other) const {
		return (x == other.x
			&& y == other.y
			&& z == other.z
			&& w == other.w);
	}
};
ostream& operator<<(ostream& os, const Pos4d& pos) {
	os << "x=" << pos.x << ", y=" << pos.y << ", z=" << pos.z << ", w=", pos.w;
	return os;
}

namespace std {
	template <>
	struct hash<Pos4d> {
		std::size_t operator()(const Pos4d& k) const {
			using std::size_t;
			using std::hash;

			return ((((hash<int>()(k.x)
				^ (hash<int>()(k.y) << 1)) >> 1)
				^ (hash<int>()(k.z) << 1)) >> 1)
				^ (hash<int>()(k.w) << 1);
		}
	};
}

typedef unordered_map<Pos3d, bool> Map3d;
typedef unordered_map<Pos4d, bool> Map4d;

Map3d initMap3d(vector<string>& lines) {
	Map3d map;
	for (int y = 0; y < lines.size(); y++) {
		for (int x = 0; x < lines[0].size(); x ++ ) {
			if (lines[y][x] == '#') {
				Pos3d pos = { x, y, 0 };
				map.insert({ pos, true });
			}
		}
	}
	return map;
}

Map4d initMap4d(vector<string>& lines) {
	Map4d map;
	for (int y = 0; y < lines.size(); y++) {
		for (int x = 0; x < lines[0].size(); x ++ ) {
			if (lines[y][x] == '#') {
				Pos4d pos = { x, y, 0, 0 };
				map.insert({ pos, true });
			}
		}
	}
	return map;
}

int getActiveNeighboursCount(const Pos3d& p, const Map3d& map) {
	int sum = 0;
	for (int dx = -1; dx <= 1; dx++) {
		for (int dy = -1; dy <= 1; dy++) {
			for (int dz = -1; dz <= 1; dz++) {
				if (dx == 0 && dy == 0 && dz == 0) {
					continue;
				}
				auto element = map.find(Pos3d(p.x + dx, p.y + dy, p.z + dz));
				if (element != map.end()) {
					sum += 1;
				}
			}
		}
	}
	return sum;
}

int getActiveNeighboursCount(const Pos4d& p, const Map4d& map) {
	int sum = 0;
	for (int dx = -1; dx <= 1; dx++) {
		for (int dy = -1; dy <= 1; dy++) {
			for (int dz = -1; dz <= 1; dz++) {
				for (int dw = -1; dw <= 1; dw++) {
					if (dx == 0 && dy == 0 && dz == 0 && dw == 0) {
						continue;
					}
					auto element = map.find(Pos4d(p.x + dx, p.y + dy, p.z + dz, p.w + dw));
					if (element != map.end()) {
						sum += 1;
					}
				}
			}
		}
	}
	return sum;
}

Map3d next3dMap(const Map3d& map) {
	Map3d newMap;
	unordered_set<Pos3d> ps;
	for (auto m : map) {
		for (int dx = -1; dx <= 1; dx++) {
			for (int dy = -1; dy <= 1; dy++) {
				for (int dz = -1; dz <= 1; dz++) {
					ps.emplace(m.first.x + dx, m.first.y + dy, m.first.z + dz);
				}
			}
		}
	}
	for (const Pos3d& p : ps) {
		bool active;
		auto element = map.find(p);
		active = (element != map.end()) ? (*element).second : false;
		int activeNeighboursCount = getActiveNeighboursCount(p, map);
		if (active && (activeNeighboursCount == 2 || activeNeighboursCount == 3)) {
			newMap[p] = true;
		}
		else if (!active && activeNeighboursCount == 3) {
			newMap[p] = true;
		}
	}
	return newMap;
}

Map4d next4dMap(const Map4d& map) {
	Map4d newMap;
	unordered_set<Pos4d> ps;
	for (auto m : map) {
		for (int dx = -1; dx <= 1; dx++) {
			for (int dy = -1; dy <= 1; dy++) {
				for (int dz = -1; dz <= 1; dz++) {
					for (int dw = -1; dw <= 1; dw++) {
						ps.emplace(m.first.x + dx, m.first.y + dy, m.first.z + dz, m.first.w + dw);
					}
				}
			}
		}
	}
	for (const Pos4d& p : ps) {
		bool active;
		auto element = map.find(p);
		active = (element != map.end()) ? (*element).second : false;
		int activeNeighboursCount = getActiveNeighboursCount(p, map);
		if (active && (activeNeighboursCount == 2 || activeNeighboursCount == 3)) {
			newMap[p] = true;
		}
		else if (!active && activeNeighboursCount == 3) {
			newMap[p] = true;
		}
	}
	return newMap;
}

int task1(vector<string>& lines) {
	Map3d map = initMap3d(lines);
	for (int i = 0; i < 6; i++) {
		map = next3dMap(map);
	}

	return map.size();
}

int task2(vector<string>& lines) {
	Map4d map = initMap4d(lines);
	for (int i = 0; i < 6; i++) {
		map = next4dMap(map);
	}
	return map.size();
}

int main()
{
	auto lines = readInput("../input.txt");
	cout << "Task1 solution: " << task1(lines) << "\n";
	cout << "Task2 solution: " << task2(lines) << "\n";
}
