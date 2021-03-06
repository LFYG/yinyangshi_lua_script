chapter_tap = switch {
  [1] = function () tap(1900, 339) end,
  [2] = function() tap(1900, 520 ) end,		
  [3] = function() tap(1900, 700) end,  
  [4] = function() tap(1900, 900)	end,	
  [17] = function() tap(1900, 750)	end, 
  [18] = function() tap(1900, 950) end
}

change_ss_tap = switch {
  [1] = function () 
    tap(1050, 1067)
    mSleep(200)
    tap(1050, 1067)
  end,
  [2] = function () 
    tap(1050, 1067)
    mSleep(200)
    tap(1050, 1067)
  end,	
  [3] = function () 
    tap(1050, 1067)
    mSleep(200)
    tap(1050, 1067)
  end,
  [4] = function () 
    tap(289, 726)
    mSleep(200)
    tap(289, 726)
  end,
  [5] = function () 
    tap(289, 726)
    mSleep(200)
    tap(289, 726)
  end,
}

----------------------------------------------------Step 1: 进入探索---------------------------------------------------
function enter_tansuo()
  local current_state = check_current_state()
  if current_state == 1 then
		local tansuo_x, tansuo_y = myFindColor(探索灯笼)
		sysLog(tansuo_x)
		sysLog(tansuo_y)
		if tansuo_x > -1 then
			sysLog('点击试试')
			tap(tansuo_x+15, tansuo_y+45)
			mSleep(3000)
			return enter_tansuo()--进入探索页面
		else
			my_toast(id, '没有找到探索，请手动进入探索')
			mSleep(2000)
			return enter_tansuo()
		end
	elseif current_state == 'machi' then
    local machi_x, machi_y = findMultiColorInRegionFuzzy(0xbeb6b3,"3|25|0xb9b5c3,1|40|0x141412,-1|228|0x979793", 95, 1540,460,1550,480)
    if machi_x > -1 then
      my_toast(id, '进入庭院')
      tap(1545, 575)
      mSleep(2000)
			my_swip(1800, 1250, 200, 1250, 50)
      return enter_tansuo()
		else
			my_toast(id, '没有找到主界面入口，麻烦手动进入')
			mSleep(2000)
			return enter_tansuo()
    end
  elseif current_state == 21 then
    my_toast(id, '正在战斗中！请完成战斗后进入探索界面开启脚本！')
		end_combat(0)
		mSleep(2000)
		return enter_tansuo()
	elseif current_state == 22 then
		my_toast(id, '在探索副本！')
		tap(80, 100)												--退出探索本
		mSleep(1500)
		tap(1244, 842)
		return enter_tansuo()
	elseif current_state == 3 then
		my_toast(id, '已经在探索界面了！')
	else
		local red_cross_x, red_cross_y = myFindColor(右上红叉)
		if red_cross_x > -1 then
			tap(red_cross_x, red_cross_y)
			mSleep(1000)
			return enter_tansuo()
		else
			my_toast(id, '请手动进入探索界面！')
			mSleep(2000)
			return enter_tansuo()
		end
end
end

function reset_scroll()
  swip(1900, 250, 1900, 1000)
  mSleep(200)
  swip(1900, 250, 1900, 1000)
  mSleep(200)
  swip(1900, 250, 1900, 1000)
  mSleep(200)
  swip(1900, 250, 1900, 1000)
  mSleep(200)
end

function scroll(times)
  for i = 1,times, 1 do
    swip(1900, 900, 1930, 300)
    mSleep(800)
  end
  mSleep(500)
end


function choose_chapter(chapter)	
  reset_scroll()
  local x  = math.ceil(chapter/4)
  if chapter <=16 then
    sysLog(x-1)
    scroll(x-1)
    chapter_tap:case(chapter - 4*(x-1))
  else
    scroll(4)
    chapter_tap:case(chapter)
  end
end


function enter_dungeon(difficuty)
  accept_quest()
  local x, y = findMultiColorInRegionFuzzy(0xe8d4cf,"26|-2|0x723152,2|24|0x753743,0|-27|0x672f38,-31|2|0x763b3f", 95, 1675, 410, 1706, 437) --xx
	if x > -1 then
    if difficuty == 1 then
      tap(542, 547)
      mSleep(500)
    else
      tap(762, 558)
      mSleep(500)
    end
    tap(1538, 1045)
  else
    mSleep(500)
		return enter_dungeon(difficuty)
  end
end





----------------------------------------------------Step 2: 检测狗粮---------------------------------------------------
--检测是否是n卡
function if_ncard()
  accept_quest()
  local ncard_x, ncard_y = findMultiColorInRegionFuzzy(0x949597,"1|10|0xb2b1b2,9|25|0xdbd9da", 93, 84, 1235, 133, 1295)
  if ncard_x == -1 then
    tap(112, 1273)
    mSleep(500)
    tap(125, 922)
  end
  mSleep(2000)
end

--检测是否需要更换， 从1-5号位开始
function if_change(slot, skip_lines)
  local combat_table = {}
  local watch_table = {}
  keepScreen(true)
  for i = 1, 5, 1 do
    accept_quest()
    local ifchange_x, ifchange_y = findMultiColorInRegionFuzzy(0xf9ac14,"7|-1|0xffad15,-1|7|0xf4bf0d,14|10|0xffd30a,14|16|0xffe605,-12|-7|0xf89819,-14|4|0xfebc11,-13|17|0xfbe504,-6|17|0xefd905,3|-6|0xff9f19", 90, slot[i][1], slot[i][2], slot[i][3], slot[i][4])
    if ifchange_x > -1 then
      my_toast(id, '需要更换狗粮')
      sysLog(ifchange_x..','..ifchange_y..'需要更换狗粮')
      if i <= 3 then
        table.insert(combat_table, i)
      else
        table.insert(watch_table, i)
      end
    end
  end
  keepScreen(false)
  
  --出战位置更换
  if next(combat_table) ~= nil then
    change_ss_tap:case(1)
		mSleep(2000)
		if_ncard()
		my_toast(id, '跳过'..skip_lines..'行')
		skip_ss(skip_lines)
    for k,v in pairs(combat_table) do 
      sysLog('出战位 '..v) 
      change_ss(v)
      mSleep(2000)
    end
		tap(59, 56)
    mSleep(2000)
  end

  if next(watch_table) ~= nil then
    change_ss_tap:case(4)
		mSleep(2000)
		if_ncard()
		my_toast(id, '跳过'..skip_lines..'行')
		skip_ss(skip_lines)
    for k,v in pairs(watch_table) do 
      sysLog('观战位 '..v) 
      change_ss(v)
      mSleep(2000)
    end
		tap(59, 56)
    mSleep(2000)
  end
end



--跳过指定前几行
function skip_ss(lines)							
  for i = 1, lines, 1 do																							
    local new = pos:new(1519, 1380)
    local move = {x=265, y=1380}
    local step = 28
    local sleep1,sleep2 = 500,20
    --表示以坐标0,0为原点滑动到100,200坐标上
    new:touchMoveTo(move,step,sleep1,sleep2)
    mSleep(2000)
  end
end


function change_ss(slot_num)
	sysLog('change_ss')
  keepScreen(true)
  for i = 1, 7, 1 do
    accept_quest()
    local emty_x, emty_y = findMultiColorInRegionFuzzy(0xf7dfa3,"-1|-1|0xc4a578,-2|-2|0xddb687,-2|3|0xd1ab7e,-2|0|0xa07e59,-1|0|0xd3b684,-5|-5|0xae8c65,-4|6|0xb08a63,-6|-7|0xa68763,-8|-8|0xad8c65",80,gouliang_position[i][1], gouliang_position[i][2], gouliang_position[i][3], gouliang_position[i][4]);
    local full_x, full_y = findMultiColorInRegionFuzzy(0xffca0d,"-8|1|0xfdcc0b,8|-1|0xfbc30e", 95, gouliang_position[i][1], gouliang_position[i][2], gouliang_position[i][3], gouliang_position[i][4])  --满字
    if emty_x > -1  and full_x == -1 then
      accept_quest()
      local watch_x, watch_y = findMultiColorInRegionFuzzy(0xb4dfff,"13|2|0xbae1ff,32|4|0xb0ddff,22|21|0xb6e0ff",95, emty_x+61, emty_y+136, emty_x+139, emty_y+213)
      local in_combat_x, in_combat_y = findMultiColorInRegionFuzzy(0xffe3c0,"1|14|0xffdfbb,26|-1|0xffdab3,31|20|0xffdab3,40|33|0xffdfba",95,emty_x+61, emty_y+136, emty_x+139, emty_y+213)
      if watch_x == -1 and in_combat_x == -1 then
        sysLog('找到gl'..emty_x..'.'..emty_y)
        local new_x = emty_x+100
        local new_y = emty_y+100
        sysLog('new_x '..new_x..';new_y '..new_y)
        local new = pos:new(new_x, new_y)
        local move = {x=ss_position[slot_num][1], y=ss_position[slot_num][2]}
        local step = 28
        local sleep1,sleep2 = 500,20
        new:touchMoveTo(move,step,sleep1,sleep2)
        --swip(new_x, new_y, ss_position[slot_num][1], ss_position[slot_num][2])
        mSleep(2000)
        --tap(59, 56)
        --mSleep(2000)
				keepScreen(false)
        return true
      elseif watch_x > -1 then
        sysLog('观战gl'..emty_x..','..emty_x..'watch_x:'..watch_x)
      elseif in_combat_x > -1 then
        sysLog('出战gl'..emty_x..','..emty_x..'combat_x:'..in_combat_x)
      end
    else
      sysLog(i..'号位未找到')
    end
  end
  keepScreen(false)
  skip_ss(1)
  return change_ss(slot_num)
end




----------------------------------------------------Step 3: 开始刷怪---------------------------------------------------


function next_scene()
	sysLog('next_scene')
  swip(1977, 1346, 500, 1346)
end


function search_for_exp(fight_times, search_times, skip_lines)
	sysLog('search_for_exp')
	sysLog(skip_lines)
  local count = 0
  my_toast(id, '寻找经验怪。。。')
  while count < search_times do
    local qTime = mTime()
    accept_quest()
    local exp_x, exp_y = findMultiColorInRegionFuzzy(0x8c1a1b,"-17|-35|0x307885,16|36|0xa16343", 95, 0, 0, 1535, 2047)
    if exp_x > -1 then
      my_toast(id, '找到经验怪')
      sysLog('x:'..exp_x..' y:'..exp_y)
      result = '找到经验怪'
      toast("s:" .. result .. "time:" .. mTime() - qTime)
      accept_quest()
      local combat_x, combat_y = findMultiColorInRegionFuzzy(0xf8f9ff,"18|16|0x343b6b,-19|14|0xe2e4fc,4|40|0x3e2215,-4|-44|0xf1acb6", 80, exp_x-500, exp_y-400, exp_x+500, exp_y-100)
      if combat_x > -1 then 
        sysLog('找到战斗')
        tap(combat_x, combat_y)
        if_outof_sushi()
        mSleep(500)
        combat_x, combat_y = findMultiColorInRegionFuzzy(0xf8f9ff,"18|16|0x343b6b,-19|14|0xe2e4fc,4|40|0x3e2215,-4|-44|0xf1acb6", 80, exp_x-500, exp_y-400, exp_x+500, exp_y-100)
        while combat_x > -1 do
          sysLog('还能找到战斗')
          tap(combat_x, combat_y)
          if_outof_sushi()
          mSleep(500)
          combat_x, combat_y = findMultiColorInRegionFuzzy(0xf8f9ff,"18|16|0x343b6b,-19|14|0xe2e4fc,4|40|0x3e2215,-4|-44|0xf1acb6", 80, exp_x-500, exp_y-400, exp_x+500, exp_y-100)
        end
        my_toast(id, '检测狗粮')
        accept_quest()
        local ready_x, ready_y = findMultiColorInRegionFuzzy(0xfffffa,"5|-39|0xfffff9,27|-34|0xfff3d1,27|-1|0xfffaeb,51|-17|0xfff2d0", 90, 1789, 1274, 1798, 1283)
        while ready_x == -1 do
          mSleep(500)
          accept_quest()
          ready_x, ready_y = findMultiColorInRegionFuzzy(0xfffffa,"5|-39|0xfffff9,27|-34|0xfff3d1,27|-1|0xfffaeb,51|-17|0xfff2d0", 90, 1789, 1274, 1798, 1283)
        end
        if_change(slot, skip_lines)
        start_combat(0)
        mSleep(5000)
        if_boss(fight_times, search_times, skip_lines)
        return search_for_exp(fight_times, search_times, skip_lines)
      else 
        my_toast(id, '未找到战斗')
      end
      --]]
    else
      result = '未找到'
      toast("s:" .. result .. "time:" .. mTime() - qTime)
    end
    count = count + 1
  end
end



----------------------------------------------------Step 4: 汇总---------------------------------------------------
function if_boss(fight_times, search_times, skip_lines)
	sysLog('if_boss')
  my_toast(id, '寻找boss中。。。')
  local boss_x, boss_y = findMultiColorInRegionFuzzy(0x8f1c1e,"32|27|0x8c4f24,29|-4|0xf8e5d6,13|-17|0x455280,19|8|0xede8e3", 90, 768, 400, 1262, 693)
  if boss_x > -1 then
    my_toast(id, '找到boss')
    tap(boss_x, boss_y)
    if_outof_sushi()
    accept_quest()
    my_toast(id, '检测狗粮')
    accept_quest()
		local ready_x, ready_y = findMultiColorInRegionFuzzy(0xfffffa,"5|-39|0xfffff9,27|-34|0xfff3d1,27|-1|0xfffaeb,51|-17|0xfff2d0", 90, 1789, 1274, 1798, 1283)
		while ready_x == -1 do
			mSleep(500)
			accept_quest()
			ready_x, ready_y = findMultiColorInRegionFuzzy(0xfffffa,"5|-39|0xfffff9,27|-34|0xfff3d1,27|-1|0xfffaeb,51|-17|0xfff2d0", 90, 1789, 1274, 1798, 1283)
		end
    if_change(slot, skip_lines)
    start_combat(0)
    mSleep(7000)
    return pick_loot(fight_times, search_times, skip_lines)
  else
    my_toast(id, '未找到boss, 继续刷怪')
    mSleep(1000)
  end
end



function pick_loot(fight_times, search_times, skip_lines)
  local loot_x, loot_y = findMultiColorInRegionFuzzy(0xb44620,"18|-12|0xfff4d4,-20|-13|0xfff4d4,-18|10|0xfff4d4,20|12|0xfff4d4", 90, 0, 0, 2047, 1535)
  if loot_x > -1 then
    my_toast(id, '找到小纸人...')
    tap(loot_x, loot_y)
    mSleep(1000)
    tap(1635, 1156)
    mSleep(2000)
    return pick_loot(fight_times, search_times, skip_lines)
  else
		my_toast(id, '未找到小纸人...')
    mSleep(10000)
    return tansuo(fight_times, search_times, skip_lines)
  end
end


function tansuo(fight_times, search_times, skip_lines)
  --Initialize chapter
	enter_tansuo()
	local chapter_x, chapter_y = findMultiColorInRegionFuzzy(0xb88dda,"38|-2|0xb98ed5,13|32|0x161748,12|43|0x080804,23|39|0x161815,-12|43|0x44b7bd,46|39|0x41a6b0,13|51|0x12283e,43|67|0x40a3ad,21|-13|0xa9d9e4", 95, 826,534,1184,866)
	if chapter_x > -1 then
		tap(chapter_x, chapter_y)
		mSleep(500)
	else
		choose_chapter(17)
	end
	enter_dungeon()
  local fight_count = 0
  while fight_count <= fight_times do
    --enter_dungeon()
    mSleep(5000)
		sysLog('检测锁定')
    local lockss_x, lockss_y = findColorInRegionFuzzy(0x4b5ee9, 90, 1571, 1386, 1642, 1460)  --检测是否锁定
    if lockss_x > -1 then
			sysLog('解锁')
      tap(lockss_x, lockss_y)
    end
    mSleep(1000)
    swip(1347, 1365, 500, 1365)    -- Initialize position
		mSleep(5000)										-- waiting for dialog 
		search_for_exp(fight_times, search_times, skip_lines)
    for find_time = 1, 4, 1 do
      next_scene()  --4次
			search_for_exp(fight_times, search_times, skip_lines)
    end
    tap(78, 103)													--退出探索
    mSleep(1500)
    tap(1244, 842)
    mSleep(2000)
    chapter_x, chapter_y = findMultiColorInRegionFuzzy(0xb88dda,"38|-2|0xb98ed5,13|32|0x161748,12|43|0x080804,23|39|0x161815,-12|43|0x44b7bd,46|39|0x41a6b0,13|51|0x12283e,43|67|0x40a3ad,21|-13|0xa9d9e4", 95, 826,534,1184,866)
    if chapter_x > -1 then
      tap(chapter_x, chapter_y)
    else
      tap(1000, 700)
    end
		mSleep(1000)
		enter_dungeon()
    fight_count = fight_count + 1
  end
end


function main_tansuo(ts_ret, ts_results)
	if ts_ret==0 then	
		toast("您选择了取消，停止脚本运行")
		lua_exit()
	end
	local fight_times = tonumber(ts_results['99'])
	local skip_lines = tonumber(ts_results['100'])
	local search_times = tonumber(ts_results['101'])
	if fight_times == 0 then
		fight_times = 999999
	end
	tansuo(fight_times, search_times, skip_lines)
end

