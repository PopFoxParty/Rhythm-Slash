% Creates class sprite for other classes to use. Is not useful by itself.
class cSprite
    % Imports the sprite module to use
    import Sprite
    export SetHeight, SetX, SetY, Show, Hide, FreeSprite

    var spSprite, iX, iY : int

    % Sets layer of the sprite
    procedure SetHeight (iHeight : int)
	    Sprite.SetHeight (spSprite, iHeight)
    end SetHeight

    % Sets X coordinate of the sprite
    procedure SetX (inX : int)
	    iX := inX
    end SetX

    % Sets Y coordinates of the sprite
    procedure SetY (inY : int)
	    iY := inY
    end SetY

    % Shows the sprite
    procedure Show
        Sprite.Show (spSprite)
    end Show
    
    % Hides the sprite
    procedure Hide 
        Sprite.Hide (spSprite)
    end Hide

    % Frees the sprite in memory
    procedure FreeSprite 
        Sprite.Free (spSprite)
    end FreeSprite
end cSprite