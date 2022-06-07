% Sets up all the initial parameters for the game.
View.Set ("graphics:1280;720, position:centre;middle, title: Rhythm Runner, nobuttonbar")

% Include the custom classes
include "objects/cSprite.t"
include "objects/Character.t"
include "objects/Note.t"
include "objects/Hitmarker.t"

% Sets initial variables for music componenets.
var iStartTime, iCurrentTime, iStartDelay : int
iStartDelay := -250 %520 when using with speakers, -250 with bluetooth JAM (make it negative to have music run earlier)

% Initializes variables for notes.
var iNextBlue, iNextRed, iNoteSpawnMS, iBlueCount, iRedCount, iBufferTime, iTimingWindow : int
iNextBlue := 0
iNextRed := 0
iBlueCount := 0
iRedCount := 0
iBufferTime := 500
iTimingWindow := 100

% Checks current colour and new colour of sprite
var iPrevColour, iNewColour, iPrevState : int := 0

% Sets up the array of characters to check for key presses.
var aKeysDown : array char of boolean

% Sets up initial keybinds
var cBlueKey, cRedKey : char

cBlueKey := 'f'
cRedKey := 'j'

% Create the initial pictures and sprites.
var pTitle, spTitle, pHitMarker, spHitMarker : int

% Create test note
var obTestNote, obTestNote2 : NoteClass
var bTestNoteCreated, bTestNote2Created : boolean := false
var iNoteStartX : int := 1280

% Creates images for the character and notes.

var sTitle, pCharIdle, pCharBlue, pCharRed, pNoteBlue, pNoteRed, sHitIdle, sHitBlue, sHitRed : string

sTitle := "images/title.bmp"
pCharIdle := "images/idle.bmp"
pCharBlue := "images/attackblue.bmp"
pCharRed := "images/attackred.bmp"
pNoteBlue := "images/blue.bmp"
pNoteRed := "images/red.bmp"
sHitIdle := "images/hitmark.bmp"
sHitBlue := "images/hitmarkblue.bmp"
sHitRed := "images/hitmarkred.bmp"

var obSwordsman : CharClass

ConstructChar (obSwordsman, pCharIdle, pCharBlue, pCharRed, 300)

% ----------Menu screen----------
% Draws background
drawfillbox (0, 0, maxx, maxy, black)

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

ConstructHit(obHitmarker, sHitIdle, sHitBlue, sHitRed, iHitmarkerX, iHitmarkerY, iNoteScale)


% ----------Gets file for songs----------

% Sets variables for reading files
var sFile : string := "maps/crystallized.txt"
var iFileNum, iNoteColour, iNoteMS, iEndTime : int
var aBlueNotes : flexible array 1 .. 0 of int
var aRedNotes : flexible array 1 .. 0 of int
var sSongFile : string

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
var aBlueQ : array 1 .. upper(aBlueNotes) of NoteClass
var aRedQ : array 1 .. upper(aRedNotes) of NoteClass
var iLastBlue, iLastRed : int := 1

% Creates notes when they are needed
procedure CreateNotes (aColourNotes : array 1 .. * of int, var iCounter : int, iColourSelect : int)
    if iCounter < upper(aColourNotes) then
        if aColourNotes(iCounter + 1) <= iCurrentTime + iNoteSpawnMS + iBufferTime then
            iCounter += 1
            if iColourSelect = 1 then
                ConstructNote (aBlueQ(iCounter), pNoteBlue, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
                aBlueQ(iCounter) -> Show
            elsif iColourSelect = 2 then
                ConstructNote (aRedQ(iCounter), pNoteRed, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
                aRedQ(iCounter) -> Show
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
            put "miss!"
        end if
    end if
end RemoveNotes

% Variable to check which note is hit
var iHitBlue, iHitRed : int := 1

procedure HitNotes (aTimings : array 1 .. * of int, var aColourQ : array 1 .. * of NoteClass, iCurrentTime : int, var iHitNote : int, iTimingWindow : int, var iScore : int, var iCombo : int)
    if iHitNote <= upper(aTimings) then
        if aTimings(iHitNote) < iCurrentTime + iTimingWindow and aTimings(iHitNote) > iCurrentTime - iTimingWindow then
            put "hit!"
            DestructNote(aColourQ(iHitNote))
            iHitNote += 1
            iScore += 100
            iCombo += 1
        else 
            put "miss!"
            iCombo := 0
        end if
    else
        put "no more notes!"
    end if
    put "score: ", iScore
    put "combo: ", iCombo
end HitNotes

% Plays menu music
Music.PlayFileReturn ("music/Halcyon.mp3")

% Places text
colour(white)
colourback(black)
locate (30, 40)
put "Press space to play"

var iScore, iCombo : int := 0

% ----------Start of main game----------
loop
    % Checks if space key has been pressed to start the game
    Input.KeyDown (aKeysDown)
    exit when aKeysDown (' ')
end loop

    
%stops music
Music.PlayFileStop

% Hides menu sprite
Sprite.Hide (spTitle)

% Shows hit marker sprite
obHitmarker -> Show

% Starts the music
Music.PlayFileReturn ("music/"+sSongFile)

% Delay so that the music has time to start up and it doesn't just go silent
delay (1)

% Stores the time that the song starts at
iStartTime := Time.Elapsed

% Show the character
obSwordsman -> Show


put iEndTime


    % Core loop of spawning notes
loop
    % Store the current time through the song
    iCurrentTime := Time.Elapsed - iStartTime + iStartDelay

    CreateNotes (aBlueNotes, iBlueCount, 1)
    MoveNotes (aBlueQ, iCurrentTime, iBlueCount, iLastBlue)
    RemoveNotes (aBlueQ, aBlueNotes, iCurrentTime, iLastBlue, iBlueCount, iTimingWindow, iCombo)

    CreateNotes (aRedNotes, iRedCount, 2)
    MoveNotes (aRedQ, iCurrentTime, iRedCount, iLastRed)
    RemoveNotes (aRedQ, aRedNotes, iCurrentTime, iLastRed, iRedCount, iTimingWindow, iCombo)     

    % Get key input
    Input.KeyDown (aKeysDown)
    
    % Prev state is how many keys were being pressed

    % Gets the colour 
    iPrevColour := obSwordsman -> GetColour
    iNewColour := 0
    if aKeysDown (cBlueKey) and aKeysDown (cRedKey) then    % Checks if both keys are being pressed
        if iPrevState = 2 then          % Checks if 2 keys were being pressed before
            iNewColour := iPrevColour
        elsif iPrevColour = 1 then      % If not, if the previous colour was blue, then change it to red because red is more recent
            HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, iTimingWindow, iScore, iCombo)
            iNewColour := 2
        else                            % If the previous colour was red, change the colour to blue, and if both are pressed at the same time, default to blue
            HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, iTimingWindow, iScore, iCombo)
            iNewColour := 1
        end if
        % Store that both the keys are being pressed down
        iPrevState := 2
    elsif aKeysDown (cBlueKey) then     % Checks if the blue key is being pressed
        if iPrevColour = 0 then         % Checks if blue has been let go or not
            HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, iTimingWindow, iScore, iCombo)
        end if
        iPrevState := 1
        iNewColour := 1
    elsif aKeysDown (cRedKey) then      % Checks if the red key is being pressed
        if iPrevColour = 0 then         % Checks if red has been let go or not
            HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, iTimingWindow, iScore, iCombo)
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

put "ended!"
