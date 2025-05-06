--[[
    Mephistroth 按键禁用助手主文件
    当BOSS Mephistroth施放“Shackles of the Legion!”时，自动禁用WASD及方向键，8秒后恢复。
    适用于魔兽世界乌龟服 1.12.x
    作者：果盘杀手, 二狗子 - 天空之城（乌龟拉风服务器）
--]]

-- 定义需要禁用的按键，包括常用移动键和方向键
local wasdKeys = { "W", "A", "S", "D", "Q", "E", "UP", "DOWN", "LEFT", "RIGHT", "SPACE" } -- 加入SPACE禁用跳跃

-- 用于保存每个按键的原始绑定，便于后续恢复
local originalBindings = {}

-- 多语言本地化表
local locale = GetLocale()
local L = {}

if locale == "zhCN" then
    L.BOSS_CAST = "Mephistroth begins to cast Shackles of the Legion"
    L.BOSS_CAST_CN = "孟菲斯托斯开始施放军团镣铐"
    L.BIGMSG = "【DT_Mephistroth】警告!!!警告!!!，请松开WASD/方向键！"
elseif locale == "zhTW" then
    L.BOSS_CAST = "Mephistroth begins to cast Shackles of the Legion"
    L.BOSS_CAST_CN = "梅菲斯托斯開始施放軍團鐐銬"
    L.BIGMSG = "【DT_Mephistroth】警告!!!警告!!!，請鬆開WASD/方向鍵！"
else
    L.BOSS_CAST = "Mephistroth begins to cast Shackles of the Legion"
    L.BOSS_CAST_CN = nil
    L.BIGMSG = "[DT_Mephistroth] WARNING!!! WARNING!!! Release WASD/Arrow keys now!"
end

-- 创建一个大字体提示的函数
local function ShowBigMessage(msg)
    if not DT_Mephistroth_BigMsg then
        local f = CreateFrame("Frame", "DT_Mephistroth_BigMsg", UIParent)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetWidth(1000) -- 更长
        f:SetHeight(800) -- 更高
        f:SetPoint("CENTER", 0, 0)
        -- 黑色背景
        local bg = f:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetTexture(0, 0, 0, 0.6) -- 1.12用SetTexture代替SetColorTexture
        f.bg = bg
        local text = f:CreateFontString(nil, "OVERLAY")
        text:SetFont("Fonts\\FRIZQT__.TTF", 120, "OUTLINE") -- 字体更大
        text:SetAllPoints()
        text:SetJustifyH("CENTER")
        text:SetJustifyV("MIDDLE")
        text:SetTextColor(1, 0, 0) -- 红色
        f.text = text
        f:Hide()
    end
    DT_Mephistroth_BigMsg.text:SetText(msg)
    DT_Mephistroth_BigMsg.text:SetTextColor(1, 0, 0) -- 确保每次都为红色
    DT_Mephistroth_BigMsg:Show()
    -- 8秒后自动隐藏
    DT_Timer.After(8, function() DT_Mephistroth_BigMsg:Hide() end)
end

-- 检查玩家是否在移动
local playerMoveState = {}
local function PlayerIsMoving()
    -- 1.12没有IsMoving，可以用速度判断
    local x, y = GetPlayerMapPosition("player")
    local now = GetTime()
    if not playerMoveState.lastX then
        playerMoveState.lastX, playerMoveState.lastY = x, y
        playerMoveState.lastTime = now
        return false -- 未知时视为未移动
    end
    -- 增加时间间隔判断，避免频繁刷新导致误判
    if now - (playerMoveState.lastTime or 0) < 0.2 then
        return false
    end
    local moved = (x ~= playerMoveState.lastX or y ~= playerMoveState.lastY)
    playerMoveState.lastX, playerMoveState.lastY = x, y
    playerMoveState.lastTime = now
    return moved
end

-- 恢复WASD及相关按键原始绑定的函数
local function RestoreWASD()
    -- 遍历之前保存的绑定表
    for key, action in pairs(originalBindings) do
        -- 恢复每个按键的原始绑定（如MOVEFORWARD等）
        SetBinding(key, action)
    end
    -- 保存当前绑定设置，确保恢复生效
    SaveBindings(GetCurrentBindingSet())
end

-- 禁用移动键的具体实现
local function ReallyDisableWASD()
    if PlayerIsMoving() == true then return end -- 如果玩家未移动，则不执行

    for _, key in ipairs(wasdKeys) do
        -- 保存当前按键的原始绑定动作（如MOVEFORWARD等）
        originalBindings[key] = GetBindingAction(key)
        -- 清除该按键的绑定（解除绑定）
        SetBinding(key)
    end
    -- 保存当前绑定设置，确保更改生效
    SaveBindings(GetCurrentBindingSet())

    -- 8秒后自动恢复按键绑定
    DT_Timer.After(8, RestoreWASD)
end

-- 禁用WASD及相关按键的函数
local function DisableWASD()
    -- 检查玩家是否在移动
    if PlayerIsMoving() == false then
        ReallyDisableWASD()
    else
        -- 如果玩家正在移动，稍后再禁用
        DT_Timer.After(1.8, function()
            if PlayerIsMoving() == false then
                ReallyDisableWASD()
            else
                -- 如果仍在移动，继续检查
                DisableWASD()
            end
        end)
    end
end

-- 聊天消息事件处理函数
-- 当检测到BOSS喊话“Mephistroth begins to cast Shackles”时，禁用按键8秒
local function OnChatMessage(event, message)
    if not message then return end
    -- 检查是否为目标BOSS喊话（多语言）
    if string.find(message, L.BOSS_CAST)
        or (L.BOSS_CAST_CN and string.find(message, L.BOSS_CAST_CN)) then
        -- DisableWASD()
        ShowBigMessage(L.BIGMSG)
    end
end

-- 创建一个Frame用于监听聊天相关事件
local frame = CreateFrame("Frame")
-- 注册BOSS表情喊话事件
frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
-- 注册团队领袖频道事件
frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
-- 注册团队频道事件
-- frame:RegisterEvent("CHAT_MSG_RAID")
-- 设置事件回调函数，收到事件时调用OnChatMessage处理
frame:SetScript("OnEvent", function()
    -- 调试信息输出到聊天框
    -- DEFAULT_CHAT_FRAME:AddMessage("Event: " .. event .. ", Message: " .. arg1)
    -- 处理事件
    OnChatMessage(event, arg1)
end)
