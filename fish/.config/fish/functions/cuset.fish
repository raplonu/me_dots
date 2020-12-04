function cuset
pushd /usr/local/
sudo rm -rf cuda
sudo ln -s cuda-$argv[1] cuda
popd
end
