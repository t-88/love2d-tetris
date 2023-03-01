local moonshine = require ("moonshine")
local Text = require("text")
require("utils")

gameLoopScreen = {
    tetrominosQueue = {},
    tetrominos ,
    currTetromino,
    gameTick = {timer = 0, delay = 1,tick = false},
    hold = {curr = nil, usedThisTick = false},
    fastFall = false,
    map = {},
    borderSprites = {},
    score = 0,
    ui = {},

    bg = {},

}

gameLoopScreen.load = function ()
    initPieces()
    gameLoopScreen.gameLoopScreen = {timer = 0, delay = 1,tick = false}
    gameLoopScreen.tetrominosQueue = {}
    gameLoopScreen.score = 0
    gameLoopScreen.hold = {curr = nil, usedThisTick = false}
    gameLoopScreen.bg = {}





    gameLoopScreen.tetrominos = {skew1, T_, L_1, L_2, skew2, square, stright}

    for i = 1, 4 do 
        table.insert(gameLoopScreen.tetrominosQueue, 
                     gameLoopScreen.tetrominos[love.math.random(#gameLoopScreen.tetrominos)])
    end

    for i = 1, 25 do
        table.insert(gameLoopScreen.bg, 
                     deepcopy(gameLoopScreen.tetrominos[love.math.random(#gameLoopScreen.tetrominos)]))
        gameLoopScreen.bg[i].posY = love.math.random(40) + HEIGHT + addSizeY 
        gameLoopScreen.bg[i].posX = love.math.random(love.graphics.getWidth() / GRIDSIZE) -  addSizeX / 2
    end


    gameLoopScreen.gameTick.timer = 0
    gameLoopScreen.gameTick.delay = 1

    gameLoopScreen.currTetromino = deepcopy(gameLoopScreen.tetrominos[love.math.random(#gameLoopScreen.tetrominos)])


    gameLoopScreen.map = {}
    for y = 0, HEIGHT - 1 do
        gameLoopScreen.map[y] = {}
        for x = 0, WIDTH - 1 do
            gameLoopScreen.map[y][x] = 0
        end
    end

    gameLoopScreen.borderSprites[1] = love.graphics.newQuad(8 * 1,8 * 6,8,8,spriteSheet:getWidth(),spriteSheet:getHeight())


    local scoreText = Text:new("Score:",GRIDSIZE,GRIDSIZE * 8,0.5)
    local scareValue = Text:new("",GRIDSIZE,GRIDSIZE * 10,0.4)
    gameLoopScreen.ui = {scareValue,scoreText}


    glowEffect =  moonshine(moonshine.effects.glow)
    glowEffect.glow.strength = 3

    blurEffect =   moonshine(moonshine.effects.fastgaussianblur)
    blurEffect.fastgaussianblur.taps = 11
    blurEffect.fastgaussianblur.offset = 2
    

end

local function moveCurr(dx, dy)
    local currTet = gameLoopScreen.currTetromino
    local hitSmth = false

    for k = 1, #currTet.tiles[currTet.curr] do
        if (currTet.posY + currTet.tiles[currTet.curr][k].y + dy >= HEIGHT) then
            dy = 0
        end
        if (currTet.posX + currTet.tiles[currTet.curr][k].x + dx < 0) or 
           (currTet.posX + currTet.tiles[currTet.curr][k].x + dx >= WIDTH) then
            dx = 0
        end
    end

    for y = 0, #gameLoopScreen.map do
        for x = 0, #gameLoopScreen.map[y] do
            if gameLoopScreen.map[y][x] ~= 0 then
                for k = 1, #currTet.tiles[currTet.curr] do
                    if (currTet.posX + currTet.tiles[currTet.curr][k].x + dx == x) and
                        (currTet.posY + currTet.tiles[currTet.curr][k].y + dy == y) then
                        dx = 0
                        dy = 0
                        if currTet.posY + currTet.tiles[currTet.curr][k].y + dy == y then
                            hitSmth = true
                        end
                    end
                end
            end
        end
    end

        
    if dy ~= 0 then
        gameLoopScreen.gameTick.timer = 0
    end

    currTet.posX = currTet.posX + dx
    currTet.posY = currTet.posY + dy

    return hitSmth
end
local function printMap()
    print('[')
    for y = 0, #gameLoopScreen.map do
        io.write('[')
        for x = 0, #map[y] do
            local b = false
            for i = 1, #currTet.tiles[currTet.curr] do
                if (currTet.tiles[currTet.curr][i].x + currTet.posX == x) and
                    (currTet.tiles[currTet.curr][i].y + currTet.posY == y) then
                    io.write('/' .. ',')
                    b = true
                    break
                end
            end

            if not b then
                io.write(map[y][x] .. ',')
            end
        end
        io.write(']')
        print()
    end
    print(']')
end
local function collided(handleHeight)
    local currTet = gameLoopScreen.currTetromino

    for y = 0, #gameLoopScreen.map do
        for x = 0, #gameLoopScreen.map[y] do
            if gameLoopScreen.map[y][x] ~= 0 then  
                for i = 1, #currTet.tiles[currTet.curr] do
                    if (currTet.tiles[currTet.curr][i].x + currTet.posX == x)  and (currTet.tiles[currTet.curr][i].y + currTet.posY + 1  == y) then  
                        if currTet.tiles[currTet.curr][i].y + currTet.posY == 1 then
                            Screen.selectScreen(3)
                        end
                        
                        return true
                    end
                end

            end
        end
    end

    if handleHeight or handleHeight == nil then
        for i = 1 , #currTet.tiles[currTet.curr] do
            if currTet.posY + currTet.tiles[currTet.curr][i].y >= HEIGHT - 1   then
                return true
            end
        end
    end


    return false

end

local function loadNextTetrimino()
    table.insert(gameLoopScreen.tetrominosQueue, gameLoopScreen.tetrominos[love.math.random(#gameLoopScreen.tetrominos)])
    gameLoopScreen.currTetromino = deepcopy(table.remove(gameLoopScreen.tetrominosQueue, 1))
end

local function updateBg()
    for j = 1, #gameLoopScreen.bg do
        gameLoopScreen.bg[j].posY = gameLoopScreen.bg[j].posY - love.timer.getDelta() * 5
        
        if gameLoopScreen.bg[j].posY < -1 then
            gameLoopScreen.bg[j] = deepcopy(gameLoopScreen.tetrominos[love.math.random(#gameLoopScreen.tetrominos)])
            gameLoopScreen.bg[j].posY = love.math.random(10) + HEIGHT + addSizeY 
            gameLoopScreen.bg[j].posX = love.math.random(love.graphics.getWidth() / GRIDSIZE) -  addSizeX / 2
        end
    
    end
end

gameLoopScreen.update = function ()
    gameLoopScreen.gameTick.timer = gameLoopScreen.gameTick.timer + love.timer.getDelta()
    if gameLoopScreen.gameTick.timer > gameLoopScreen.gameTick.delay then
        moveCurr(0, 1);
        gameLoopScreen.gameTick.tick = true;
        gameLoopScreen.gameTick.timer = 0
    end
    if gameLoopScreen.fastFall then moveCurr(0, 1) end

    local currTet = gameLoopScreen.currTetromino

    if collided() and (gameLoopScreen.gameTick.tick or gameLoopScreen.fastFall) then
        for i = 1, #currTet.tiles[currTet.curr] do
            gameLoopScreen.map[currTet.posY + currTet.tiles[currTet.curr][i].y][currTet.posX + currTet.tiles[currTet.curr][i].x] = currTet.id
        end

        sources.lineFall:stop()
        sources.lineFall:play()
        loadNextTetrimino()
        gameLoopScreen.fastFall = false
        gameLoopScreen.hold.usedThisTick = false
    end


    filledRows = {}
    for y = 0, #gameLoopScreen.map do
        counter = 0
        for x = 0, #gameLoopScreen.map[y] do
            counter = counter + 1
            if gameLoopScreen.map[y][x] == 0 then
                counter = 0
                break
            end
        end
        if counter == WIDTH then
            sources.destruction:stop()
            sources.destruction:play()
            table.insert(filledRows, y)
            gameLoopScreen.score = gameLoopScreen.score + 1
            gameLoopScreen.ui[1].text =gameLoopScreen.score * 10       
        end
    end
    for i = 1, #filledRows do
        local j
        j = filledRows[i]
        for k = 0, #gameLoopScreen.map[j] do gameLoopScreen.map[j][k] = 0 end
        for k = j, 1, -1 do
            for m = 0, #gameLoopScreen.map[k] do
                gameLoopScreen.map[k][m] = gameLoopScreen.map[k - 1][m]
            end
        end
    end


    for i = 1, #gameLoopScreen.ui do 
        gameLoopScreen.ui[i]:update()
    end
    updateBg()

    gameLoopScreen.gameTick.tick = false
end


local function drawTetrominoQueue()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill',(WIDTH + offsetX  + 2) * GRIDSIZE,2*GRIDSIZE, GRIDSIZE * 5 ,GRIDSIZE * 13)
    love.graphics.setColor(1,1,1,1)


    local yOffsetQueue = 3
    local centerStright
    for i = 1, #gameLoopScreen.tetrominosQueue do
        centerStright = 2.1 
        for j = 1, #gameLoopScreen.tetrominosQueue[i].tiles[1] do
            if gameLoopScreen.tetrominosQueue[i].id == 2 then
                centerStright = 1.5
            end

            love.graphics.draw(
                spriteSheet,
                gameLoopScreen.tetrominosQueue[i].sprite,
                (centerStright + WIDTH + offsetX + 1 + gameLoopScreen.tetrominosQueue[i].tiles[1][j].x) * GRIDSIZE,
                (yOffsetQueue + gameLoopScreen.tetrominosQueue[i].tiles[1][j].y) * GRIDSIZE,
                0, 4, 4
            )
        end
        yOffsetQueue = yOffsetQueue + 3
    end
end

local function drawTetrominoHold()

    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill' , 2*GRIDSIZE ,2 *GRIDSIZE, GRIDSIZE * 5 ,GRIDSIZE * 3)
    love.graphics.setColor(1,1,1,1)

    if gameLoopScreen.hold.curr ~= nil then
        local offsetStrightY, offsetStrightX = 1, WIDTH - offsetX 
        for j = 1, #gameLoopScreen.hold.curr.tiles[1] do
            if gameLoopScreen.hold.curr.id == 2 then
                offsetStrightY = 1.5
                offsetStrightX = WIDTH - offsetX - 0.5 
            elseif gameLoopScreen.hold.curr.id == 1 then
                offsetStrightX = WIDTH - offsetX + 0.5
            end
            love.graphics.draw(
                spriteSheet,
                gameLoopScreen.hold.curr.sprite,
                (offsetStrightX + 2 + gameLoopScreen.hold.curr.tiles[1][j].x) * GRIDSIZE,
                (offsetStrightY + 0.5 + offsetY + gameLoopScreen.hold.curr.tiles[1][j].y) * GRIDSIZE,
                0, 4, 4)
        end
    end
end

local function drawShadow()
    local currTet =  gameLoopScreen.currTetromino

    local shodowPosY = 0
    local prevBetter = -1
    local thisGood = true

    for y = currTet.posY, #gameLoopScreen.map do
        for k = 1, #currTet.tiles[currTet.curr] do
            if y + currTet.tiles[currTet.curr][k].y - shodowPosY <= #gameLoopScreen.map and y + currTet.tiles[currTet.curr][k].y - shodowPosY > 0 then
                if gameLoopScreen.map[y + currTet.tiles[currTet.curr][k].y - shodowPosY][currTet.posX + currTet.tiles[currTet.curr][k].x] ~= 0 then
                    shodowPosY = y - currTet.tiles[currTet.curr][k].y
                    thisGood = false
                end
            end
        end
        if thisGood then
            prevBetter = y
        end
    end

    for k = 1, #currTet.tiles[currTet.curr] do
        if prevBetter + currTet.tiles[currTet.curr][k].y  >= #gameLoopScreen.map then
            prevBetter = #gameLoopScreen.map - currTet.tiles[currTet.curr][k].y
        end
    end

    love.graphics.setColor(1, 1, 1, 0.5)
        for i = 1, #currTet.tiles[currTet.curr] do
            love.graphics.draw(spriteSheet, currTet.sprite,
                (currTet.posX + currTet.tiles[currTet.curr][i].x + offsetX) * GRIDSIZE,
                (prevBetter + currTet.tiles[currTet.curr][i].y + offsetY) * GRIDSIZE,
                0, 4, 4)
        end
    love.graphics.setColor(1, 1, 1, 1)
end

local function drawBorder(x,y,width,height)
    for i = x , width     do 
        love.graphics.draw(spriteSheet, gameLoopScreen.borderSprites[1],
        i * GRIDSIZE,
        y * GRIDSIZE,
        0, 4, 4)
    end

    for i = x , width      do 
        love.graphics.draw(spriteSheet, gameLoopScreen.borderSprites[1],
        i * GRIDSIZE,
        (y + height) * GRIDSIZE,
        0, 4, 4)
    end


    for i = y, height + 1     do 
        love.graphics.draw(spriteSheet, gameLoopScreen.borderSprites[1],
        (x - 1) * GRIDSIZE,
        (i) * GRIDSIZE,
        0, 4, 4)
    end
    for i = y, height + 1     do 
        love.graphics.draw(spriteSheet, gameLoopScreen.borderSprites[1],
        (width + 1) * GRIDSIZE,
        (i) * GRIDSIZE,
        0, 4, 4)
    end
end

local function drawBg()
    love.graphics.setColor(1,1,1,1)

    blurEffect(function ()
    for j = 1, #gameLoopScreen.bg do
        for i = 1, #gameLoopScreen.bg[j].tiles[gameLoopScreen.bg[j].curr] do
            love.graphics.draw(spriteSheet, gameLoopScreen.bg[j].sprite,
                (gameLoopScreen.bg[j].posX + gameLoopScreen.bg[j].tiles[gameLoopScreen.bg[j].curr][i].x + offsetX ) * GRIDSIZE,
                (gameLoopScreen.bg[j].posY + gameLoopScreen.bg[j].tiles[gameLoopScreen.bg[j].curr][i].y + offsetY) * GRIDSIZE,
                0, 4, 4)
        end
   end 
   end)

   love.graphics.setColor(1,1,1,1)

end

gameLoopScreen.draw = function ()
    drawBg()

    for i = 1, #gameLoopScreen.ui do 
        gameLoopScreen.ui[i]:draw()
    end

    drawBorder(WIDTH - offsetX  + 1,offsetY ,5 + WIDTH - offsetX ,4)
    drawTetrominoHold()

    pushPop(function ()
        love.graphics.translate(2 * GRIDSIZE,0)
        drawBorder(WIDTH + offsetX + 2, offsetY, WIDTH + offsetX +  6 ,14 )
        drawTetrominoQueue()
    end)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle('fill' , (offsetX + 1) * GRIDSIZE ,2 *GRIDSIZE, GRIDSIZE * WIDTH ,GRIDSIZE * HEIGHT)
    love.graphics.setColor(1,1,1,1)



    glowEffect(function ()

        local currTetro = gameLoopScreen.currTetromino  
        for i = 1, #currTetro.tiles[currTetro.curr] do
            pushPop(function ()
                love.graphics.translate(32,0)
                
            end)
            love.graphics.draw(spriteSheet, currTetro.sprite,
                (currTetro.posX + currTetro.tiles[currTetro.curr][i].x + offsetX ) * GRIDSIZE,
                (currTetro.posY + currTetro.tiles[currTetro.curr][i].y + offsetY) * GRIDSIZE,
                0, 4, 4)
            end
        end) 

    pushPop(function ()
        love.graphics.translate(32,0)
        drawBorder(offsetX,offsetY,WIDTH + offsetX - 1,HEIGHT)
        drawShadow()

        for y = 0, #gameLoopScreen.map do
            for x = 0, #gameLoopScreen.map[y] do
                if gameLoopScreen.map[y][x] ~= 0 then
                    love.graphics.draw(spriteSheet, sprites[gameLoopScreen.map[y][x]],
                        (x + offsetX) * GRIDSIZE,
                        (y + offsetY) * GRIDSIZE,
                        0, 4, 4)
                end
            end
        end
    end)
end


gameLoopScreen.events = function (key, scancode, isrepeat)
    local currTet = gameLoopScreen.currTetromino
    if not isrepeat then
        if key == "up" then
            local rotation = (currTet.curr + 1) % (#currTet.tiles + 1)
            if rotation == 0 then rotation = 1 end
            local prev_rotation = currTet.curr
            currTet.curr = rotation


            if not collided(false) then
                for k = 1, #currTet.tiles[currTet.curr] do
                    if (currTet.posY + currTet.tiles[currTet.curr][k].y >= HEIGHT) then currTet.posY = HEIGHT - 1 -
                            currTet.tiles[currTet.curr][k].y end
                    if (currTet.posX + currTet.tiles[currTet.curr][k].x >= WIDTH) then currTet.posX = WIDTH - 1 -
                            currTet.tiles[currTet.curr][k].x end
                    if (currTet.posX + currTet.tiles[currTet.curr][k].x <= 0) then currTet.posX = currTet.tiles[currTet.curr][k].x end
                end
            else
                while (collided() and rotation ~= prev_rotation) do
                    rotation = (rotation + 1) % (#currTet.tiles + 1)
                    if rotation == 0 then rotation = 1 end
                    currTet.curr = rotation
                end

                if collided() then rotation = prev_rotation end

                currTet.curr = rotation
            end
        elseif key == "space" then
            gameLoopScreen.fastFall = true
        elseif key == "down" and not gameLoopScreen.fastFall then
            moveCurr(0, 1)
        elseif key == "left" and not gameLoopScreen.fastFall then
            moveCurr( -1, 0)
        elseif key == "right" and not gameLoopScreen.fastFall then
            moveCurr(1, 0)
        elseif key == "d" then
            printMap()
        elseif key == "c" and not gameLoopScreen.hold.usedThisTick then
            local tmp = deepcopy(gameLoopScreen.hold.curr)

            gameLoopScreen.hold.curr = deepcopy(gameLoopScreen.currTetromino)
            gameLoopScreen.hold.posY = 0
            gameLoopScreen.hold.posX = WIDTH / 2
            gameLoopScreen.hold.usedThisTick = true

            if tmp == nil then
                loadNextTetrimino()
            else
                tmp.posY = 0
                tmp.posX = WIDTH / 2
                gameLoopScreen.currTetromino = deepcopy(tmp)
            end
        end
    else
        if key == "left" and not gameLoopScreen.fastFall then
            moveCurr( -1, 0)
        elseif key == "right" and not gameLoopScreen.fastFall then
            moveCurr(1, 0)
        elseif key == "down" and not gameLoopScreen.fastFall then
            moveCurr(0, 1)
        end
    end
end