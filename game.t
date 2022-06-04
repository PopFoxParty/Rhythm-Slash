% Sets up all the initial parameters for the game.
View.Set ("graphics:1280;720, position:centre;middle, title: Rhythm Runner, nobuttonbar")

% Sets initial variables for music componenets.
var iStartTime, iCurrentTime, iStartDelay, iBPM : int

% Checks if key is pressed
var bNonePressed, bBluePressed, bRedPressed : boolean := false

% Sets up the array of characters to check for key presses.
var aKeysDown : array char of boolean


% Create the initial pictures and sprites.
var pTitle, spTitle : int

iStartDelay := 0
iBPM := 100

% Creates images for the character and notes.

var pCharIdle, pCharBlue, pCharRed, pNoteBlue, pNoteRed, pHitMarker : string

pCharIdle := "images/idle.bmp"
pCharBlue := "images/attackblue.bmp"
pCharRed := "images/attackred.bmp"
pNoteBlue := "images/blue.bmp"
pNoteRed := "images/red.bmp"
pHitMarker := "images/hitmark.bmp"

class cSprite
    import Sprite
    export SetHeight, SetX, SetY, Show, Hide

    var spSprite, iX, iY : int

    procedure SetHeight (iHeight : int)
	    Sprite.SetHeight (spSprite, iHeight)
    end SetHeight

    procedure SetX (inX : int)
	    iX := inX
    end SetX

    procedure SetY (inY : int)
	    iY := inY
    end SetY

    procedure Show
        Sprite.Show (spSprite)
    end Show
    
    procedure Hide 
        Sprite.Hide (spSprite)
    end Hide
end cSprite

% Create note class
/*class Note
    inherit cSprite
    export SetPic, SetHeight, SetX, SetY, EndPos, Move, Show, Hide

    % Delare variables
    var spSprite, pBlue, pRed, iX, iY, iEndX, iEndY, Move, Show, Hide
    
    procedure SetPic (inBlue, inRed : string, scale : int)
        pBlue := Pic.FileNew (inBlue)
        pRed := Pic.FileNew (inRed)

        Pic.SetTransparentColour (pBlue, black)
        Pic.SetTransparentColour (pRed, black)

        spSprite := Sprite.New (pBlue)
    end SetPic

    procedure EndX

end Note*/

% Creates a character
class Character
    inherit cSprite
    export SetPic, SetColour, Move, SetShift

    % Variables needed.
    var pIdle, pBlue, pRed, iShift : int

    % Gets all the images for the sprite
    procedure SetPic (inIdle, inBlue, inRed : string, scale : int)
        pIdle := Pic.FileNew (inIdle)
        pBlue := Pic.FileNew (inBlue)
        pRed := Pic.FileNew (inRed)

        Pic.SetTransparentColour (pIdle, black)
        Pic.SetTransparentColour (pBlue, black)
        Pic.SetTransparentColour (pRed, black)

        pIdle := Pic.Scale (pIdle, scale, scale)
        pBlue := Pic.Scale (pBlue, scale, scale)
        pRed := Pic.Scale (pRed, scale, scale)

        spSprite := Sprite.New (pIdle)
    end SetPic

    procedure Move 
	    Sprite.SetPosition (spSprite, iX, iY, true)
    end Move

    procedure SetColour (inColour : int)
        case inColour of
            label 0 :
                Sprite.ChangePic (spSprite, pIdle)
                Sprite.SetPosition (spSprite, iX, iY, true)
            label 1 :
                Sprite.ChangePic (spSprite, pBlue)
                Sprite.SetPosition (spSprite, iX+iShift, iY, true)
            label 2 :
                Sprite.ChangePic (spSprite, pRed)
                Sprite.SetPosition (spSprite, iX+iShift, iY, true)
        end case
    end SetColour

    procedure SetShift (inShift : int)
        iShift := inShift
    end SetShift
end Character

type CharClass : pointer to Character

% Creates procedure to generate character object
procedure ConstructChar (var obChar : CharClass, pIdle, pBlue, pRed : string, scale : int)
    % Initialize object and enter default parameters
    new Character, obChar
    obChar -> SetPic (pIdle, pBlue, pRed, scale)
    obChar -> SetHeight (2)
    obChar -> SetX (200)
    obChar -> SetY (200)
    obChar -> SetShift (188)
    obChar -> SetColour (0)
    obChar -> Move
    obChar -> Hide
end ConstructChar

% Creates procedure to free character object
procedure DestructChar (var obChar : CharClass)
    free obChar
end DestructChar

var obSwordsman : CharClass

ConstructChar (obSwordsman, pCharIdle, pCharBlue, pCharRed, 300)


% Start of program
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
            % Store the current time through the song
            iCurrentTime := Time.Elapsed - iStartTime
            if iCurrentTime = 9007 then
                put "beat"
            elsif iCurrentTime = 9179 then
                put "beat"
            elsif iCurrentTime = 9179 then
                put "beat"
            elsif iCurrentTime = 9351 then
                put "beat"
            elsif iCurrentTime = 9524 then
                put "beat"
            elsif iCurrentTime = 9696 then
                put "beat"
            elsif iCurrentTime = 9869 then
                put "beat"
            elsif iCurrentTime = 10041 then
                put "beat"
            end if

            % Get key input
            Input.KeyDown (aKeysDown)

            %Checking if the keys are being pressed, and then checking if they are being held down to avoid repeatedly setting the sprite to the same image.
            if aKeysDown (' ') then
                put iCurrentTime
            end if
            if aKeysDown ('f') then
                if not bBluePressed then
                    put "blue!"
                    obSwordsman -> SetColour (1)
                    bBluePressed := true
                    bNonePressed := false
                end if
            else
                bBluePressed := false
            end if
            if aKeysDown ('j') then
                if not bRedPressed then
                    put "red!"
                    obSwordsman -> SetColour (2)
                    bRedPressed := true
                    bNonePressed := false
                end if
            else
                bRedPressed := false
            end if
            if not (bBluePressed or bRedPressed) and not bNonePressed then 
                put "reset!"
                obSwordsman -> SetColour (0)
                bNonePressed := true
            end if
        end loop
    end if
end loop

var lol : string


get lol
