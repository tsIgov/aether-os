mkdir -p $out/share/kitty/kitty_grab
cp -r ./* $out/share/kitty/kitty_grab/

chmod +x $out/share/kitty/kitty_grab/grab.py || true
chmod +x $out/share/kitty/kitty_grab/_grab_ui.py || true
