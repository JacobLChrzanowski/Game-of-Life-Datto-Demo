################################################################
##                                                           ##
## GoL.rb, a Conway's Game of Life implementation in Ruby.  ##
##                                                         ##
## Takes in console input. Expects a filepath/filename    ##
## in root directory. ie, 'ruby GoL.rb  3x3r1.txt'       ##   
##                                                      ##
## by Jacob L. Chrzanowski                             ##
## for Datto Backup, Inc.                             ##
##                                                   ##
######################################################


# GoL is a struct that holds data for a Game of Life map
#
# => height -> meant to be used to store the height of the grid array
# => width -> meant to be used to store the width of the grid array
# => grid -> meant to be used to store the grid array
#
GoL = Struct.new(:height, :width, :grid)


# nArray creates a new 2D array of height 'height' and width 'width.'
#
# => height -> number of columns in new 2D array
# => width -> number of rows in new 2D array
#
def nArray(height, width)
    a = Array.new(height)
    a.map! { Array.new(width) }
    return a
end

# getMap takes a filename and returns a map structure
#     this method creates a new GoL structure to save data to, open a file,
#     error-checks the file, and copies file contents into a structure in
#     memory, as well as the width and height of the map.
#
# => file -> name of file to access
#
def getMap(file)
    map = GoL.new()
    map.height = 0
    map.width = 0

    openFile = File.open(file, "r")
    openFile.each_line do |line|
        map.height += 1
        line = line.gsub("\n",'')
        if (map.width == 0)
            (map.width = line.length)
        else
            if (map.width != line.length) 
                abort("\n'" + ARGV[0] +
                    "' is not formatted correctly!\n" +
                    "There are inconsistent widths to " +
                    "this file's formatting at line " +
                    String(map.height) + "."
                )
            end
        end
        for i in 0..map.width-1
            if (line[i] != '1' && line[i] != '0')
                abort("\n'" + ARGV[0] +
                    "' is not formatted correctly!\n" +
                    "An illegal character, '" + line[i] +
                    "' was found!"
                )
            end
        end
    end

    map.grid = nArray(map.height, map.width)
    y = 0
    openFile.rewind
    openFile.each_line do |line|
        for x in 0..map.width-1
            map.grid[y][x] = line[x]
        end
        y += 1
    end
    openFile.close
    return map
end


# fNeighbors takes a map struct, and a row/col to look around for neighbors
#     this method searches 1 unit in each cardinal and diagonal direction
#     for the number of 'neighbors' (in the given data structure, a 1) around
#     a given row/col origin and treats everything else (a 0 or wall) as
#     non-neighbor.
#
# => map -> data structure containing :grid, :height, and :width
# => row -> row to look around
# => col -> column to look around
#
def fNeighbors(map, row, col)
    neighbors = 0
    if !((row == 0)             ||  (col == 0))             then if(map.grid[(row - 1)][(col - 1)]  == '1') then neighbors += 1 end end
    if !((row == 0))                                        then if(map.grid[(row - 1)][(col)]      == '1') then neighbors += 1 end end
    if !((row == 0)             ||  (col == map.width-1))   then if(map.grid[(row - 1)][(col + 1)]  == '1') then neighbors += 1 end end
    if !(                           (col == 0))             then if(map.grid[(row)][(col - 1)]      == '1') then neighbors += 1 end end
    if !(                           (col == map.width-1))   then if(map.grid[(row)][(col + 1)]      == '1') then neighbors += 1 end end
    if !((row == map.height-1)  ||  (col == 0))             then if(map.grid[(row + 1)][(col - 1)]  == '1') then neighbors += 1 end end
    if !((row == map.height-1))                             then if(map.grid[(row + 1)][(col)]      == '1') then neighbors += 1 end end
    if !((row == map.height-1)  ||  (col == map.width-1))   then if(map.grid[(row + 1)][(col + 1)]  == '1') then neighbors += 1 end end
    return neighbors
end


# nextIter finds the next state of Conway's Game of Life
#     this method uses the standard Conway's Game of Life rules to find the
#     next state of each 'cell' of a given map and returns a structure
#     containing the next iteration of Game of Life.
#
# => map -> data structure containing :grid, :height, and :width
#
def nextIter(map)
    nIter = nArray(map.height, map.width)
    for y in 0..map.height-1
        for x in 0..map.width-1
            num = fNeighbors(map, y, x)
            case num
            when 0..1
                nIter[y][x] = '0'
            when 2
                nIter[y][x] = map.grid[y][x]
            when 3
                nIter[y][x] = '1'
            when 4..8
                nIter[y][x] = '0'
            end
        end
    end
    map.grid = nIter

    return map
end


# printMap takes a map struct and prints it to STDOUT
#     this method takes a map structure and prints the contents of
#     its :grid entry to STOUT.
#
# => map -> data structure containing :grid, :height, and :width
#
def printMap(map)
    for y in 0..map.height-1
        for x in 0..map.width-1
            printf("%c", map.grid[y][x])
        end
        printf("\n")
    end
end


# main is the primary method in GoL.rb
#     main expects a filepath/filename such as
#     '/home/user/Desktop/GoL/3x3r1.txt' or '3x3r1.txt'.
#
# => map -> data structure containing :grid, :height, and :width
#
def main()

    if (!File.file?(ARGV[0]))
        abort("'" + ARGV[0] + "' is not a valid filename! Aborting Ruby script!")
    end

    map = getMap(ARGV[0])
    
    map = nextIter(map)

    printMap(map)

end

main()