require "object"
require "global"
require "timer"
require "sprite"
require "wall"

translateX = 50

function initLevels()
	level1 =  {walls={wall.new(30,300),wall.new(750,300,nil,nil,function() loadLevel(level2) end)}
	                ,objs={fg={},bg={}}}
	local obj = object.new(520,500,love.graphics.newImage("piston.png"),"Initiative",function(obj) global.overlay2 = "108 minutes to end of the world" end,.6)
	obj.y = 600 - obj.height*obj.scale
	level1.objs.bg[1] = obj
	obj = object.new(200,0,love.graphics.newImage("piston.png"),"Dharma",nil,.6)
	obj.y = 600 - obj.height*obj.scale
	level1.objs.bg[2] = obj
	level1.playerPosX = 500
	
	level2 =  {walls={wall.new(0,300,100),wall.new(700,300,100,nil,function() loadLevel (level3) end)}
	            ,objs={bg={},fg={object.new(420,500,love.graphics.newImage("piston.png"),
		            "KATE, WE HAVE TO GO BACK",function(obj) loadLevel(level1) end,.6)}}
		        ,playerPosX=100}
    
    level3 = {walls={wall.new(0,300,30,nil,function() loadLevel (level2) end),wall.new(750,300,30),wall.new(200,300,200,400,nil,false)}
                ,playerPosX=100}
end

function createPlayer()
    rob = {
        imgs = {walking=sprite.new(love.graphics.newImage("rainbowrob.png"),180,1,false),standing=love.graphics.newImage("rob.png")},
        imgindex = "standing",
        x = 200,
        y = 340,
        width = 180,
        height = 210,
        scale=1,
        Vx = 300
    }
    function rob:update(dt)
        if love.keyboard.isDown('d') then self.x = self.x + self.Vx*dt end
        if love.keyboard.isDown('a') then self.x = self.x - self.Vx*dt end
        local collided = false
        for _,ob in pairs(object.objs) do
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
    bg = love.graphics.newImage("bg.jpg")
    createPlayer()
    
    paintables = {}
	initLevels()
    loadLevel(level1)
end --load()

function loadLevel(level)
	wall.ws = level.walls or {}
	object.objs = level.objs or {bg={},fg={}}
    if not object.objs.fg then object.objs.fg = {} end
    if not object.objs.bg then object.objs.bg = {} end
	sprite.sps = level.sps or {}
	paintables.walls = wall.ws
	paintables.objs = object.objs
	paintables.sps = sprite.sps
	rob.x= level.playerPosX or rob.x 
	rob.y = level.playerPosY or rob.y
end --loadLevel()

function collides(t1,t2)
    return (not((t1.y+t1.height*t1.scale<t2.y) or (t1.y>t2.y+t2.height*t2.scale))) and (not((t1.x+t1.width*t1.scale<t2.x) or (t1.x>t2.x+t2.width*t2.scale)))
end --collides(t1,t2)

function love.draw()
	love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg,0,0,0,.67)
    love.graphics.setBackgroundColor(100,100,100,255)
    for i,v in ipairs(object.objs.bg) do
        love.graphics.translate(translateX*(v.parallax or 1),0)
        v:draw()
        love.graphics.translate(-translateX*(v.parallax or 1),0)
        --love.graphics.rectangle("line",v.x,v.y,v.width*v.scale,v.height*v.scale) --debugging bounds
    end
    
    rob:draw()
    --love.graphics.rectangle("line",rob.x,rob.y,rob.width,rob.height)
    love.graphics.setColor(0,200,0,255)
    for a,b in pairs(paintables) do
        if a=="objs" then 
            for _,v in ipairs(b.fg) do
                love.graphics.translate(translateX*(v.parallax or 1),0)
                v:draw()
                love.graphics.translate(-translateX*(v.parallax or 1),0)
                --love.graphics.rectangle("line",v.x,v.y,v.width*v.scale,v.height*v.scale) --debugging bounds
            end
        else 
            for _,v in ipairs(b) do
                love.graphics.translate(translateX*(v.parallax or 1),0)
                v:draw()
                love.graphics.translate(-translateX*(v.parallax or 1),0)
                --love.graphics.rectangle("line",v.x,v.y,v.width*v.scale,v.height*v.scale) --debugging bounds
           end
        end
    end
    if global.overlay and not global.overlay2 then love.graphics.print(global.overlay,350,50) end --mudar pra printf com centralização e  tal
    if global.overlay2 then love.graphics.print(global.overlay2,150,50) end
end --draw()

function love.update(dt)
    timer.update(dt,1,false)
    rob:update(dt)
    for a,b in pairs(paintables) do
        for i,v in pairs(b) do
            if i=="fg" or i=="bg" then
                for _,o in ipairs(v) do
                    o:update()
                end
            else v:update(dt) end
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
