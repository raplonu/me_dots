function cmake-graph
set output $argv[1]
if set -q argv[2]
set source_dir $argv[2]
else 
set source_dir ..
end
set tmp_dir (mktemp -d -t graph-XXXXXXX)
cmake --graphviz=$tmp_dir/graph.dot $source_dir
dot -Grankdir=LR $tmp_dir/graph.dot -Tpng -o $output
rm -rf $tmp_dir
end
