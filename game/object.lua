module("object",package.seeall) do

    local Object = {scale=1}
    Object.__index = Object
    
    function Object:draw()
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(self.img,self.x,self.y,0,self.scale)
    end
    
    function Object:update()
        
    end
    
    function new(x,y,img,textoverlay,func,scale)
        local object = {
            x = x,
            y = y,
            img = img,
            width = img:getWidth(),
            height = img:getHeight(),
            text = textoverlay,
            f = func,
            scale = scale,
            depth = 1
        }
        setmetatable(object,Object)
        return object
    end
    
end
