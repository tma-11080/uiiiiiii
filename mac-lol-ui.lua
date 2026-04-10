-- mac-lol-ui
-- ライブラリを読み込む (パスは環境に合わせて変更してね)
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.lua"
))()

-- ============================================================
--  起動アニメーション
-- ============================================================
local TweenService = game:GetService("TweenService")
local Players     = game:GetService("Players")
local LP          = Players.LocalPlayer

local GUI_PARENT  = (typeof(gethui) == "function" and gethui())
                 or game:GetService("CoreGui")

local BG_COLOR    = Color3.fromRGB(43, 46, 59)
local STAR_COLOR  = Color3.fromRGB(210, 248, 254)
local TEXT_COLOR  = Color3.fromRGB(210, 248, 254)

-- ScreenGui
local StartGui = Instance.new("ScreenGui")
StartGui.Name            = "MacLolStartup"
StartGui.IgnoreGuiInset  = true
StartGui.ResetOnSpawn    = false
StartGui.DisplayOrder    = 999
StartGui.Parent          = GUI_PARENT

-- 背景フレーム
local BG = Instance.new("Frame")
BG.Size                  = UDim2.fromScale(1, 1)
BG.BackgroundColor3      = BG_COLOR
BG.BackgroundTransparency = 0.12   -- ちょい透過
BG.BorderSizePixel       = 0
BG.ZIndex                = 1
BG.Parent                = StartGui

-- ============================================================
--  星 (無数・背景レイヤー ZIndex=2)
-- ============================================================
local STAR_COUNT = 160

local function makeStar()
    local size = math.random(2, 5)
    local s = Instance.new("Frame")
    s.Size                  = UDim2.fromOffset(size, size)
    s.Position              = UDim2.fromScale(math.random(), math.random())
    s.BackgroundColor3      = STAR_COLOR
    s.BackgroundTransparency = math.random(1, 6) / 10
    s.BorderSizePixel       = 0
    s.ZIndex                = 2
    s.Parent                = BG

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = s

    -- ふわふわ移動
    task.spawn(function()
        while s and s.Parent do
            local dur = math.random(20, 50) / 10
            local nx  = math.clamp(s.Position.X.Scale + math.random(-15, 15) / 100, 0, 1)
            local ny  = math.clamp(s.Position.Y.Scale + math.random(-15, 15) / 100, 0, 1)
            local tr  = math.random(1, 7) / 10
            TweenService:Create(s, TweenInfo.new(dur, Enum.EasingStyle.Sine), {
                Position             = UDim2.fromScale(nx, ny),
                BackgroundTransparency = tr
            }):Play()
            task.wait(dur)
        end
    end)
end

for _ = 1, STAR_COUNT do
    makeStar()
end

-- ============================================================
--  テキスト群 (ZIndex=3 ← 星の前面)
-- ============================================================

-- メイン数字
local MainText = Instance.new("TextLabel")
MainText.Size               = UDim2.new(0.9, 0, 0, 70)
MainText.Position           = UDim2.fromScale(0.5, 0.47)
MainText.AnchorPoint        = Vector2.new(0.5, 0.5)
MainText.BackgroundTransparency = 1
MainText.Text               = "102272836959278"
MainText.TextColor3         = TEXT_COLOR
MainText.TextSize           = 44
MainText.Font               = Enum.Font.BuilderSansExtraBold
MainText.TextTransparency   = 1
MainText.ZIndex             = 3
MainText.Parent             = BG

-- UIScale for ポン アニメ
local Scale = Instance.new("UIScale")
Scale.Scale  = 0.4
Scale.Parent = MainText

-- mac-lol-ui サブテキスト
local SubText = Instance.new("TextLabel")
SubText.Size                = UDim2.new(0.9, 0, 0, 28)
SubText.Position            = UDim2.new(0.5, 0, 0.47, 42)
SubText.AnchorPoint         = Vector2.new(0.5, 0)
SubText.BackgroundTransparency = 1
SubText.Text                = "mac-lol-ui"
SubText.TextColor3          = TEXT_COLOR
SubText.TextSize            = 15
SubText.Font                = Enum.Font.BuilderSansMedium
SubText.TextTransparency    = 1
SubText.LetterSpacing       = 4
SubText.ZIndex              = 3
SubText.Parent              = BG

-- ============================================================
--  "ポン" 効果音
-- ============================================================
local Pon = Instance.new("Sound")
Pon.SoundId  = "rbxassetid://9119713951"  -- pop sound
Pon.Volume   = 0.75
Pon.Parent   = BG

-- ============================================================
--  アニメーション再生
-- ============================================================
local function tween(obj, props, dur, style, dir)
    return TweenService:Create(
        obj,
        TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    )
end

task.wait(0.4)

-- ポン！ スケールイン
Pon:Play()
tween(Scale,    {Scale = 1.08}, 0.25, Enum.EasingStyle.Back):Play()
tween(MainText, {TextTransparency = 0}, 0.2):Play()
task.wait(0.25)
tween(Scale,    {Scale = 1.0},  0.15, Enum.EasingStyle.Sine):Play()

task.wait(0.15)
tween(SubText, {TextTransparency = 0}, 0.4, Enum.EasingStyle.Quint):Play()

-- 2秒表示
task.wait(2.0)

-- フェードアウト
tween(BG,       {BackgroundTransparency = 1}, 0.5):Play()
tween(MainText, {TextTransparency = 1},       0.4):Play()
tween(SubText,  {TextTransparency = 1},       0.4):Play()

for _, obj in BG:GetChildren() do
    if obj:IsA("Frame") then
        tween(obj, {BackgroundTransparency = 1}, 0.5):Play()
    end
end

task.wait(0.6)
StartGui:Destroy()

-- ============================================================
--  メインウィンドウ
-- ============================================================
local Window = Library:MakeWindow({
    Title       = "Nice Hub : Cool Game",
    SubTitle    = "dev by real_redz",
    ScriptFolder = "redz-library-V5"
})

-- ミニマイザー
local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

local MobileButton = Minimizer:CreateMobileMinimizer({
    Image            = "rbxassetid://0",
    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
})

-- ============================================================
--  タブ上の検索バー (ライブラリ外から注入)
-- ============================================================
-- ウィンドウが描画されるまで少し待つ
task.wait(0.1)

local screenGui = game:GetService("CoreGui"):FindFirstChild("redz-library-v5")
local tabsScroll = screenGui
    and screenGui:FindFirstChild("Window", true)
    and screenGui.Window:FindFirstChild("Components", true)
    and screenGui.Window.Components:FindFirstChild("TabsScroll", true)

if tabsScroll then
    -- TabsScroll の上部に余白を作って検索バーを差し込む
    local searchFrame = Instance.new("Frame")
    searchFrame.Name                  = "SearchBar"
    searchFrame.Size                  = UDim2.new(1, -20, 0, 24)
    searchFrame.Position              = UDim2.new(0.5, 0, 0, 8)
    searchFrame.AnchorPoint           = Vector2.new(0.5, 0)
    searchFrame.BackgroundColor3      = Color3.fromRGB(38, 38, 40)
    searchFrame.BorderSizePixel       = 0
    searchFrame.Parent                = tabsScroll.Parent  -- Tabs の親に追加

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = searchFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color     = Color3.fromRGB(55, 55, 60)
    stroke.Thickness = 1
    stroke.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size                  = UDim2.new(0.82, 0, 0.82, 0)
    searchBox.AnchorPoint           = Vector2.new(0.5, 0.5)
    searchBox.Position              = UDim2.fromScale(0.55, 0.5)
    searchBox.BackgroundTransparency = 1
    searchBox.PlaceholderText       = "Search tabs..."
    searchBox.PlaceholderColor3     = Color3.fromRGB(130, 130, 140)
    searchBox.Text                  = ""
    searchBox.TextColor3            = Color3.fromRGB(232, 233, 235)
    searchBox.TextSize              = 10
    searchBox.Font                  = Enum.Font.BuilderSansMedium
    searchBox.TextXAlignment        = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus      = false
    searchBox.Parent                = searchFrame

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size                  = UDim2.fromOffset(12, 12)
    searchIcon.Position              = UDim2.new(0, 8, 0.5, 0)
    searchIcon.AnchorPoint           = Vector2.new(0, 0.5)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image                 = "rbxassetid://10734943674"
    searchIcon.ImageColor3           = Color3.fromRGB(160, 160, 170)
    searchIcon.Parent                = searchFrame

    -- タブ一覧をスクロールに反映
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for _, tabBtn in tabsScroll:GetChildren() do
            if tabBtn:IsA("TextButton") then
                local title = tabBtn:FindFirstChildOfClass("TextLabel")
                if title then
                    tabBtn.Visible = query == ""
                        or title.Text:lower():find(query, 1, true) ~= nil
                end
            end
        end
    end)

    -- TabsScroll を少し下にずらして検索バーと重ならないように
    tabsScroll.Position = UDim2.new(0, 0, 0, 38)
    tabsScroll.Size     = UDim2.new(tabsScroll.Size.X.Scale, tabsScroll.Size.X.Offset,
                                    1, -tabsScroll.Position.Y.Offset)
end

-- ============================================================
--  タブ & 要素サンプル (使いたいものだけ残してね)
-- ============================================================
local MainTab = Window:MakeTab({
    Title = "Cool Tab",
    Icon  = "Home"
})

-- セクション
MainTab:AddSection("Section")

-- トグル
MainTab:AddToggle({
    Name     = "Toggle",
    Default  = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

-- ボタン
MainTab:AddButton({
    Name     = "My Button",
    Debounce = 0.5,
    Callback = function()
        print("Button clicked")
    end
})

-- スライダー
MainTab:AddSlider({
    Name      = "Cool Title",
    Min       = -5,
    Max       = 5,
    Increment = 0.25,
    Default   = 0,
    Callback  = function(Value)
        print("Slider:", Value)
    end
})

-- ドロップダウン (シングル)
MainTab:AddDropdown({
    Name     = "Dropdown",
    Options  = {"one", "two", "three", "four", "five"},
    Default  = "one",
    Callback = function(Value)
        print("Dropdown:", Value)
    end
})

-- ドロップダウン (マルチ)
MainTab:AddDropdown({
    Name        = "Multi Dropdown",
    MultiSelect = true,
    Options     = {"one", "two", "three", "four", "five"},
    Default     = {"one", "four"},
    Callback    = function(Value)
        print("Multi Dropdown:", Value)
    end
})

-- テキストボックス
MainTab:AddTextBox({
    Name          = "My TextBox",
    Default       = "text",
    Placeholder   = "input text...",
    ClearOnFocus  = true,
    Callback      = function(Value)
        print("TextBox:", Value)
    end
})

-- Discord 招待
MainTab:AddDiscordInvite({
    Title       = "redz Hub | Community",
    Description = "A community for redz Hub Users -- official scripts, updates, and support in one place.",
    Banner      = "rbxassetid://17382040552",
    Logo        = "rbxassetid://17382040552",
    Invite      = "https://discord.gg/redz-hub",
    Members     = 470000,
    Online      = 20000,
})

-- ダイアログ例
Window:Dialog({
    Title   = "Hello!",
    Content = "do you like Coffee?",
    Options = {
        {
            Name = "No"
        },
        {
            Name     = "Yes!",
            Callback = function()
                print("Yes, i like Coffee")
            end
        }
    }
})

-- 通知例
Window:Notify({
    Title    = "Notification",
    Content  = "this is a Notification",
    Image    = "rbxassetid://10734953451",
    Duration = 5
})

-- UI スケール
Library:SetUIScale(1.0)
print(string.format("UI Scale: min=%s max=%s", Library:GetMinScale(), Library:GetMaxScale()))

-- フラグ例
local ToggleValue = Window:GetFlag("toggle_flag") or false
MainTab:AddToggle({
    Name    = "Cool Toggle (flag)",
    Default = ToggleValue,
    Flag    = "toggle_flag",
    Callback = function(Value)
        Window:SetFlag("toggle_flag", Value)
    end
})
