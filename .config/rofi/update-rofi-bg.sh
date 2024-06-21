#!/bin/bash

# Ruta al archivo de configuración de Waypaper
WAYPAPER_CONFIG=~/.config/waypaper/config.ini

# Ruta al archivo de estilo de Rofi
ROFI_STYLE=~/.config/rofi/launchers/type-7/style-2-musagy.rasi

# Extraer el valor de 'wallpaper' del archivo de configuración de Waypaper
WALLPAPER=$(grep -E '^wallpaper\s*=' $WAYPAPER_CONFIG | cut -d'=' -f2 | tr -d ' ')

# Escapar la ruta del wallpaper para uso en sed
ESCAPED_WALLPAPER=$(echo $WALLPAPER | sed 's/[\/&]/\\&/g')

# Actualizar el archivo de estilo de Rofi con la nueva imagen de fondo
sed -i "s|background-image: url(\".*\", width);|background-image: url(\"$ESCAPED_WALLPAPER\", width);|" $ROFI_STYLE