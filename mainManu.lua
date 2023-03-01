local Text = require("text")
local moonshine = require ("moonshine")

mainMenuScreen = {}


mainMenuScreen.load = function ()
    local textOffset = 5
    local textScale = 1.7

    local playText = Text:new("Play",  GRIDSIZE * 5, 2*GRIDSIZE +   (HEIGHT - 3 *   textOffset) * GRIDSIZE )
    local SettingText = Text:new("Setting",GRIDSIZE * 5, 2*GRIDSIZE +  (HEIGHT - 2 * textOffset) * GRIDSIZE )
    local ExitText = Text:new("Exit",  GRIDSIZE * 5, 2*GRIDSIZE +  (HEIGHT - 1 * textOffset) * GRIDSIZE )
    playText.onClick = function () Screen.selectScreen(2) end
    ExitText.onClick = function () love.event.quit() end
    playText.color = {0.5,1,0.5,1}
    SettingText.color = {1,1,0,1}
    ExitText.color = {1,0,0,1}


    mainMenuScreen.btns = {playText,SettingText,ExitText}
    
    textOffset = 4


    mainMenuScreen.Logo = {
        Text:new("T", 0           ,  0 ,textScale),
        Text:new("E", 1 *      textOffset  * GRIDSIZE   ,  0,textScale),
        Text:new("T", 2 *    textOffset * GRIDSIZE,  0,textScale),
        Text:new("R", 3 *   textOffset  * GRIDSIZE, 0,textScale),
        Text:new("I", 4 *   textOffset  * GRIDSIZE, 0,textScale),
        Text:new("S", 5 *   textOffset  * GRIDSIZE,0,textScale),
    }


    effect = moonshine(moonshine.effects.glow)
    effect.glow.strength = 3

end
mainMenuScreen.update = function ()
    for i = 1, #mainMenuScreen.btns do
        mainMenuScreen.btns[i]:update()
    end


    for i = 1, #mainMenuScreen.btns do
        if mainMenuScreen.btns[i].hoverOver then
            isHand = true
            if love.mouse.isDown(1) then
                mainMenuScreen.btns[i].onClick()
            end
        end
    end

    for i = 1 ,#mainMenuScreen.Logo do 
        mainMenuScreen.Logo[i]:setY((math.sin(love.timer.getTime() * 3 + (i - 1) * GRIDSIZE ) * 40))
    end

end

mainMenuScreen.draw = function ()
    for i = 1, #mainMenuScreen.btns do
        if mainMenuScreen.btns[i].hoverOver then 
            mainMenuScreen.btns[i]:setX(mainMenuScreen.btns[i].defaulX +  math.sin(love.timer.getTime() * 100) * 2  )
            love.graphics.setColor(mainMenuScreen.btns[i].color[1],mainMenuScreen.btns[i].color[2],mainMenuScreen.btns[i].color[3],mainMenuScreen.btns[i].color[4])
        effect(function ()
            mainMenuScreen.btns[i]:draw()
            
        end)
        else 
            mainMenuScreen.btns[i]:setX(mainMenuScreen.btns[i].defaulX)
            mainMenuScreen.btns[i]:draw()

        end


        love.graphics.setColor(1,1,1,1)
    end    



    love.graphics.setColor(0.4,0.4,0.4,1)
    pushPop(function ()
        love.graphics.translate(GRIDSIZE * 3.5,60)
        for i = 1, #mainMenuScreen.Logo do
            mainMenuScreen.Logo[i]:draw()
        end
    end)
    love.graphics.setColor(1,1,1,1)
    effect(function ()
        for i = 1, #mainMenuScreen.Logo do
            pushPop(function ()
                love.graphics.translate(GRIDSIZE * 3.5,50)
                mainMenuScreen.Logo[i]:draw()
            end)
        end   
    end)
end


mainMenuScreen.events = function () end
