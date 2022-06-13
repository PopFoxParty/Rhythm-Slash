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
			iMenuOption := DeathScreen (cKey)
		label 7 :
			iMenuOption := PassScreen (cKey)
		label 8 :
			iMenuOption := Player2Turn (cKey)
		label 9 :
			iMenuOption := MultiplayerEnd (cKey)
		label :
			quit
	end case
end loop