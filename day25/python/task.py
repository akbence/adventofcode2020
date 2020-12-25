import re

lines = []
with open("../input.txt") as f:
  for l in f:
    lines.append(l.strip())

card_public_key = int(lines[0])
door_public_key = int(lines[1])
subject = 7

def find_loop_size(pkey, subject):
  value = 1
  loop_size = 0
  while value != pkey:
    loop_size += 1
    value = (value * subject) % 20201227
  return (loop_size, value)

c_loop_size, c_value = find_loop_size(card_public_key, subject)
d_loop_size, d_value = find_loop_size(door_public_key, subject)
encryption_key = 1
for _ in range(d_loop_size):
  encryption_key = (encryption_key * c_value) % 20201227
print(f'Task1 solution: {encryption_key}')