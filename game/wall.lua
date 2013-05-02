module ("wall",package.seeall) do
    local Wall = {}
    Wall.__index = Wall
    
    function Wall:draw()
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)  
    end
    
    function Wall:update(dt)
        if collides(rob,self) then
            if self.collides then
                if rob.x+3>self.x then rob.x = self.x+self.width*self.scale
                else rob.x = self.x-rob.width*rob.scale end
            end
            if self.f then self.f() end
       end
    end
    function new(x,y,w,h,func,collides)
        local wall = {
            x = x,
            y= y,
            width = w or 30,
            height = h or 300,
            color = {255,0,0,255},
            depth = 1,
            scale = 1,
            f = func
        }
        if collides==false then wall.collides = false
        else wall.collides = true end
        setmetatable(wall,Wall)
        return wall
    end
end
