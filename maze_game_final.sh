#!/bin/bash

level_1=(
  "00000000000000000000000000000"
  "01111111111111111111111312220"
  "01111111111111111111111312220"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "01111111110000000000000000000"
  "00000000000000000000000000000")

level_2=(
  "00000000000000000000000000000"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "00000000000000000000000001110"
  "00000000000000000000000001110"
  "00000000000000000000000001110"
  "00000000000000000000000001110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01110000000000000000000000000"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "00000000000000000000000011110"
  "00000000000000000000000011110"
  "00000000000000000000000011110"
  "00000000000000000000000011110"
  "02221311111111111111111111110"
  "00000000000000000000000000000")

level_3=(
  "00000000000000000000000000000"
  "00000000000000022200000000000"
  "00000000000000022200000000000"
  "00000000000000022200000000000"
  "00000000000000022200000000000"
  "00000000000000001000000000000"
  "00000000000000004000000000000"
  "00000000000000111000000000000"
  "00000000000000100000000000000"
  "00000000000000100000000000000"
  "00000000000000111000000000000"
  "00000000000000001000000000000"
  "00000000000000001000000000000"
  "00000000000000001000000000000"
  "00000000000000001000000000000"
  "01111111111111111000000000000"
  "01111111111111100000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01100000000000000000000000000"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "00000000000000000000000000110"
  "00000000000000000000000000110"
  "01111111111111111111111111110"
  "01111111111111111111111111110"
  "00000000000000000000000000000")

# ANSI escape codes
TURQUOISE_BG='\e[46m'
BLACK_BG='\e[40m'
RED_BG='\e[41m'
PLAYER_BG='\e[44m'
GREEN_BG='\e[42m'
GREEN_TEXT='\e[32m'
BLACK_TEXT='\e[30m'
WHITE_TEXT='\e[97m'
WHITE_BG='\e[47m'
RESET='\e[0m'
HIDE_CURSOR='\e[?25l'

# Check if VLC is installed
if command -v vlc &> /dev/null; then
  VLC_INSTALLED=true
else
  VLC_INSTALLED=false
fi



# Levels array
levels=(level_1 level_2 level_3)
current_level=0

# Player positions for each level
level_positions=(
  "29 5"
  "2 26"
  "29 1"
)

# Player direction
direction="A"

# Initial player directions for each level
level_directions=(
  "A"  # Player starts moving Up in level 1
  "D"  # Player starts moving Left in level 2
  "C"  # Player starts moving Right in level 3
)

# Player movement speeds for each level (in seconds)
level_speeds=(
  0.16 # seconds in level 1
  0.14 # seconds in level 2
  0.10 # seconds in level 3
)

echo -e "${HIDE_CURSOR}"

# Load the current level
load_level() {
  local level_name=${levels[$current_level]}
  eval "maze=(\"\${$level_name[@]}\")"

  ROWS=${#maze[@]}
  COLS=${#maze[0]}

  # Set player position
  player_position=(${level_positions[$current_level]})
  player_x=${player_position[0]}
  player_y=${player_position[1]}

  # Set player direction
  direction=${level_directions[$current_level]}

  # Set player movement delay
  movement_delay=${level_speeds[$current_level]}
}

# Move the cursor to a specific position
move_cursor() {
  echo -ne "\e[${1};${2}H"
}

draw_maze() {
  clear
  for ((i = 0; i < ROWS; i++)); do
    for ((j = 0; j < COLS; j++)); do
      case "${maze[i]:j:1}" in
        1|3|4) echo -ne "${TURQUOISE_BG}  ${RESET}" ;;
        2) echo -ne "${RED_BG}  ${RESET}" ;;
        *) echo -ne "${BLACK_BG}  ${RESET}" ;;
      esac
    done
    echo
  done
  if [[ $DEV_MODE == true ]]; then
    echo -e "${RED_BG}${WHITE_TEXT} Level: $((current_level + 1))${RESET} ${GREEN_TEXT}DEV MODE${RESET}"
  else
    echo -e "${RED_BG}${WHITE_TEXT} Level: $((current_level + 1))${RESET}"
  fi
  
  move_cursor $((ROWS + 1)) 1
}

draw_error_screen() {

  clear

  # Error message
  error_message="Ouch!"

  # Calculate offsets for centering the error message within the grid (ROWS and COLS)
  vertical_offset=$(( (ROWS - 1) / 2 ))  # Center vertically in the grid
  horizontal_offset=$(( (COLS * 2 - ${#error_message}) / 2 ))  # Center horizontally in the grid (each cell is 2 chars wide)

  # Ensure offsets are non-negative
  vertical_offset=$(( vertical_offset < 0 ? 0 : vertical_offset ))
  horizontal_offset=$(( horizontal_offset < 0 ? 0 : horizontal_offset ))

  # Draw a colored border around the game area based on ROWS and COLS
  for ((i = 0; i < ROWS; i++)); do
    for ((j = 0; j < COLS; j++)); do
      if ((i == 0 || i == ROWS - 1 || j == 0 || j == COLS - 1)); then
        echo -ne "${RED_BG}  ${RESET}"
      else
        echo -ne "  "
      fi
    done
    echo
  done

  # Display the error message centered within the game area
  move_cursor $((vertical_offset + 1)) $((horizontal_offset))
  echo -e "${WHITE_TEXT}${RED_BG}  $error_message  ${RESET}"

  # Wait for a brief moment before continuing
  sleep 1
}


# Reset the game to level 1
reset_game() {
  current_level=0
  block_input
  load_level
  draw_maze
}


# Handle player movement
move_player() {
  local next_x=$player_x
  local next_y=$player_y

  # Calculate next position based on direction
  case "$direction" in
    A) ((next_x--)) ;; # Up
    B) ((next_x++)) ;; # Down
    C) ((next_y++)) ;; # Right
    D) ((next_y--)) ;; # Left
  esac

  # Check boundaries and move if valid
  if [[ $next_x -ge 0 && $next_x -lt $ROWS && $next_y -ge 0 && $next_y -lt $COLS ]]; then
    local target=${maze[next_x]:next_y:1}
    if [[ $target == "1" || $target == "2" || $target == "3" || $target == "4" ]]; then
      player_x=$next_x
      player_y=$next_y
    elif [[ $target == "0" ]]; then
      if [[ $DEV_MODE != true ]]; then
        play_failure_sound
        block_input
        draw_error_screen
        reset_game
      fi
    fi

    if [[ $target == "4" ]]; then
      play_final_video
    fi

    if [[ $target == "3" ]]; then
      play_next_level_sound
    fi

    # Check if the player reaches the red section (level transition zone)
    if [[ $target == "2" ]]; then
      ((current_level++))
      if [[ $current_level -lt ${#levels[@]} ]]; then
        block_input
        load_level
        draw_maze
      else
        sleep 2
        reset_game
        main_menu
      fi
    fi
  fi
}

# Function to play failure sound
play_failure_sound() {
  if [[ $VLC_INSTALLED == true ]]; then
    vlc --intf dummy --no-video --quiet assets/failure.mp3 vlc://quit &
  fi
}

# Function to play final video
play_final_video() {
  if [[ $VLC_INSTALLED == true ]]; then
    vlc --intf dummy --fullscreen --no-video-title-show --mouse-hide-timeout=5 --quiet "assets/final.mp4" vlc://quit &
  fi
}

# Function to play next level sound
play_next_level_sound() {
  if [[ $VLC_INSTALLED == true ]]; then
    vlc --intf dummy --no-video --quiet assets/next-level.mp3 vlc://quit &
  fi
}

update_player_position() {
  # Erase the previous position
  move_cursor $((prev_x + 1)) $((prev_y * 2 + 1))
  case "${maze[prev_x]:prev_y:1}" in
    1|3|4) echo -ne "${TURQUOISE_BG}  ${RESET}" ;;
    2) echo -ne "${RED_BG}  ${RESET}" ;;
    *) echo -ne "${BLACK_BG}  ${RESET}" ;;
  esac

  # Draw the player at the new position
  move_cursor $((player_x + 1)) $((player_y * 2 + 1))
  echo -ne "${PLAYER_BG}  ${RESET}"

  # Update cursor position for smoother input
  move_cursor $((ROWS + 1)) 1
}


display_main_menu() {
  clear
  echo -e "${GREEN_BG}${BLACK_TEXT} Welcome to the Maze Game! ${RESET}"
  echo
  echo "Use the arrow keys to navigate the menu and press Enter to select."
  echo
  echo "Controls:"
  echo "  - Use the arrow keys to move the player."
  echo "  - Press m at anytime to return to the main menu."
  echo "  - Press q to quit the game."
  echo
  echo "Rules:"
  echo "  - Reach the red zone to move to the next level."
  echo "  - Avoid touching the black zones or the game will reset."
  echo "  - You can only change directions."
  echo "  - If you hold any key pressed, the game will halt."
  echo
  echo "Modes:"
  echo "  - DEV Mode: The game will continue if you hit the boundaries."
  echo "  - Normal Mode: The game will reset if the player hits the boundaries."
  echo
  echo "Select a mode to start the game:"
  echo
}


main_menu() {
  local selected=0
  while true; do
    display_main_menu
    case $selected in
      0)
        echo -e "  > ${GREEN_BG}${BLACK_TEXT}DEV Mode${RESET}"
        echo "    Normal Mode"
        ;;
      1)
        echo "    DEV Mode"
        echo -e "  > ${GREEN_BG}${BLACK_TEXT}Normal Mode${RESET}"
        ;;
    esac

    read -sn 1 key
    if [[ $key == $'\e' ]]; then
      read -sn 2 -t 0.1 key
      case "${key:1:1}" in
        A) ((selected--))
           if [[ $selected -lt 0 ]]; then selected=1; fi ;;
        B) ((selected++))
           if [[ $selected -gt 1 ]]; then selected=0; fi ;;
      esac
    elif [[ $key == "q" || $key == "Q" ]]; then
      clear
      exit
    elif [[ $key == "" ]]; then
      break
    fi
  done

  if [[ $selected -eq 0 ]]; then
    DEV_MODE=true
  else
    DEV_MODE=false
  fi

  load_level
  draw_maze
}




MAX_CONSECUTIVE_INPUTS=2  # Maximum allowed rapid direction changes
COUNTER_RESET_TIME=1      # Time (in seconds) to reset the counter after inactivity

input_counter=0           # Counter to track consecutive inputs
last_input_time=$SECONDS  # Timer to track the last input time

# Function to block the user input
block_input() {
  while read -sn 1 -t 0.1; do :; done
  input_counter=0
}

main_menu
prev_x=$player_x
prev_y=$player_y

# Main game loop
while true; do

  update_player_position
  prev_x=$player_x
  prev_y=$player_y
  move_player

  # Reset counter if the timer exceeds the reset threshold
  if (( SECONDS - last_input_time >= COUNTER_RESET_TIME )); then
    input_counter=0
  fi

  # Block input if the limit is exceeded
  if (( input_counter >= MAX_CONSECUTIVE_INPUTS )); then
    block_input
  fi

  # Handle user input
  if read -sn 1 -t "$movement_delay" key; then
    if [[ $key == $'\e' ]]; then
      read -sn 2 -t 0.05 key
      case "${key:1:1}" in
        A) direction="A" ;; # Up
        B) direction="B" ;; # Down
        C) direction="C" ;; # Right
        D) direction="D" ;; # Left
      esac
      # Increment the input counter on every key press
      ((input_counter++))
      last_input_time=$SECONDS

    elif [[ $key == "m" || $key == "M" ]]; then
      echo -e "${RED_BG}${WHITE_TEXT} Are you sure you want to return to the main menu? (y/n) ${RESET}"
      read -sn 1 confirm
      if [[ $confirm == "y" || $confirm == "Y" ]]; then
        main_menu
      else
        draw_maze
      fi
    elif [[ $key == "q" || $key == "Q" ]]; then
      clear
      exit
    else
      block_input
    fi
  fi
done