function wcc
for compiler in CC CXX
set -q $compiler; or set $compiler "not set"
end
echo "CC is $CC & CXX is $CXX"
end
