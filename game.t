% Sets up all the initial parameters for the game.
View.Set ("graphics:1280;720, position:centre;middle, title: Rhythm Runner, nobuttonbar")
%View.Set ("offscreenonly")

% Include the custom classes
include "objects/cSprite.t"
include "objects/Character.t"
include "objects/Note.t"

% Sets initial variables for music componenets.
var iStartTime, iCurrentTime, iStartDelay, iBPM : int

% Checks current colour and new colour of sprite
var iPrevColour, iNewColour, iPrevState : int := 0

% Sets up the array of characters to check for key presses.
var aKeysDown : array char of boolean

% Sets up initial keybinds
var cBlueKey, cRedKey : char

cBlueKey := 'f'
cRedKey := 'j'

% Create the initial pictures and sprites.
var pTitle, spTitle : int

iStartDelay := 0
iBPM := 100

% Create test note
var obTestNote, obTestNote2 : NoteClass
var bTestNoteCreated, bTestNote2Created : boolean := false

% Creates images for the character and notes.

var pCharIdle, pCharBlue, pCharRed, pNoteBlue, pNoteRed, pHitMarker : string

pCharIdle := "images/idle.bmp"
pCharBlue := "images/attackblue.bmp"
pCharRed := "images/attackred.bmp"
pNoteBlue := "images/blue.bmp"
pNoteRed := "images/red.bmp"
pHitMarker := "images/hitmark.bmp"

var obSwordsman : CharClass

ConstructChar (obSwordsman, pCharIdle, pCharBlue, pCharRed, 300)

% ----------Menu screen----------
% Draws background
drawfillbox (0, 0, maxx, maxy, black)

% Draws logo
pTitle := Pic.FileNew ("images/title.bmp")

Pic.SetTransparentColor (pTitle, black)

pTitle := Pic.Scale (pTitle, 400, 400)

spTitle := Sprite.New (pTitle)
Sprite.SetHeight (spTitle, 1)
Sprite.SetPosition (spTitle, 640, 400, true)
Sprite.Show (spTitle)

% Plays menu music
Music.PlayFileReturn ("music/Halcyon.mp3")

% Places text
colour(white)
colourback(black)
locate (30, 40)
put "Press space to play"

View.Update
% ----------Start of main game----------
loop
    % Checks if space key has been pressed to start the game
    Input.KeyDown (aKeysDown)
    if aKeysDown (' ') then
        %stops music
        Music.PlayFileStop

        % Hides menu sprite
        Sprite.Hide (spTitle)


	    % Starts the music
	    Music.PlayFileReturn ("music/crystallized.mp3")

        % Stores the time that the song starts at
        delay (iStartDelay)
        iStartTime := Time.Elapsed

        put "started at ", iStartTime
       
        % Show the character
        obSwordsman -> Show

         % Core loop of spawning notes
        loop
            % Clears screen
            % Draw.Cls
            
            % Draws background
            % drawfillbox (0, 0, maxx, maxy, black)

            % Store the current time through the song
            iCurrentTime := Time.Elapsed - iStartTime

            % Test Note
            if iCurrentTime = 1000 and not bTestNoteCreated then
                ConstructNote (obTestNote, pNoteBlue, 50, 1280, 200, 200, 200, 7000, iCurrentTime)
                obTestNote -> Show
                bTestNoteCreated := true
            end if
            if bTestNoteCreated then
                obTestNote -> Move (iCurrentTime)
            end if

            if iCurrentTime = 2000 and not bTestNote2Created then
                ConstructNote (obTestNote2, pNoteBlue, 50, 1280, 200, 200, 200, 8000, iCurrentTime)
                obTestNote2 -> Show
                bTestNote2Created := true
            end if
            if bTestNote2Created then
                obTestNote2 -> Move (iCurrentTime)
            end if

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
                    put "red"
                    iNewColour := 2
                else                            % If the previous colour was red, change the colour to blue, and if both are pressed at the same time, default to blue
                    put "blue"
                    iNewColour := 1
                end if
                % Store that both the keys are being pressed down
                iPrevState := 2
            elsif aKeysDown (cBlueKey) then     % Checks if the blue key is being pressed
                if iPrevColour = 0 then         % Checks if blue has been let go or not
                    put "blue"
                end if
                iPrevState := 1
                iNewColour := 1
            elsif aKeysDown (cRedKey) then      % Checks if the red key is being pressed
                if iPrevColour = 0 then         % Checks if red has been let go or not
                    put "red"
                end if
                iPrevState := 1
                iNewColour := 2
            else                                % If other keys or no keys are pressed set it to the idle animation
                iPrevState := 0
            end if

            if iNewColour not= iPrevColour then % Checks if sprite is different as last frame, if so, change the sprite, if not, don't change it
                obSwordsman -> SetColour (iNewColour)
            end if 

            % Updates Screen
            % View.Update
        end loop
    end if
end loop