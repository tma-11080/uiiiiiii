local TweenService = game:GetService("TweenService")

local GUI_PARENT = (typeof(gethui) == "function" and gethui())
               or game:GetService("CoreGui")

local BG_COLOR   = Color3.fromRGB(43, 46, 59)
local STAR_COLOR = Color3.fromRGB(210, 248, 254)
local TEXT_COLOR = Color3.fromRGB(210, 248, 254)

local StartGui = Instance.new("ScreenGui")
StartGui.Name           = "MacLolStartup"
StartGui.IgnoreGuiInset = true
StartGui.ResetOnSpawn   = false
StartGui.DisplayOrder   = 999
StartGui.Parent         = GUI_PARENT

local BG = Instance.new("Frame")
BG.Size                   = UDim2.fromScale(1, 1)
BG.BackgroundColor3       = BG_COLOR
BG.BackgroundTransparency = 0.12
BG.BorderSizePixel        = 0
BG.ZIndex                 = 1
BG.Parent                 = StartGui

-- 星
for _ = 1, 160 do
    local size = math.random(2, 5)
    local s = Instance.new("Frame")
    s.Size                   = UDim2.fromOffset(size, size)
    s.Position               = UDim2.fromScale(math.random(), math.random())
    s.BackgroundColor3       = STAR_COLOR
    s.BackgroundTransparency = math.random(1, 6) / 10
    s.BorderSizePixel        = 0
    s.ZIndex                 = 2
    s.Parent                 = BG
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while s and s.Parent do
            local dur = math.random(20, 50) / 10
            TweenService:Create(s, TweenInfo.new(dur, Enum.EasingStyle.Sine), {
                Position             = UDim2.fromScale(
                    math.clamp(s.Position.X.Scale + math.random(-15, 15) / 100, 0, 1),
                    math.clamp(s.Position.Y.Scale + math.random(-15, 15) / 100, 0, 1)
                ),
                BackgroundTransparency = math.random(1, 7) / 10
            }):Play()
            task.wait(dur)
        end
    end)
end

-- 数字テキスト
local MainText = Instance.new("ImageLabel")
MainText.Size                  = UDim2.new(0.9, 0, 0, 70)
MainText.Position              = UDim2.fromScale(0.5, 0.47)
MainText.AnchorPoint           = Vector2.new(0.5, 0.5)
MainText.BackgroundTransparency = 1
MainText.Text                  = "rbxassetid://102272836959278" 
MainText.TextColor3            = TEXT_COLOR
MainText.TextSize              = 44
MainText.Font                  = Enum.Font.BuilderSansExtraBold
MainText.TextTransparency      = 1
MainText.ZIndex                = 3
MainText.Parent                = BG

local Scale = Instance.new("UIScale")
Scale.Scale  = 0.4
Scale.Parent = MainText

-- mac-lol-ui
local SubText = Instance.new("TextLabel")
SubText.Size                   = UDim2.new(0.9, 0, 0, 28)
SubText.Position               = UDim2.new(0.5, 0, 0.47, 42)
SubText.AnchorPoint            = Vector2.new(0.5, 0)
SubText.BackgroundTransparency = 1
SubText.Text                   = "mac-lol-ui"
SubText.TextColor3             = TEXT_COLOR
SubText.TextSize               = 15
SubText.Font                   = Enum.Font.BuilderSansMedium
SubText.TextTransparency       = 1
SubText.ZIndex                 = 3
SubText.Parent                 = BG

-- ポン音
local Pon = Instance.new("Sound")
Pon.SoundId = "rbxassetid://9119713951"
Pon.Volume  = 0.75
Pon.Parent  = BG

-- アニメーション
task.wait(0.4)
Pon:Play()

TweenService:Create(Scale,    TweenInfo.new(0.25, Enum.EasingStyle.Back),  {Scale = 1.08}):Play()
TweenService:Create(MainText, TweenInfo.new(0.2),                           {TextTransparency = 0}):Play()
task.wait(0.25)
TweenService:Create(Scale,    TweenInfo.new(0.15, Enum.EasingStyle.Sine),  {Scale = 1.0}):Play()
task.wait(0.15)
TweenService:Create(SubText,  TweenInfo.new(0.4,  Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()

task.wait(2.0)

-- フェードアウト
TweenService:Create(BG,       TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(MainText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
TweenService:Create(SubText,  TweenInfo.new(0.4), {TextTransparency = 1}):Play()
for _, obj in BG:GetChildren() do
    if obj:IsA("Frame") then
        TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    end
end

task.wait(0.6)
StartGui:Destroy()
