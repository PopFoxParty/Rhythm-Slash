% Check which button the player is hovering on.
var iSelection : int

% Function for arrow key selections.
function Select (var cKey : char, var iSelection : int, iLower, iUpper : int) : boolean
    cKey := getchar
    case cKey of
        label KEY_RIGHT_ARROW, KEY_DOWN_ARROW :
            iSelection += 1
        label KEY_LEFT_ARROW, KEY_UP_ARROW :
            iSelection -= 1
        label ' ', KEY_ENTER :
            result true
        label KEY_BACKSPACE :
            iSelection := 0
            result true
        label KEY_ESC :
            quit
        label :
    end case

    % Prevent player from moving selection off the screen.
    if iSelection > iUpper then
        iSelection := iUpper
    elsif iSelection < iLower then
        iSelection := iLower
    end if

    result false
end Select


function ReturnToSong (var cKey : char) : int
    % Detect user input, then refer them to a specific screen
    loop
        if hasch then
            cKey := getchar
            case cKey of
                label KEY_BACKSPACE :
                    result 3
                label ' ', KEY_ENTER :
                    result 5
                label KEY_ESC :
                    quit
                label :
            end case
        end if
    end loop
end ReturnToSong


% ----------Menu screens----------
function TitleMenu (var cKey : char) : int
    Draw.Cls
    % Sets the button being hovered to the title
    iSelection := 1

    % Plays title screen music
    Music.PlayFileReturn ("music/Labyrinth in Kowloon- Walled World.mp3")

    % Draws the sprites in the title screen
    Pic.Draw (pTitleBack, 0, 0, picCopy)
    Sprite.Show (spTitle)
    Sprite.Show (spSettings)
    Sprite.Show (spInfo)

    % Makes sprites default size
    Sprite.Animate (spTitle, pTitleLarge, 640, 400, true)
    Sprite.Animate (spSettings, pSettings, iSettingsX, iSettingsY, true)
    Sprite.Animate (spInfo, pInfo, iInfoX, iInfoY, true)
    View.Update
    loop
		% Checks if space key has been pressed to start the game   
        if hasch then
            if Select (cKey, iSelection, 1, 3) then
                if iSelection not= 0 then
                    Sprite.Hide (spTitle)
                    Sprite.Hide (spSettings)
                    Sprite.Hide (spInfo)
                    Draw.Cls
                    Pic.Draw (pTitleBack, 0, 0, picCopy)
                    case iSelection of
                        label 1 : result 3
                        label 2 : result 1
                        label 3 : result 2
                end case
                end if
            end if 

            % Makes whichever button the player is hovering on larger.
            if iSelection = 1 then
                Sprite.Animate (spTitle, pTitleLarge, 640, 400, true)
            else
                Sprite.Animate (spTitle, pTitle, 640, 400, true)
            end if
            
            if iSelection = 2 then
                Sprite.Animate (spSettings, pSettingsLarge, iSettingsX, iSettingsY, true)
            else
                Sprite.Animate (spSettings, pSettings, iSettingsX, iSettingsY, true)
            end if 

            if iSelection = 3 then
                Sprite.Animate (spInfo, pInfoLarge, iInfoX, iInfoY, true)
            else
                Sprite.Animate (spInfo, pInfo, iInfoX, iInfoY, true)
            end if 
        end if
	end loop
end TitleMenu

% Settings screen to change your note delay.
function Settings (var cKey : char, var iNoteDelay : int) : int
    var sInput : string
    
    Pic.Draw (pTitleBack, 0, 0, picCopy)
    Draw.Text ("[Space/Enter] Set Note Delay", 20, 600, fontLarge, white)	
    Draw.Text ("[Backspace] Go back", 20, 520, fontLarge, white)	
    Draw.Text ( "Your note delay is " + intstr(iNoteDelay) + " ms.", 20, 450, font, white)
    loop
        if hasch then
            cKey := getchar
            case cKey of 
                label ' ', KEY_ENTER :
                    Text.ColourBack(black)
                    Text.Colour (white)
                    Text.LocateXY (600, 400)
                    get sInput
                    Draw.Cls
                    Pic.Draw (pTitleBack, 0, 0, picCopy)
                    if strintok (sInput) then
                        iNoteDelay := strint(sInput)
                        Draw.Text ( "Delay set!", 10, 150, font, white)
                    else
                        Draw.Text ( "invalid integer!", 10, 150, font, white)
                    end if
                    Draw.Text ("[Space/Enter] Set Note Delay", 20, 600, fontLarge, white)	
                    Draw.Text ("[Backspace] Go back", 20, 520, fontLarge, white)	
                    Draw.Text ( "Your note delay is " + intstr(iNoteDelay) + " ms.", 20, 450, font, white)
                label KEY_BACKSPACE : result 0
                label KEY_ESC : quit
                label :
            end case
        end if
    end loop
end Settings

function HowTo (var cKey : char): int
    Pic.Draw (pHowTo, 0, 0, picCopy)
    View.Update
    loop
        if hasch then
            % Removes character from buffer
            cKey := getchar 
            if cKey = KEY_ESC then
                quit
            end if
            result 0
        end if
    end loop
end HowTo

% Map selection screen
function MapSelect (var cKey : char, aMapList : array 1 .. * of string, var sMapChosen : string) : int
    Draw.Cls
    iSelection := 1
    Pic.Draw (pMapSelect, 0, 0, picCopy)
    Text.ColourBack(black)
    Text.Colour (white)
    Text.LocateXY (600, 400)
    Draw.Text (aMapNameList(iSelection), 100, 420, fontVeryLarge, white)
    Draw.Text ("Difficulty: "+aMapDifficulty(iSelection), 100, 350, fontLarge, white)
    Draw.Text ("Artist: "+aMapArtist(iSelection), 100, 300, fontLarge, white)
    View.Update
    Music.PlayFileStop
    sMapSelectSongPrev := "none"
    if File.Exists ("maps/"+aMapList(iSelection)+".txt") then
        Music.PlayFileStop
        open : iMapCurrentListFile, "maps/"+aMapList(iSelection)+".txt", get
        get : iMapCurrentListFile, sMapSelectSong
        Draw.Text ("Now playing: "+sMapSelectSong, 100, 220, font, white)
        if sMapSelectSong not= sMapSelectSongPrev then
            Music.PlayFileReturn ("music/"+sMapSelectSong)
            delay (1)
            % Prevent song from restarting if it is already playing
            sMapSelectSongPrev := sMapSelectSong
        end if
        close : iMapCurrentListFile
    end if
    loop
        if hasch then
            Draw.Cls
            Pic.Draw (pMapSelect, 0, 0, picCopy)
            if Select (cKey, iSelection, 1, upper(aMapList)) then
                if iSelection = 0 then
                    result 0
                else
                    sMapChosen := aMapList(iSelection)
                    result 4
                end if
            end if 
            if File.Exists ("maps/"+aMapList(iSelection)+".txt") then
                open : iMapCurrentListFile, "maps/"+aMapList(iSelection)+".txt", get
                get : iMapCurrentListFile, sMapSelectSong
                Draw.Text ("Now playing: "+sMapSelectSong, 100, 220, font, white)
                if sMapSelectSong not= sMapSelectSongPrev then
                    Music.PlayFileStop
                    Music.PlayFileReturn ("music/"+sMapSelectSong)
                    delay (1)
                    % Prevent song from restarting if it is already playing
                    sMapSelectSongPrev := sMapSelectSong
                end if
                close : iMapCurrentListFile
            end if
            Draw.Text (aMapNameList(iSelection), 100, 420, fontVeryLarge, white)
            Draw.Text ("Difficulty: "+aMapDifficulty(iSelection), 100, 350, fontLarge, white)
            Draw.Text ("Artist: "+aMapArtist(iSelection), 100, 300, fontLarge, white)
            View.Update
        end if
    end loop
end MapSelect

% Player selection screen
function PlayerSelect (var cKey : char, var iMultiplayer : int) : int
    Draw.Cls
    Pic.Draw (pPlayerSelect, 0, 0, picCopy)
    loop
        if hasch then
            cKey := getchar
            case cKey of
                label KEY_LEFT_ARROW, KEY_UP_ARROW :
                    iMultiplayer := 0
                    result 5
                label KEY_RIGHT_ARROW, KEY_DOWN_ARROW :
                    iMultiplayer := 1
                    result 5
                label KEY_BACKSPACE : result 3
                label KEY_ESC : quit
                label :
            end case
        end if
    end loop
end PlayerSelect

% Starts the actual game
function MainGame : int
    loop
        % ----------Set variables to defaults----------
        % Background
        Pic.Draw (pTitleBack, 0, 0, picCopy)



        % Variable to check which note is hit
        var iHitBlue, iHitRed : int := 1

        % Sets HP to 100
        iHealth := 200

        % Makes previous explosion 0
        iPrevEx := 0

        % Sets score, combo, and notes to 0, resetting them for a new game.
        iMisses := 0
        iOkays := 0
        iGreats := 0
        iPerfects := 0
        rScore := 0
        iCombo := 0
        rMultiplier := 1
        iTotalNotes := 0

        % ----------Gets file for songs----------

        iBlueCount := 0
        iRedCount := 0

        % Sets variables for reading files

        var sFile : string

        sFile := "maps/"+sMapChosen+".txt"

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
            iTotalNotes += 1
            iEndTime := iNoteMS
        end loop

        % Closes file
        close : iFileNum

        % Creates queue of blue and red notes
        var aBlueQ : flexible array 1 .. upper(aBlueNotes) of NoteClass
        var aRedQ : flexible array 1 .. upper(aRedNotes) of NoteClass

        Draw.Text ( "Press space to play!", 0, 200, font, white)

        % Stops music
        Music.PlayFileStop

        % Adds background
        pBackground := Pic.Scale (pBackground, 1280, 720)
        Pic.Draw (pBackground, 0, 0, picCopy)

        % Hides the explosion 
        Sprite.Hide (spExplosion)
        bExplosionShown := false

        % Shows the progress bar
        Sprite.Show (spProgressBar)

        % Shows the health bar
        Sprite.Show (spHealthBar)

        % Health bar background
        Pic.Draw (pHealthBarBack, 780, 650, picMerge)

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

        % Move progress back back to start
        Sprite.SetPosition (spProgressBar, -1280, 0, false)

        % Core loop of spawning notes
        loop
            
        
            % Store the current time through the song
            iCurrentTime := Time.Elapsed - iStartTime + iStartDelay

            if upper(aBlueNotes) > 0 then % Check if there are any notes in queue
                CreateNotes (aBlueNotes, aBlueQ, iBlueCount, 1)
                MoveNotes (aBlueQ, iCurrentTime, iBlueCount, iLastBlue)
                RemoveNotes (aBlueQ, aBlueNotes, iCurrentTime, iLastBlue, iBlueCount, iTimingWindowOkay, iCombo, iHealth)
            end if
            
            if upper(aRedNotes) > 0 then % Check if there are any notes in queue
                CreateNotes (aRedNotes, aRedQ, iRedCount, 2)
                MoveNotes (aRedQ, iCurrentTime, iRedCount, iLastRed)
                RemoveNotes (aRedQ, aRedNotes, iCurrentTime, iLastRed, iRedCount, iTimingWindowOkay, iCombo, iHealth)
            end if
            % Get key input
            Input.KeyDown (aKeysDown)
            
            if aKeysDown (KEY_ESC) then
                quit
            elsif aKeysDown (KEY_BACKSPACE) then
                 % Hides all the sprites
                obSwordsman -> Hide
                obHitmarker -> Hide
                Sprite.Hide (spExplosion)
                Sprite.Hide (spProgressBar)
                Sprite.Hide (spHealthBar)

                % Hide all notes
                for i : iLastBlue .. iBlueCount
                    DestructNote(aBlueQ(i))
                end for
        
                for i : iLastRed .. iRedCount
                    DestructNote(aRedQ(i))
                end for
        
                Draw.Cls
                result 3
            end if
            
            % Prev state is how many keys were being pressed

            % Gets the colour 
            iPrevColour := obSwordsman -> GetColour
            iNewColour := 0
            if (aKeysDown (cBlueKey1) or aKeysDown (cBlueKey2)) and (aKeysDown (cRedKey1) or aKeysDown (cRedKey2)) then    % Checks if both keys are being pressed
                if iPrevState = 2 then          % Checks if 2 keys were being pressed before
                    iNewColour := iPrevColour
                elsif iPrevColour = 1 then      % If not, if the previous colour was blue, then change it to red because red is more recent
                    if upper(aRedNotes) > 0 then
                        HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, rScore, iCombo, rMultiplier, iHealth, iOkays, iGreats, iPerfects)
                    end if
                    iNewColour := 2
                else                            % If the previous colour was red, change the colour to blue, and if both are pressed at the same time, default to blue
                    if upper(aBlueNotes) > 0 then
                        HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, rScore, iCombo, rMultiplier, iHealth, iOkays, iGreats, iPerfects)
                    end if
                    iNewColour := 1
                end if
                % Store that both the keys are being pressed down
                iPrevState := 2
            elsif aKeysDown (cBlueKey1) or aKeysDown (cBlueKey2) then     % Checks if the blue key is being pressed
                if iPrevColour = 0 then         % Checks if blue has been let go or not
                    if upper(aBlueNotes) > 0 then
                        HitNotes(aBlueNotes, aBlueQ, iCurrentTime, iLastBlue, rScore, iCombo, rMultiplier, iHealth, iOkays, iGreats, iPerfects)
                    end if
                end if
                iPrevState := 1
                iNewColour := 1
                elsif aKeysDown (cRedKey1) or aKeysDown (cRedKey2) then      % Checks if the red key is being pressed
                if iPrevColour = 0 then         % Checks if red has been let go or not
                    if upper(aRedNotes) > 0 then
                        HitNotes(aRedNotes, aRedQ, iCurrentTime, iLastRed, rScore, iCombo, rMultiplier, iHealth, iOkays, iGreats, iPerfects)
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

            % Move the progress bar across the screen
            if iCurrentTime > 0 then
                Sprite.SetPosition (spProgressBar, round((1280 / (iEndTime + 2000) * iCurrentTime)) - 1280, 0, false)
            end if
            
            exit when iCurrentTime > iEndTime + 2000
            
            if iHealth > 200 then
                iHealth := 200
            end if

            Sprite.SetPosition (spHealthBar, round(-(490 / 200 * iHealth)) + 1280, 661, false)

            exit when iHealth <= 0
        end loop

        for i : iLastBlue .. iBlueCount
            DestructNote(aBlueQ(i))
        end for

        for i : iLastRed .. iRedCount
            DestructNote(aRedQ(i))
        end for

        Draw.Cls

        % Hides all the sprites
        obSwordsman -> Hide
        obHitmarker -> Hide
        Sprite.Hide (spExplosion)
        Sprite.Hide (spProgressBar)
        Sprite.Hide (spHealthBar)

        % If it is multiplayer, change the player's score
        case iMultiplayer of
            label 1 : 
                rPlayer1Score := rScore
                iMultiplayer := 2
                result 8
            label 2 : 
                rPlayer2Score := rScore
                result 9
            label :
                if iHealth <= 0 then
                    result 6
                else
                    result 7
                end if
        end case

        if iHealth <= 0 then
            result 6
        else
            result 7
        end if

    end loop
    result 4
end MainGame

% Displays a screen when you die
function DeathScreen (var cKey : char) : int
    Draw.Cls
    Pic.Draw (pDeath, 0, 0, picCopy)
    result ReturnToSong (cKey)
end DeathScreen

% Displays a screen when you pass the game
function PassScreen (var cKey : char) : int
    Draw.Cls
    Pic.Draw (pPass, 0, 0, picCopy)

	Draw.Text (realstr(rScore, 2), 780, 455, fontVeryLarge, white)	
	Draw.Text (intstr(iPerfects), 370, 455, fontVeryLarge, white)	
	Draw.Text (intstr(iGreats), 370, 359, fontVeryLarge, white)	
	Draw.Text (intstr(iOkays), 370, 263, fontVeryLarge, white)	
	Draw.Text (intstr(iMisses), 370, 167, fontVeryLarge, white)	
    Draw.Text (intstr(round(((iPerfects * 1) + (iGreats * 0.5) + (iOkays * 0.2)) / iTotalNotes * 100))+"%", 900, 200, fontVeryLarge, white)

    result ReturnToSong (cKey)
end PassScreen

% Displays a screen for when switching turns from player 1 to player 2
function Player2Turn (var cKey : char) : int
    Draw.Cls
    Pic.Draw (pPlayer2Turn, 0, 0, picCopy)
    result ReturnToSong (cKey)
end Player2Turn

% Displays the end screen if playing on multiplayer
function MultiplayerEnd (var cKey : char) : int
    Draw.Cls
    Pic.Draw (pMultiplayer, 0, 0, picCopy)

    % Draw all the text on screen
    if rPlayer1Score > rPlayer2Score then
        Draw.Text ("Player 1 Wins!", 400, 455, fontVeryLarge, white)	
    elsif rPlayer1Score < rPlayer2Score then
        Draw.Text ("Player 2 Wins!", 400, 455, fontVeryLarge, white)	
    else
        Draw.Text ("Tie!", 580, 455, fontVeryLarge, white)	
    end if
    
    Draw.Text ("P1: " + realstr(rPlayer1Score, 2), 200, 290, fontVeryLarge, white)	
    Draw.Text ("P2: " + realstr(rPlayer2Score, 2), 200, 200, fontVeryLarge, white)	

    % Exit when you press space or enter
    loop
        if hasch then
            cKey := getchar
            case cKey of
                label ' ', KEY_ENTER :
                    result 3
                label KEY_ESC :
                    quit
                label :
            end case
        end if
    end loop
end MultiplayerEnd