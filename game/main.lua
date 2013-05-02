require "object"
require "global"
require "timer"
require "sprite"
require "wall"
require "camera"

width, height = 800, 600

function initLevels()
	level1 =  {walls={wall.new(30,300),wall.new(1000,300,nil,nil,function() loadLevel(level2) end)}
	                ,objsfg={},objsbg={}}
	local obj = object.new(520,500,love.graphics.newImage("resources/piston.png"),"Initiative",function(obj) global.overlay2 = "108 minutes to end of the world" end,.6)
	obj.y = 600 - obj.height*obj.scale
	level1.objsbg[1] = obj
	obj = object.new(200,0,love.graphics.newImage("resources/piston.png"),"Dharma",nil,.6)
	obj.y = 600 - obj.height*obj.scale
	level1.objsfg[1] = obj
	level1.playerPosX = 500
    level1.width = 1050
	
	level2 =  {walls={wall.new(0,300,100),wall.new(700,300,100,nil,function() loadLevel (level3) end)}
	            ,objsbg={},objsfg={object.new(420,500,love.graphics.newImage("resources/piston.png"),
		            "KATE, WE HAVE TO GO BACK",function(obj) loadLevel(level1) end,.6)}
		        ,playerPosX=100}
    
    level3 = {walls={wall.new(1,300,30,nil,function() loadLevel (level2) end),wall.new(750,300,30),wall.new(200,300,200,400,nil,false)}
                ,playerPosX=100}
end

function updateCamera( player, dt )
    local dx = between( player.x + player.width/2 - width/2, 0, levelwidth - width)
    camera.setTranslation( camera.x - (camera.x - dx)*dt*7 )
    
end

function createPlayer()
    rob = {
        imgs = {walking=sprite.new(love.graphics.newImage("resources/rainbowrob.png"),180,1,false),standing=love.graphics.newImage("resources/rob.png")},
        imgindex = "standing",
        x = 200,
        y = 340,
        width = 180,
        height = 210,
        scale=1,
        parallax = .999,
        Vx = 300
    }
    function rob:update(dt)
        if love.keyboard.isDown('d') then self.x = self.x + self.Vx*dt end
        if love.keyboard.isDown('a') then self.x = self.x - self.Vx*dt end
        updateCamera(self,dt)

        local collided = false
        for _,ob in ipairs({object.objsfg,object.objsbg}) do
            for a,b in ipairs(ob) do
                if collides(self,b) then
                    global.overlay = b.text
                    objectintouch = b
                    collided = true
                    break 
                end
            end
        end
        if not collided then global.overlay = nil objectintouch=nil end
    end
    function rob:draw()
        love.graphics.setColor(255,255,255,255)
        if self.imgs[self.imgindex].isSprite then self.imgs[self.imgindex]:draw(self.x,self.y)
        else love.graphics.draw(self.imgs[self.imgindex],self.x,self.y) end
    end
	function rob:walk(flip)
		global.overlay2 = nil
        rob.imgindex="walking"
        rob.imgs.walking:start()
        rob.imgs.walking:setflip(flip)
	end
	function rob:stand()
		rob.imgindex = "standing"
		rob.imgs.walking:stop()
	end
end

function love.load()

   
    bgobj = { bg = love.graphics.newImage("resources/bg.jpg"), depth = 8 }
    function bgobj:draw()
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(self.bg,0,0,0,.67)
    end


    createPlayer()
    camera.translate(100,0)

    paintables = {}
	initLevels()
    loadLevel(level1)
end --load()

function initLevel( level )
    if level.initialized then return end

    if level.objsfg then
        for _,obj in ipairs(level.objsbg) do
            obj.depth = obj.depth*.999
        end
    end

    level.initialized = true
end

function loadLevel(level)
    initLevel(level)

	wall.ws = level.walls or {}
	object.objsfg = level.objsfg or {}
    object.objsbg  = level.objsbg or {}
	sprite.sps = level.sps or {}
	paintables.walls = wall.ws
    paintables.objsfg = object.objsfg
    paintables.objsbg = object.objsbg
	paintables.sps = sprite.sps
	rob.x= level.playerPosX or rob.x 
	rob.y = level.playerPosY or rob.y
    levelwidth = level.width or 800

    for _,obj in ipairs(object.objsbg) do
        obj.depth = obj.depth*.99
    end

    camera.clear()
    for _,a in pairs(paintables) do
        for __,paintable in ipairs(a) do
            camera.add(paintable)
        end
    end
    camera.add(rob)
    camera.add(bgobj)
end --loadLevel()

function collides(t1,t2)
    return (not((t1.y+t1.height*t1.scale<t2.y) or (t1.y>t2.y+t2.height*t2.scale))) and (not((t1.x+t1.width*t1.scale<t2.x) or (t1.x>t2.x+t2.width*t2.scale)))
end --collides(t1,t2)

function love.draw()
    love.graphics.setBackgroundColor(100,100,100,255)
    
    --rob:draw()

    love.graphics.setColor(0,200,0,255)

    camera.draw()

    if global.overlay and not global.overlay2 then love.graphics.print(global.overlay,350,50) end --mudar pra printf com centralização e  tal
    if global.overlay2 then love.graphics.print(global.overlay2,150,50) end
end --draw()

function love.update(dt)
    timer.update(dt,1,false)
    rob:update(dt)
    for a,b in pairs(paintables) do
        for i,v in pairs(b) do
            v:update(dt)
        end
    end
end --update(dt)

function love.keypressed(key,code)
    if key=='e' and objectintouch~=nil and (love.keyboard.isDown('a') == love.keyboard.isDown('d'))then
        if objectintouch.f~=nil then objectintouch.f(objectintouch) end
    end
    if key=='a' or key=='d' then
        if love.keyboard.isDown('a') ~= love.keyboard.isDown('d') then rob:walk(key=='a')
		else rob:stand() end
    end
end --keyPressed()

function love.keyreleased(key,code)
    if key=='a' or key=='d' then
		if love.keyboard.isDown('a') ~= love.keyboard.isDown('d') then rob:walk(key=='d')
		else rob:stand() end
    end
end

function between(x, min, max)
  return x < min and min or (x > max and max or x)
end
