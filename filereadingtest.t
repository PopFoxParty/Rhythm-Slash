var sFile : string := "maps/crystallized.txt"
var iFileNum : int
var sFileContents : flexible array 1 .. 0, 1 .. 2 of int
var sSongFile : string

open : iFileNum, sFile, get


get : iFileNum, sSongFile

loop
    exit when eof (iFileNum)
    new sFileContents, upper(sFileContents) + 1, 2
    get : iFileNum, sFileContents( upper(sFileContents), 1), sFileContents( upper(sFileContents), 2)
end loop

put sSongFile

for i : 1 .. upper(sFileContents)
    put sFileContents(i,1), " and ", sFileContents(i,2)
end for

delay (10000)