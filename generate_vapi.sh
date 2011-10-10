vala-gen-introspect midgard2 ./
vapigen --library Midgard midgard2.gi
perl -p -i -e  "s/midgard2.h/midgard\/midgard.h/g" Midgard.vapi
