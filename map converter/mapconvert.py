# HOW TO USE: Import hitobjects from osu file into test.txt. Then, remove any text in outtext.txt. Run program to get map in outtext.txt.
import sys
try:
    droppedFile = sys.argv[1]
    mapName = input("Enter map name (no file extension): ")
    songName = input("Enter song name (include file extension): ")
    timeDelay = input("Enter note speed (how long the note will be on the screen for) (in ms): ")
    with open (f"{mapName}.txt", "w") as songMapOut:
        songMapOut.write(f"\"{songName}\" {timeDelay}\n")
        try:
            with open(droppedFile, "r", encoding="utf-8") as songMap:
                lines = songMap.read().splitlines()
                start = lines.index("[HitObjects]")
                for line in lines[start+1:]:
                    if line.split(",")[4] in {"0", "4"}:
                        noteColour = 2
                    elif line.split(",")[4] in {"2", "8", "12"}:
                        noteColour = 1
                    else:
                        noteColour = 0
                    timing = line.split(",")[2]
                    songMapOut.write(f"{noteColour}  {timing}\n")
        except:
            input("Error! ")
except IndexError:
    input("No file dropped! Please drag and drop an .osu file onto the python script to convert it! ")


