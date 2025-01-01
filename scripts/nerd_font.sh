#/bin/bash
# install FiraMono Nerd Font --> others at: https://www.nerdfonts.com/font-downloads
echo "[-] Download fonts [-]"
echo "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip
unzip FiraMono.zip -d ~/.local/share/fonts
fc-cache -fv
rm FiraMono.zip
echo "done!"
