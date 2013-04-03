require "object"
require "global"
require "timer"
require "sprite"


function initLevels()
	level1 =  {{newWall(30,300),newWall(750,300)},{}}
	local obj = object.new(520,500,love.graphics.newImage("piston.png"),"Initiative",function(obj) global.overlay2 = "108 minutes to end of the world" end,.6)
	obj.y = 600 - obj.height*obj.scale
	level1[2][1] = obj
	obj = object.new(200,0,love.graphics.newImage("piston.png"),"Dharma",function(obj) loadLevel(level2) end,.6)
	obj.y = 600 - obj.height*obj.scale
	level1[2][2] = obj
	level2 =  {{newWall(0,300,100),newWall(700,300,100)},{object.new(420,500,love.graphics.newImage("piston.png"),
		"KATE, WE HAVE TO GO BACK",function(obj) loadLevel(level1,100) end,.6)}}
end

function love.load()
    bg = love.graphics.newImage("bg.jpg")
    rob = {
        img = sprite.new(love.graphics.newImage("rob.png"),200,340,180,1),
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
        for a,b in ipairs(object.objs) do
            if collides(self,b) then
                global.overlay = b.text
                objectintouch = b
                collided = true
                break 
            end
        end
        if not collided then global.overlay = nil objectintouch=nil end
    end
    function rob:draw()
        love.graphics.setColor(255,255,255,255)
        self.img:draw()
    end
    paintables = {}
    walls = {}
    paintables[1] = walls
    paintables[2] = object.objs
    paintables[3] = sprite.sps
	initLevels()
    loadLevel(level1)
end --load()

function loadLevel(level,playerPosX,playerPosY)
	walls = level[1] or walls
	object.objs = level[2] or object.objs
	sprite.sps = level[3] or sprite.sps
	if playerPosX then rob.x= playerPosX end
	if playerPosY then rob.y = playerPosY end
end --loadLevel()

function newWall(x,y,w,h)
    local wall = {
        x = x,
        y= y,
        width = w or 30,
        height = h or 300,
        color = {255,0,0,255},
        scale = 1
    }
    function wall:draw()
        love.graphics.setColor(self.color)
        love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)    
    end
    function wall:update(dt)
        if collides(rob,self) then
            if rob.x+3>self.x then rob.x = self.x+self.width*self.scale
            else rob.x = self.x-rob.width*rob.scale end
       end
    end
    return wall
end --newWall(x,y,w,h)

function collides(t1,t2)
    return (not((t1.y+t1.height*t1.scale<t2.y) or (t1.y>t2.y+t2.height*t2.scale))) and (not((t1.x+t1.width*t1.scale<t2.x) or (t1.x>t2.x+t2.width*t2.scale)))
end --collides(t1,t2)

function love.draw()
	love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg,0,0,0,.67)
    love.graphics.setBackgroundColor(100,100,100,255)
    rob:draw()
    --love.graphics.rectangle("line",rob.x,rob.y,rob.width,rob.height)
    love.graphics.setColor(0,200,0,255)
    for a,b in pairs(paintables) do
        for i,v in pairs(b) do
            v:draw()
            --love.graphics.rectangle("line",v.x,v.y,v.width*v.scale,v.height*v.scale) --debugging bounds
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
            v:update(dt)
        end
    end
end --update(dt)

function love.keypressed(key,code)
    if key=='e' and objectintouch~=nil and not(love.keyboard.isDown('a') or love.keyboard.isDown('d'))then
        if objectintouch.f~=nil then objectintouch.f(objectintouch) end
    end
    if key=='a' or key=='d' then global.overlay2 = nil end
end --keyPressed()
