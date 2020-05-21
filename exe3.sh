#!/usr/bin/env sh
for MET in \
    bisim \
    bisim-gv \
    bisim-gjkw \
    branching-bisim \
    branching-bisim-gv \
    branching-bisim-gjkw \
    dpbranching-bisim \
    dpbranching-bisim-gv \
    dpbranching-bisim-gjkw \
    weak-bisim \
    dpweak-bisim \
    sim \
    ready-sim \
    trace \
    weak-trace
do
echo "$(ltscompare -q -e "$MET" Ctm_lim.lts Cm.lts)\t$MET"
done
