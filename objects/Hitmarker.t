% Create class Hitmarker
class Hitmarker
    inherit cSprite
    export SetPic, SetColour, Move, FreePics
    
    var pIdle, pBlue, pRed, iCurrColour : int

    procedure SetPic (inIdle, inRed, inBlue : string, iScale : int)
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
            label 1 :
                iCurrColour := 1
                Sprite.ChangePic (spSprite, pBlue)
            label 2 :
                iCurrColour := 2
                Sprite.ChangePic (spSprite, pRed)
        end case
    end SetColour

    procedure Move 
	    Sprite.SetPosition (spSprite, iX, iY, true)
    end Move

    procedure FreePics
        % Free the picture from memory
        Pic.Free (pIdle)
        Pic.Free (pBlue)
        Pic.Free (pRed)
    end FreePics
end Hitmarker

type HitClass : pointer to Hitmarker

procedure ConstructHit (var obHit : HitClass, pIdle, pBlue, pRed : string, inX, inY, iScale : int)
    new Hitmarker, obHit
    obHit -> SetPic (pIdle, pRed, pBlue, iScale)
    obHit -> SetHeight (2)
    obHit -> SetX (inX)
    obHit -> SetY (inY)
    obHit -> SetColour (0)
    obHit -> Move
end ConstructHit

procedure DestructHit (var obChar : CharClass)
    obChar -> FreePics
    obChar -> FreeSprite
    free obChar
end DestructHit