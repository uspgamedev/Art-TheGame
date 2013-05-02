module('camera',package.seeall)

x = 0
y = 0
paintables = {}

function set()
	love.graphics.push()
	love.graphics.translate(-x,-y)
end

unset = love.graphics.pop

function translate( dx, dy )
	x = x + (dx or 0)
	y = y + (dy or 0)
end

function setTranslation( tx, ty )
	x = tx or x
	y = ty or y
end

function add( paintable )
	local ind = 1
	paintable.parallax = paintable.parallax or 1/paintable.depth
	--table.insert(paintables,paintable)

	for i=1,#paintables do
		if paintables[i].parallax > paintable.parallax then
			ind = i
			break
		end
	end
	--table.sort(paintables, function(a, b) return a.parallax < b.parallax end)
	table.insert(paintables, ind, paintable)
end

function draw()
	local bakx, baky = 0, 0
	for _,v in ipairs(paintables) do
		bakx, baky = x,y
		x, y = x*v.parallax, y*v.parallax
		set()
		v:draw()
		unset()
		x, y = bakx, baky
	end
end

function clear()
	for i=1,#paintables do
		paintables[i] = nil
	end
end