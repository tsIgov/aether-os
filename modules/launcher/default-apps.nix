{ ... }:
{
	xdg.mime = {
		enable = true;
		defaultApplications = {
			# Web
			"text/html" = [ "firefox.desktop" ];
			"x-scheme-handler/http" = [ "firefox.desktop" ];
			"x-scheme-handler/https" = [ "firefox.desktop" ];
			"x-scheme-handler/ftp" = [ "firefox.desktop" ];

			# Email
			# "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];

			# Text / Code
			"text/plain" = [ "micro.desktop" ];
			"text/x-shellscript" = [ "micro.desktop" ];
			"application/json" = [ "micro.desktop" ];

			# PDFs
			"application/pdf" = [ "org.gnome.Evince.desktop" ];

			# Images
			"image/png" = [ "org.gnome.eog.desktop" ]; # Eye of GNOME
			"image/jpeg" = [ "org.gnome.eog.desktop" ];
			"image/gif" = [ "org.gnome.eog.desktop" ];

			# Video / Audio
			"video/mp4" = [ "celluloid_player.Celluloid.desktop" ];
			"audio/mpeg" = [ "celluloid_player.Celluloid.desktop" ];
			"audio/ogg" = [ "celluloid_player.Celluloid.desktop" ];

			# Archives
			"application/zip" = [ "org.gnome.FileRoller.desktop" ];
			"application/x-tar" = [ "org.gnome.FileRoller.desktop" ];

			# Office Docs
			# "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "libreoffice-writer.desktop" ];
			# "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = [ "libreoffice-calc.desktop" ];
			# "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "libreoffice-impress.desktop" ];

			# Default file manager
			"inode/directory" = [ "nemo.desktop" ];
		};
	};
}
