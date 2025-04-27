--[[
    Mephistroth 按键禁用助手主文件
    当BOSS Mephistroth施放“Shackles of the Legion!”时，自动禁用WASD及方向键，7秒后恢复。
    适用于魔兽世界乌龟服 1.12.x
    作者：果盘杀手, 二狗子 - 天空之城（乌龟拉风服务器）
--]]

-- 定义需要禁用的按键，包括常用移动键和方向键
local wasdKeys = {"W", "A", "S", "D", "Q", "E", "UP", "DOWN", "LEFT", "RIGHT"}

-- 用于保存每个按键的原始绑定，便于后续恢复
local originalBindings = {}

-- 禁用WASD及相关按键的函数
local function DisableWASD()
    -- 遍历所有需要禁用的按键
    for _, key in ipairs(wasdKeys) do
        -- 保存当前按键的原始绑定动作（如MOVEFORWARD等）
        originalBindings[key] = GetBindingAction(key)
        -- 清除该按键的绑定（解除绑定）
        SetBinding(key)
    end
    -- 保存当前绑定设置，确保更改生效
    SaveBindings(GetCurrentBindingSet())
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

-- 聊天消息事件处理函数
-- 当检测到BOSS喊话“Mephistroth begins to cast Shackles of the Legion!”时，禁用按键7秒
local function OnChatMessage(event, message)
    -- 检查是否为目标BOSS喊话
    if message == "Mephistroth begins to cast Shackles of the Legion!" then
        DisableWASD()
        -- 7秒后自动恢复按键绑定
        DT_Timer.After(7, RestoreWASD)
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