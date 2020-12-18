import re

lines = []
with open('../input.txt') as f:
  for line in f:
    lines.append(line.strip())

def evalA1(exp):
  k = re.search(r'(\d+\s*(\+|\*)\s*\d+)', exp)
  while k:
    exp = exp[:k.start()] + str(eval(k.group(1))) + exp[k.end():]
    k = re.search(r'(\d+\s*(\+|\*)\s*\d+)', exp)
  return int(exp)

def evalP1(exp: str):
  k = re.search(r'\(([^()]+)\)', exp)
  while k:
    exp = exp[:k.start()] + str(evalA1(k.group(1))) + exp[k.end():]
    k = re.search(r'\(([^()]+)\)', exp)
  return evalA1(exp)


def evalM2(exp):
  k = re.search(r'(\d+\s*\*\s*\d+)', exp)
  while k:
    exp = exp[:k.start()] + str(eval(k.group(1))) + exp[k.end():]
    k = re.search(r'(\d+\s*\*\s*\d+)', exp)
  return int(exp)

def evalA2(exp):
  k = re.search(r'(\d+\s*\+\s*\d+)', exp)
  while k:
    exp = exp[:k.start()] + str(eval(k.group(1))) + exp[k.end():]
    k = re.search(r'(\d+\s*\+\s*\d+)', exp)
  return evalM2(exp)

def evalP2(exp: str):
  k = re.search(r'\(([^()]+)\)', exp)
  while k:
    exp = exp[:k.start()] + str(evalA2(k.group(1))) + exp[k.end():]
    k = re.search(r'\(([^()]+)\)', exp)
  return evalA2(exp)


print(f'Task1 solution: {sum([evalP1(line) for line in lines])}')
print(f'Task2 solution: {sum([evalP2(line) for line in lines])}')
