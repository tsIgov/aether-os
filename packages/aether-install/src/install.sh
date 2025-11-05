mkdir -p $out/bin

cp -r bin/aether-install.sh $out/bin/aether-install
cp -r lib $out/lib

chmod +x $out/bin/aether-install
chmod +x $out/lib/*.sh
