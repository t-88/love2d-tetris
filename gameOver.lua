local moonshine = require ("moonshine")
local Text = require("text")
require("utils")


gameOverScreen = {
    gameOverText = {}
}

local effect

gameOverScreen.load = function ()
    local textOffset = 5
    local textScale = 1.7
    gameOverScreen.gameOverText = {
        Text:new("G", 0           ,  0 ,textScale),
        Text:new("A", 1 *      textOffset  * GRIDSIZE   ,  0,textScale),
        Text:new("M", 2 *    textOffset * GRIDSIZE,  0,textScale),
        Text:new("E", 3 *   textOffset  * GRIDSIZE, 0,textScale),
        Text:new("O", 0 *   textOffset  * GRIDSIZE, 5 * GRIDSIZE,textScale),
        Text:new("V", 1 *   textOffset  * GRIDSIZE,5 * GRIDSIZE,textScale),
        Text:new("R", 2 *   textOffset  * GRIDSIZE,5 * GRIDSIZE,textScale),
        Text:new("E", 3 *   textOffset  * GRIDSIZE,5 * GRIDSIZE,textScale),
    }

    textScale = 0.8
    local restartText = Text:new("Restart",  GRIDSIZE * 10    , 5 * GRIDSIZE +   (HEIGHT - 3 *   textOffset) * GRIDSIZE ,textScale)
    local backText = Text:new("Back"      ,  GRIDSIZE * 10    , 10  * GRIDSIZE +  (HEIGHT - 3 * textOffset) * GRIDSIZE ,textScale)
    restartText.onClick = function () Screen.selectScreen(2) end
    backText.onClick = function () Screen.selectScreen(1) end
    restartText.color = {0.5,1,0.5,1}
    backText.color = {1,1,0,1}

    gameOverScreen.btns = {restartText,backText}



    effect = moonshine(moonshine.effects.glow)
    effect.glow.strength = 2

end


gameOverScreen.update = function ()


    for i = 1 ,#gameOverScreen.gameOverText  do 
        gameOverScreen.gameOverText[i]:setY((math.sin(love.timer.getTime() * 3 + (i - 1) * GRIDSIZE ) * 10 + gameOverScreen.gameOverText[i].defaulY))
    end

    for i = 1, #gameOverScreen.btns do
        gameOverScreen.btns[i]:update()
    end

    for i = 1, #gameOverScreen.btns do
        if gameOverScreen.btns[i].hoverOver then
            isHand = true
            if love.mouse.isDown(1) then
                gameOverScreen.btns[i].onClick()
            end
            gameOverScreen.btns[i]:setX(gameOverScreen.btns[i].defaulX +  math.sin(love.timer.getTime() * 100) * 2  )
        else 
            gameOverScreen.btns[i]:setX(gameOverScreen.btns[i].defaulX)
            
        end
    end


 
end


gameOverScreen.draw = function ()


    for i = 1, #gameOverScreen.btns do
        if gameOverScreen.btns[i].hoverOver then 
            love.graphics.setColor(gameOverScreen.btns[i].color[1],gameOverScreen.btns[i].color[2],gameOverScreen.btns[i].color[3],gameOverScreen.btns[i].color[4])
            effect(function ()
                gameOverScreen.btns[i]:draw()
            end)
        else 
            gameOverScreen.btns[i]:draw()
        end
        love.graphics.setColor(1,1,1,1)
    end    


    love.graphics.setColor(1,1 ,1,1)
    love.graphics.push()
    love.graphics.translate(GRIDSIZE * 6,GRIDSIZE / 2 )
    effect(function ()
        for i = 1, #gameOverScreen.gameOverText do
                gameOverScreen.gameOverText[i]:draw()
        end
    love.graphics.setColor(1,1,1,1)
    love.graphics.pop()
end)


end


gameOverScreen.events = function (key, scancode, isrepeat)
    
end