function love.load()
	--[[

		[WARNING! THIS CODE IS TERRIBLE!]

	--]]
	--hope it works this time
	c = 0
	size = 64
	uisize = 64
	cam = {x=size*-5,y=size*-5}
	cam = {x=size*-524288,y=size*-524288}

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
	message = "Pess enter to open menu"
	settings = {}
	settings.screen = "main"
	settings.lastScreenMouseDownOn="main"
	settings.nameList = {"Infobox","Highlighting","Bookmark","Movement Speed","Navigate","Debug"," ","Close Menu"}

	settings.main = {list=1}
	settings.window = {}
	settings.window.cerp = 0
	settings.window.open = false
	settings.oktoclick = true
	settings.nav = {}
	settings.nav.place = 1
	settings.nav.loc = {}
	settings.nav.loc[1] = "0"
	settings.nav.loc[2] = "0"
	settings.nav.loc[3] = "0"
	settings.nav.loc[4] = "0"
	mode = "mult" --mult, add, expo, mod
	modeText = " x "
end
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
function boolText(bool)
	if bool then return "enabled" end
	return "disabled"
end
function cerp(a,b,t) local f=(1-math.cos(t*math.pi))*.5 return a*(1-f)+b*f end
	--no idea how this works
	--i just took it off the wiki

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function love.update(dt)
	if settings.window.open and settings.window.cerp==1 then
		settingCode("update",settings.screen,mo)
	end
	if titleFade > -2 then titleFade = titleFade-math.abs(dt) end
	mTimer = mTimer - math.abs(dt)
	mTimer = clamp(0,mTimer,4)
	if settings.window.open then
		settings.window.cerp = settings.window.cerp + math.abs(dt)*2
	else
		settings.window.cerp = settings.window.cerp - math.abs(dt)*2
	end
	settings.window.cerp = clamp(0, settings.window.cerp, 1)
	local globalX, globalY = love.graphics.inverseTransformPoint(love.mouse.getX(),love.mouse.getY())
	mx = math.floor(globalX/size)*size
	my = math.floor(globalY/size)*size
	if my>=0 and mx>=0 and windowToggle then
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

	if love.keyboard.isDown("x") then
		bookmark = {}
		mTimer = 99
		message = "Bookmark deleted"
	elseif love.keyboard.isDown("c") then
		if bookmark.x ~= nil and (not love.mouse.isDown(1)) then
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
	
	if cam.x < size*-5 then cam.x = size*-5 end
	if cam.y < size*-5 then cam.y = size*-5 end

	if love.mouse.isDown(1) and not(love.keyboard.isDown("c")) and not(settings.window.open) then
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
				if numbx*numby == domath(mx/size+1,my/size+1) and highlight and mx/size+1 == math.abs(mx/size+1) then
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
				--love.graphics.print(numbx..modeText..numby,locx,locy)
				if numbx > 0 and numby > 0 then

love.graphics.print(domath(numbx,numby),font,locx+size/2,locy+size/2,nil,1/font:getWidth(domath(numbx,numby))*size,nil,font:getWidth(domath(numbx,numby))/2,font:getHeight('6')/2)
				end
		end
	end
end
function camMove()
	love.graphics.translate(cam.x*-1,cam.y*-1)
end
function domath (inx,iny)
	local ans = -1
	if mode == "mult" then
		ans = inx*iny
	elseif mode == "add" then
		--iny = iny - 1 
		--inx = inx - 1
		ans = inx+iny
	end
	return ans
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
		love.graphics.print("Press \"O\" or  Enter to open menu",10-size*4+ox,10-size*4+oy-25)
		love.graphics.print("Press \"T\" to toggle info box",10-size*4+ox,10-size*4+oy)
		love.graphics.print("Press \"H\" to return home",(10-size*4)+ox,(10-size*4)+25+oy)
		love.graphics.print("Press \"L\" to toggle highlighting",(10-size*4)+ox,(10-size*4)+50+oy)
		love.graphics.print("Press arrow keys or WASD to move",(10-size*4)+ox,(10-size*4)+75+oy)
		love.graphics.print("Press number keys 1-9 to change speed",(10-size*4)+ox,(10-size*4)+100+oy)
		love.graphics.print("Click on a square to set bookmark",(10-size*4)+ox,(10-size*4)+125+oy)
		love.graphics.print("Press \"X\" to delete bookmark",(10-size*4)+ox,(10-size*4)+150+oy)
		love.graphics.print("Press \"C\" set view to location of bookmark",(10-size*4)+ox,(10-size*4)+175+oy)
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
		love.graphics.print(domath(n1,n2),font,love.graphics.getWidth()/2,ypos,0,nil,nil,font:getWidth(domath(n1,n2))/2)
		love.graphics.print(n1..modeText..n2,font,love.graphics.getWidth()/2,ypos+font:getHeight('2'),0,0.5,nil,font:getWidth(n1..modeText..n2)/2)
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


	if settings.window.cerp ~= 0 then
		mo = cerp(0,1,settings.window.cerp) --master opacity
		love.graphics.setColor(0,0,0,clamp(0,mo,0.5))
		love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),love.graphics.getHeight())
		settingCode("draw",settings.screen,mo)
		--love.graphics.draw()
	elseif settings.screen ~= "main" then
		settings.screen = "main"
	end
	love.graphics.setColor(1,1,1)
	camMove()
end

-----------------------------------------
function settingCode(mode,screen,opacity)
	local tsize = 100
	if mode == "draw" then
		love.graphics.setColor(1,1,1,opacity)
		if screen ~= "main" then
			love.graphics.print("'o' or enter to return, escape to close menu",0,love.graphics.getHeight()-15)
		end
		if screen == "main" then
			for i=1,#settings.nameList do
				love.graphics.print(settings.nameList[i],font,love.graphics.getWidth()/2,(i-1)*font:getHeight('y')/(cerp(0,1,settings.window.cerp)),nil,nil,nil,font:getWidth(settings.nameList[i])/2)
			end
			love.graphics.setColor(1,1,1,clamp(0,opacity,0.5))
			love.graphics.rectangle("fill",0,font:getHeight('y')*(settings.main.list-1),love.graphics.getWidth(),font:getHeight('y'))
		elseif screen == "infobox" then
			local o1 = "line"
			local o2 = "fill"
			if not windowToggle then o1 = "fill"; o2 = "line" end
			love.graphics.setColor(1,0,0,opacity)
			love.graphics.circle(o1,love.graphics.getWidth()/4,love.graphics.getHeight()/2,tsize)
			love.graphics.setColor(0,1,0,opacity)
			love.graphics.circle(o2,love.graphics.getWidth()/4*3,love.graphics.getHeight()/2,tsize)
			love.graphics.setColor(1,1,1,opacity)
			love.graphics.print(boolText(windowToggle),font,love.graphics.getWidth()/2,love.graphics.getHeight()-150,nil,nil,nil,font:getWidth(boolText(windowToggle))/2)
love.graphics.print("Infobox Toggle (T)",font,love.graphics.getWidth()/2,100,nil,nil,nil,font:getWidth("Infobox Toggle (T)")/2)
		elseif screen == "debug" then
			local text = {
				"framerate: "..love.timer.getFPS(),
				"delta: ",love.timer.getDelta(),
				"counter: "..c,
				"size: " .. size .. ", " .. uisize,
				"bookmark: "..tostring(bookmark.x)..", "..tostring(bookmark.y),
				"cursor: "..tostring(mx)..", "..tostring(my),
				"speed: "..speed,
				--"cam: " .. tostring(cam.x) ", " .. tostring(cam.y),
				"infobox cerp: " .. windowCerp,
				"message: " .. message,
				"message time:" .. mTimer,
				"cam x:" .. cam.x,
				"cam y:" .. cam.y,
				}

				for i=1,#text do
					love.graphics.print(text[i],0,(i-1)*10)
				end
		elseif screen == "hl" then
			local o1 = "line"
			local o2 = "fill"
			if not highlight then o1 = "fill"; o2 = "line" end
			love.graphics.setColor(1,0,0,opacity)
			love.graphics.circle(o1,love.graphics.getWidth()/4,love.graphics.getHeight()/2,tsize)
			love.graphics.setColor(0,1,0,opacity)
			love.graphics.circle(o2,love.graphics.getWidth()/4*3,love.graphics.getHeight()/2,tsize)
			love.graphics.setColor(1,1,1,opacity)
			love.graphics.print(boolText(highlight),font,love.graphics.getWidth()/2,love.graphics.getHeight()-150,nil,nil,nil,font:getWidth(boolText(windowToggle))/2)
love.graphics.print("Highlighting Toggle (L)",font,love.graphics.getWidth()/2,100,nil,nil,nil,font:getWidth("Highlighting Toggle (T)")/2)
		elseif screen == "bookmark" then
			love.graphics.setColor(1,1,1,opacity)
			love.graphics.line(love.graphics.getWidth()/2,0,love.graphics.getWidth()/2,love.graphics.getHeight())
			local x = 0
			if love.mouse.getX() > love.graphics.getWidth()/2 then	
				x = love.graphics.getWidth()/2
			end
			love.graphics.setColor(1,1,1,clamp(0,opacity,0.5))
			love.graphics.rectangle("fill",x,0,love.graphics.getWidth()/2,love.graphics.getHeight())
			if bookmark.x ~= nil then
				love.graphics.setColor(1,1,1,opacity)
			end
			love.graphics.print("Delete Bookmark (X)",font,love.graphics.getWidth()/4*3,love.graphics.getHeight()/2,nil,0.5,nil,font:getWidth("Delete Bookmark (X)")/2)
			love.graphics.setColor(1,1,1,opacity)
			love.graphics.print("Go to Bookmark (C)",font,love.graphics.getWidth()/4,love.graphics.getHeight()/2,nil,0.5,nil,font:getWidth("Go to Bookmark (C)")/2)
		elseif screen == "speed" then
			love.graphics.setColor(1,1,1,opacity)
			for i=1, #speedTable do
				love.graphics.setColor(1,1,1,opacity)
				love.graphics.circle("line",(love.graphics.getWidth()/#speedTable)*(i-1)+love.graphics.getWidth()/#speedTable/2,love.graphics.getHeight()/2,love.graphics.getWidth()/#speedTable/2)
				if speedTable[i] == speed then
					love.graphics.circle("fill",(love.graphics.getWidth()/#speedTable)*(i-1)+love.graphics.getWidth()/#speedTable/2,love.graphics.getHeight()/2,love.graphics.getWidth()/#speedTable/2)
					local si = i
				end
			end
				love.graphics.print("Click to select speed",font,love.graphics.getWidth()/2,love.graphics.getHeight()/4,0,nil,nil,font:getWidth("Click to select speed")/2)
		elseif screen == "nav" then
			love.graphics.print(settings.nav.loc[1],font,love.graphics.getWidth()/2,love.graphics.getHeight()/4,nil,nil,nil,font:getWidth(settings.nav.loc[1])/2,font:getHeight('1')/2)

love.graphics.print(settings.nav.loc[2],font,love.graphics.getWidth()/2,love.graphics.getHeight()/4*3,nil,nil,nil,font:getWidth(settings.nav.loc[2])/2,font:getHeight('1')/2)

			local mt = {"Type first number and click","Type second number and click","Bookmark set to location. Click to input new location"," "}

			love.graphics.print(mt[settings.nav.place],font,love.graphics.getWidth()/2,20,nil,0.25,nil,font:getWidth(mt[settings.nav.place])/2)
		end
	elseif mode == "update" then
		--if love.mouse.isDown(1) then
		--	local oktoclick = settings.lastScreenMouseDownOn==settings.screen
		--end
		if screen == "main" then
			local ty = 0
			local h = font:getHeight('t')
			for i=1,#settings.nameList do
				if 2+love.mouse.getY() > h*(i-1) and love.mouse.getY()+1 < h*i then
					ty = i
				end
			end
			if love.mouse.isDown(1) then
				if ty == 8 and oktoclick then
					settings.window.open = false
				end
				if ty == 1 and oktoclick then
					settings.screen = "infobox"
				end
				if ty == 2 and oktoclick then
					settings.screen = "hl"
				end
				if ty == 3 and oktoclick then
					settings.screen = "bookmark"
				end
				if ty == 4 and oktoclick then
					settings.screen = "speed"
				end
				if ty == 5 and oktoclick then
					settings.nav.place = 1
					settings.nav.loc = {}
					settings.nav.loc[1] = "0"
					settings.nav.loc[2] = "0"
					settings.screen = "nav"
				end
				if ty == 6 and oktoclick then
					settings.screen = "debug"
				end
			end
			settings.main.list = ty

		elseif screen == "infobox" then
			if love.mouse.isDown(1) and oktoclick then
				if math.dist(love.mouse.getX(),love.mouse.getY(),love.graphics.getWidth()/4,love.graphics.getHeight()/2) < tsize then
					windowToggle = false
				elseif math.dist(love.mouse.getX(),love.mouse.getY(),love.graphics.getWidth()/4*3,love.graphics.getHeight()/2) < tsize then
					windowToggle = true
				end
			end
		elseif screen == "hl" then
			if love.mouse.isDown(1) and oktoclick then
				if math.dist(love.mouse.getX(),love.mouse.getY(),love.graphics.getWidth()/4,love.graphics.getHeight()/2) < tsize then
					highlight = false
				elseif math.dist(love.mouse.getX(),love.mouse.getY(),love.graphics.getWidth()/4*3,love.graphics.getHeight()/2) < tsize then
					highlight = true
				end
			end
		elseif screen == "bookmark" then
			if love.mouse.isDown(1) and oktoclick then
				if love.mouse.getX() > love.graphics.getWidth()/2 then
					bookmark = {}
				elseif bookmark.x ~= nil then
					cam.x = bookmark.x - love.graphics.getWidth()/2 + size/2
					cam.y = bookmark.y - love.graphics.getHeight()/2 + size/2
				end
			end
		elseif screen == "speed" then
			if love.mouse.isDown(1) and oktoclick then
				for i=1,#speedTable do
					if math.dist(love.mouse.getX(),love.mouse.getY(),(love.graphics.getWidth()/#speedTable)*(i-1)+love.graphics.getWidth()/#speedTable/2,love.graphics.getHeight()/2) < love.graphics.getWidth()/#speedTable/2 then
						speed = speedTable[i]
					end
				end
			end
		elseif screen == "nav" then
			if love.mouse.isDown(1) and oktoclick then
				--if settings.nav.place == 1 then
					settings.nav.place = settings.nav.place + 1
				--end
				if settings.nav.place == 3 then
					bookmark.x = (settings.nav.loc[1] * size)-size
					bookmark.y = (settings.nav.loc[2] * size)-size
				end
				if settings.nav.place == 4 then
					settings.nav.place = 1
					settings.nav.loc[1] = "0"
					settings.nav.loc[2] = "0"
				end
			end
		end
	end

	if not love.mouse.isDown(1) then
		settings.lastScreenMouseDownOn=settings.screen
		oktoclick=true
	else oktoclick = false end
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
	elseif key =="o" or key == "return" then
		if not settings.window.open and settings.window.cerp == 0 then
			settings.window.open = true
			settings.screen = "main"
		elseif settings.window.open and settings.window.cerp == 1 then
			if settings.screen == "main" then
				settings.window.open = false
			else
				settings.screen = "main"
			end
		end
	elseif key == "escape" then
		settings.window.open = false
	end
	for i=0,10 do
		if (tostring(i)) == key then
			if 	settings.screen ~= "nav" and i ~= 0 then
				speed = speedTable[i]
				mTimer = 99
				message = "Speed set to "..i
			end
		end
		if (tostring(i)) == key and settings.screen == "nav" and settings.window.open and settings.nav.place < 3 then
			settings.nav.loc[settings.nav.place] = settings.nav.loc[settings.nav.place] .. key
		end
	end
end
