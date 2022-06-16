% Sets up all the initial parameters for the game.

% Creates procedure to draw button sprites
procedure DrawButton (sImage : string, var spSprite, pImage, pImageLarge, iX, iY : int, iSmall, iLarge : int)

	pImageLarge := Pic.FileNew (sImage)
	Pic.SetTransparentColour (pImageLarge, black)

	pImage := Pic.Scale (pImageLarge, iSmall, iSmall)
	pImageLarge := Pic.Scale (pImageLarge, iLarge, iLarge)

	spSprite := Sprite.New (pImageLarge)
	Sprite.SetHeight (spSprite, 2)
	Sprite.SetPosition (spSprite, iX, iY, true)
	Sprite.Hide (spSprite)
end DrawButton



% Sets initial variables for music componenets and delay.
var iStartTime, iCurrentTime, iStartDelay : int
iStartDelay := -50 %520 when using with speakers, -150 with bluetooth JAM (make it negative to have music run earlier)

% Initializes variables for gameplay.
var iNoteSpawnMS, iBlueCount, iRedCount, iBufferTime, iTimingWindowOkay, iTimingWindowGreat, iTimingWindowPerfect, iMisses, iOkays, iGreats, iPerfects, iHealth, iCombo: int
var rMultiplier,rScore : real

iBufferTime := 500
iTimingWindowOkay := 135
iTimingWindowGreat := 90
iTimingWindowPerfect := 45

% Sets font for game
var font, fontLarge, fontVeryLarge : int
font := Font.New ("ebrima:14:bold")
fontLarge := Font.New ("ebrima:30:bold")
fontVeryLarge := Font.New ("ebrima:48:bold")


% Checks current colour and new colour of sprite
var iPrevColour, iNewColour, iPrevState : int := 0

% Sets up the array of characters to check for key presses.
var aKeysDown : array char of boolean

% Sets up initial keybinds
var cBlueKey1, cBlueKey2, cRedKey1, cRedKey2 : char

cBlueKey1 := 'd'
cBlueKey2 := 'k'

cRedKey1 := 'f'
cRedKey2 := 'j'



% Where to start creating notes (usually max screen size, set to 1280 for consistency when resizing)
var iNoteStartX : int := 1280

% Creates images for the character and notes.
var sTitle, sTitleBack, sSettings, sInfo, sHowTo, sMapSelect, sPlayerSelect, pCharIdle, pCharBlue, pCharRed, pNoteBlue, pNoteRed, pHitIdle, pHitBlue, pHitRed, sExplosionPerfect, sExplosionGreat, sExplosionOkay, sExplosionMiss, sBackground, sProgressBar, sHealthBar, sHealthBarBack, sScore, sDeath, sPass, sPlayer2Turn, sMultiplayer : string

sTitle := "images/menu/logo.bmp"
sTitleBack := "images/menu/title.jpg"
sSettings := "images/menu/settings.bmp"
sInfo := "images/menu/info.bmp"
sHowTo := "images/howto/howto.jpg"
sMapSelect := "images/songselect/songselect.jpg"
sPlayerSelect := "images/playerselect/playerselect.jpg"
pCharIdle := "images/idle.bmp"
pCharBlue := "images/attackblue.bmp"
pCharRed := "images/attackred.bmp"
pNoteBlue := "images/blue.bmp"
pNoteRed := "images/red.bmp"
pHitIdle := "images/hitmark/hitmark.bmp"
pHitBlue := "images/hitmark/hitmarkblue.bmp"
pHitRed := "images/hitmark/hitmarkred.bmp"
sExplosionPerfect := "images/explosionperfect.bmp"
sExplosionGreat := "images/explosiongreat.bmp"
sExplosionOkay := "images/explosionokay.bmp"
sExplosionMiss := "images/explosionmiss.bmp"
sBackground := "images/cyberpunk.jpg"
sProgressBar := "images/progressbar.bmp"
sHealthBar := "images/healthbar.bmp"
sHealthBarBack := "images/healthbarback.bmp"
sScore := "images/score.jpg"
sDeath := "images/death.jpg"
sPass := "images/pass.jpg"
sPlayer2Turn := "images/player2turn.jpg"
sMultiplayer := "images/multiplayer.jpg"

% Create the initial pictures and sprites.
var pTitle, spTitle, pTitleBack, pTitleLarge, spSettings, pSettings, pSettingsLarge, spInfo, pInfo, pInfoLarge, pMapSelect, pPlayerSelect, pHitMarker, spHitMarker, pHowTo, pProgressBar, spProgressBar, pHealthBar, pHealthBarBack, spHealthBar, pScore, pDeath, pPass, pPlayer2Turn, pMultiplayer : int

% Creates the swordsman object for the main game.
var obSwordsman : CharClass

ConstructChar (obSwordsman, pCharIdle, pCharBlue, pCharRed, 300)

var pBackground : int

% ----------Images----------

% Draws logo
pTitleLarge := Pic.FileNew (sTitle)
Pic.SetTransparentColour (pTitleLarge, black)

pTitle := Pic.Scale (pTitleLarge, 400, 400)

spTitle := Sprite.New (pTitleLarge)
Sprite.SetHeight (spTitle, 2)
Sprite.SetPosition (spTitle, 640, 400, true)
Sprite.Hide (spTitle)

% Sets settings button position
var iSettingsX, iSettingsY : int
iSettingsX := 1030
iSettingsY := 100

% Draws settings button
DrawButton (sSettings, spSettings, pSettings, pSettingsLarge, iSettingsX, iSettingsY, 100, 150)

% Sets info button position
var iInfoX, iInfoY : int
iInfoX := 1180
iInfoY := 100

DrawButton (sInfo, spInfo, pInfo, pInfoLarge, iInfoX, iInfoY, 100, 150)

% Draws Hit Marker
var obHitmarker : HitClass
var iHitmarkerX, iHitmarkerY, iNoteScale : int
iNoteScale := 100
iHitmarkerX := 500
iHitmarkerY := 150

ConstructHit(obHitmarker, pHitIdle, pHitBlue, pHitRed, iHitmarkerX, iHitmarkerY, 120)

% Draws progress bar
pProgressBar := Pic.FileNew (sProgressBar)


Pic.SetTransparentColour (pProgressBar, black)


spProgressBar := Sprite.New (pProgressBar)
Sprite.SetHeight (spProgressBar, 4)
Sprite.SetPosition (spProgressBar, -1280, 0, false)
Sprite.Hide (spProgressBar)

% Draws health bar
pHealthBar := Pic.FileNew (sHealthBar)
pHealthBarBack := Pic.FileNew (sHealthBarBack)

Pic.SetTransparentColour (pHealthBar, black)
Pic.SetTransparentColour (pHealthBarBack, black)

spHealthBar := Sprite.New (pHealthBar)
Sprite.SetHeight (spHealthBar, 4)
Sprite.SetPosition (spHealthBar, 790, 661, false)
Sprite.Hide (spHealthBar)

% Creates explosion sprite
var pExplosionP, pExplosionG, pExplosionO, pExplosionM, spExplosion, iPrevEx : int
var bExplosionShown : boolean := false

% Tracks previous explosion, checks if explosion sprite needs to be changed
pExplosionP := Pic.FileNew (sExplosionPerfect)
pExplosionG := Pic.FileNew (sExplosionGreat)
pExplosionO := Pic.FileNew (sExplosionOkay)
pExplosionM := Pic.FileNew (sExplosionMiss)

Pic.SetTransparentColour (pExplosionP, black)
Pic.SetTransparentColour (pExplosionG, black)
Pic.SetTransparentColour (pExplosionO, black)
Pic.SetTransparentColour (pExplosionM, black)

pExplosionP := Pic.Scale (pExplosionP, 160, 160)
pExplosionG := Pic.Scale (pExplosionG, 160, 160)
pExplosionO := Pic.Scale (pExplosionO, 160, 160)
pExplosionM := Pic.Scale (pExplosionM, 160, 160)

spExplosion := Sprite.New (pExplosionP)

Sprite.SetHeight (spExplosion, 4)
Sprite.SetPosition (spExplosion, iHitmarkerX, iHitmarkerY, true)
Sprite.Hide (spExplosion)

% Pictures
pTitleBack := Pic.FileNew (sTitleBack)
pBackground := Pic.FileNew (sBackground)
pHowTo := Pic.FileNew (sHowTo)
pMapSelect := Pic.FileNew (sMapSelect)
pPlayerSelect := Pic.FileNew (sPlayerSelect)
pScore := Pic.FileNew (sScore)
pDeath := Pic.FileNew (sDeath)
pPass := Pic.FileNew (sPass)
pPlayer2Turn := Pic.FileNew (sPlayer2Turn)
pMultiplayer := Pic.FileNew (sMultiplayer)

% List of maps
var iMapListFile, iMapCurrentListFile : int

% Open the file for list of maps
open : iMapListFile, "maplist.txt", get

open : iMapCurrentListFile, "maplist.txt", get

var aMapList,  aMapDifficulty, aMapNameList, aMapArtist : flexible array 1 .. 0 of string

% Temporary storage for map name
var sMapName, sMapDifficulty, sMapFile, sMapArtist, sMapSelectSong, sMapSelectSongPrev : string

% Get all map names
loop
	exit when eof (iMapListFile)
	get : iMapListFile, sMapName, sMapDifficulty, sMapFile, sMapArtist
	new aMapList, upper(aMapList) + 1
	new aMapDifficulty, upper (aMapDifficulty) + 1
	new aMapNameList, upper(aMapNameList) + 1
	new aMapArtist, upper(aMapArtist) + 1
	aMapNameList(upper(aMapList)) := sMapName
	aMapDifficulty(upper(aMapDifficulty)) := sMapDifficulty
	aMapList(upper(aMapNameList)) := sMapFile
	aMapArtist(upper(aMapArtist)) := sMapArtist
end loop

% Stores the chosen song
var sMapChosen : string

% Stores whether player is playing singleplayer or multiplayer
var iMultiplayer : int

% Stores player scores
var rPlayer1Score, rPlayer2Score : real

% Total notes in song
var iTotalNotes : int

% Stores the players score percentage
var rScorePercent : real

% Stores the player's map selection
iSelection := 1
