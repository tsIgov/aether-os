mkdir -p $out/lib
mkdir -p $out/bin

cp -r ./basic_colormath $out/lib
cp -r ./color_manager $out/lib
cp palette.json $out/palette.json

cp ./src/aether-recolor.sh $out/bin/aether-recolor
chmod +x $out/bin/aether-recolor

