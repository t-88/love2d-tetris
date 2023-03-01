require("utils")
require("mainManu")
require("gameLoop")
require("gameOver")
local moonshine = require ("moonshine")


local crtEffect 



function love.load()
    love.window.setTitle('Tetris')
    love.window.setMode((WIDTH + addSizeX) * GRIDSIZE, (HEIGHT + addSizeY) * GRIDSIZE)
    love.keyboard.setKeyRepeat(true, 0)

    spriteSheet = love.graphics.newImage('sources/NES - Tetris - Block Tiles.png')
    spriteSheet:setFilter('nearest', 'nearest')
    sources = {
        background = love.audio.newSource('sources/OriginalTetristheme.wav', 'stream'),
        destruction = love.audio.newSource('sources/destroyLine.wav', 'static'),
        lineFall = love.audio.newSource('sources/lock.mp3', 'static'),
    }
    sources.background:setLooping(true)
    sources.background:play()

    handCursor =  love.mouse.getSystemCursor("hand")

    mainFontNormal = love.graphics.newFont("sources/joystix monospace.otf", GRIDSIZE * 3)
    mainFontNormal:setFilter('nearest', 'nearest')
    love.graphics.setFont(mainFontNormal)


    Screen.selectScreen = function (state)
        Screen.currScreen = state
        Screen.Screens[Screen.currScreen].load()
        isHand = false
    end

    Screen.Screens = {}
    table.insert(Screen.Screens,mainMenuScreen)
    table.insert(Screen.Screens,gameLoopScreen)
    table.insert(Screen.Screens,gameOverScreen)

    Screen.selectScreen(1)


    crtEffect = moonshine(moonshine.effects.crt)
    crtEffect.crt.feather = 0.05
end

function love.update()
    isHand = false

    Screen.Screens[Screen.currScreen].update()


    if isHand then love.mouse.setCursor(handCursor)
    else  love.mouse.setCursor() end
end



function love.draw()

    crtEffect(function ()
        Screen.Screens[Screen.currScreen].draw()

        love.graphics.setColor(0.5,0.5,0.8,0.2)


        love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
    end)

end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
    Screen.Screens[Screen.currScreen].events(key, scancode, isrepeat)
end
