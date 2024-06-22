#!/bin/bash

# Número máximo de espacios de trabajo
MAX_WORKSPACES=6

# Obtener el espacio de trabajo actual
CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id' )

if [ "$1" == "next" ]; then
  # Mover al siguiente espacio de trabajo
  NEXT_WS=$((CURRENT_WS + 1))
  if [ $NEXT_WS -gt $MAX_WORKSPACES ]; then
    NEXT_WS=1
  fi
  hyprctl dispatch movetoworkspace $NEXT_WS
elif [ "$1" == "prev" ]; then
  # Mover al espacio de trabajo anterior
  PREV_WS=$((CURRENT_WS - 1))
  if [ $PREV_WS -lt 1 ]; then
    PREV_WS=$MAX_WORKSPACES
  fi
  hyprctl dispatch movetoworkspace $PREV_WS
fi
