pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function dist(a,b)
return sqrt(((b.x-a.x)^2)+((b.y-a.y)^2))
end

function rspr(s,x,y,a,w,h)
 sw=(w or 1)*8
 sh=(h or 1)*8
 sx=(s%8)*8
 sy=flr(s/8)*8
 x0=flr(0.5*sw)
 y0=flr(0.5*sh)
 --a=a/360
 sa=sin(a)
 ca=cos(a)
 for ix=sw*-1,sw+4 do
  for iy=sh*-1,sh+4 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh-1) then
    local col = sget(sx+xx,sy+yy)
    if col != 0 then
     pset(x+ix,y+iy,col)
    end
   end
  end
 end
end


function spawn_particles(_x,_y,_dx,_dy,_l,_s,_g,_p,_f)
    add(particles, {
        fade=_f,
     x=_x,
     y=_y,
     dx=_dx,
     dy=_dy,
     life=_l,
     orig_life=_l,
     rad=_s,
     p=_p,
        col=12, --set to color
     grav=_g,
     draw=function(self)
         --this function takes care
         --of drawing the particle
        
         --clear the palette
         pal()
         palt()
        
         --draw the particle
         circfill(self.x,self.y,self.rad,self.col)
     end,
     update=function(self)
         --this is the update function
        
         --move the particle based on
         --the speed
         self.x+=self.dx
         self.y+=self.dy
         --and gravity
         self.dy+=self.grav
        
         --reduce the radius
         --this is set to 90%, but
         --could be altered
         self.rad*=self.p
        
         --reduce the life
         self.life-=1
        
         --set the color
         if type(self.fade)=="table" then
             --assign color from fade
             --this code works out how
             --far through the lifespan
             --the particle is and then
             --selects the color from the
             --table
             self.col=self.fade[flr(#self.fade*(self.life/self.orig_life))+1]
            else
                --just use a fixed color
                self.col=self.fade            
         end
         
         --if the dust has exceeded
         --its lifespan, delete it
         --from the table
         if self.life<0 then
             del(particles,self)
        end
     end
 })
end

function zspr(n,w,h,dx,dy,dz,fx,fy)
 sspr(8*(n%16),8*flr(n/16),8*w,8*h,dx,dy,8*w*dz,8*h*dz,fx,fy)
end

function collision(a,b)
 if abs(a.x-b.x)<(a.w+b.w) and abs(a.y-b.y)<(a.h+b.h) then
  return true
 else
  return false 
 end
end

-- common comparators
function  ascending(a,b) return a<b end
function descending(a,b) return a>b end

function pick (prop)
return (function (a,b) return a.prop<b.prop end)
end

axes={
x=function (a,b) return a.x<b.x end,
y=function (a,b) return a.y<b.y end}
-- a: array to be sorted in-place
-- c: comparator (optional, defaults to ascending)
-- l: first index to be sorted (optional, defaults to 1)
-- r: last index to be sorted (optional, defaults to #a)
function qsort(a,c,l,r)
    c,l,r=c or ascending,l or 1,r or #a
    if l<r then
        if c(a[r],a[l]) then
            a[l],a[r]=a[r],a[l]
        end
        local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
        while k<=rp do
            if c(a[k],p) then
                a[k],a[lp]=a[lp],a[k]
                lp+=1
            elseif not c(a[k],q) then
                while c(q,a[rp]) and k<rp do
                    rp-=1
                end
                a[k],a[rp]=a[rp],a[k]
                rp-=1
                if c(a[k],p) then
                    a[k],a[lp]=a[lp],a[k]
                    lp+=1
                end
            end
            k+=1
        end
        lp-=1
        rp+=1
        a[l],a[lp]=a[lp],a[l]
        a[r],a[rp]=a[rp],a[r]
        qsort(a,c,l,lp-1)
        qsort(a,c,lp+1,rp-1)
        qsort(a,c,rp+1,r)
    end
end

function isort(a,cmp)
  for i=1,#a do
    local j = i
    while j > 1 and cmp(a[j],a[j-1]) do
        a[j],a[j-1] = a[j-1],a[j]
    j = j - 1
    end
  end
end

function sap(stuff)

 local choice=rnd({"x","y"})
 isort(stuff, pick(choice))
 
 --sap
 local actives={}
 local current={}
 add(current,stuff[1])
 for k=1,#stuff-1 do
  if stuff[k+1].choice >= v.choice+v.size then
   add(current,stuff[k+1])
  elseif #current >1 then
   add(activities,current)
   current={stuff[k+1]}
  else
   current={stuff[k+1]}
  end
 end
 
 --collision
 
end
-->8
--[[todo:

-thrusters go through spaceship

-make planets

-make minigames

-import hannah monkey

-call rabbit babs

]]--

function spawn_player()
	add(players,{
	x=64,
	y=64,
	vx=0,
	vy=0,
	a=.1,
	turn=0,
 w=2,
 h=2,
	draw=function(self)
	 --particles here
	 --if (count(dirs,true)>0 and abs((self.vx+self.vy)/2)>(.4*maxv)) spawn_particles(p1.x-(4*self.vx),p1.y-(4*self.vy),-self.vx,-self.vy,2,2,0,1.5,{5,5,5,5}) 
	 if (count(dirs,true)>0) spawn_particles(p1.x,p1.y,-self.vx,-self.vy,3,1.8,0,1.4,{2,2,12,12}) 
	 --spr(1, self.x, self.y)
	 rspr(1,p1.x-4, p1.y-4,(atan2(self.vy,self.vx))) 
	  
	end,
	update=function(self)
	 self.x += self.vx
	 self.y += self.vy
	  
	 if btn(0) then
	  dirs[1]=true
	  if (self.vx>(maxv*-1)) self.vx -= self.a  
  else dirs[1]=false
	 end	 
  if btn(1) then 
   dirs[2]=true
   if (self.vx<maxv) self.vx += self.a 
  else dirs[2]=false
  end
  
  if btn(2) then
   dirs[3]=true
   if (self.vy>(maxv*-1)) self.vy -= self.a
  else dirs[3]=false
  end
  
  if btn(3) then
   dirs[4]=true
   if (self.vy<maxv) self.vy += self.a
  else dirs[4]=false
  end
  
  self.turn=(atan2(self.vy,self.vx))
 end})
 
end



function spawn_asteroid()
 add(asteroids,{
 x=rnd({p1.x-80,p1.x+80}),
	y=rnd({p1.y-80,p1.y+80}),
	vx=rnd(2)-1,
	vy=rnd(2)-1,
	size=2+flr(rnd(5)),
	h=size,
	w=size,
	draw=function(self)
	 circfill(self.x, self.y,(self.size), 4)
	end,
	
	update=function(self)
	 if self.x < (p1.x-70)-(self.size+10) or self.x > (p1.x+70)+(self.size+10) or self.y < (p1.y-70)-(self.size+10) or self.y > (p1.x+70)+(self.size+10) then
	  del(asteroids, self)
	 else
	  self.x+=self.vx
	  self.y+=self.vy
	 end
 end})
  
end

function spawn_stars(limit)
add(stars,{
x=(p1.x-70)+rnd(130)+(rnd({1,-1})*limit),
y=(p1.y-70)+rnd(130)+(rnd({1,-1})*limit),
v=rnd(2),
c=rnd(16),

update=function(self)
 if (dist(p1,self)>130) then
  del(stars, self)
 end
 self.x-=p1.vx*self.v
 self.y-=p1.vy*self.v
end,

draw=function(self)
 pset(self.x,self.y,self.c)
 --circ(self.x,self.y,rnd(2),self.c)
end
})

end


function spawn_planet(xp,yp, sizep,namep)
 add(planets,{
 x=xp,
 y=yp,
 size=sizep,
 craters={},
 h=sizep,
 w=sizep,
 name=namep,
  
 update=function(self)
 
 
 end,
 
 draw=function(self)
 if dist(self,p1)<120 then 
 circfill(self.x, self.y,(self.size+2), 5)
 circfill(self.x, self.y,(self.size), 6)
 circ(self.x+7,self.y,3,0)
 circ(self.x+8,self.y+8,2,5)
 circ(self.x-4,self.y+4,2,0)
 circ(self.x-8,self.y-6,4,5)

 end 
 
 
 end
 })
end



-->8
	--timer
t=0

function tupdate()
 --increase timer
 t+=0.05
end

function tdraw()
 cls()
 
 --this crazy bit loops through
 --limited background colors,
 --and changes it when the
 --screen is covered with white
 local c = 12 + ((t-2.55)/4)%4
 rectfill(0,0,128,128,c)
 
 for i=0,8 do -- column loop
  for j=0,8 do -- row loop
      --x positions are snapped
      --to 16px columns
      local x = i*16
     
      --this number sweeps back
      --and forth from -1 to 1
      local osc1 = sin(t+i*0.1)
     
      --this number also sweeps
      --back and forth, but at
      --a different rate
      local osc2 = sin(t/4+j*0.03)
     
      --y positions are influenced
      --by one of the sweepy
      --numbers
      local y = j*16 + osc1*10
     
      --the circles' radii are
      --influenced by the other
      --sweepy number
   circfill(x, y, osc2*15, 7)
   
  end
 end
end
-->8
function _init()
 dirs={false,false,false,false}
 particles={}
 stars={}
 planets={}
 players={}
 asteroids={}
  
 --parameters

 --player
 maxv=1.5
 
 spawn_player()
 p1=players[1]
 --stars
 maxstars=50
 
 for cc=0,maxstars\4 do
  spawn_stars(0)
 end	
 
 --asteroids
 maxnum=8
 chance=10
 
 --planets
 spawn_planet(-10,-10, 12,"ten")
 			

 qsort(planets, byx )
 

end

--[[
60 fps

function _update60()

end
]]



--[[
30 fps
]]


function _update60()
 --player
 p1:update()
 
 --asteroids
 if count(asteroids) < maxnum and flr(rnd(chance))==1 then
  spawn_asteroid()
 end
 
 for rock in all(asteroids) do
  rock:update()
 end
 
 --stars
 for i=0,(maxstars-count(stars)) do
  spawn_stars(95)
 end
 
 
 for star in all(stars) do
  star:update()
 end
 
 --particles
 for d in all(particles) do
  d:update()
 end

--foreach(game_objs, function(obj) obj:draw() end)

 --camera
 camera(p1.x-64,p1.y-64)
end



--render stuff, should be last
function _draw()
 cls()

 --stars
	for star in all(stars) do
	 star:draw()
	end

 --planets
 for p in all(planets) do
  p:draw()
 end
 	
	--rocks
	for rock in all(asteroids) do
	 rock:draw()
	end	
	
	--particles
	for d in all(particles) do
  d:draw()
 end


 
 --player
	p1:draw() 
 
 

 
	--[[print(p1.x.."\n"..p1.y.."\n"
	..p1.vx.."\n"..p1.vy.."\n"..
	p1.turn.."\n",
	p1.x-30,p1.y-30, 7)
	]]--



end



__gfx__
00000000030330300060600000000660600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000033330000f0f00000006776760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700009999000066770000006776760000000000000990000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000990099000657500000067f6f60000000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000999999000677700000067f6f60000000000aaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700009999000353350000006777776000000000044444400000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000355550000067777777600000044444444444400000000000000000000000000000000000000000000000000000000000000000000000000
000000000009900000100100006777577576000004ff44444444ff40000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa0000099900006777777776000004f440fff0444f40000000000000000000000000000000000000000000000000000000000000000000000000
000000000aa00aa0000999a0000667777776000000444f5f5f444400000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa9999aa0f44444f000066777660000000004fffff440044000000000000000000000000000000000000000000000000000000000000000000000000
00000000a900009a00440f000000533333500000000004fff4400400000000000000000000000000000000000000000000000000000000000000000000000000
00000000a000000a0004fff000065555595700000000488888884400000000000000000000000000000000000000000000000000000000000000000000000000
00000000400000044488888000067d11116700000000488888224000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000048880000000d10110000000000008888200000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000004040000000660660000000000004404400000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110003030000000000000000004444444400030033000000000000000000000000000000000000000000000000000000000000000000000000
00000000454445444a3334a000000000000000005545555503330300000000000000000000000000000000000000000000000000000000000000000000000000
00000000144114413a3333a300030000000000006556666530033000000000000000000000000000000000000000000000000000000000000000000000000000
00000000911991194a3334a000033300000000006666666600099000000000000000000000000000000000000000000000000000000000000000000000000000
0000000099999999334a333000333400000030006665556600999900003003000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa333a3333343b343000bb30006656665600999900000330000000000000000000000000000000000000000000000000000000000000000000
000000009a99a999034a33300333bbb00bbb33006665556600099000000990000030030000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa3333033333b43b330b3bb3304466666600499400000990000003300000000000000000000000000000000000000000000000000000000000
00000000a9a99aa90000000000000000000000006666666500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000006556644600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa99a9a90000000000000000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000006665555600000000000000000000000000000000000000000000000000000000000000000000000000000000
000000009aa9aa9a0000000000000000000000006656666500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa0000000000000000000000004665555600000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000006666666600000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001400002d0050c05515005330051d055000050c0550d0050a0051d0551b0051e0051a05526005270050d05527005240050d0551f0051c005200551800512055200051f005000051900519005170050000500005
01100000000000000000000147500b75004770000000f750000001675000000167500e75019750000002775000000000003105000000000002575000000000002a750167001e500227501a5000f5002b05029050
__music__
01 01024344

