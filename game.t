/* +-------------------------------------------------------------------------+
   |         This program will run a game named "Rhythm Slash" in Turing.    |
   |         It will display graphics and music. This includes menus, the    |
   |         core gameplay, and end screens. It takes in keyboard presses as |
   |         input. It uses the keys D, F, J, K, Enter, Space, Backspace,    |
   |         and Escape.                                                     |
   |         This game uses many different kinds of objects. The note object |
   |         being the main object used. When this object is created, it     |
   |         spawns in a sprite that moves across the screen from the right. |
   |         It uses the current time to find the X position of the sprite,  |
   |         using linear equations. It can also be deleted when it goes off |
   |         the screen or the player hits the note. The character sprite    |
   |         moves the character depending on what button is pressed, as     |
   |         well as shifting the character to the right when a button is    |
   |         pressed to account for the images having the character closer   |
   |         to the left when he is swinging. Most of my code is split up.   |
   |         The file "initialization.t" initializes most of the variables   |
   |         and functions needed for later code. The file                   |
   |         "note_procedures.t" creates procedures for the notes, and       |
   |         "menus.t" houses all the menus and screen used in the game.     |
   +-------------------------------------------------------------------------+
   | Author - Jonathan Yang                                                  |
   | Date   - June 13 2022                                                   |
   +-------------------------------------------------------------------------+
   | Input  - The keys D, F, J, K, Enter, Space, Backspace, and Escape.      |
   | Output - Text, images, sprites, and music.                              |
   +-------------------------------------------------------------------------+ */

View.Set ("graphics:1280;720, position:centre;middle, title: Rhythm Slash, nobuttonbar")
View.Set ("nooffscreenonly")

% Include the custom classes
include "objects/cSprite.t"
include "objects/Character.t"
include "objects/Note.t"
include "objects/Hitmarker.t"
include "turing/initialization.t"
include "turing/note_procedures.t"
include "turing/menus.t"

% Check which menu the player is on
var iMenuOption : int := 0

% Variable to store key pressed.
var cKey : char

loop
	% Prevent flashing
	View.Set ("offscreenonly")
	case iMenuOption of
		label 0 :
			% Title screen
			iMenuOption := TitleMenu (cKey)
		label 1 :
			% Settings screen
			View.Set ("nooffscreenonly")
			iMenuOption := Settings (cKey, iStartDelay)
		label 2 :
			% Tutorial screen
			iMenuOption := HowTo (cKey)
		label 3 :
			% Map selection screen
			iMenuOption := MapSelect (cKey, aMapList, sMapChosen)
		label 4 :
			% Player selection screen. 1 player or 2 players
			iMenuOption := PlayerSelect (cKey, iMultiplayer)
		label 5 :
			% Remove offscreenonly to reduce lag
			View.Set ("nooffscreenonly")
			% ----------Start of main game----------
			iMenuOption := MainGame
		label 6 :
			% Death screen if your HP goes to 0
			iMenuOption := DeathScreen (cKey)
		label 7 :
			% Pass screen if you complete the song
			iMenuOption := PassScreen (cKey)
		label 8 :
			% Screen to swap from player 1 to player 2
			iMenuOption := Player2Turn (cKey)
		label 9 :
			% End screen for multiplayer
			iMenuOption := MultiplayerEnd (cKey)
		label :
	end case
end loop
