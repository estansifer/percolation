#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Author: Eric Stansifer
# Date: 2017 May 4
# License: MIT License
# Hosted on https://github.com/estansifer/percolation
# Tested on Python 3.5.2. Requires numpy.

import numpy as np
import numpy.random as npr
import sys
import heapq

push = heapq.heappush
pop = heapq.heappop

def invperc(L):
    L = int(L)

    adj = [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1)]

    visited = np.zeros((2 * L, L, L), dtype = bool)
    rs = npr.random((8 * L * L * L,))
    i = 0

    q = [(0, 0, 0, 0)]

    while len(q) > 0:
        p, x, y, z = pop(q)

        if not visited[x, y, z]:
            visited[x, y, z] = True

            if x == L and y == 0:
                break

            for dx, dy, dz in adj:
                x_ = (x + dx) % (2 * L)
                y_ = (y + dy) % L
                z_ = (z + dz) % L
                if not visited[x_, y_, z_]:
                    push(q, (rs[i], x_, y_, z_))
                    i += 1

    return np.sum(visited)

usage=(
"""A program for simulating invasion percolation.
Usage:
    python perc.py L

The program simulates a three dimensional domain of size 2L x L x L
with periodic boundary conditions. The inlet and outlet are chosen to
be a distance of L apart.
""")

def main():
    args = sys.argv
    if len(args) == 2:
        L = int(args[1])
        print(invperc(L))
    else:
        print(usage)

if __name__ == "__main__":
    main()
