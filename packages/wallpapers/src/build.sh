mkdir -p $TMPDIR/processed
for svg in $(find ./images -name "*.svg"); do
	name=$(basename "$svg" .svg)
	echo $svg
	sed -e "s/#ffffff/#$FOREGROUND_COLOR/g" -e "s/#000000/#$BACKGROUND_COLOR/g" "$svg" > "$TMPDIR/processed/$name.processed.svg"

done

mkdir -p $TMPDIR/pngs
for svg in $TMPDIR/processed/*.svg; do
	name=$(basename "$svg" .processed.svg)
	inkscape "$svg" --export-type=png --export-height=2048 --export-width=3640 --export-area-page --export-filename="$TMPDIR/pngs/$name.png"
done
