function love.load()
    rob = {
        img = love.graphics.newImage("rob.png"),
        x = 200,
        y = 100,
        Vx = 50
    }
    function rob:update(dt)
        if love.keyboard.isDown('d') then
            self.x = self.x + self.Vx*dt
        elseif love.keyboard.isDown('a') then
            self.x = self.x - self.Vx*dt
        end
    end
    function rob:draw()
        love.graphics.draw(self.img,self.x,self.y)
    end
end --load()

function love.draw()
    love.graphics.setBackgroundColor(100,100,100,255)
    rob:draw()
end --draw()

function love.update(dt)
    rob:update(dt)
end --update()
