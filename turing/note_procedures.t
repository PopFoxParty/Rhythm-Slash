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

% Calculates multiplier from combo.
procedure GetMultiplier (var rMultiplier : real, iCombo : int)
	if iCombo <= 40 then
		rMultiplier := 1 + intreal(iCombo) / 10
	end if
end GetMultiplier

% Creates notes when they are needed
procedure CreateNotes (aColourNotes : array 1 .. * of int, var aColourQ : array 1 .. * of NoteClass, var iCounter : int, iColourSelect : int)
    if iCounter < upper(aColourNotes) then
		if aColourNotes(iCounter + 1) <= iCurrentTime + iNoteSpawnMS + iBufferTime then
			iCounter += 1
			if iColourSelect = 1 then
				ConstructNote (aColourQ(iCounter), pNoteBlue, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
			elsif iColourSelect = 2 then
				ConstructNote (aColourQ(iCounter), pNoteRed, iNoteScale, iNoteStartX, iHitmarkerY, iHitmarkerX, aColourNotes(iCounter), aColourNotes(iCounter) - iNoteSpawnMS)
			end if
			aColourQ(iCounter) -> Show
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

% Check if note can be hit if key is pressed, then check how much score the player will get based on timing.
procedure HitNotes (aTimings : array 1 .. * of int, var aColourQ : array 1 .. * of NoteClass, iCurrentTime : int, var iHitNote : int, var rScore : real, var iCombo : int, var rMultiplier : real, var iHealth, iOkays, iGreats, iPerfects : int)
	if iHitNote <= upper(aTimings) then
		if aTimings(iHitNote) < iCurrentTime + iTimingWindowOkay and aTimings(iHitNote) > iCurrentTime - iTimingWindowOkay then
			GetMultiplier (rMultiplier, iCombo)
			if aTimings(iHitNote) < iCurrentTime + iTimingWindowGreat and aTimings(iHitNote) > iCurrentTime - iTimingWindowGreat then
				if aTimings(iHitNote) < iCurrentTime + iTimingWindowPerfect and aTimings(iHitNote) > iCurrentTime - iTimingWindowPerfect then
					rScore += 100 * rMultiplier
					iPerfects += 1
					Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 1, iPrevEx)
				else
					rScore += 50 * rMultiplier
					iGreats += 1
					Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 2, iPrevEx)
				end if
			else
				rScore += 20 * rMultiplier
				iOkays += 1
				Explosion (aColourQ(iHitNote) -> GetX (iCurrentTime), iHitmarkerY, 3, iPrevEx)
			end if
			DestructNote(aColourQ(iHitNote))
			iHealth += 5
			iHitNote += 1
			iCombo += 1
		else 
			iMisses += 1
			iCombo := 0
			iHealth -= 25
			Explosion (iHitmarkerX, iHitmarkerY, 4, iPrevEx)
		end if
        if not bExplosionShown then
            Sprite.Show (spExplosion)
            bExplosionShown := true
        end if
    else
        put "no more notes!"
        end if
	Pic.Draw (pScore, 30, 580, picCopy)
	Draw.Text ("Combo: "+intstr(iCombo), 50, 640, font, white)
	Draw.Text ("Multiplier "+realstr(rMultiplier, 2), 50, 620, font, white)
	Draw.Text ("Score: "+realstr(rScore, 2), 50, 600, font, white)
end HitNotes

% Removes notes once they go too far off the screen
procedure RemoveNotes (var aColourQ : array 1 .. * of NoteClass, aTimings : array 1 .. * of int, var iCurrentTime, iLowestNote, iCounter, iTimingWindow, iCombo, iHealth : int)
    if iLowestNote <= iCounter then  % Check if array object has been initialized yet
		if iCurrentTime - iTimingWindow - 10 > aTimings(iLowestNote) then
			DestructNote(aColourQ(iLowestNote))
			iLowestNote += 1
			iCombo := 0
			iMisses += 1
			iHealth -= 25
			if bExplosionShown then
				Sprite.Hide (spExplosion)
				bExplosionShown := false
			end if
		end if
    end if
end RemoveNotes

