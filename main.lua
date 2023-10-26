function love.load()
	c = 0
	size = 64
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
end
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
function love.update(dt)
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
			end
		end
	if love.keyboard.isDown("left") then
	cam.x = cam.x - speed * dt
	end
	if love.keyboard.isDown("right") then
	cam.x = cam.x + speed * dt
	end
	if love.keyboard.isDown("up") then
	cam.y = cam.y - speed * dt
	end
	if love.keyboard.isDown("down") then
	cam.y = cam.y + speed * dt
	end
	if cam.x < size*-5 then cam.x = size*-5 end
	if cam.y < size*-5 then cam.y = size*-5 end
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

			if numbx > 0 and numby > 0 then
				love.graphics.setColor(168/255, 50/255, 50/255)
				local colorZoom=6
				love.graphics.setColor(1,math.sin(numbx/colorZoom)/4+0.5,math.cos(numby/colorZoom)/4+0.5)
				if numbx == 1 or numby ==1 or numbx == numby then
					love.graphics.setColor(math.sin(numbx/colorZoom)/4+0.5,math.cos(numby/colorZoom)/4+0.5,1)
				end
				love.graphics.rectangle('fill',locx,locy,size,size)
				love.graphics.setColor(1,1,1)
				love.graphics.rectangle('line',locx,locy,size,size)
				--love.graphics.print(numbx.."x"..numby,locx,locy)
				love.graphics.print(numbx*numby,font,locx+size/2,locy+size/2,nil,1/font:getWidth(numbx*numby)*size,nil,font:getWidth(numbx*numby)/2,font:getHeight('6')/2)
			else
				love.graphics.rectangle('line',gx+(size*(i-1)),gy+(size*(j-1)),size,size)
			end
		end
	end
end
function camMove()
	love.graphics.translate(cam.x*-1,cam.y*-1)
end
function love.draw()
	camMove()
	drawGrid()
	love.graphics.setLineWidth(love.graphics.getLineWidth()*2)
	love.graphics.setColor(1,1,0,math.sin(c/50)/2+0.5)
	local dmx = mx
	local dmy = my
	if windowToggle then love.graphics.rectangle('line',dmx,dmy,size,size) end
	if cam.x<0 and cam.y<0 then
		love.graphics.print("Press \"T\" to toggle info box",10-size*4,10-size*4)
		love.graphics.print("Press \"H\" to return home",(10-size*4),(10-size*4)+25)
		love.graphics.print("Press arrow keys to move",(10-size*4),(10-size*4)+50)
		love.graphics.print("Press arrow keys to move",(10-size*4),(10-size*4)+75)
		love.graphics.print("Press number keys 1-9 to change speed",(10-size*4),(10-size*4)+100)
		--love.graphics.print("Press number keys 1-9 to change speed",(10-size*4),(10-size*4)+125)
	end
	love.graphics.origin()
	--love.graphics.translate(0,)
	local ypos = love.graphics.getHeight()-cerp(0,size*2+love.graphics.getLineWidth()/2,windowCerp) + love.graphics.getLineWidth()
	love.graphics.setColor(0,0,0,0.5)
	love.graphics.rectangle('fill',size,ypos,love.graphics.getWidth()-size*2,size*2,size/2,size/2)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line',size,ypos,love.graphics.getWidth()-size*2,size*2,size/2,size/2)
	if drawWindow then
		local n1 = mx/size+1
		local n2 = my/size+1
		love.graphics.print(n1*n2,font,love.graphics.getWidth()/2,ypos,0,nil,nil,font:getWidth(n1*n2)/2)
		love.graphics.print(n1..' x '..n2,font,love.graphics.getWidth()/2,ypos+font:getHeight('2'),0,0.5,nil,font:getWidth(n1..' x '..n2)/2)
	end
	camMove()
end

function love.keypressed(key,scan)
	if key == "t" then
		windowToggle = not windowToggle
	elseif key == "h" then
		cam.x = 0
		cam.y = 0
	end
end
