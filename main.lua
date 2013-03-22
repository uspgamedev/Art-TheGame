function love.load()
    rob = {
        img = love.graphics.newImage("rob.jpg"),
        x = 200,
        y = 100,
        Vx = 50
    }
    function rob:gororoba(k)
        if love.keyboard.isDown('d') then
            self.x = self.x + self.Vx*k
        end
    end
    function rob:draw()
        love.graphics.draw(self.img,self.x,self.y)
    end
end --load()

function love.draw()
    rob:draw()
end --draw()

function love.update(dt)
    rob:gororoba(dt)
end --update()
