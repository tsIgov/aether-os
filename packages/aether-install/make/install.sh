mkdir -p $out/bin

cp -r src/bin/aether-install.sh $out/bin/aether-install
cp -r src/lib $out/lib

chmod +x $out/bin/aether-install
chmod +x $out/lib/*.sh
