require "utils"

local Text = {}

function Text:new(text,x,y,scale,obj)
    obj = obj or {}
    setmetatable(obj,self)
    self.__index = self

    self.x = x 
    self.y = y 

    self.defaulX = self.x
    self.defaulY = self.y
    self.text = text
    self.hoverOver = false
    self.font = love.graphics.getFont()
    self.scale = scale or 1
    self.color = {1,1,1,1}
    
    self.effects = {}

    self.onClick = function () end

    return deepcopy(obj)
end


function Text:setY(y)
    self.y = y 
end
function Text:setX(x)
    self.x = x
end

function Text:update()
    self.hoverOver = (love.mouse.getX() > self.x and love.mouse.getX() < self.x + self.font:getWidth(self.text)) and
                     (love.mouse.getY() > self.y and love.mouse.getY() < self.y + self.font:getHeight())
end

function Text:draw()
    local y = self.y 
    if type(y) == 'table' then
        y = y.y
    end

    love.graphics.print(self.text,self.x,y,0,self.scale,self.scale)

end

return Text