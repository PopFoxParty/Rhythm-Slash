% Fix the jpg corruption in the title
% Add combos, health



% Sets up all the initial parameters for the game.
View.Set ("graphics:1280;720, position:centre;middle, title: Rhythm Slash, nobuttonbar")

% Include the custom classes
include "objects/cSprite.t"
include "objects/Character.t"
include "objects/Note.t"
include "objects/Hitmarker.t"

% Sets initial variables for music componenets.
var iStartTime, iCurrentTime, iStartDelay : int
iStartDelay := -50 %520 when using with speakers, -150 with bluetooth JAM (make it negative to have music run earlier)

% Initializes variables for notes.
var iNoteSpawnMS, iBlueCount, iRedCount, iBufferTime, iTimingWindowOkay, iTimingWindowGreat, iTimingWindowPerfect, iMisses, iOkays, iGreats, iPerfects, iHealth: int
var rMultiplier : real
iBufferTime := 500
iTimingWindowOkay := 135
iTimingWindowGreat := 90
iTimingWindowPerfect := 45

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

% Create the initial pictures and sprites.
var pTitle, spTitle, pHitMarker, spHitMarker : int

% Where to start creating notes (usually max screen size, set to 1280 for consistency when resizing)
var iNoteStartX : int := 1280

% Creates images for the character and notes.

var sTitle, pCharIdle, pCharBlue, pCharRed, pNoteBlue, pNoteRed, pHitIdle, pHitBlue, pHitRed, sExplosionPerfect, sExplosionGreat, sExplosionOkay, sExplosionMiss, sBackground : string

sTitle := "images/logo.bmp"
pCharIdle := "images/idle.bmp"
pCharBlue := "images/attackblue.bmp"
pCharRed := "images/attackred.bmp"
pNoteBlue := "images/blue.bmp"
pNoteRed := "images/red.bmp"
pHitIdle := "images/hitmark.bmp"
pHitBlue := "images/hitmarkblue.bmp"
pHitRed := "images/hitmarkred.bmp"
sExplosionPerfect := "images/explosionperfect.bmp"
sExplosionGreat := "images/explosiongreat.bmp"
sExplosionOkay := "images/explosionokay.bmp"
sExplosionMiss := "images/explosionmiss.bmp"
sBackground := "images/cyberpunk.jpg"

var obSwordsman : CharClass

ConstructChar (obSwordsman, pCharIdle, pCharBlue, pCharRed, 300)

var pBackground : int

% ----------Menu screen----------
% Draws background
drawfillbox (0, 0, maxx, maxy, purple)

% Draws logo
pTitle := Pic.FileNew (sTitle)

Pic.SetTransparentColour (pTitle, black)

pTitle := Pic.Scale (pTitle, 400, 400)

spTitle := Sprite.New (pTitle)
Sprite.SetHeight (spTitle, 2)
Sprite.SetPosition (spTitle, 640, 400, true)
Sprite.Show (spTitle)

% Draws Hit Marker
var obHitmarker : HitClass
var iHitmarkerX, iHitmarkerY, iNoteScale : int
iNoteScale := 100
iHitmarkerX := 500
iHitmarkerY := 150

ConstructHit(obHitmarker, pHitIdle, pHitBlue, pHitRed, iHitmarkerX, iHitmarkerY, iNoteScale)

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

pExplosionP := Pic.Scale (pExplosionP, iNoteScale + 40, iNoteScale + 40)
pExplosionG := Pic.Scale (pExplosionG, iNoteScale + 40, iNoteScale + 40)
pExplosionO := Pic.Scale (pExplosionO, iNoteScale + 40, iNoteScale + 40)
pExplosionM := Pic.Scale (pExplosionM, iNoteScale + 40, iNoteScale + 40)

spExplosion := Sprite.New (pExplosionP)

Sprite.SetHeight (spExplosion, 4)
Sprite.SetPosition (spExplosion, iHitmarkerX, iHitmarkerY, true)
Sprite.Hide (spExplosion)

% Create explosion effect
procedure Explosion (inX, inY, iTimingWin : int, var iPrevTime : int)
    Sprite.SetPosition (spExplosion, inX, inY, true)
	if iPrevTime = 0 then
		Sprite.Show (spExplosion)
	end if
	if iPrevTime not= iTimingWin then
		case iTimingWin of
			label 1 : Sprite.ChangePic (spExplosion, pExplosionP)
			label 2 : Sprite.ChangePic (spExplosion, pExplosionG)
			label 3 : Sprite.ChangePic (spExplosion, pExplosionO)
			label 4 : Sprite.ChangePic (spExplosion, pExplosionM)
		end case
		iPrevTime := iTimingWin
	end if
end Explosion

% Creates notes when they are needed
procedure CreateNotes (aColourNotes : array 1 .. * of int, var aColourQ : array 1 .. * of NoteClass, var iCounter : int, iColourSelect : int)
    if iCounter < upper(aColourNotes) then
	if aColourNotes(iCounter + 1) <= iCurrentTime + iNoteSpawnMS + iBufferTime then
	    iCounter += 1
	    if iColourSelect = 1 then
            ConstructNote (aColourQ(iCounter), pNoteBlue, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
            aColourQ(iCounter) -> Show
	    elsif iColourSelect = 2 then
            ConstructNote (aColourQ(iCounter), pNoteRed, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
            aColourQ(iCounter) -> Show
	    end if
	end if
    end if
end CreateNotes

% Moves notes
procedure MoveNotes (var aColourQ : array 1 .. * of NoteClass, iCurrentTime, iCounter : int, var iLowestNote : int)
    if iCounter > 0 then
		for noteNum : iLowestNote .. iCounter % Later change lowest value to last destroyed note + 1 (aka the oldest living note)
			aColourQ(noteNum) -> Move (iCurrentTime)
		end for
    end if
end MoveNotes

% Removes notes once they go too far off the screen
procedure RemoveNotes (var aColourQ : array 1 .. * of NoteClass, aTimings : array 1 .. * of int, iCurrentTime : int, var iLowestNote : int, iCounter, iTimingWindow : int, var iCombo : int)
    if iLowestNote <= iCounter then  % Check if array object has been initialized yet
		if iCurrentTime - iTimingWindow - 10 > aTimings(iLowestNote) then
			DestructNote(aColourQ(iLowestNote))
			iLowestNote += 1
			iCombo := 0
			iMisses += 1
			if bExplosionShown then
				Sprite.Hide (spExplosion)
				bExplosionShown := false
			end if
		end if
    end if
end RemoveNotes


procedure GetMultiplier (var rMultiplier : real, iCombo : int)
	rMultiplier := 1 + intreal(iCombo) / 100
end GetMultiplier

% Variable to check which note is hit
var iHitBlue, iHitRed : int := 1

procedure HitNotes (aTimings : array 1 .. * of int, var aColourQ : array 1 .. * of NoteClass, iCurrentTime : int, var iHitNote : int, var rScore : real, var iCombo : int, var rMultiplier : real, var iOkays, iGreats, iPerfects : int)
    if iHitNote <= upper(aTimings) then
		if aTimings(iHitNote) < iCurrentTime + iTimingWindowOkay and aTimings(iHitNote) > iCurrentTime - iTimingWindowOkay then
			GetMultiplier (rMultiplier, iCombo)
			if aTimings(iHitNote) < iCurrentTime + iTimingWindowGreat and aTimings(iHitNote) > iCurrentTime - iTimingWindowGreat then
				if aTimings(iHitNote) < iCurrentTime + iTimingWindowPerfect and aTimings(iHitNote) > iCurrentTime - iTimingWindowPerfect then
					rScore += 100 * rMultiplier
					iPerfects += 1
					Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 1, iPrevEx)
				else
					rScore += 75 * rMultiplier
					iGreats += 1
					Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 2, iPrevEx)
				end if
			else
				rScore += 50 * rMultiplier
				iOkays += 1
				Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 3, iPrevEx)
			end if
			DestructNote(aColourQ(iHitNote))
			iHitNote += 1
			iCombo += 1
		else 
			iMisses += 1
			iCombo := 0
			Explosion (iHitmarkerX, iHitmarkerY, 4, iPrevEx)
		end if
	if not bExplosionShown then
		Sprite.Show (spExplosion)
		bExplosionShown := true
	end if
    else
	put "no more notes!"
    end if
	locatexy (1100, 60)
	put "multiplier: ", rMultiplier
	locatexy (1100, 40)
	put "score: ", rScore
	locatexy (1100, 20)
	put "combo: ", iCombo
end HitNotes


% Plays menu music
Music.PlayFileReturn ("music/Halcyon.mp3")

% Places text
colour(white)
colourback(black)
locate (30, 40)
put "Press space to play"

var rScore : real
var iCombo : int

% ----------Start of main game----------



loop
% Checks for start

% Sets HP to 100
iHealth := 100


% Makes previous explosion 0
iPrevEx := 0


% ----------Sets score, combo, and notes to 0---------
iMisses := 0
iOkays := 0
iGreats := 0
iPerfects := 0
rScore := 0
iCombo := 0
rMultiplier := 1

% ----------Gets file for songs----------

iBlueCount := 0
iRedCount := 0

% Sets variables for reading files
var sFile : string := "maps/crystallizedhard.txt"
var iFileNum, iNoteColour, iNoteMS, iEndTime : int
var aBlueNotes : flexible array 1 .. 0 of int
var aRedNotes : flexible array 1 .. 0 of int
var sSongFile : string


var iLastBlue, iLastRed : int := 1

open : iFileNum, sFile, get

% Gets song name and note speed from file
get : iFileNum, sSongFile, iNoteSpawnMS

% Gets all the notes in the file.
loop
    exit when eof (iFileNum)
    get : iFileNum, iNoteColour, iNoteMS
    if iNoteColour = 1 then
        new aBlueNotes, upper(aBlueNotes) + 1
        aBlueNotes(upper(aBlueNotes)) := iNoteMS
    elsif iNoteColour = 2 then
        new aRedNotes, upper(aRedNotes) + 1
        aRedNotes(upper(aRedNotes)) := iNoteMS
    end if
    iEndTime := iNoteMS
end loop

% Creates queue of blue and red notes
var aBlueQ : flexible array 1 .. upper(aBlueNotes) of NoteClass
var aRedQ : flexible array 1 .. upper(aRedNotes) of NoteClass


% ----------Checks for game start-----------
loop
    % Checks if space key has been pressed to start the game
    Input.KeyDown (aKeysDown)
    exit when aKeysDown (' ')
end loop


%stops music
Music.PlayFileStop

% Adds background
pBackground := Pic.FileNew (sBackground)
pBackground := Pic.Scale (pBackground, 1280, 720)
Pic.Draw (pBackground, 0, 0, picCopy)


% Hides menu sprite
Sprite.Hide (spTitle)

% Hides the explosion 
Sprite.Hide (spExplosion)
bExplosionShown := false

% Shows hit marker sprite and explosion
obHitmarker -> Show
obHitmarker -> SetColour (0)

% Show the character
obSwordsman -> Show
obSwordsman -> SetColour (0)

% Starts the music
Music.PlayFileReturn ("music/"+sSongFile)

% Delay so that the music has time to start up and it doesn't just go silent
delay (1)

% Stores the time that the song starts at
iStartTime := Time.Elapsed

    % Core loop of spawning notes
loop
    % Store the current time through the song
    iCurrentTime := Time.Elapsed - iStartTime + iStartDelay

    if upper(aBlueNotes) > 0 then % Check if there are any notes in queue
        CreateNotes (aBlueNotes, aBlueQ, iBlueCount, 1)
        MoveNotes (aBlueQ, iCurrentTime, iBlueCount, iLastBlue)
        RemoveNotes (aBlueQ, aBlueNotes, iCurrentTime, iLastBlue, iBlueCount, iTimingWindowOkay, iCombo)
    end if
    
    if upper(aRedNotes) > 0 then % Check if there are any notes in queue
        CreateNotes (aRedNotes, aRedQ, iRedCount, 2)
        MoveNotes (aRedQ, iCurrentTime, iRedCount, iLastRed)
        RemoveNotes (aRedQ, aRedNotes, iCurrentTime, iLastRed, iRedCount, iTimingWindowOkay, iCombo)
    end if
    % Get key input
    Input.KeyDown (aKeysDown)
    
    % Prev state is how many keys were being pressed

    % Gets the colour 
    iPrevColour := obSwordsman -> GetColour
    iNewColour := 0
    if (aKeysDown (cBlueKey1) or aKeysDown (cBlueKey2)) and (aKeysDown (cRedKey1) or aKeysDown (cRedKey2)) then    % Checks if both keys are being pressed
	if iPrevState = 2 then          % Checks if 2 keys were being pressed before
	    iNewColour := iPrevColour
	elsif iPrevColour = 1 then      % If not, if the previous colour was blue, then change it to red because red is more recent
	    if upper(aRedNotes) > 0 then
		    HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, rScore, iCombo, rMultiplier, iOkays, iGreats, iPerfects)
	    end if
	    iNewColour := 2
	else                            % If the previous colour was red, change the colour to blue, and if both are pressed at the same time, default to blue
	    if upper(aBlueNotes) > 0 then
		    HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, rScore, iCombo, rMultiplier, iOkays, iGreats, iPerfects)
	    end if
	    iNewColour := 1
	end if
	% Store that both the keys are being pressed down
	iPrevState := 2
    elsif aKeysDown (cBlueKey1) or aKeysDown (cBlueKey2) then     % Checks if the blue key is being pressed
	if iPrevColour = 0 then         % Checks if blue has been let go or not
	    if upper(aBlueNotes) > 0 then
		    HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, rScore, iCombo, rMultiplier, iOkays, iGreats, iPerfects)
	    end if
	end if
	iPrevState := 1
	iNewColour := 1
    elsif aKeysDown (cRedKey1) or aKeysDown (cRedKey2) then      % Checks if the red key is being pressed
	if iPrevColour = 0 then         % Checks if red has been let go or not
	    if upper(aRedNotes) > 0 then
		    HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, rScore, iCombo, rMultiplier, iOkays, iGreats, iPerfects)
	    end if
	end if
	iPrevState := 1
	iNewColour := 2
    else                                % If other keys or no keys are pressed set it to the idle animation
	iPrevState := 0
    end if

    if iNewColour not= iPrevColour then % Checks if sprite is different as last frame, if so, change the sprite, if not, don't change it
        obSwordsman -> SetColour (iNewColour)
        obHitmarker -> SetColour (iNewColour)
    end if

    exit when iCurrentTime > iEndTime + 5000
end loop

for i : iLastBlue .. iBlueCount
	DestructNote(aBlueQ(i))
end for

for i : iLastRed .. iRedCount
	DestructNote(aRedQ(i))
end for

put "ended!"
put "final score ", rScore
put "final combo: ", iCombo
put "total misses: ", iMisses
put "total goods: ", iOkays
put "total greats: ", iGreats
put "total perfects: ", iPerfects
end loop