
--[[
Each train in the trainList holds:
tileX, tileY: the tile coordinates of the tile the train is currently on
anlge: the direction the train is currently moving in (radians)
dir: the direction the next tile is in
x, y: the position ON the tile
curNode: the node it last visited


]]--

local train = {}

local train_mt = { __index = train }

local trainList = {}

local TRAIN_SPEED = 30

trainImage = love.image.newImageData("Images/Train1.png")
--[[
trainImagePlayer1
trainImagePlayer2
trainImagePlayer3
trainImagePlayer4
]]--

function tint(col)
	local bright = 0
	return function (x,y,r,g,b,a)
		bright = (r+g+b)/3	--calc brightness (average) of pixel
		print("in:", x,y,r,g,b,a)
		print(bright,bright*col.r/255, bright*col.g/255, bright*col.b/255, a)
		return bright*col.r/255, bright*col.g/255, bright*col.b/255, a
	end
end

function train.init(col1, col2, col3, col4)

	trainList[1] = {}
	trainList[2] = {}
	trainList[3] = {}
	trainList[4] = {}

	trainImagePlayer1d = love.image.newImageData(trainImage:getWidth(), trainImage:getHeight())
	trainImagePlayer2d = love.image.newImageData(trainImage:getWidth(), trainImage:getHeight())
	trainImagePlayer3d = love.image.newImageData(trainImage:getWidth(), trainImage:getHeight())
	trainImagePlayer4d = love.image.newImageData(trainImage:getWidth(), trainImage:getHeight())
	
	f = tint(col1)
	f(10,10,10,10,10,10)
	
	--[[trainImagePlayer1d:mapPixel(tint(col1))
	trainImagePlayer2d:mapPixel(tint(col2))
	trainImagePlayer3d:mapPixel(tint(col3))
	trainImagePlayer4d:mapPixel(tint(col4))
	]]--
	
	
	for i=0,trainImage:getWidth()-1 do
		for j=0,trainImage:getHeight()-1 do
			r,g,b,a = trainImage:getPixel(i, j)
			bright = (r+g+b)/3	--calc brightness (average) of pixel
			trainImagePlayer1d:setPixel(i, j, bright*col1.r/255, bright*col1.g/255, bright*col1.b/255, a)
			trainImagePlayer2d:setPixel(i, j, bright*col2.r/255, bright*col2.g/255, bright*col2.b/255, a)
			trainImagePlayer3d:setPixel(i, j, bright*col3.r/255, bright*col3.g/255, bright*col3.b/255, a)
			trainImagePlayer4d:setPixel(i, j, bright*col4.r/255, bright*col4.g/255, bright*col4.b/255, a)
		end
	end
	trainImagePlayer1 = love.graphics.newImage(trainImagePlayer1d)
	trainImagePlayer2 = love.graphics.newImage(trainImagePlayer2d)
	trainImagePlayer3 = love.graphics.newImage(trainImagePlayer3d)
	trainImagePlayer4 = love.graphics.newImage(trainImagePlayer4d)
end

function getTrainImage( aiID )
	if aiID == 1 then return trainImagePlayer1
	elseif aiID == 2 then return trainImagePlayer2
	elseif aiID == 3 then return trainImagePlayer3
	else return trainImagePlayer4
	end
end


function train:new( aiID, x, y, dir )
	if curMap[x][y] ~= "C" then
		error("Trying to place train on non-valid tile")
	end
	for i=1,#trainList[aiID]+1,1 do
		if not trainList[aiID][i] then
			--local imageOff = createButtonOff(width, height, label)
			--local imageOver = createButtonOver(width, height, label)
			local image = getTrainImage( aiID )
			trainList[aiID][i] = setmetatable({image=image}, button_mt)
			
			if dir == "N" then
				path = train.getRailPath(x, y, dir)
			elseif dir == "S" then
				path = train.getRailPath(x, y, dir)
			elseif dir == "E" then
				path = train.getRailPath(x, y, dir)
			else
				path = train.getRailPath(x, y, dir)
			end
			
			trainList[aiID][i].tileX = x
			trainList[aiID][i].tileY = y
			
			if path and path[1] then		--place at the center of the current piece.
				curPathNode = math.ceil((#path-1)/2)
				print("curPathNode:", curPathNode)
				print("y, x", x, y)
				print("curPathNode coords:", path[curPathNode].x, path[curPathNode].y)
				print("curPathNode+1 coords:", path[curPathNode+1].x, path[curPathNode+1].y)
				--local position:
				trainList[aiID][i].x = (path[curPathNode+1].x - path[curPathNode].x)/2 + path[curPathNode].x
				trainList[aiID][i].y = (path[curPathNode+1].y - path[curPathNode].y)/2 + path[curPathNode].y
				print("local:", trainList[aiID][i].x, trainList[aiID][i].y)
				--global position
				--trainList[aiID][i].x = trainList[aiID][i].x + trainList[aiID][i].tileX*TILE_SIZE
				--trainList[aiID][i].y = trainList[aiID][i].y + trainList[aiID][i].tileY*TILE_SIZE
				--print("global:", trainList[aiID][i].x, trainList[aiID][i].y)
				
				trainList[aiID][i].angle = math.atan((path[curPathNode+1].y - path[curPathNode].y)/(path[curPathNode+1].x - path[curPathNode].x))
				trainList[aiID][i].path = path
				trainList[aiID][i].curNode = curPathNode
				trainList[aiID][i].dir = dir
				
				dx = (path[curPathNode+1].x - trainList[aiID][i].x)
				dy = (path[curPathNode+1].y - trainList[aiID][i].y)
				trainList[aiID][i].dxPrevSign = (dx < 0)
				trainList[aiID][i].dyPrevSign = (dy < 0)
				
			else
				trainList[aiID][i].x = 0
				trainList[aiID][i].y = math.random(100)
			end
			
			return trainList[aiID][i]
		end
	end
end

-- function distance(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function train.move()
	t = love.timer.getDelta()
	for k, list in pairs(trainList) do
		for k, tr in pairs(list) do
			if tr.path and not tr.stop then
				dx = (tr.path[tr.curNode+1].x - tr.x)
				dy = (tr.path[tr.curNode+1].y - tr.y)
				dx1,dy1 = dx,dy
				--normalize:
				d = math.sqrt(dx ^ 2 + dy ^ 2)
				
				-- if distance is small, or sign of dx or dy has changed, go to next node:
				if d < 1 or (dx < 0) ~= (tr.dxPrevSign) or (dy < 0) ~= (tr.dyPrevSign) then
					if tr.path[tr.curNode+2] then
						tr.curNode = tr.curNode + 1
						dx = (tr.path[tr.curNode+1].x - tr.x)
						dy = (tr.path[tr.curNode+1].y - tr.y)
						dx1,dy1 = dx,dy
						--normalize:
						d = math.sqrt(dx ^ 2 + dy ^ 2)
					else
						print("Reached path end")
						tr.stop = true
						possibleDirs = train.getNextPossibleDirs(tr.tileX, tr.tileY, tr.dir)
						nextDir = possibleDirs[math.random(#possibleDirs)]
						print("possible dirs:")
						for k, d in pairs(possibleDirs) do
							print("\t" .. d)
						end
						
						if tr.dir == "N" then
							tr.tileY = tr.tileY - 1
							print("moved north")
						end
						if tr.dir == "S" then
							tr.tileY = tr.tileY + 1
							print("moved south")
						end
						if tr.dir == "W" then
							tr.tileX = tr.tileX - 1
							print("moved west")
						end
						if tr.dir == "E" then
							tr.tileX = tr.tileX + 1
							print("moved east")
						end
						tr.path = train.getRailPath(tr.tileX, tr.tileY ,nextDir, tr.dir)
						tr.dir = nextDir
						
						print("new path:")
						for k, point in pairs(tr.path) do
							print(point.x, point.y)
						end
						
						if tr.path then
							tr.stop = false
							tr.curNode = 1
							
							tr.x = tr.path[tr.curNode].x
							tr.y = tr.path[tr.curNode].y
							
							dx = (tr.path[tr.curNode+1].x - tr.x)
							dy = (tr.path[tr.curNode+1].y - tr.y)
							dx1,dy1 = dx,dy
							--normalize:
							d = math.sqrt(dx ^ 2 + dy ^ 2)
						end
						a, b = tr.tileX, tr.tileY
						print(a, b)
						print(curMapRailTypes[a][b])
					end
				end
				
				tr.dxPrevSign = (dx < 0)
				tr.dyPrevSign = (dy < 0)
				
				
				dx = dx/d
				dy = dy/d
				tr.x = tr.x + t*dx*TRAIN_SPEED
				tr.y = tr.y + t*dy*TRAIN_SPEED
			end
		end
	end
end

function train.clear()
	trainList[1] = {}
	trainList[2] = {}
	trainList[3] = {}
	trainList[4] = {}
end


-- if I keep moving into the same direction, which direction can I move in on the next tile?
function train.getNextPossibleDirs(curTileX, curTileY , curDir)
	local nextTileX, nextTileY = curTileX, curTileY
	
	if curDir == "N" then
		print("currently going North")
		nextTileY = nextTileY - 1
	elseif curDir == "S" then
		print("currently going South")
		nextTileY = nextTileY + 1
	elseif curDir == "E" then
		print("currently going East")
		nextTileX = nextTileX + 1
	elseif curDir == "W" then
		print("currently going West")
		nextTileX = nextTileX - 1
	end
	
	railType = getRailType( nextTileX, nextTileY )
	print("type of next rail:", railType)
	if railType == 1 or railType == 2 then		-- straight rail: can only keep moving in same dir
		return {curDir}
	end
	--curves:
	if railType == 3 then
		if curDir == "E" then return {"N"}
		else return {"W"} end
	end
	if railType == 4 then
		if curDir == "E" then return {"S"}
		else return {"W"} end
	end
	if railType == 5 then
		if curDir == "W" then return {"N"}
		else return {"E"} end
	end
	if railType == 6 then
		if curDir == "W" then return {"S"}
		else return {"E"} end
	end
	--junctions
	if railType == 7 then
		if curDir == "S" then return {"E", "W"}
		elseif curDir == "W" then return {"W", "N"}
		else return {"N", "E"} end
	end
	if railType == 8 then
		if curDir == "S" then return {"E", "S"}
		elseif curDir == "W" then return {"S", "N"}
		else return {"N", "E"} end
	end
	if railType == 9 then
		if curDir == "E" then return {"E", "S"}
		elseif curDir == "W" then return {"W", "S"}
		else return {"W", "E"} end
	end
	if railType == 10 then
		if curDir == "S" then return {"S", "W"}
		elseif curDir == "E" then return {"N", "S"}
		else return {"W", "N"} end
	end
	if railType == 11 then
		if curDir == "E" then return {"E", "S", "N"}
		elseif curDir == "W" then return {"W", "S", "N"}
		elseif curDir == "S" then return {"S", "E", "W"}
		else return {"N", "E", "W"} end
	end
	
	if railType == 12 then
		return {"W"}
	end
	if railType == 13 then
		return {"E"}
	end
	if railType == 14 then
		return {"N"}
	end
	if railType == 15 then
		return {"S"}
	end
end

function train.getRailPath(tileX, tileY, dir, prevDir)
	print("getting next path:", tileX, tileY, dir, prevDir)
	print("rail type:",curMapRailTypes[tileX][tileY])	

	if curMapRailTypes[tileX][tileY] == 1 then
		if dir == "S" then
			return pathNS, dir
		else
			return pathSN, "N"
		end
	elseif curMapRailTypes[tileX][tileY] == 2 then
		if dir == "W" then
			return pathEW, dir
		else
			return pathWE, "E"
		end
	elseif curMapRailTypes[tileX][tileY] == 3 then
		if dir == "N" then
			return pathWN, dir
		else
			return pathNW, "W"
		end
	elseif curMapRailTypes[tileX][tileY] == 4 then
		if dir == "W" then
			return pathSW, dir
		else
			return pathWS, "S"
		end
	elseif curMapRailTypes[tileX][tileY] == 5 then
		if dir == "N" then
			return pathEN, dir
		else
			return pathNE, "E"
		end
	elseif curMapRailTypes[tileX][tileY] == 6 then
		if dir == "E" then
			return pathSE, dir
		else
			return pathES, "S"
		end
	elseif curMapRailTypes[tileX][tileY] == 7 then	-- NEW
		if dir == "E" then
			if prevDir == "E" then
				return pathWE, dir
			else
				return pathNE, "E"
			end
		elseif dir == "W" then
			if prevDir == "W" then
				return pathEW, dir
			else
				return pathNW, "W"
			end
		else
			if prevDir == "W" then
				return pathEN, dir
			else
				return pathWN, "N"
			end
		end
	elseif curMapRailTypes[tileX][tileY] == 8 then	-- NES
		if dir == "N" then
			if prevDir == "N" then
				return pathSN, dir
			else
				return pathEN, "N"
			end
		elseif dir == "S" then
			if prevDir == "S" then
				return pathNS, dir
			else
				return pathES, "S"
			end
		else
			if prevDir == "N" then
				return pathSE, dir
			else
				return pathNE, "E"
			end
		end
	elseif curMapRailTypes[tileX][tileY] == 9 then	-- ESW
		if dir == "E" then
			if prevDir == "E" then
				return pathWE, dir
			else
				return pathSE
			end
		elseif dir == "W" then
			if prevDir == "W" then
				return pathEW, dir
			else
				return pathSW, "W"
			end
		else
			if prevDir == "W" then
				return pathES, dir
			else
				return pathWS, "S"
			end
		end
	elseif curMapRailTypes[tileX][tileY] == 10 then	-- NSW
		if dir == "N" then
			if prevDir == "N" then
				return pathSN, dir
			else
				return pathWN, "N"
			end
		elseif dir == "S" then
			if prevDir == "S" then
				return pathNS, dir
			else
				return pathWS, "S"
			end
		else
			if prevDir == "S" then
				return pathNW, dir
			else
				return pathSW, "W"
			end
		end
	elseif curMapRailTypes[tileX][tileY] == 11 then	-- NESW
		if dir == "N" then
			if prevDir == "N" then
				return pathSN
			elseif prevDir == "E" then
				return pathWN, dir
			else
				return pathEN, "N"
			end
		elseif dir == "S" then
			if prevDir == "S" then
				return pathNS, dir
			elseif prevDir == "E" then
				return pathWS, dir
			else
				return pathES, "S"
			end
		elseif dir == "E" then
			if prevDir == "E" then
				return pathWE, dir
			elseif prevDir == "N" then
				return pathSE, dir
			else
				return pathNE, "E"
			end
		else
			if prevDir == "W" then
				return pathEW, dir
			elseif prevDir == "S" then
				return pathNW, dir
			else
				return pathSW, "W"
			end
		end
	elseif curMapRailTypes[tileX][tileY] == 12 then	-- W
		return pathEW, "W"
	elseif curMapRailTypes[tileX][tileY] == 13 then	-- E
		return pathWE, "E"
	elseif curMapRailTypes[tileX][tileY] == 14 then	-- N
		return pathSN, "N"
	elseif curMapRailTypes[tileX][tileY] == 15 then	-- S
		return pathNS, "S"
	end
	print("Path not found", tileX, tileY)
	return pathNS, "S"		--fallback, should never happen!
end

function train.show()
	for k, list in pairs(trainList) do
		for k, tr in pairs(list) do
			--love.graphics.draw( tr.image, tr.x-tr.image:getWidth()/2, tr.y-tr.image:getHeight()/2 , tr.angle, 1, 1, tr.image:getWidth()/2, tr.image:getHeight()/2 )--, tr.angle)
			
			for i = 1,#tr.path do
				brightness = 1-(#tr.path-i)/#path
				love.graphics.setColor(255,0,0,255)
				love.graphics.circle( "fill", tr.tileX*TILE_SIZE+tr.path[i].x,  tr.tileY*TILE_SIZE+tr.path[i].y, brightness*4+3)
			end
			
			love.graphics.setColor(255,255,0,255)
			love.graphics.rectangle( "fill", tr.tileX*TILE_SIZE,  tr.tileY*TILE_SIZE, 10, 10)
			love.graphics.setColor(128,255,0,255)
			love.graphics.circle( "fill", tr.tileX*TILE_SIZE+tr.x, tr.tileY*TILE_SIZE+tr.y, 5)
			
			
			
		end
	end
end

return train
