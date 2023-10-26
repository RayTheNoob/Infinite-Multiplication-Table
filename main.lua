function love.load()
	c = 0
	size = 64
	uisize = 64
	cam = {x=size*-5,y=size*-5}
	lastMx = 0
	lastMy = 0
	font = love.graphics.newFont(size)
	windowCerp = 0
	drawWindow = false
	windowToggle = true
	speed = 200
	speedTable = {50,200,500,1000,10000,500000,1000000,1000000000,1000000000000}
	love.window.setTitle('Infinite Multiplication Table')
	titleFade = 8
	highlight = true
	bookmark = {}
	mTimer = 99
	message = "Welcome"
end
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
function boolText(bool)
	if bool then return "enabled" end
	return "disabled"
end
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
function love.update(dt)
	if titleFade > -2 then titleFade = titleFade-math.abs(dt) end
	mTimer = mTimer - math.abs(dt)
	mTimer = clamp(0,mTimer,4)

	local globalX, globalY = love.graphics.inverseTransformPoint(love.mouse.getX(),love.mouse.getY())
	mx = math.floor(globalX/size)*size
	my = math.floor(globalY/size)*size
	if my>0 and mx>0 and windowToggle then
		windowCerp = windowCerp + love.timer.getDelta()
		drawWindow = true
	else
		windowCerp = windowCerp - love.timer.getDelta()
		drawWindow = false
	end
	windowCerp = clamp(0,windowCerp,1)
	c = c + dt
	--cam.x = cam.x + 1
	--cam.y = cam.y + 1
	for i=1,9 do
		if love.keyboard.isDown(tostring(i)) then
				speed = speedTable[i]
				mTimer = 99
				message = "Speed set to "..i
			end
		end
	if love.keyboard.isDown("x") then
		bookmark = {}
		mTimer = 99
		message = "Bookmark deleted"
	elseif love.keyboard.isDown("c") then
		if bookmark.x ~= nil and not love.mouse.isDown(1) then
			cam.x = bookmark.x - love.graphics.getWidth()/2 + size/2
			cam.y = bookmark.y - love.graphics.getHeight()/2 + size/2
			mTimer = 99
			message = "Moved to bookmark"
		end
	end
	if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
	cam.x = cam.x - speed * dt
	end
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
	cam.x = cam.x + speed * dt
	end
	if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
	cam.y = cam.y - speed * dt
	end
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
	cam.y = cam.y + speed * dt
	end
	--[[
	if love.keyboard.isDown("=") then
		size = size + 1
	end
	if love.keyboard.isDown("-") then
		size = size - 1
	end
	--]]
	if cam.x < size*-5 then cam.x = size*-5 end
	if cam.y < size*-5 then cam.y = size*-5 end

	if love.mouse.isDown(1) and not love.keyboard.isDown("c") then
		bookmark.x = mx
		bookmark.y = my
		mTimer = 99
		message = "Bookmark set"
	end
end

function drawGrid()	
	love.graphics.setLineWidth(3)
	for j=1,math.ceil(love.graphics.getHeight()/size)+1 do
		for i=1,math.ceil(love.graphics.getWidth()/size)+1 do
			gx = math.floor(cam.x/size)*size
			gy = math.floor(cam.y/size)*size

			numbx = (gx/size)+i
			numby = (gy/size)+j
			locx = gx+(size*(i-1))
			locy = gy+(size*(j-1))

			--if numbx > 0 and numby > 0 then
				love.graphics.setColor(168/255, 50/255, 50/255)
				local colorZoom=6
				love.graphics.setColor(1,math.sin(numbx/colorZoom)/4+0.5,math.cos(numby/colorZoom)/4+0.5)
				if numbx == 1 or numby ==1 or numbx == numby then
					love.graphics.setColor(math.sin(numbx/colorZoom)/4+0.5,math.cos(numby/colorZoom)/4+0.5,1)
				end
				if bookmark.x ~= nil and highlight and bookmark.x == math.abs(bookmark.x) then
					if (numbx*numby == ((bookmark.x/size)+1)*((bookmark.y/size)+1)) then
						love.graphics.setColor(0,0,1)
					end
				end
				if numbx*numby == (mx/size+1) * (my/size+1) and highlight and mx/size+1 == math.abs(mx/size+1) then
					love.graphics.setColor(1,1,0)
				end
				--local r, g, b, a = love.graphics.getColor()
				--love.graphics.setColor(r,g,b)
				if numbx < 1 or numby < 1 then
					love.graphics.setColor(0,0,0)
					if numbx < -4 or numby < -4 then
						love.graphics.setColor(1,0,0)
					end
				end
				love.graphics.rectangle('fill',locx,locy,size,size)
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle('line',locx,locy,size,size)
				--love.graphics.print(numbx.."x"..numby,locx,locy)
				if numbx > 0 and numby > 0 then
love.graphics.print(numbx*numby,font,locx+size/2,locy+size/2,nil,1/font:getWidth(numbx*numby)*size,nil,font:getWidth(numbx*numby)/2,font:getHeight('6')/2)
				end
		end
	end
end
function camMove()
	love.graphics.translate(cam.x*-1,cam.y*-1)
end
function love.draw()
	love.graphics.setColor(1,1,1)
	local text = "\"Infinite\" Multiplication Table"
	camMove()
	drawGrid()
	love.graphics.setLineWidth(love.graphics.getLineWidth()*2)
	love.graphics.setColor(1,1,0,0.75)
	local dmx = mx
	local dmy = my
	if windowToggle or highlight then love.graphics.rectangle('line',dmx,dmy,size,size) end
	love.graphics.setColor(0,0,1,0.75)
	if bookmark.x ~= nil then love.graphics.rectangle('line',bookmark.x,bookmark.y,size,size) end
	if cam.x<0 and cam.y<0 then
		local ox = math.floor(math.sin(c/2)*50)
		local oy = math.floor(math.cos(c/2)*50)
		love.graphics.setColor(1,1,1)
		love.graphics.print("Press \"T\" to toggle info box",10-size*4+ox,10-size*4+oy)
		love.graphics.print("Press \"H\" to return home",(10-size*4)+ox,(10-size*4)+25+oy)
		love.graphics.print("Press \"L\" to toggle highlighting",(10-size*4)+ox,(10-size*4)+50+oy)
		love.graphics.print("Press arrow keys to move",(10-size*4)+ox,(10-size*4)+75+oy)
		love.graphics.print("Press arrow keys or WASD to move",(10-size*4)+ox,(10-size*4)+100+oy)
		love.graphics.print("Press number keys 1-9 to change speed",(10-size*4)+ox,(10-size*4)+125+oy)
		--love.graphics.print("Press number keys 1-9 to change speed",(10-size*4)+ox,(10-size*4)+150+oy)
		love.graphics.print("Click on a square to set bookmark",(10-size*4)+ox,(10-size*4)+150+oy)
		love.graphics.print("Press \"X\" to delete bookmark",(10-size*4)+ox,(10-size*4)+175+oy)
		love.graphics.print("Press \"C\" set view to location of bookmark",(10-size*4)+ox,(10-size*4)+200+oy)
	end
	love.graphics.origin()
	--love.graphics.translate(0,)
	local ypos = love.graphics.getHeight()-cerp(0,uisize*2+love.graphics.getLineWidth()/2,windowCerp) + love.graphics.getLineWidth()
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.rectangle('fill',uisize,ypos,love.graphics.getWidth()-uisize*2,uisize*2,uisize/2,uisize/2)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line',uisize,ypos,love.graphics.getWidth()-uisize*2,uisize*2,uisize/2,uisize/2)
	if drawWindow  then
		local n1 = mx/size+1
		local n2 = my/size+1
		love.graphics.print(n1*n2,font,love.graphics.getWidth()/2,ypos,0,nil,nil,font:getWidth(n1*n2)/2)
		love.graphics.print(n1..' x '..n2,font,love.graphics.getWidth()/2,ypos+font:getHeight('2'),0,0.5,nil,font:getWidth(n1..' x '..n2)/2)
	end
	if titleFade > 0 then
		local opacity = cerp(0,1,clamp(0,titleFade,1))
		love.graphics.setColor(0,0,0,opacity)
		love.graphics.print(text,font,love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,0.75,nil,font:getWidth(text)/2)
		love.graphics.setColor(1,1,1,opacity)
		love.graphics.print(text,font,love.graphics.getWidth()/2,love.graphics.getHeight()/2-3,0,0.75,nil,font:getWidth(text)/2)
	end
	if mTimer ~= 0 then
		local s = 0.25
		love.graphics.setColor(0,0,0,cerp(0,1,clamp(0,mTimer,1)))
		love.graphics.print(message,font,love.graphics.getWidth()-10,12,0,s,nil,(font:getWidth(message)))
		love.graphics.setColor(1,1,1,cerp(0,1,clamp(0,mTimer,1)))
		love.graphics.print(message,font,love.graphics.getWidth()-10,10,0,s,nil,(font:getWidth(message)))
	end
	camMove()
end

function love.keypressed(key,scan)
	if key == "t" then
		windowToggle = not windowToggle
		mTimer = 99
		message = "Infobox "..boolText(windowToggle)
	elseif key == "h" then
		cam.x = size*-1
		cam.y = size*-1
		mTimer = 99
		message = "Returned home"
	elseif key == "l" then
		highlight = not highlight
		mTimer = 99
		message = "Highlighting "..boolText(highlight)
	end
end
