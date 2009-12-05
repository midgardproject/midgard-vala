vala-gen-introspect midgard2 ./
vapigen --library midgard2 midgard2.gi
perl -p -i -e  "s/midgard2.h/midgard\/midgard.h/g" midgard2.vapi
