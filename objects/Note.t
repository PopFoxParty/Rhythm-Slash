% Create note class
class Note
    inherit cSprite
    export SetPic, SetNoteTime, SetSpawnTime, GetTime, SetEndPos, CalculateSlope, Move, GetX

    % Delare variables
    var pNote, pNoteIn, iEndX, iNoteTime, iSpawnTime : int
    var rSlope : real     

    % Set the picture for notes
    procedure SetPic (inNote : string, iScale : int)
        % Create picture of note
        pNoteIn := Pic.FileNew (inNote)

        % Create transparency
        Pic.SetTransparentColour (pNoteIn, black)

        % Change the scale
        pNote := Pic.Scale (pNoteIn, iScale, iScale)

        % Free the note before scaling
        Pic.Free (pNoteIn)

        % Create sprite from image
        spSprite := Sprite.New (pNote)
        
        % Hides sprite
        Sprite.Hide (spSprite)

        % Moves the sprite offscreen
        Sprite.SetPosition (spSprite, 1780, 0, true)

        % Free the picture from memory
        Pic.Free (pNote)
    end SetPic

    % Sets variable for the timing of the note
    procedure SetNoteTime (inNoteTime : int)
        iNoteTime := inNoteTime
    end SetNoteTime

    % Sets the spawn time of the note
    procedure SetSpawnTime (inSpawnTime : int)
        iSpawnTime := inSpawnTime
    end SetSpawnTime

    % Gets the timing of the note
    function GetTime : int
        result iNoteTime
    end GetTime

    % Sets the end position for the note
    procedure SetEndPos (inX : int)
        iEndX := inX
    end SetEndPos

    % Calculates the slope for the location of the note based on time
    procedure CalculateSlope
        % Calculates slope using (y2-y1)/(x2-y1)
        rSlope := (iEndX-iX)/(iNoteTime-iSpawnTime)
    end CalculateSlope

    % Moves the note based on current time.
    procedure Move (inTime : int)
        % Calculates the X position based on slope and time. Looks like my grade 9 math finally became useful for once.
        Sprite.SetPosition (spSprite, round(rSlope*(inTime-iSpawnTime)+iX), iY, true)
    end Move

    function GetX (inTime : int) : int
        % Calculates the X position based on slope and time. Looks like my grade 9 math finally became useful for once.
        result round(rSlope*(inTime-iSpawnTime)+iX)
    end GetX
end Note

type NoteClass : pointer to Note

% Creates procedure to generate a note object
procedure ConstructNote (var obNote : NoteClass, pImage : string, scale, iX, iY, iEndX, iNoteTime, iSpawnTime : int)
    % Initialize object and enter default parameters
    new Note, obNote
    obNote -> SetPic (pImage, scale)
    obNote -> SetHeight (3)
    obNote -> SetX (iX)
    obNote -> SetY (iY)
    obNote -> SetEndPos (iEndX)
    obNote -> SetNoteTime (iNoteTime)
    obNote -> SetSpawnTime (iSpawnTime)
    obNote -> CalculateSlope
end ConstructNote

% Creates procedure to destroy the note object
procedure DestructNote (var obNote : NoteClass)
    obNote -> Hide
    obNote -> FreeSprite
    free obNote
end DestructNote