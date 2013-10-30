#!/usr/bin/python

def count_neighbors(cells, x, y):
   count = 0
   for i in xrange(max(0,x-1), x+2):
      for o in xrange(max(0,y-1), y+2):
         if o != y or i != x:
            try:
               if cells[i][o] == '*':
                  count+=1
            except:
               pass
   return count

H, W = map(int, raw_input().split())

cells = []
for i in xrange(H):
   cells.append(list(raw_input()))

new_cells = [list(row) for row in cells]

for i in xrange(H):
   for o in xrange(W):
      new_cells[i][o] = '*' if cells[i][o] == '*' and 1 < count_neighbors(cells, i, o) < 4 else ' '

print '\n'.join(''.join(i) for i in new_cells)
