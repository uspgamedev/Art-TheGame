require "timer"
module("sprite",package.seeall) do
    sps = {}
    local Sprite = {}
    Sprite.__index = Sprite
    Sprite.isSprite = true
    
    function Sprite:update(dt)
        
    end
    
    function Sprite:draw(x,y)
        love.graphics.drawq(self.image,self.quad,x or self.x,y or self.y)
    end
    
    function Sprite:nextframe()
        self.i = self.i + 1 
        if self.i>=self.maxframe then self.i=0 end
		self.quad:setViewport(self.i*self.width,0,self.width,self.width*self.maxframe)
		if self.flipped then self.quad:flip(true) end
    end
    
    function Sprite:stop()
        self.timer:stop()
        self.i = 0
        self.quad:setViewport(0,0,self.width,self.width*self.maxframe)
    end
    
    function Sprite:start()
        self.timer:start()
        self.quad:flip(self.flipped)
    end
    
    function Sprite:setflip(flip)
        self.quad:flip(flip == not self.flipped)
        self.flipped = flip
    end
    
    function new(image,width,step,starts,flipped)
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
        sprite.flipped = flipped or false
        if flipped then sprite.quad:flip(true) end
        if starts == nil then starts = true end
        sprite.timer = timer.new(step or .1, function() sprite:nextframe() end,starts)
        return sprite
    end
end
