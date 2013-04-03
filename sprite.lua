require "timer"
module("sprite",package.seeall) do
    sps = {}
    local Sprite = {}
    Sprite.__index = Sprite
    
    function Sprite:update(dt)
        
    end
    
    function Sprite:draw()
        love.graphics.drawq(self.image,self.quad,self.x,self.y)
    end
    function Sprite:nextframe()
        self.i = self.i + 1 
        if self.i>self.maxframe then self.i=0 end
        self.quad.x = self.i*self.width
    end
    
    function new(image,x,y,width,step)
        local sprite = {}
        setmetatable(sprite,Sprite)
        sprite.x = x
        sprite.width = width
        sprite.frame = 0
        sprite.maxframe = image:getWidth()/width
        sprite.y = y
        sprite.image = image
        sprite.step = step or .1
        sprite.i = 0
        sprite.quad = love.graphics.newQuad(0,0,width,image:getHeight(),image:getWidth(),image:getHeight())
        sprite.timer = timer.new(step or .1, function() sprite:nextframe() end)
        return sprite
    end
end
