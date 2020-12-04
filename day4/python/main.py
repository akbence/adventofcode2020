import re

lines = []
with open("../input.txt") as f:
  for line in f:
    lines.append(line.strip())

passports = [{}]
for line in lines:
  if line == "":
    passports.append({})
    continue

  attributes = [(part.split(":")[0], part.split(":")[1]) for part in line.split(" ")]
  current_passport = passports[-1]
  for attribute in attributes:
    current_passport[attribute[0]] = attribute[1]


def valid_passport_part1(passport):
  needed_attributes = {
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
    # "cid",
  }
  for needed_attr in needed_attributes:
    if passport.get(needed_attr) == None:
      return False
  return True

def valid_passport_part2(passport):
  if not passport.get("byr") or not re.match("^\d{4}$", passport.get("byr")) or not 1920 <= int(passport.get("byr")) <= 2002:
    return False
  if not passport.get("iyr") or not re.match("^\d{4}$", passport.get("iyr")) or not 2010 <= int(passport.get("iyr")) <= 2020:
    return False
  if not passport.get("eyr") or not re.match("^\d{4}$", passport.get("eyr")) or not 2020 <= int(passport.get("eyr")) <= 2030:
    return False
  if not passport.get("hcl") or not re.match("^#[a-f0-9]{6}$", passport.get("hcl")):
    return False
  if not passport.get("ecl") or passport.get("ecl") not in ("amb", "blu", "brn", "gry", "grn", "hzl", "oth"):
    return False
  if not passport.get("pid") or not re.match("^\d{9}$", passport.get("pid")):
    return False
  hgt = passport.get("hgt")
  if not hgt:
    return False
  hgt_match = re.match("(\d+)(cm|in)", hgt)
  if not hgt_match:
    return False
  if hgt_match.group(2) == "in" and not 59 <= int(hgt_match.group(1)) <= 76:
    return False
  if hgt_match.group(2) == "cm" and not 150 <= int(hgt_match.group(1)) <= 193:
    return False

  return True

part1_valid_passport_count = 0
part2_valid_passport_count = 0
for passport in passports:
  if valid_passport_part1(passport):
    part1_valid_passport_count+=1
  if valid_passport_part2(passport):
    part2_valid_passport_count+=1

print(f"Task1 solution: {part1_valid_passport_count}")
print(f"Task2 solution: {part2_valid_passport_count}")
