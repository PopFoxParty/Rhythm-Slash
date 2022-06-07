% NOTICE: Use Sprite.t with this object

% Creates a character
class Character
    inherit cSprite
    export SetPic, SetColour, GetColour, Move, SetShift, FreePics

    % Variables needed.
    var pIdle, pBlue, pRed, iShift, iCurrColour : int

    % Gets all the images for the sprite
    procedure SetPic (inIdle, inBlue, inRed : string, iScale : int)
        pIdle := Pic.FileNew (inIdle)
        pBlue := Pic.FileNew (inBlue)
        pRed := Pic.FileNew (inRed)

        Pic.SetTransparentColour (pIdle, black)
        Pic.SetTransparentColour (pBlue, black)
        Pic.SetTransparentColour (pRed, black)

        pIdle := Pic.Scale (pIdle, iScale, iScale)
        pBlue := Pic.Scale (pBlue, iScale, iScale)
        pRed := Pic.Scale (pRed, iScale, iScale)
        
        spSprite := Sprite.New (pIdle)
        Sprite.Hide (spSprite)
    end SetPic

    % Sets the sprite's colour
    procedure SetColour (inColour : int)
        case inColour of
            label 0 :
                iCurrColour := 0
                Sprite.ChangePic (spSprite, pIdle)
                Sprite.SetPosition (spSprite, iX, iY, true)
            label 1 :
                iCurrColour := 1
                Sprite.ChangePic (spSprite, pBlue)
                Sprite.SetPosition (spSprite, iX+iShift, iY, true)
            label 2 :
                iCurrColour := 2
                Sprite.ChangePic (spSprite, pRed)
                Sprite.SetPosition (spSprite, iX+iShift, iY, true)
        end case
    end SetColour
    
    % Gets the sprites current colour
    function GetColour : int
        result iCurrColour
    end GetColour

    procedure Move 
	    Sprite.SetPosition (spSprite, iX, iY, true)
    end Move

    procedure SetShift (inShift : int)
        iShift := inShift
    end SetShift

    procedure FreePics
        % Free the picture from memory
        Pic.Free (pIdle)
        Pic.Free (pBlue)
        Pic.Free (pRed)
    end FreePics
end Character

% Creates pointer
type CharClass : pointer to Character

% Creates procedure to generate character object
procedure ConstructChar (var obChar : CharClass, pIdle, pBlue, pRed : string, iScale : int)
    % Initialize object and enter default parameters
    new Character, obChar
    obChar -> SetPic (pIdle, pBlue, pRed, iScale)
    obChar -> SetHeight (1)
    obChar -> SetX (200)
    obChar -> SetY (200)
    obChar -> SetShift (188)
    obChar -> SetColour (0)
    obChar -> Move
end ConstructChar

% Creates procedure to free character object
procedure DestructChar (var obChar : CharClass)
    obChar -> FreePics
    obChar -> FreeSprite
    free obChar
end DestructChar

