STND_BUTTON_WIDTH = 90
STND_BUTTON_HEIGHT = 45

function createMsgBoxBG(width, height, text)
	local ang = 0
	local verts = {}
	local r = 10 -- math.max(math.min(width, height)/6, 10)
	for ang = 0,90,10 do
		verts[#verts+1] = -2 + width -r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height -r + math.cos(ang/180*math.pi)*r
	end
	for ang = 90,180,10 do
		verts[#verts+1] = -2 + width - r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 180,270,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 270,360,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height - r + math.cos(ang/180*math.pi)*r
	end
	
	local shadowVerts = {}
	for i = 1, #verts, 2 do
		shadowVerts[i] = verts[i] --+ 7
		shadowVerts[i+1] = verts[i+1] + 10
	end
	
	c = love.graphics.newCanvas()
	love.graphics.setCanvas(c)
	
	love.graphics.setColor(0,0,0,120)
	love.graphics.polygon( "fill", shadowVerts)
	
	love.graphics.setColor(55,78,125,240)
	love.graphics.polygon( "fill", verts)
	--love.graphics.setColor(120,140,170,255)
	love.graphics.setColor(30,60,100,240)
	love.graphics.setLine(1, "smooth")
	love.graphics.polygon( "line", verts)
	love.graphics.setFont(FONT_BUTTON)
	love.graphics.setColor(180,200,255,255)
	for i = 1, #text, 1 do
		love.graphics.print(text[i], 25, 10 + (i-1)*FONT_BUTTON:getHeight())
	end
	
	love.graphics.setCanvas()
	return c
end


function createButtonOff(width, height, label)
	local ang = 0
	local verts = {}
	local r = 10 -- math.max(math.min(width, height)/6, 10)
	for ang = 0,90,10 do
		verts[#verts+1] = -2 + width -r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height -r + math.cos(ang/180*math.pi)*r
	end
	for ang = 90,180,10 do
		verts[#verts+1] = -2 + width - r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 180,270,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 270,360,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height - r + math.cos(ang/180*math.pi)*r
	end
	
	local shadowVerts = {}
	for i = 1, #verts, 2 do
		shadowVerts[i] = verts[i] -- 4
		shadowVerts[i+1] = verts[i+1] + 6
	end
	
	c = love.graphics.newCanvas()
	love.graphics.setCanvas(c)
	
	love.graphics.setColor(0,0,0,120)
	love.graphics.polygon( "fill", shadowVerts)
	
	love.graphics.setColor(60,98,155,240)
	love.graphics.polygon( "fill", verts)
	love.graphics.setColor(30,60,100,255)
	love.graphics.setLine(1, "smooth")
	love.graphics.polygon( "line", verts)
	love.graphics.setFont(FONT_BUTTON)
	love.graphics.setColor(180,200,255,255)
	love.graphics.print(label, (width-FONT_BUTTON:getWidth(label))/2, (height-FONT_BUTTON:getHeight())/2)
	
	love.graphics.setCanvas()
	return c
end

function createButtonOver(width, height, label)
	local ang = 0
	local verts = {}
	local r = 10 -- math.max(math.min(width, height)/6, 10)
	for ang = 0,90,10 do
		verts[#verts+1] = -2 + width -r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height -r + math.cos(ang/180*math.pi)*r
	end
	for ang = 90,180,10 do
		verts[#verts+1] = -2 + width - r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 180,270,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = 2 + r + math.cos(ang/180*math.pi)*r
	end
	for ang = 270,360,10 do
		verts[#verts+1] = 2 + r + math.sin(ang/180*math.pi)*r
		verts[#verts+1] = -2 + height - r + math.cos(ang/180*math.pi)*r
	end
	
	local shadowVerts = {}
	for i = 1, #verts, 2 do
		shadowVerts[i] = verts[i] -- 7
		shadowVerts[i+1] = verts[i+1] + 9
	end
	
	c = love.graphics.newCanvas()
	love.graphics.setCanvas(c)
	
	love.graphics.setColor(0,0,0,120)
	love.graphics.polygon( "fill", shadowVerts)
	
--	love.graphics.setColor(120,140,175,250)
	love.graphics.setColor(60,98,155, 250)
	love.graphics.polygon( "fill", verts)
	
	love.graphics.setColor(240,240,255,250)
	love.graphics.setLine(1, "smooth")
	love.graphics.polygon( "line", verts)
	
	love.graphics.setFont(FONT_BUTTON)
	love.graphics.print(label, (width-FONT_BUTTON:getWidth(label))/2, (height-FONT_BUTTON:getHeight())/2)
	
	love.graphics.setCanvas()
	return c
end
