--[[
    DT_Timer 计时器工具库
    提供 After、NewTimer、NewTicker 等定时器功能，兼容1.12客户端
    用于插件内延迟执行和循环执行任务
--]]

-- 生成计时器函数
local function GenerateTimer()
    local Timer = CreateFrame("Frame")
    local TimerObject = {}

    Timer.Infinite = 0  -- -1 无限循环，0 停止，1..n 循环 n 次
    Timer.ElapsedTime = 0

    -- 启动计时器
    function Timer:Start(duration, callback)
        if type(duration) ~= "number" then
            duration = 0
        end

        self:SetScript("OnUpdate", function()
            self.ElapsedTime = self.ElapsedTime + arg1

            -- 到达指定时间后执行回调
            if self.ElapsedTime >= duration and type(callback) == "function" then
                callback()
                self.ElapsedTime = 0

                -- 判断是否继续循环
                if self.Infinite == 0 then
                    self:SetScript("OnUpdate", nil)
                elseif self.Infinite > 0 then
                    self.Infinite = self.Infinite - 1
                end
            end
        end)
    end

    -- 判断计时器是否已取消
    function TimerObject:IsCancelled()
        return not Timer:GetScript("OnUpdate")
    end

    -- 取消计时器
    function TimerObject:Cancel()
        if Timer:GetScript("OnUpdate") then
            Timer:SetScript("OnUpdate", nil)
            Timer.Infinite = 0
            Timer.ElapsedTime = 0
        end
    end

    return Timer, TimerObject
end

-- 模拟 DT_Timer 库
if not DT_Timer then
    DT_Timer = {
        -- 延迟duration秒后执行callback
        After = function(duration, callback)
            GenerateTimer():Start(duration, callback)
        end,
        -- 创建一次性计时器
        NewTimer = function(duration, callback)
            local timer, timerObj = GenerateTimer()
            timer:Start(duration, callback)
            return timerObj
        end,
        -- 创建循环计时器（ticker），可指定循环次数
        NewTicker = function(duration, callback, ...)
            local timer, timerObj = GenerateTimer()
            local iterations = unpack(arg)

            if type(iterations) ~= "number" or iterations < 0 then
                iterations = 0  -- 无限循环
            end

            timer.Infinite = iterations - 1
            timer:Start(duration, callback)
            return timerObj
        end
    }
end