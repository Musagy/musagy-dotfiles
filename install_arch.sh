#!/bin/bash

# Variables por defecto
CUSTOM_ZSH=true
JAPANESE_FONTS=true
KOREAN_FONTS=true
AUR_MANAGER_DEFAULT=true
WALLPAPER_FOLDER=~/Pictures/Wallpapers
CUSTOM_ROFI=true
BROWSER_DEFAULT=true
CUSTOM_NVIM=true

function presentation {
    echo -e " ______                                   _____              ___ _ _            "
    echo -e "|  ___ \                                 (____ \       _    / __(_| |           "
    echo -e "| | _ | |_   _  ___  ____  ____ _   _ ___ _   \ \ ___ | |_ | |__ _| | ____  ___ "
    echo -e "| || || | | | |/___)/ _  |/ _  | | | (___| |   | / _ \|  _)|  __| | |/ _  )/___)"
    echo -e "| || || | |_| |___ ( ( | ( ( | | |_| |   | |__/ | |_| | |__| |  | | ( (/ /|___ |"
    echo -e "|_||_||_|\____(___/ \_||_|\_|| |\__  |   |_____/ \___/ \___|_|  |_|_|\____(___/ "
    echo -e "                         (_____(____/                                           "
}

# > Instalando dependencias generales
function installDependencies {
    sudo pacman -Syu
    sudo pacman -S --needed curl git unzip rofi waybar jq --noconfirm
}

## Configuracion de Fonts
function installFonts {
    # Instalacion de JetBrainsMono
    echo -e "Instalacion de JetBrainsMono" 
    if [ -d "$HOME/.config/fastfetch" ]; then
        echo -e "\n\tExiste el directorio fastfetch...\n\
        tCopiando archivos\n"
        unzip -o ./fonts/JetBrainsMono.zip -d ~/.local/share/fonts
    else
        echo -e "\n\tEl directorio no existe...\n\tCreandolo...\n"
        mkdir $HOME/.config/fastfetch
        unzip -o ./fonts/JetBrainsMono.zip -d ~/.local/share/fonts
    fi

    # Instalando emojis
    echo -e "Instalando emojis"
    sudo pacman -S noto-fonts-emoji --noconfirm

    # Instalacion fuentes japonesas
    if [ "$JAPANESE_FONTS" == true ]; then
        echo -e "Instalacion fuentes japonesas"
        sudo pacman -S adobe-source-han-sans-jp-fonts --noconfirm
    fi


    # Instalacion fuentes coreanas
    if [ "$KOREAN_FONTS" == true ]; then
        echo -e "Instalacion fuentes coreanas" 
        sudo pacman -S adobe-source-han-sans-kr-fonts --noconfirm
    fi
}

function copyKittyConf {
    if [ -d "$HOME/.config/kitty" ]; then
        echo -e "\n\tExiste el directorio kitty"
        if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
            echo -e "\tExiste el archivo kitty.conf"
            cp $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/backup_kitty.conf
            cp config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
        else
            echo -e "\n\tNo existe el archivo copiando ...\n"
            cp config/kitty/kitty.conf $HOME/.config/kitty
        fi
    else
        echo -e "\n\tEl directorio no existe copiando...\n"
        cp config/kitty/ $HOME/.config/
    fi
}

function copyZshConf {
    # Check if .zshrc exist
    if [ -f "$HOME/.zshrc" ]; then
        echo -e "\n\tExiste el archivo .zshrc"
        cp $HOME/.zshrc $HOME/.zshrc_backup
        cp home/.zshrc $HOME/
    else
        echo -e "\n\tNo existe el archivo, copiando ...\n"
        cp home/.zshrc $HOME/
    fi
}

function copyFastfetch {
    # Check if fastfatch directory exist
    if [ -d "$HOME/.config/fastfetch" ]; then
        echo -e "\n\tExiste el directorio fastfetch...\n\tCopiando archivos\n"
        cp -r config/fastfetch/* $HOME/.config/fastfetch/
    else
        echo -e "\n\tEl directorio no existe...\n\tCreandolo...\n"
        mkdir $HOME/.config/fastfetch
        cp -r config/fastfetch/* $HOME/.config/fastfetch/
    fi
}

function installZshCustom {
    sudo pacman -S --needed zsh fastfetch
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    copyZshConf

    copyFastfetch
}

function setWallpaperFolder {
    # Variables
    WAYPAPER_CONFIG="./config/waypaper/config.ini"
    WALLPAPER_DEFAULT="$WALLPAPER_FOLDER/bg-default.png"

    # Cambiando los parametros de la configuracion de waypaper
    sed -i "s|^folder *=.*|folder = $WALLPAPER_FOLDER|" "$WAYPAPER_CONFIG"
    sed -i "s|^wallpaper *=.*|wallpaper = $WALLPAPER_DEFAULT|" "$WAYPAPER_CONFIG"

    # Creando y copiando la carpeta de Wallpapers donde debe de ir
    mkdir -p "$WALLPAPER_FOLDER"
    cp -r ./Wallpapers/. "$WALLPAPER_FOLDER"
}

# Función para instalar de AUR manager y dependencias
function installAurManager {
    if [ "$AUR_MANAGER_DEFAULT" == true ]; then
        Instalación de rust
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        # Instalación de paru
        sudo pacman -S --needed base-devel --noconfirm
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si
        cd ..
        rm -rf paru
        # echo "paru"
    else
        Instalación de yay
        sudo pacman -S --needed base-devel git --noconfirm
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
        cd ..
        rm -rf yay
        # echo "yay"
    fi
}

function installAurDependencies {
    if [ "$AUR_MANAGER_DEFAULT" == true ]; then
        paru -S swww waypaper --noconfirm
    else
        yay -S swww waypaper --noconfirm
    fi
}

function copyHyprConf {
    if [ -d "$HOME/.config/hypr" ]; then
        echo -e "\n\tExiste el directorio hypr...\n\tCopiando archivos\n"
        cp config/hypr/* $HOME/.config/hypr
    else
        echo -e "\n\tEl directorio no existe...\n\tCreandolo...\n"
        mkdir $HOME/.config/hypr
        cp config/hypr/* $HOME/.config/hypr
    fi
}

function copyWaybarConf {
    if [ -d "$HOME/.config/waybar" ]; then
        echo -e "\n\tExiste el directorio waybar...\n\tCopiando archivos\n"
        cp config/waybar/* $HOME/.config/waybar
    else
        echo -e "\n\tEl directorio no existe...\n\tCreandolo...\n"
        mkdir $HOME/.config/waybar
        cp config/waybar/* $HOME/.config/waybar/
    fi
}

function copyRofiConf {
    if [ -d "$HOME/.config/rofi" ]; then
        echo -e "\n\tExiste el directorio rofi...\n\tCopiando archivos\n"
        cp -r config/rofi/* $HOME/.config/rofi
    else
        echo -e "\n\tEl directorio no existe...\n\tCreandolo...\n"
        mkdir $HOME/.config/rofi
        cp -r config/rofi/* $HOME/.config/rofi/
    fi
}
function setRofiTheme {
    git clone --depth=1 https://github.com/adi1090x/rofi.git
    cd rofi
    chmod +x setup.sh
    ./setup.sh
    cd ..
    rm -rf rofi
}

function installBrowser {
    if [ "$BROWSER_DEFAULT" == true ]; then
        if [ "$AUR_MANAGER_DEFAULT" == true ]; then
            paru -S brave --noconfirm
        else
            yay -S brave --noconfirm
        fi
    else
        sudo pacman --needed -S firefox --noconfirm
    fi
}
function setNeoVim {
    sudo pacman -S --needed neovim

    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    #Check if nvim directory exist
    if [ -d "$HOME/.config/nvim" ]; then
        # Check if init.vim exist
        echo -e "\n\tExiste el directorio nvim"
        if [ -f "$HOME/.config/nvim/init.vim" ]; then
            echo -e "\tExiste el archivo init.vim"
            cp $HOME/.config/nvim/init.vim $HOME/.config/nvim/backup.vim
            cp config/nvim/init.vim $HOME/.config/nvim/init.vim
        else
            echo -e "\n\tNo existe el archivo creando copiando ...\n"
            cp config/nvim/init.vim $HOME/.config/nvim/
        fi
    else
        echo -e "\n\tEl directorio no existe copiando ...\n"
	    mkdir $HOME/.config/nvim
        cp config/nvim/init.vim $HOME/.config/
    fi
}

function setCustomInstallation {
    # ZSH Custom
    read -p "> Instalación y Customizacion de ZSH (Y/n): " CUSTOM_ZSH_CHOISE
    case $CUSTOM_ZSH_CHOISE in
        "Y" | "y" | "")
            CUSTOM_ZSH=true
            break
            ;;
        "N" | "n")
            CUSTOM_ZSH=false
            break
            ;;
    esac

    # Fuentes Japonesas
    read -p "> Descargar fuentes Japonesas (Y/n): " JAPANESE_FONTS_CHOISE
    case $JAPANESE_FONTS_CHOISE in
        "Y" | "y" | "")
            JAPANESE_FONTS=true
            break
            ;;
        "N" | "n")
            JAPANESE_FONTS=false
            break
            ;;
    esac

    # Fuentes Coreanas
    read -p "> Descargar fuentes Coreanas (Y/n): " KOREAN_FONTS_CHOISE
    case $KOREAN_FONTS_CHOISE in
        "Y" | "y" | "")
            KOREAN_FONTS=true
            break
            ;;
        "N" | "n")
            KOREAN_FONTS=false
            break
            ;;
    esac

    # AUR manager
    echo "> Selecciona el administrador de AUR (por defecto: Paru):"
    echo "    1) Paru (por defecto)"
    echo "    2) Yay"
    while true; do
        read -p "Introduce el número correspondiente (1 o 2, por defecto 1): " AUR_MANAGER_CHOICE

        case $AUR_MANAGER_CHOICE in
            1 | "")
                AUR_MANAGER_DEFAULT=true
                break
                ;;
            2)
                AUR_MANAGER_DEFAULT=false
                break
                ;;
            *)
                echo "Selección no válida. Por favor, introduce 1 o 2."
                ;;
        esac
    done

    # Carpeta de wallpapers
    read -p "> Carpeta de wallpapers (por defecto: ~/Pictures/Wallpapers): " WALLPAPER_FOLDER
    WALLPAPER_FOLDER=${WALLPAPER_FOLDER:-"~/Pictures/Wallpapers"}

    # ROFI Custom
    read -p "> Instalación y Customizacion de Rofi (Y/n): " CUSTOM_ROFI_CHOISE
    case $CUSTOM_ROFI_CHOISE in
        "Y" | "y" | "")
            CUSTOM_ROFI=true
            break
            ;;
        "N" | "n")
            CUSTOM_ROFI=false
            break
            ;;
    esac

    # Browser
    echo "> Selecciona el Navegador:"
    echo "    1) Brave (por defecto)"
    echo "    2) Firefox"
    while true; do
        read -p "Introduce el número correspondiente (1 o 2, por defecto 1): " BROWSER_CHOICE

        case $BROWSER_CHOICE in
            1 | "")
                BROWSER_DEFAULT=true
                break
                ;;
            2)
                BROWSER_DEFAULT=false
                break
                ;;
            *)
                echo "Selección no válida. Por favor, introduce 1 o 2."
                ;;
        esac
    done

    # ROFI Custom
    read -p "> Instalación y Customizacion de NeoVim. PS: no uso NeoVim (Y/n): " CUSTOM_NVIM_CHOISE
    case $CUSTOM_NVIM_CHOISE in
        "Y" | "y" | "")
            CUSTOM_NVIM=true
            break
            ;;
        "N" | "n")
            CUSTOM_NVIM=false
            break
            ;;
    esac
}

function installer {
    echo -e ">>> Instalando dependencias"
    installDependencies
    echo -e ">>> Instalando Fuentes"
    installFonts
    if [ "$CUSTOM_ZSH" == true ]; then
        echo ">>> Instalando y configurando ZSH"
        installZshCustom
    fi
    echo -e ">>> Copiando configuracion de kitty"
    copyKittyConf
    echo -e ">>> Instalando AUR manager"
    installAurManager
    echo -e ">>> Configurando la carpeta de Wallpapers y pre montando Waypaper conf"
    setWallpaperFolder
    echo -e ">>> Instalando AUR dependencias"
    installAurDependencies
    echo -e ">>> Creando carpeta de Wallpaper"
    installAurDependencies
    echo -e ">>> Copiando configuracion de hyprland"
    copyHyprConf
    echo -e ">>> Copiando configuracion de waybar"
    copyWaybarConf
    if [ "$CUSTOM_ROFI" == true ]; then
        echo -e ">>> Instalando tema de rofi"
        setRofiTheme
        echo -e ">>> Copiando configuracion de rofi"
        copyRofiConf
    fi
    echo -e ">>> Instalando Navegador"
    installAurDependencies

    if [ "$CUSTOM_ZSH" == true ]; then
        echo ">>> Instalando y configurando NeoVim"
        setNeoVim
    fi
}

function setTypeInstall {
    echo "> Instalación por defecto o custom:"
    echo "    1) Por Defecto"
    echo "    2) Custom"

    while true; do
        read -p "Introduce el número correspondiente (1 o 2, por defecto 1): " TYPE_INSTALL_CHOICE

        case $TYPE_INSTALL_CHOICE in
            1|"")
                installer
                break
                ;;
            2)
                setCustomInstallation
                installer
                break
                ;;
            *)
                echo "Selección no válida. Por favor, introduce 1 o 2."
                ;;
        esac
    done
}



presentation
setTypeInstall
