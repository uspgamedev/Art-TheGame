require "timer"
module("sprite",package.seeall) do
    sps = {}
    local Sprite = {}
    Sprite.__index = Sprite
    
    function Sprite:update(dt)
        
    end
    
    function Sprite:draw(x,y)
        love.graphics.drawq(self.image,self.quad,x or self.x,y or self.y)
    end
    function Sprite:nextframe()
        self.i = self.i + 1 
        if self.i>=self.maxframe then self.i=0 end
		self.quad:setViewport(self.i*self.width,0,self.width,self.width*self.maxframe)
    end
    
    function new(image,width,step,x,y)
        local sprite = {}
        setmetatable(sprite,Sprite)
        sprite.width = width
        sprite.frame = 0
		sprite.x = x or 0
		sprite.y = y or 0
        sprite.maxframe = image:getWidth()/width
        sprite.image = image
        sprite.step = step or .1
        sprite.i = 0
        sprite.quad = love.graphics.newQuad(0,0,width,image:getHeight(),image:getWidth(),image:getHeight())
        sprite.timer = timer.new(step or .1, function() sprite:nextframe() end)
        return sprite
    end
end
