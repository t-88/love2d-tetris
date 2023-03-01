GRIDSIZE = 32
WIDTH = 10
HEIGHT = 24
offsetX = 9
offsetY = 1
addSizeX = 21
addSizeY = 3

sources = {}
mainFontNoraml = nil
mainFontBig =  nil

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function pushPop(func)
    love.graphics.push()
    func()
    love.graphics.pop()

end




local tetromino = {
    posX = WIDTH / 2,
    posY = 1,
    tiles = { },
    curr = 1,
    done = false,
    sprite = nil,
    id = 1
}

square = {}
stright = {}
L_1 = {}
L_2 = {}
T_ = {}
skew1 = {}
skew2 = {}
spriteSheet =   nil 
sprites = {}

mainMenuTitle = {}

handCursor = nil
isHand = false
Screen = {
    currScreen = 1
}


function initPieces()
    local tiles = {}

    sprites = {
        love.graphics.newQuad(8 * 1,8 * 1,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 0,8 * 2,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 0,8 * 3,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 1,8 * 4,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 1,8 * 5,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 2,8 * 6,8,8,spriteSheet:getWidth(),spriteSheet:getHeight()),
        love.graphics.newQuad(8 * 2,8 * 7,8,8,spriteSheet:getWidth(),spriteSheet:getHeight())
    }



    square = deepcopy(tetromino);
    stright = deepcopy(tetromino);
    T_ = deepcopy(tetromino);
    skew1 = deepcopy(tetromino);
    skew2 = deepcopy(tetromino);
    L_1 = deepcopy(tetromino);
    L_2 = deepcopy(tetromino);


    square.sprite = sprites[1]
    stright.sprite = sprites[2]
    L_1.sprite = sprites[3]
    T_.sprite = sprites[4]
    skew2.sprite = sprites[5]
    L_2.sprite = sprites[6]
    skew1.sprite = sprites[7]


    square.id = 1
    stright.id = 2
    L_1.id = 3
    T_.id = 4
    skew2.id = 5
    L_2.id = 6
    skew1.id = 7


    table.insert(tiles,{x = 0,y = 0})
    table.insert(tiles,{x = 1,y = 0})
    table.insert(tiles,{x = 0,y = 1})
    table.insert(tiles,{x = 1,y = 1})
    table.insert(square.tiles,deepcopy(tiles))


    
        tiles = {}
        table.insert(tiles,{x = 0 ,y = 0 })
        table.insert(tiles,{x = 1 ,y = 0 })
        table.insert(tiles,{x = 2 ,y = 0 })
        table.insert(tiles,{x = 3 ,y = 0 })
        table.insert(stright.tiles,deepcopy(tiles))



        tiles = {}
        table.insert(tiles,{x = 2,y = -2 })
        table.insert(tiles,{x = 2,y = -1 })
        table.insert(tiles,{x = 2,y = 0 })
        table.insert(tiles,{x = 2,y = 1 })
        table.insert(stright.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0 ,y = 1 })
        table.insert(tiles,{x = 1 ,y = 1 })
        table.insert(tiles,{x = 2 ,y = 1 })
        table.insert(tiles,{x = 3 ,y = 1 })
        table.insert(stright.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1 ,y = 0 })
        table.insert(tiles,{x = 1 ,y = 1 })
        table.insert(tiles,{x = 1 ,y = 2 })
        table.insert(tiles,{x = 1 ,y = 3 })
        table.insert(stright.tiles,deepcopy(tiles))




        tiles = {}
        table.insert(tiles,{x = 0,y = 0})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(L_1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 2,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(L_1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 2,y = 2})
        table.insert(L_1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(tiles,{x = 0,y = 2})
        table.insert(L_1.tiles,deepcopy(tiles))



        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(T_.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(T_.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(T_.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(T_.tiles,deepcopy(tiles))



        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 2,y = 0})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(skew1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 2,y = 2})
        table.insert(skew1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 0,y = 2})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(skew1.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 0})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(skew1.tiles,deepcopy(tiles))



        tiles = {}
        table.insert(tiles,{x = 0,y = 0})
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(skew2.tiles,deepcopy(tiles))


        tiles = {}
        table.insert(tiles,{x = 2,y = 0})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(skew2.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(tiles,{x = 2,y = 2})
        table.insert(skew2.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 0,y = 2})
        table.insert(skew2.tiles,deepcopy(tiles))


        tiles = {}
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 2,y = 0})
        table.insert(L_2.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(tiles,{x = 2,y = 2})
        table.insert(L_2.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 1})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 2,y = 1})
        table.insert(tiles,{x = 0,y = 2})
        table.insert(L_2.tiles,deepcopy(tiles))

        tiles = {}
        table.insert(tiles,{x = 0,y = 0})
        table.insert(tiles,{x = 1,y = 0})
        table.insert(tiles,{x = 1,y = 1})
        table.insert(tiles,{x = 1,y = 2})
        table.insert(L_2.tiles,deepcopy(tiles))
end