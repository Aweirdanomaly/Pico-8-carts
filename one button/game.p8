pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
--[[todo:
add 2 player

fix title screen for more options

add sprites for font and title screen

add powerups

draw number sprites to display
level 

fuck around with graphics buffer
for flipping

make music and better sfx
]]--
function dist(a,b)
return sqrt(((b.x-a.x)^2)+((b.y-a.y)^2))
end

function norm(v)
return sqrt(v[1]^2+v[2]^2)

end


function spawn_player(c,cs,_osc)

 --local osc=_osc 
 local xs={0,0}
 local ys={64,114}
 local boxx={2,2,1,1,-2,-2,-1,-1}
 local boxy={-1,1,-2,2,-1,1,-2,2}

	add(players,{
	x=xs[cs],
	y=ys[cs],
	t=0,
	osc=_osc,
	dt=gt,
	size=2,
	draw=function(self)
 circfill(self.x,self.y,self.size,c)
--  print(self.y,self.x,self.y-8)

--[[ 	 for i=1,#boxx do
	 pset(self.x+boxx[i],self.y+boxy[i],8)
	 end]]--

 --[[
  for i=1,health-1 do
   local c=5
   if (i%2==0) c=1
   circfill(self.x-(i*3),50*sin(t-(i/100))+64,2,c)
  end  
 ]]--
 
	end,
	update=function(self)

	  
	  if self.osc then
			 self.x += speed
			 if (not btn(4)) then
				 self.t+=.025
				 self.y = 50*sin(self.t)+64 
		  end
		 else 
		  test[1]=p2.x
		  self.x+=speed
			 if (not btn(5)) then
				 self.t+=.025
				 self.x = 50*cos(self.t)+p1.x+50
		  end
		 end
	  
	 
 	for i=1,#boxx do
	  if pget(self.x+boxx[i],self.y+boxy[i])==8 or
	   pget(self.x+boxx[i],self.y+boxy[i])==9 then
	   sfx(2)
	   self.dt=gt
	   obstacles={}
    self.vx=0
	   self.update=crash
	   
	   break
	  end
	 end
	
	end})
	
end



pats={
pillar=function(_obs,_size)

local obs=_obs
local offset= rnd(100)
local size=_size
local area=(128-2*rw)-2*size


for i=1,obs do
add(obstacles,{
x=p1.x+150,
y=(i*((area/obs))+offset)%(area-1)+rw+size+1,
 draw=function(self)
 rectfill(self.x-size,self.y-size,self.x+size,self.y+size,8)
end,
update=function(self)
 if (p1.x > self.x+40) then
  --sfx(1)
  del(obstacles,self)
 end
end 
})
end

end,


spinner=function(_obs,_size,_amp)

local obs=_obs
local size=_size
local amp=_amp
local sx=p1.x+150
local sy=(2*rw+size+1)+rnd((112-rw)-amp)

for i=1,obs do
add(obstacles,{
x=sx,
y=sy,
 draw=function(self)
 rectfill(self.x-size,self.y-size,self.x+size,self.y+size,8)
end,
update=function(self)
 self.x=amp*cos(gt-(i/obs))+sx
 self.y=amp*sin(gt-(i/obs))+sy
 if (p1.x > self.x+100) then
  --sfx(1)
  del(obstacles,self)
 end
end 
})
end

end,

tracker=function(_obs,_size,_detect,_speed)

local obs=_obs
local size=_size
local speed=1+_speed
local detect=size+_detect

add(obstacles,{
x=p1.x+150,
y=rnd(112-(rw+size-1))+(rw+size+1),
vy=0,
vx=0,
seen=false,
 draw=function(self)
 rectfill(self.x-size,self.y-size,self.x+size,self.y+size,9)
 circ(self.x,self.y,detect,5)
end,
update=function(self)
 if dist(self,p1)<detect and not self.seen then
 local v={p1.x-self.x,p1.y-self.y}
 local norm=norm(v)

 self.vx=speed*(v[1]/norm)
 self.vy=speed*(v[2]/norm)
 
 self.seen = true
 end
 self.x+=self.vx
 self.y+=self.vy

 if (p1.x > self.x+100) or dist(self,p1)>200 then
  del(obstacles,self)
 end
end 
})

end}

function crash(player)
 speed=0
 
 if (gt-player.dt)>.8 then
   --cam[1]+=.5
   
   --(cam[1]+64)-player.x/10
   --64-player.y/10
   if player.size<150 then
   	player.size+=2
   	--test[1]=player.size
   else
    hiscore=max(hiscore,p1.x\10)
    _init()
    alive=false
   end
 
 end
 
end

function easeoutquad(t)
    t-=1
    return 1-t*t
end
-->8
mode="null"
test={}
hiscore=0

function _init()

--timers

gt=0

--gameplay

spacing=100

health=100

speed=2 --probs max of 5

obs=2

difficulty=1

alive=false

cam={20,0}
--aesthetics
rw=8

c=1
players={}
obstacles={}

spawn_player(12,1,true)

--spawn_player(11,2,false)

p1=players[1]
p2=players[2]
graze=1

--levels
l2=true

camera(0,0)
end


function _update()
if alive then
--global timer
 gt+=.015
 if (p1.x%1000==0) obs+=1

 if p1.x % spacing ==0 then 
  choice=rnd({"pillar","spinner","tracker"})
 -- pats.tracker(obs,5,2)
--[[ 
  rnd({pats.pillar(obs,rnd(4)+2),
  pats.spinner(obs,rnd(4)+2,rnd(40)+2),
  pats.tracker(obs,5,2)})
]]--
  pats[choice](obs,rnd(4)+2,rnd(40)+2,2)
 end

 foreach(players, function(obj) obj:update() end)

	foreach(obstacles, function(obj) obj:update() end)
	
	camera(p1.x-cam[1],cam[2])

else
 alive= btnp(4)

end



end
function _draw()

	
	if alive then
		cls()
		--gui
		rectfill(p1.x-cam[1],0,p1.x+108,0+rw,7)
		rectfill(p1.x-cam[1],128,p1.x+108,127-rw,7)
		print("score:"..p1.x\10 .."       ".."hi-score:"..hiscore,p1.x-(cam[1]-2),2,0)
	 print("mode:"..mode,p1.x-(cam[1]-2),121,0)
	 --
	 foreach(players, function(obj) obj:draw() end)
		
		for o in all(obstacles) do
		 o:draw()
		end
 
 else
  cls(12)
  print("ball ● game",37,20,7)
  
  print("press z to begin",30,100,7)
  
 end	
	
--testing array
i=0
for x in all(test) do
print(x,p1.x+60,20+i,8)
i+=6
end

end
-->8

--[[

rects--8 tall from -64 

size - 5

	

112 black size

128*128

]]--
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00140000237501e7501975021750217501a0001c7001c7001c7001c7001c7001c7001c70000700037001c7001c7001c7001c70000000000000000000000000000000000000000000000000000000000000000000
001000001d550205501f5501c5501b5501d5501b5501a5501a5501950017500135001350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001362012620357202e7202b70028700247001a7501c7501e7502b6001c7001a7002e700187001770015700147002475010700107000f7000f7000f7001070012700157001970021700237002d7002d700
001000002150025500255002450023500225002250027500235001e5001a500165001a50012500255001950017500085000000000000000000000000000000000000000000000000000000000000000000000000
00100000175501d550000000000017500000000000000000000000000019500005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 07424344

