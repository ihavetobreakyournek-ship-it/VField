 local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService") local SoundService = game:GetService("SoundService") local TextService = game:GetService("TextService") local GuiService = game:GetService("GuiService") local Lighting = game:GetService("Lighting") local HttpService = game:GetService("HttpService") local Stats = game:GetService("Stats") local lp = Players.LocalPlayer local rgb = Color3.fromRGB local env = (getgenv and getgenv()) or _G if env.VFieldLib and env.VFieldLib.Unload then pcall(env.VFieldLib.Unload, env.VFieldLib) end local VField = {Version = "7.0.0", Flags = {}, Overrides = {}} env.VFieldLib = VField local canFS = (writefile and readfile and isfile) ~= nil local function ensureFolder(path) 	if not (makefolder and isfolder) then return end 	local acc = "" 	for part in path:gmatch("[^/]+") do 		acc = acc == "" and part or (acc .. "/" .. part) 		if not isfolder(acc) then pcall(makefolder, acc) end 	end end local function fsWrite(path, data) 	if not writefile then return false end 	ensureFolder(path:match("^(.*)/") or "") 	return (pcall(writefile, path, data)) end local function fsRead(path) 	if readfile and isfile and isfile(path) then 		local ok, d = pcall(readfile, path) 		if ok then return d end 	end end local BASE = { 	Background = rgb(8, 8, 10), Panel = rgb(16, 16, 19), Raised = rgb(25, 25, 29), Hover = rgb(38, 38, 44), 	Text = rgb(246, 246, 246), Muted = rgb(153, 153, 160), Line = rgb(55, 55, 62), } local THEMES, THEME_ORDER = {}, {} local function defineTheme(name, t) 	local full = {} 	for k, v in pairs(BASE) do full[k] = v end 	for k, v in pairs(t) do full[k] = v end 	if not THEMES[name] then THEME_ORDER[#THEME_ORDER + 1] = name end 	THEMES[name] = full end defineTheme("Mono", {Accent = rgb(232, 232, 232), Bright = rgb(255, 255, 255), Soft = rgb(59, 59, 64)}) defineTheme("Crimson", {Accent = rgb(255, 70, 90), Bright = rgb(255, 125, 140), Soft = rgb(84, 22, 32)}) defineTheme("Ocean", {Accent = rgb(60, 170, 255), Bright = rgb(135, 208, 255), Soft = rgb(20, 52, 84)}) defineTheme("Emerald", {Accent = rgb(60, 220, 130), Bright = rgb(135, 255, 188), Soft = rgb(18, 72, 46)}) defineTheme("Violet", {Accent = rgb(170, 110, 255), Bright = rgb(208, 168, 255), Soft = rgb(50, 28, 86)}) defineTheme("Sunset", {Accent = rgb(255, 140, 60), Bright = rgb(255, 195, 125), Soft = rgb(88, 46, 18)}) defineTheme("Rose", {Accent = rgb(255, 110, 180), Bright = rgb(255, 170, 215), Soft = rgb(86, 26, 60)}) defineTheme("Gold", {Accent = rgb(255, 205, 60), Bright = rgb(255, 228, 130), Soft = rgb(84, 66, 14)}) defineTheme("Midnight", {Accent = rgb(110, 130, 255), Bright = rgb(160, 175, 255), Soft = rgb(34, 40, 96), 	Background = rgb(6, 8, 18), Panel = rgb(11, 14, 28), Raised = rgb(18, 22, 40), Hover = rgb(28, 34, 60), Line = rgb(44, 52, 88)}) defineTheme("Snow", {Accent = rgb(30, 100, 255), Bright = rgb(70, 130, 255), Soft = rgb(200, 215, 250), 	Background = rgb(242, 242, 245), Panel = rgb(228, 228, 233), Raised = rgb(250, 250, 252), Hover = rgb(212, 212, 220), 	Text = rgb(20, 20, 26), Muted = rgb(98, 98, 110), Line = rgb(188, 188, 198)}) defineTheme("Dracula", {Accent = rgb(189, 147, 249), Bright = rgb(255, 121, 198), Soft = rgb(68, 50, 104), Background = rgb(30, 31, 41), Panel = rgb(40, 42, 54), Raised = rgb(52, 55, 70), Hover = rgb(68, 71, 90), Line = rgb(98, 114, 164)})
defineTheme("Nord", {Accent = rgb(136, 192, 208), Bright = rgb(163, 214, 228), Soft = rgb(46, 74, 92), Background = rgb(36, 41, 51), Panel = rgb(46, 52, 64), Raised = rgb(59, 66, 82), Hover = rgb(67, 76, 94), Line = rgb(76, 86, 106)})
defineTheme("TokyoNight", {Accent = rgb(122, 162, 247), Bright = rgb(187, 154, 247), Soft = rgb(41, 53, 94), Background = rgb(22, 22, 30), Panel = rgb(26, 27, 38), Raised = rgb(36, 40, 59), Hover = rgb(47, 52, 77), Line = rgb(65, 72, 104)})
defineTheme("Catppuccin", {Accent = rgb(203, 166, 247), Bright = rgb(245, 194, 231), Soft = rgb(73, 56, 105), Background = rgb(24, 24, 37), Panel = rgb(30, 30, 46), Raised = rgb(49, 50, 68), Hover = rgb(69, 71, 90), Line = rgb(88, 91, 112)})
defineTheme("Gruvbox", {Accent = rgb(250, 189, 47), Bright = rgb(254, 128, 25), Soft = rgb(94, 72, 18), Background = rgb(29, 32, 33), Panel = rgb(40, 40, 40), Raised = rgb(60, 56, 54), Hover = rgb(80, 73, 69), Line = rgb(102, 92, 84)})
defineTheme("Monokai", {Accent = rgb(166, 226, 46), Bright = rgb(249, 38, 114), Soft = rgb(58, 82, 18), Background = rgb(30, 31, 28), Panel = rgb(39, 40, 34), Raised = rgb(52, 53, 46), Hover = rgb(68, 69, 60), Line = rgb(90, 90, 80)})
defineTheme("Solarized", {Accent = rgb(38, 139, 210), Bright = rgb(42, 161, 152), Soft = rgb(10, 62, 96), Background = rgb(0, 30, 38), Panel = rgb(0, 43, 54), Raised = rgb(7, 54, 66), Hover = rgb(16, 68, 82), Line = rgb(88, 110, 117)})
defineTheme("Cyberpunk", {Accent = rgb(252, 238, 10), Bright = rgb(0, 240, 255), Soft = rgb(86, 80, 4), Background = rgb(10, 8, 18), Panel = rgb(18, 14, 30), Raised = rgb(28, 22, 46), Hover = rgb(42, 32, 66), Line = rgb(255, 0, 110)})
defineTheme("Matrix", {Accent = rgb(0, 255, 70), Bright = rgb(150, 255, 170), Soft = rgb(0, 70, 22), Background = rgb(0, 6, 2), Panel = rgb(2, 14, 6), Raised = rgb(5, 24, 10), Hover = rgb(9, 38, 16), Line = rgb(10, 70, 28), Muted = rgb(90, 170, 110)})
defineTheme("Blood", {Accent = rgb(210, 20, 30), Bright = rgb(255, 80, 80), Soft = rgb(72, 6, 10), Background = rgb(10, 4, 5), Panel = rgb(20, 8, 9), Raised = rgb(32, 12, 14), Hover = rgb(48, 18, 20), Line = rgb(90, 28, 32)})
defineTheme("Ice", {Accent = rgb(150, 220, 255), Bright = rgb(225, 245, 255), Soft = rgb(26, 70, 98), Background = rgb(6, 12, 18), Panel = rgb(11, 20, 30), Raised = rgb(18, 32, 46), Hover = rgb(28, 48, 68), Line = rgb(44, 78, 104)})
defineTheme("Lavender", {Accent = rgb(186, 160, 255), Bright = rgb(224, 208, 255), Soft = rgb(58, 44, 98), Background = rgb(14, 11, 22), Panel = rgb(22, 18, 34), Raised = rgb(34, 28, 52), Hover = rgb(50, 42, 76), Line = rgb(74, 62, 108)})
defineTheme("Coffee", {Accent = rgb(214, 160, 110), Bright = rgb(240, 200, 150), Soft = rgb(84, 56, 32), Background = rgb(16, 11, 8), Panel = rgb(26, 19, 14), Raised = rgb(40, 30, 22), Hover = rgb(58, 44, 32), Line = rgb(88, 66, 48)})
defineTheme("Sakura", {Accent = rgb(255, 150, 190), Bright = rgb(255, 205, 225), Soft = rgb(96, 40, 66), Background = rgb(20, 11, 15), Panel = rgb(32, 18, 24), Raised = rgb(48, 28, 36), Hover = rgb(68, 40, 52), Line = rgb(102, 62, 78)})
defineTheme("Synthwave", {Accent = rgb(255, 56, 200), Bright = rgb(80, 220, 255), Soft = rgb(86, 20, 70), Background = rgb(14, 8, 28), Panel = rgb(24, 14, 46), Raised = rgb(38, 22, 70), Hover = rgb(54, 32, 98), Line = rgb(110, 52, 160)})
defineTheme("Forest", {Accent = rgb(98, 190, 110), Bright = rgb(170, 230, 150), Soft = rgb(26, 70, 34), Background = rgb(8, 13, 9), Panel = rgb(14, 22, 15), Raised = rgb(22, 35, 24), Hover = rgb(32, 52, 36), Line = rgb(48, 78, 52)})
defineTheme("Graphite", {Accent = rgb(176, 184, 196), Bright = rgb(226, 232, 240), Soft = rgb(58, 62, 70), Background = rgb(18, 19, 21), Panel = rgb(26, 28, 31), Raised = rgb(36, 39, 43), Hover = rgb(50, 54, 60), Line = rgb(72, 77, 85)})
defineTheme("OLED", {Accent = rgb(255, 255, 255), Bright = rgb(255, 255, 255), Soft = rgb(44, 44, 44), Background = rgb(0, 0, 0), Panel = rgb(6, 6, 6), Raised = rgb(14, 14, 14), Hover = rgb(26, 26, 26), Line = rgb(48, 48, 48)})
defineTheme("Aqua", {Accent = rgb(0, 220, 220), Bright = rgb(130, 255, 245), Soft = rgb(0, 72, 76), Background = rgb(4, 14, 16), Panel = rgb(8, 24, 27), Raised = rgb(13, 38, 42), Hover = rgb(20, 56, 62), Line = rgb(30, 84, 90)})
defineTheme("Toxic", {Accent = rgb(190, 255, 0), Bright = rgb(230, 255, 110), Soft = rgb(60, 80, 0), Background = rgb(9, 12, 4), Panel = rgb(16, 22, 7), Raised = rgb(26, 35, 11), Hover = rgb(40, 54, 16), Line = rgb(62, 82, 26)})
defineTheme("Royal", {Accent = rgb(255, 200, 70), Bright = rgb(255, 232, 150), Soft = rgb(88, 66, 12), Background = rgb(10, 8, 28), Panel = rgb(17, 14, 46), Raised = rgb(27, 23, 70), Hover = rgb(40, 34, 98), Line = rgb(66, 58, 140)})
defineTheme("Volcano", {Accent = rgb(255, 98, 30), Bright = rgb(255, 170, 70), Soft = rgb(96, 34, 8), Background = rgb(14, 7, 5), Panel = rgb(24, 12, 8), Raised = rgb(38, 19, 12), Hover = rgb(56, 28, 17), Line = rgb(94, 46, 28)})
defineTheme("Galaxy", {Accent = rgb(140, 100, 255), Bright = rgb(255, 130, 220), Soft = rgb(44, 26, 100), Background = rgb(6, 4, 16), Panel = rgb(12, 8, 30), Raised = rgb(20, 14, 48), Hover = rgb(32, 22, 74), Line = rgb(56, 40, 110)})
defineTheme("Sandstone", {Accent = rgb(190, 120, 40), Bright = rgb(214, 140, 56), Soft = rgb(238, 220, 188), Background = rgb(246, 241, 232), Panel = rgb(234, 227, 214), Raised = rgb(252, 249, 243), Hover = rgb(222, 213, 196), Text = rgb(40, 30, 20), Muted = rgb(120, 104, 86), Line = rgb(200, 188, 168)})
defineTheme("MintLight", {Accent = rgb(16, 170, 120), Bright = rgb(10, 140, 98), Soft = rgb(196, 238, 220), Background = rgb(240, 247, 244), Panel = rgb(226, 238, 233), Raised = rgb(250, 253, 251), Hover = rgb(210, 227, 220), Text = rgb(16, 30, 24), Muted = rgb(90, 112, 102), Line = rgb(184, 206, 196)})
defineTheme("RoseLight", {Accent = rgb(230, 70, 130), Bright = rgb(200, 40, 100), Soft = rgb(250, 208, 224), Background = rgb(250, 241, 245), Panel = rgb(240, 226, 233), Raised = rgb(254, 250, 252), Hover = rgb(228, 210, 220), Text = rgb(34, 16, 24), Muted = rgb(118, 92, 104), Line = rgb(210, 188, 200)})
local ALIAS = {Default = "Mono", Light = "Snow", Green = "Emerald", Amethyst = "Violet", DarkBlue = "Midnight", AmberGlow = "Sunset", Bloom = "Rose", Serenity = "Ocean"} local COLORS = {} for k, v in pairs(THEMES.Mono) do COLORS[k] = v end local THEME_KEYS = {} for k in pairs(COLORS) do THEME_KEYS[#THEME_KEYS + 1] = k end local STATUS = {success = rgb(80, 225, 135), warn = rgb(255, 192, 60), error = rgb(255, 85, 85)} local FONT, FONT_BOLD, FONT_HEAVY = Enum.Font.Gotham, Enum.Font.GothamSemibold, Enum.Font.GothamBold local PING, CLICK = "rbxasset://sounds/electronicpingshort.wav", "rbxasset://sounds/clickfast.wav" local SOUNDS = { 	Click = {PING, 0.2, 1.0}, Hover = {CLICK, 0.06, 1.7}, ToggleOn = {CLICK, 0.3, 1.3}, ToggleOff = {CLICK, 0.3, 0.8}, 	Tab = {CLICK, 0.25, 1.1}, Open = {PING, 0.2, 0.85}, Close = {PING, 0.2, 0.65}, Notify = {PING, 0.25, 1.15}, 	Success = {PING, 0.25, 1.4}, Warn = {PING, 0.25, 0.7}, Error = {PING, 0.28, 0.5}, Expand = {CLICK, 0.2, 1.0}, 	Collapse = {CLICK, 0.2, 0.75}, Tick = {CLICK, 0.12, 1.0}, } local PRESETS = {rgb(255, 255, 255), rgb(255, 0, 0), rgb(255, 140, 0), rgb(255, 215, 0), rgb(0, 200, 0), rgb(0, 255, 255), rgb(0, 120, 255), rgb(170, 0, 255)} local snd = {on = true, vol = 1} local hooks = {} local function hook(fn) hooks[#hooks + 1] = fn pcall(fn) end local function runHooks() for i = 1, #hooks do pcall(hooks[i]) end end local themeToken, currentTheme, rainbowOn, dead = 0, "Mono", false, false local loadingCfg = false local COMPACT, BOOST = false, 0 local WINDOW_W, WINDOW_H, SIDEBAR_W, HEADER_H, PAD, ROW_W, NOTIF_W, SEARCH_H = 620, 420, 160, 60, 18, 0, 300, 36 local function computeLayout(cfg) 	local cam = workspace.CurrentCamera 	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) 	COMPACT = (UIS.TouchEnabled and not UIS.KeyboardEnabled) or vp.X < 700 	if COMPACT then 		BOOST = 1 		WINDOW_W, WINDOW_H = math.clamp(vp.X - 16, 290, 560), math.clamp(vp.Y - 36, 250, 440) 		SIDEBAR_W, HEADER_H, PAD, SEARCH_H = 58, 50, 10, 40 		NOTIF_W = math.clamp(vp.X - 28, 220, 300) 	else 		BOOST = 0 		local sz = cfg and typeof(cfg.Size) == "Vector2" and cfg.Size or Vector2.new(620, 420) 		WINDOW_W, WINDOW_H = sz.X, sz.Y 		SIDEBAR_W, HEADER_H, PAD, NOTIF_W, SEARCH_H = 160, 60, 18, 300, 36 	end 	ROW_W = WINDOW_W - SIDEBAR_W - PAD * 2 end local function make(class, props, parent) 	local i = Instance.new(class) 	for k, v in pairs(props or {}) do i[k] = v end 	i.Parent = parent 	return i end local function P(inst, map) 	hook(function() for prop, key in pairs(map) do inst[prop] = COLORS[key] end end) 	return inst end local function tween(i, d, props, style, dir) 	local t = TweenService:Create(i, TweenInfo.new(math.max(d * (VField._anim or 1), 0.001), style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props) 	t:Play() 	return t end local function loop(i, d, props, style, reverse, force) 	if VField._lite and not force then return {Cancel = function() end, Play = function() end, Pause = function() end} end 	local t = TweenService:Create(i, TweenInfo.new(d, style or Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, reverse or false), props) 	t:Play() 	return t end local function stroke(i, color, tr, th) 	return make("UIStroke", {Color = color or COLORS.Line, Transparency = tr or 0, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, i) end local function T(parent, text, size, col, font, pos, dim) 	local l = make("TextLabel", {BackgroundTransparency = 1, Font = font or FONT, Text = text or "", TextSize = size or 13, 		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, 		Position = pos or UDim2.new(), Size = dim or UDim2.new(1, 0, 0, 20)}, parent) 	if typeof(col) == "Color3" then l.TextColor3 = col else P(l, {TextColor3 = col or "Text"}) end 	return l end local function B(parent, text, pos, dim, bg) 	local b = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Font = FONT_BOLD, Text = text or "", TextSize = 12, 		Position = pos or UDim2.new(), Size = dim or UDim2.new(1, 0, 0, 34)}, parent) 	P(b, {BackgroundColor3 = bg or "Raised", TextColor3 = "Text"}) 	return b end local function list(parent, pad) 	return make("UIListLayout", {Padding = UDim.new(0, pad or 8), SortOrder = Enum.SortOrder.LayoutOrder}, parent) end local function strip(t) return (tostring(t or ""):gsub("<[^>]*>", "")) end local function measure(text, size, font, width) 	local clean = strip(text) 	if clean:gsub("%s", "") == "" then return 0 end 	local ok, b = pcall(function() return TextService:GetTextSize(clean, size, font, Vector2.new(math.max(width, 40), 10000)) end) 	return ok and b and b.Y or size + 2 end local function playSound(kind, volMul, speedMul) 	if not snd.on or snd.vol <= 0 then return end 	local d = SOUNDS[kind] 	if not d then return end 	local s = make("Sound", {SoundId = d[1], Volume = d[2] * snd.vol * (volMul or 1), PlaybackSpeed = d[3] * (speedMul or 1)}, SoundService) 	s:Play() 	task.delay(3, function() if s.Parent then s:Destroy() end end) end local function getPlayerGui() return lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui") end local function getGuiParent() 	local ok, hidden = pcall(function() return gethui and gethui() end) 	if ok and typeof(hidden) == "Instance" then return hidden end 	local okc, core = pcall(function() return game:GetService("CoreGui") end) 	if okc and core then 		local probe = Instance.new("Folder") 		local okp = pcall(function() probe.Parent = core end) 		local usable = okp and probe.Parent == core 		probe:Destroy() 		if usable then return core end 	end 	return getPlayerGui() end local function newScreen(name) 	local s = Instance.new("ScreenGui") 	s.Name, s.IgnoreGuiInset, s.ResetOnSpawn, s.DisplayOrder = name, true, false, 999999 	s.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 	if syn and syn.protect_gui then pcall(syn.protect_gui, s) end 	s.Parent = getGuiParent() 	return s end local function pointer(i) return Vector2.new(i.Position.X, i.Position.Y + GuiService:GetGuiInset().Y) end local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end local function inside(gui, p) 	local a, s = gui.AbsolutePosition, gui.AbsoluteSize 	return p.X >= a.X and p.X <= a.X + s.X and p.Y >= a.Y and p.Y <= a.Y + s.Y end

local IC = {}
IC.Alias = {
	close = "x", cross = "x", remove = "minus", add = "plus", tick = "check", ok = "check", dots = "dot", misc = "grid", other = "grid", extras = "grid", more = "grid",
	settings = "gear", setting = "gear", cog = "gear", config = "save", configs = "save", tune = "sliders", options = "sliders", filter = "sliders",
	esp = "eye", visuals = "eye", visual = "eye", view = "eye", wallhack = "eye", chams = "eye", vision = "eye", show = "eye", hide = "eyeoff",
	aim = "crosshair", aimbot = "crosshair", silentaim = "crosshair", aimassist = "crosshair", lockon = "crosshair", hitbox = "crosshair", scope = "crosshair",
	bullseye = "target", goal = "target",
	combat = "sword", pvp = "sword", fight = "sword", kill = "sword", killaura = "sword", melee = "sword", attack = "sword", sword = "sword",
	battle = "swords", war = "swords", duel = "swords",
	gun = "gun", guns = "gun", weapon = "gun", weapons = "gun", pistol = "gun", mods = "gun", gunmods = "gun", shoot = "gun",
	player = "user", character = "user", char = "user", self = "user", localplayer = "user", profile = "user", account = "user", me = "user",
	players = "users", people = "users", friends = "users", server = "users", targets = "users", team = "users", teams = "users", social = "users",
	speed = "bolt", power = "power", lightning = "bolt", energy = "bolt", fast = "bolt", boost = "bolt",
	movement = "move", move = "move", walk = "move", fly = "plane", flight = "plane", noclip = "ghost", ghost = "ghost", send = "plane",
	jump = "up", arrowup = "up", arrowdown = "downarrow", arrowleft = "left", arrowright = "right", back = "left", next = "right",
	world = "globe", map = "globe", environment = "globe", web = "globe", internet = "globe", earth = "globe",
	teleport = "portal", tp = "portal", warp = "portal", portal = "portal", location = "pin", waypoint = "pin", locations = "pin", places = "pin", place = "pin",
	main = "home", hub = "home", general = "home", home = "home", house = "home", lobby = "home", start = "home",
	lighting = "sun", light = "sun", brightness = "sun", day = "sun", graphics = "monitor", display = "monitor", screen = "monitor", fps = "cpu", performance = "cpu",
	farm = "dollar", autofarm = "dollar", money = "dollar", cash = "dollar", coins = "dollar", coin = "dollar", economy = "dollar", currency = "dollar",
	shop = "cart", store = "cart", buy = "cart", market = "cart", cart = "cart",
	inventory = "bag", items = "bag", item = "bag", backpack = "bag", loot = "bag",
	tools = "hammer", tool = "hammer", build = "hammer", builder = "hammer", craft = "hammer", crafting = "hammer",
	debug = "bug", dev = "bug", developer = "bug", exploit = "bug", exploits = "bug", bugs = "bug",
	info = "info", about = "info", credits = "info", help = "info", information = "info", changelog = "list",
	warning = "warn", alert = "warn", danger = "warn", caution = "warn",
	discord = "chat", community = "chat", chat = "chat", message = "chat", messages = "chat", support = "chat",
	key = "key", keys = "key", keybind = "keyboard", keybinds = "keyboard", binds = "keyboard", keyboard = "keyboard", controls = "keyboard", input = "keyboard",
	script = "code", scripts = "code", lua = "code", executor = "code", code = "code", source = "code", api = "code",
	console = "terminal", log = "list", logs = "list", output = "terminal", terminal = "terminal", cmd = "terminal", commands = "terminal", command = "terminal",
	troll = "skull", fun = "skull", trolling = "skull", skull = "skull", death = "skull", rage = "skull", fling = "skull",
	car = "car", vehicle = "car", vehicles = "car", drive = "car",
	game = "gamepad", games = "gamepad", controller = "gamepad", gamepad = "gamepad", minigames = "gamepad", universal = "gamepad",
	stats = "chart", statistics = "chart", analytics = "chart", graph = "chart", data = "chart", chart = "chart",
	sound = "music", sounds = "music", music = "music", audio = "music", radio = "music", song = "music", songs = "music",
	theme = "palette", themes = "palette", color = "palette", colors = "palette", appearance = "palette", style = "palette", palette = "palette", paint = "palette", ui = "palette", interface = "palette",
	animation = "sparkle", animations = "sparkle", effects = "sparkle", effect = "sparkle", magic = "sparkle", emotes = "sparkle", emote = "sparkle", sparkle = "sparkle", particles = "sparkle",
	anti = "shield", protect = "shield", protection = "shield", safe = "shield", defense = "shield", bypass = "shield", bypasses = "shield", security = "shield", shield = "shield",
	health = "health", heal = "health", medic = "health", medkit = "health", hp = "health", healing = "health",
	admin = "crown", premium = "crown", vip = "crown", owner = "crown", crown = "crown", pro = "crown",
	rank = "trophy", ranks = "trophy", leaderboard = "trophy", win = "trophy", wins = "trophy", trophy = "trophy", achievements = "trophy", rewards = "gift", reward = "gift", gift = "gift", codes = "gift", redeem = "gift", daily = "gift",
	network = "signal", ping = "signal", signal = "signal", latency = "signal", connection = "signal", wifi = "signal",
	time = "clock", timer = "clock", clock = "clock", schedule = "clock", history = "clock",
	lock = "lock", locked = "lock", unlock = "unlock", unlocked = "unlock", private = "lock", password = "lock",
	mouse = "mouse", click = "cursor", autoclick = "cursor", autoclicker = "cursor", clicker = "cursor", cursor = "cursor", pointer = "cursor",
	camera = "camera", spectate = "camera", photo = "camera", screenshot = "camera", cam = "camera", freecam = "camera", fov = "camera",
	radar = "radar", minimap = "radar", scanner = "radar", scan = "radar", detect = "radar",
	cube = "cube", part = "cube", parts = "cube", block = "cube", blocks = "cube", objects = "cube", instance = "cube", explorer = "cube",
	layers = "layers", stack = "layers", levels = "layers", level = "layers",
	link = "link", links = "link", url = "link", socials = "link",
	folder = "folder", files = "folder", file = "file", document = "file", docs = "file", notes = "file", note = "file", text = "file",
	save = "save", load = "download", download = "download", upload = "upload", import = "download", export = "upload", backup = "save",
	trash = "trash", delete = "trash", clear = "trash", reset = "refresh", reload = "refresh", refresh = "refresh", sync = "refresh", rejoin = "refresh", restart = "refresh",
	play = "play", run = "play", auto = "play", pause = "pause", stop = "stop",
	star = "star", favorites = "star", favorite = "star", fav = "star", featured = "star", new = "star", top = "star", best = "star",
	heart = "heart", like = "heart", love = "heart", favourite = "heart",
	bell = "bell", notifications = "bell", notification = "bell", notify = "bell", alerts = "bell", reminders = "bell",
	gem = "gem", gems = "gem", premiumgem = "gem", crystal = "gem", diamonds = "gem",
	flag = "flag", flags = "flag", objective = "flag", objectives = "flag", quest = "flag", quests = "flag", missions = "flag", mission = "flag", tasks = "flag", task = "flag",
	list = "list", menu = "menu", lists = "list", queue = "list",
	exit = "power", quit = "power", unload = "power", shutdown = "power", off = "power",
}

IC.Rules = {
	{"aim", "crosshair"}, {"silent", "crosshair"}, {"hitbox", "crosshair"}, {"trigger", "crosshair"}, {"snipe", "crosshair"},
	{"esp", "eye"}, {"visual", "eye"}, {"wall", "eye"}, {"cham", "eye"}, {"render", "eye"}, {"highlight", "eye"}, {"tracer", "eye"}, {"nametag", "eye"},
	{"gun", "gun"}, {"weapon", "gun"}, {"ammo", "gun"}, {"shoot", "gun"},
	{"combat", "sword"}, {"pvp", "sword"}, {"fight", "sword"}, {"kill", "sword"}, {"melee", "sword"}, {"attack", "sword"}, {"aura", "sword"}, {"reach", "sword"},
	{"players", "users"}, {"server", "users"}, {"friend", "users"}, {"team", "users"},
	{"player", "user"}, {"character", "user"}, {"avatar", "user"}, {"profile", "user"}, {"account", "user"}, {"self", "user"},
	{"teleport", "portal"}, {"warp", "portal"}, {"waypoint", "pin"}, {"location", "pin"},
	{"noclip", "ghost"}, {"fly", "plane"}, {"speed", "bolt"}, {"move", "move"}, {"walk", "move"}, {"jump", "up"}, {"physics", "bolt"},
	{"world", "globe"}, {"map", "globe"}, {"environment", "globe"}, {"light", "sun"}, {"sky", "sun"}, {"weather", "sun"},
	{"graphic", "monitor"}, {"display", "monitor"}, {"fps", "cpu"}, {"perform", "cpu"}, {"optimi", "cpu"},
	{"farm", "dollar"}, {"money", "dollar"}, {"cash", "dollar"}, {"coin", "dollar"}, {"econom", "dollar"}, {"grind", "dollar"}, {"auto", "play"},
	{"shop", "cart"}, {"store", "cart"}, {"buy", "cart"}, {"market", "cart"},
	{"inventory", "bag"}, {"item", "bag"}, {"loot", "bag"}, {"backpack", "bag"},
	{"tool", "hammer"}, {"build", "hammer"}, {"craft", "hammer"},
	{"debug", "bug"}, {"develop", "bug"}, {"exploit", "bug"}, {"test", "bug"},
	{"discord", "chat"}, {"chat", "chat"}, {"communit", "chat"}, {"message", "chat"}, {"social", "chat"},
	{"keybind", "keyboard"}, {"key", "key"}, {"bind", "keyboard"}, {"control", "keyboard"},
	{"script", "code"}, {"lua", "code"}, {"executor", "code"}, {"console", "terminal"}, {"output", "terminal"}, {"command", "terminal"},
	{"troll", "skull"}, {"fun", "skull"}, {"fling", "skull"}, {"rage", "skull"}, {"prank", "skull"},
	{"vehicle", "car"}, {"car", "car"}, {"drive", "car"},
	{"game", "gamepad"}, {"universal", "gamepad"}, {"mini", "gamepad"},
	{"stat", "chart"}, {"analytic", "chart"}, {"graph", "chart"},
	{"sound", "music"}, {"music", "music"}, {"audio", "music"}, {"radio", "music"},
	{"theme", "palette"}, {"color", "palette"}, {"colour", "palette"}, {"appearance", "palette"}, {"style", "palette"}, {"skin", "palette"},
	{"anim", "sparkle"}, {"effect", "sparkle"}, {"emote", "sparkle"}, {"magic", "sparkle"}, {"particle", "sparkle"}, {"fx", "sparkle"},
	{"anti", "shield"}, {"protect", "shield"}, {"bypass", "shield"}, {"defen", "shield"}, {"secur", "shield"}, {"safe", "shield"},
	{"health", "health"}, {"heal", "health"}, {"medic", "health"},
	{"admin", "crown"}, {"premium", "crown"}, {"vip", "crown"}, {"owner", "crown"},
	{"rank", "trophy"}, {"leader", "trophy"}, {"achiev", "trophy"}, {"trophy", "trophy"},
	{"reward", "gift"}, {"gift", "gift"}, {"redeem", "gift"}, {"daily", "gift"},
	{"network", "signal"}, {"ping", "signal"}, {"latency", "signal"},
	{"time", "clock"}, {"clock", "clock"}, {"history", "clock"},
	{"lock", "lock"}, {"camera", "camera"}, {"spectate", "camera"}, {"fov", "camera"}, {"photo", "camera"},
	{"radar", "radar"}, {"scan", "radar"}, {"minimap", "radar"}, {"detect", "radar"},
	{"cube", "cube"}, {"part", "cube"}, {"object", "cube"}, {"instance", "cube"}, {"explorer", "cube"},
	{"click", "cursor"}, {"mouse", "mouse"},
	{"link", "link"}, {"folder", "folder"}, {"file", "file"}, {"note", "file"}, {"doc", "file"},
	{"save", "save"}, {"config", "save"}, {"setting", "gear"}, {"option", "gear"}, {"prefer", "gear"},
	{"log", "list"}, {"change", "list"}, {"list", "list"},
	{"info", "info"}, {"about", "info"}, {"credit", "info"}, {"help", "info"},
	{"warn", "warn"}, {"alert", "bell"}, {"notif", "bell"},
	{"gem", "gem"}, {"diamond", "gem"}, {"crystal", "gem"},
	{"quest", "flag"}, {"mission", "flag"}, {"task", "flag"}, {"objective", "flag"},
	{"star", "star"}, {"favorite", "star"}, {"favourite", "star"}, {"heart", "heart"},
	{"home", "home"}, {"main", "home"}, {"hub", "home"}, {"general", "home"}, {"lobby", "home"}, {"start", "home"},
	{"misc", "grid"}, {"other", "grid"}, {"extra", "grid"}, {"more", "grid"},
	{"troll", "skull"},
}

IC.Names = {"menu", "grid", "diamond", "sliders", "plus", "search", "check", "dot", "minus", "x", "down", "up", "left", "right", "downarrow", "grip",
	"eye", "eyeoff", "crosshair", "target", "sword", "swords", "gun", "user", "users", "bolt", "move", "globe", "home", "gear", "star", "heart", "shield", "lock", "unlock",
	"key", "folder", "file", "code", "terminal", "bell", "info", "warn", "play", "pause", "stop", "refresh", "cursor", "camera", "palette", "music", "signal", "hammer",
	"bug", "flag", "clock", "chart", "cart", "dollar", "crown", "skull", "pin", "portal", "car", "gamepad", "bag", "gift", "trophy", "link", "list", "layers", "cube",
	"radar", "sparkle", "sun", "plane", "chat", "mouse", "keyboard", "health", "download", "upload", "save", "trash", "monitor", "cpu", "gem", "ghost", "power"}

local function normIcon(s)
	return (tostring(s or ""):lower():gsub("[%s_%-%.]", ""))
end

IC.Set = {}
for _, n in ipairs(IC.Names) do IC.Set[n] = true end

local function resolveIcon(icon, tabName)
	local k = normIcon(icon)
	if k ~= "" then
		if IC.Set[k] then return k end
		if IC.Alias[k] then return IC.Alias[k] end
	end
	if tabName and (k == "" or k == "auto") then
		local nm = tostring(tabName):lower()
		local flat = normIcon(nm)
		if IC.Alias[flat] then return IC.Alias[flat] end
		for _, r in ipairs(IC.Rules) do
			if nm:find(r[1], 1, true) then return r[2] end
		end
	end
	return nil
end

local function makeIcon(parent, kind, s, key, zi)
	local box = make("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(s, s), ZIndex = zi or 5}, parent)
	local obj = {Frame = box, Parts = {}}
	local th = math.max(2, math.floor(s / 9 + 0.5))
	local function paint(inst, prop)
		if typeof(key) == "Color3" then inst[prop] = key else P(inst, {[prop] = key or "Text"}) end
		obj.Parts[#obj.Parts + 1] = {inst, prop}
	end
	local function px(v) return math.max(math.floor(v * s + 0.5), 1) end
	local function line(cx, cy, len, rot)
		paint(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(math.max(math.floor(len * s + 0.5), th), th), Rotation = rot or 0, ZIndex = box.ZIndex}, box), "BackgroundColor3")
	end
	local function block(cx, cy, sz, rot)
		local p = math.max(math.floor(sz * s + 0.5), th)
		paint(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(p, p), Rotation = rot or 0, ZIndex = box.ZIndex}, box), "BackgroundColor3")
	end
	local function ring(cx, cy, sz, rot)
		local p = math.floor(sz * s + 0.5)
		local f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(p, p), Rotation = rot or 0, ZIndex = box.ZIndex}, box)
		paint(make("UIStroke", {Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, f), "Color")
	end
	-- segment between two points (fractions of the icon box)
	local function seg(x1, y1, x2, y2, w)
		local dx, dy = (x2 - x1) * s, (y2 - y1) * s
		local len = math.sqrt(dx * dx + dy * dy)
		local t = w or th
		paint(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
			Size = UDim2.fromOffset(math.max(math.floor(len + t * 0.7 + 0.5), t), t), Rotation = math.deg(math.atan2(dy, dx)), ZIndex = box.ZIndex}, box), "BackgroundColor3")
	end
	local function poly(pts, closed)
		for i = 1, #pts - 1 do seg(pts[i][1], pts[i][2], pts[i + 1][1], pts[i + 1][2]) end
		if closed and #pts > 2 then seg(pts[#pts][1], pts[#pts][2], pts[1][1], pts[1][2]) end
	end
	-- filled circle
	local function disc(cx, cy, sz)
		local p = math.max(px(sz), 2)
		local f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(p, p), ZIndex = box.ZIndex}, box)
		make("UICorner", {CornerRadius = UDim.new(1, 0)}, f)
		paint(f, "BackgroundColor3")
	end
	-- outlined circle
	local function circ(cx, cy, sz)
		local p = math.max(px(sz), 3)
		local f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(p, p), ZIndex = box.ZIndex}, box)
		make("UICorner", {CornerRadius = UDim.new(1, 0)}, f)
		paint(make("UIStroke", {Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, f), "Color")
	end
	-- filled rounded rectangle
	local function fbox(cx, cy, w, h, r, rot)
		local f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(math.max(px(w), 2), math.max(px(h), 2)), Rotation = rot or 0, ZIndex = box.ZIndex}, box)
		if r and r > 0 then make("UICorner", {CornerRadius = UDim.new(0, math.max(math.floor(r * s + 0.5), 1))}, f) end
		paint(f, "BackgroundColor3")
	end
	-- outlined rounded rectangle
	local function rbox(cx, cy, w, h, r, rot)
		local f = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromScale(cx, cy), Size = UDim2.fromOffset(math.max(px(w), 3), math.max(px(h), 3)), Rotation = rot or 0, ZIndex = box.ZIndex}, box)
		if r and r > 0 then make("UICorner", {CornerRadius = UDim.new(0, math.max(math.floor(r * s + 0.5), 1))}, f) end
		paint(make("UIStroke", {Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, f), "Color")
	end
	local function glyph(txt, size)
		local l = make("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
			Font = Enum.Font.GothamBold, Text = txt, TextSize = math.max(math.floor(size * s), 6), ZIndex = box.ZIndex}, box)
		paint(l, "TextColor3")
	end
	local function sword(mirror)
		local function X(x) return mirror and (1 - x) or x end
		seg(X(0.9), 0.1, X(0.4), 0.6)
		seg(X(0.24), 0.46, X(0.54), 0.76)
		seg(X(0.33), 0.67, X(0.14), 0.86)
		disc(X(0.12), 0.88, 0.16)
	end
	if kind == "x" then line(0.5, 0.5, 1.15, 45) line(0.5, 0.5, 1.15, -45)
	elseif kind == "minus" then line(0.5, 0.5, 0.85, 0)
	elseif kind == "plus" then line(0.5, 0.5, 0.85, 0) line(0.5, 0.5, 0.85, 90)
	elseif kind == "check" then line(0.3, 0.66, 0.34, 46) line(0.63, 0.53, 0.68, -48)
	elseif kind == "down" then line(0.325, 0.525, 0.5, 45) line(0.675, 0.525, 0.5, -45)
	elseif kind == "up" then seg(0.5, 0.92, 0.5, 0.1) seg(0.5, 0.1, 0.22, 0.38) seg(0.5, 0.1, 0.78, 0.38)
	elseif kind == "downarrow" then seg(0.5, 0.08, 0.5, 0.9) seg(0.5, 0.9, 0.22, 0.62) seg(0.5, 0.9, 0.78, 0.62)
	elseif kind == "left" then seg(0.9, 0.5, 0.1, 0.5) seg(0.1, 0.5, 0.38, 0.22) seg(0.1, 0.5, 0.38, 0.78)
	elseif kind == "right" then seg(0.1, 0.5, 0.9, 0.5) seg(0.9, 0.5, 0.62, 0.22) seg(0.9, 0.5, 0.62, 0.78)
	elseif kind == "search" then circ(0.42, 0.42, 0.62) line(0.8, 0.8, 0.4, 45)
	elseif kind == "grip" then line(0.65, 0.65, 0.85, -45) line(0.78, 0.78, 0.5, -45) line(0.9, 0.9, 0.15, -45)
	elseif kind == "menu" then line(0.5, 0.25, 0.85, 0) line(0.5, 0.5, 0.85, 0) line(0.5, 0.75, 0.85, 0)
	elseif kind == "grid" then block(0.27, 0.27, 0.36) block(0.73, 0.27, 0.36) block(0.27, 0.73, 0.36) block(0.73, 0.73, 0.36)
	elseif kind == "diamond" then ring(0.5, 0.5, 0.58, 45)
	elseif kind == "sliders" then line(0.5, 0.22, 0.85, 0) line(0.5, 0.5, 0.85, 0) line(0.5, 0.78, 0.85, 0) block(0.3, 0.22, 0.26) block(0.7, 0.5, 0.26) block(0.42, 0.78, 0.26)
	elseif kind == "eye" then
		poly({{0.05, 0.5}, {0.24, 0.3}, {0.5, 0.2}, {0.76, 0.3}, {0.95, 0.5}, {0.76, 0.7}, {0.5, 0.8}, {0.24, 0.7}}, true)
		disc(0.5, 0.5, 0.3)
	elseif kind == "eyeoff" then
		poly({{0.05, 0.5}, {0.24, 0.3}, {0.5, 0.2}, {0.76, 0.3}, {0.95, 0.5}, {0.76, 0.7}, {0.5, 0.8}, {0.24, 0.7}}, true)
		seg(0.14, 0.9, 0.86, 0.1)
	elseif kind == "crosshair" then
		circ(0.5, 0.5, 0.58) disc(0.5, 0.5, 0.14)
		seg(0.5, 0.04, 0.5, 0.3) seg(0.5, 0.7, 0.5, 0.96) seg(0.04, 0.5, 0.3, 0.5) seg(0.7, 0.5, 0.96, 0.5)
	elseif kind == "target" then circ(0.5, 0.5, 0.92) circ(0.5, 0.5, 0.52) disc(0.5, 0.5, 0.18)
	elseif kind == "sword" then sword(false)
	elseif kind == "swords" then sword(false) sword(true)
	elseif kind == "gun" then
		fbox(0.5, 0.3, 0.88, 0.22, 0.04) fbox(0.3, 0.58, 0.2, 0.4, 0.03, 12) seg(0.52, 0.42, 0.52, 0.6) circ(0.6, 0.62, 0.22)
	elseif kind == "user" then disc(0.5, 0.28, 0.36) fbox(0.5, 0.84, 0.76, 0.34, 0.17)
	elseif kind == "users" then
		disc(0.31, 0.3, 0.28) fbox(0.31, 0.82, 0.46, 0.3, 0.15)
		disc(0.73, 0.36, 0.24) fbox(0.73, 0.84, 0.36, 0.26, 0.13)
	elseif kind == "bolt" then
		poly({{0.6, 0.04}, {0.22, 0.56}, {0.48, 0.56}, {0.4, 0.96}, {0.8, 0.4}, {0.54, 0.4}}, true)
	elseif kind == "move" then
		seg(0.5, 0.1, 0.5, 0.9) seg(0.1, 0.5, 0.9, 0.5)
		seg(0.5, 0.08, 0.36, 0.24) seg(0.5, 0.08, 0.64, 0.24) seg(0.5, 0.92, 0.36, 0.76) seg(0.5, 0.92, 0.64, 0.76)
		seg(0.08, 0.5, 0.24, 0.36) seg(0.08, 0.5, 0.24, 0.64) seg(0.92, 0.5, 0.76, 0.36) seg(0.92, 0.5, 0.76, 0.64)
	elseif kind == "globe" then circ(0.5, 0.5, 0.88) rbox(0.5, 0.5, 0.4, 0.88, 0.2) seg(0.06, 0.5, 0.94, 0.5)
	elseif kind == "home" then
		seg(0.06, 0.5, 0.5, 0.1) seg(0.5, 0.1, 0.94, 0.5)
		seg(0.2, 0.42, 0.2, 0.9) seg(0.8, 0.42, 0.8, 0.9) seg(0.2, 0.9, 0.8, 0.9) fbox(0.5, 0.74, 0.18, 0.28, 0.02)
	elseif kind == "gear" then
		circ(0.5, 0.5, 0.5)
		for i = 0, 7 do
			local a = math.rad(i * 45)
			fbox(0.5 + 0.37 * math.cos(a), 0.5 + 0.37 * math.sin(a), 0.2, 0.2, 0.02, i * 45)
		end
	elseif kind == "star" then
		local pts = {}
		for i = 0, 9 do
			local r = (i % 2 == 0) and 0.47 or 0.2
			local a = math.rad(-90 + i * 36)
			pts[#pts + 1] = {0.5 + r * math.cos(a), 0.54 + r * math.sin(a)}
		end
		poly(pts, true)
	elseif kind == "heart" then disc(0.32, 0.34, 0.42) disc(0.68, 0.34, 0.42) fbox(0.5, 0.56, 0.46, 0.46, 0.02, 45)
	elseif kind == "shield" then poly({{0.5, 0.05}, {0.88, 0.2}, {0.88, 0.52}, {0.5, 0.95}, {0.12, 0.52}, {0.12, 0.2}}, true)
	elseif kind == "lock" then fbox(0.5, 0.68, 0.68, 0.46, 0.06) circ(0.5, 0.34, 0.42)
	elseif kind == "unlock" then fbox(0.5, 0.7, 0.68, 0.44, 0.06) circ(0.5, 0.2, 0.4)
	elseif kind == "key" then circ(0.27, 0.5, 0.4) seg(0.45, 0.5, 0.94, 0.5) seg(0.76, 0.5, 0.76, 0.72) seg(0.9, 0.5, 0.9, 0.68)
	elseif kind == "folder" then rbox(0.5, 0.6, 0.9, 0.58, 0.06) fbox(0.27, 0.22, 0.34, 0.16, 0.04)
	elseif kind == "file" then rbox(0.5, 0.5, 0.64, 0.88, 0.06) seg(0.34, 0.36, 0.66, 0.36) seg(0.34, 0.54, 0.66, 0.54) seg(0.34, 0.72, 0.54, 0.72)
	elseif kind == "code" then seg(0.34, 0.26, 0.08, 0.5) seg(0.08, 0.5, 0.34, 0.74) seg(0.66, 0.26, 0.92, 0.5) seg(0.92, 0.5, 0.66, 0.74) seg(0.58, 0.2, 0.42, 0.8)
	elseif kind == "terminal" then rbox(0.5, 0.5, 0.92, 0.72, 0.1) seg(0.24, 0.38, 0.4, 0.5) seg(0.4, 0.5, 0.24, 0.62) seg(0.5, 0.64, 0.74, 0.64)
	elseif kind == "bell" then fbox(0.5, 0.42, 0.56, 0.6, 0.28) fbox(0.5, 0.7, 0.84, 0.12, 0.04) disc(0.5, 0.88, 0.18) disc(0.5, 0.1, 0.14)
	elseif kind == "info" then circ(0.5, 0.5, 0.9) disc(0.5, 0.3, 0.12) seg(0.5, 0.45, 0.5, 0.76)
	elseif kind == "warn" then poly({{0.5, 0.08}, {0.95, 0.9}, {0.05, 0.9}}, true) seg(0.5, 0.4, 0.5, 0.64) disc(0.5, 0.77, 0.1)
	elseif kind == "play" then poly({{0.26, 0.12}, {0.86, 0.5}, {0.26, 0.88}}, true)
	elseif kind == "pause" then fbox(0.32, 0.5, 0.22, 0.72, 0.03) fbox(0.68, 0.5, 0.22, 0.72, 0.03)
	elseif kind == "stop" then fbox(0.5, 0.5, 0.64, 0.64, 0.08)
	elseif kind == "refresh" then circ(0.5, 0.5, 0.7) seg(0.8, 0.12, 0.8, 0.34) seg(0.8, 0.34, 0.58, 0.34)
	elseif kind == "cursor" then poly({{0.2, 0.08}, {0.2, 0.84}, {0.4, 0.66}, {0.56, 0.94}, {0.7, 0.87}, {0.54, 0.6}, {0.8, 0.6}}, true)
	elseif kind == "camera" then fbox(0.5, 0.24, 0.34, 0.14, 0.04) rbox(0.5, 0.58, 0.9, 0.58, 0.1) circ(0.5, 0.58, 0.3)
	elseif kind == "palette" then
		circ(0.5, 0.5, 0.9) disc(0.32, 0.4, 0.13) disc(0.54, 0.28, 0.13) disc(0.72, 0.44, 0.13) disc(0.4, 0.68, 0.13)
	elseif kind == "music" then disc(0.28, 0.78, 0.3) seg(0.4, 0.78, 0.4, 0.14) seg(0.4, 0.14, 0.84, 0.26) seg(0.84, 0.26, 0.84, 0.5)
	elseif kind == "signal" then fbox(0.16, 0.82, 0.15, 0.2, 0.02) fbox(0.39, 0.7, 0.15, 0.44, 0.02) fbox(0.62, 0.56, 0.15, 0.72, 0.02) fbox(0.85, 0.44, 0.15, 0.96, 0.02)
	elseif kind == "hammer" then seg(0.2, 0.86, 0.6, 0.46) fbox(0.68, 0.34, 0.5, 0.2, 0.04, 45)
	elseif kind == "bug" then
		disc(0.5, 0.24, 0.22) fbox(0.5, 0.6, 0.42, 0.54, 0.2)
		seg(0.3, 0.46, 0.08, 0.38) seg(0.3, 0.62, 0.06, 0.62) seg(0.3, 0.78, 0.1, 0.9)
		seg(0.7, 0.46, 0.92, 0.38) seg(0.7, 0.62, 0.94, 0.62) seg(0.7, 0.78, 0.9, 0.9)
		seg(0.42, 0.16, 0.32, 0.04) seg(0.58, 0.16, 0.68, 0.04)
	elseif kind == "flag" then seg(0.2, 0.06, 0.2, 0.94) fbox(0.58, 0.3, 0.7, 0.42, 0.03)
	elseif kind == "clock" then circ(0.5, 0.5, 0.9) seg(0.5, 0.5, 0.5, 0.22) seg(0.5, 0.5, 0.7, 0.62)
	elseif kind == "chart" then fbox(0.2, 0.72, 0.2, 0.34, 0.02) fbox(0.5, 0.6, 0.2, 0.58, 0.02) fbox(0.8, 0.5, 0.2, 0.78, 0.02)
	elseif kind == "cart" then
		seg(0.04, 0.14, 0.2, 0.14) seg(0.2, 0.14, 0.34, 0.62) seg(0.34, 0.62, 0.86, 0.62) seg(0.86, 0.62, 0.94, 0.3) seg(0.94, 0.3, 0.25, 0.3)
		disc(0.42, 0.84, 0.16) disc(0.78, 0.84, 0.16)
	elseif kind == "dollar" then circ(0.5, 0.5, 0.92) glyph("$", 0.6)
	elseif kind == "crown" then poly({{0.08, 0.78}, {0.08, 0.28}, {0.3, 0.52}, {0.5, 0.16}, {0.7, 0.52}, {0.92, 0.28}, {0.92, 0.78}}, true)
	elseif kind == "skull" then
		rbox(0.5, 0.4, 0.72, 0.62, 0.3) rbox(0.5, 0.82, 0.38, 0.22, 0.04) disc(0.35, 0.42, 0.15) disc(0.65, 0.42, 0.15)
	elseif kind == "pin" then circ(0.5, 0.36, 0.56) disc(0.5, 0.36, 0.16) seg(0.28, 0.56, 0.5, 0.95) seg(0.72, 0.56, 0.5, 0.95)
	elseif kind == "portal" then rbox(0.5, 0.5, 0.46, 0.92, 0.23) rbox(0.5, 0.5, 0.2, 0.56, 0.1)
	elseif kind == "car" then
		fbox(0.5, 0.58, 0.92, 0.28, 0.08) seg(0.24, 0.46, 0.36, 0.22) seg(0.36, 0.22, 0.64, 0.22) seg(0.64, 0.22, 0.76, 0.46) disc(0.28, 0.78, 0.22) disc(0.72, 0.78, 0.22)
	elseif kind == "gamepad" then
		rbox(0.5, 0.55, 0.92, 0.56, 0.24) seg(0.24, 0.55, 0.42, 0.55) seg(0.33, 0.44, 0.33, 0.66) disc(0.65, 0.48, 0.12) disc(0.77, 0.6, 0.12)
	elseif kind == "bag" then rbox(0.5, 0.62, 0.74, 0.66, 0.12) rbox(0.5, 0.2, 0.34, 0.26, 0.1) seg(0.26, 0.64, 0.74, 0.64)
	elseif kind == "gift" then
		rbox(0.5, 0.66, 0.76, 0.5, 0.04) rbox(0.5, 0.4, 0.92, 0.2, 0.03) seg(0.5, 0.3, 0.5, 0.91) circ(0.36, 0.14, 0.22) circ(0.64, 0.14, 0.22)
	elseif kind == "trophy" then
		fbox(0.5, 0.3, 0.48, 0.46, 0.14) circ(0.17, 0.3, 0.26) circ(0.83, 0.3, 0.26) seg(0.5, 0.5, 0.5, 0.78) fbox(0.5, 0.88, 0.46, 0.14, 0.03)
	elseif kind == "link" then rbox(0.33, 0.67, 0.5, 0.28, 0.14, -45) rbox(0.67, 0.33, 0.5, 0.28, 0.14, -45) seg(0.38, 0.62, 0.62, 0.38)
	elseif kind == "list" then
		disc(0.12, 0.2, 0.14) seg(0.3, 0.2, 0.94, 0.2) disc(0.12, 0.5, 0.14) seg(0.3, 0.5, 0.94, 0.5) disc(0.12, 0.8, 0.14) seg(0.3, 0.8, 0.94, 0.8)
	elseif kind == "layers" then
		poly({{0.5, 0.1}, {0.94, 0.32}, {0.5, 0.54}, {0.06, 0.32}}, true) seg(0.06, 0.5, 0.5, 0.72) seg(0.5, 0.72, 0.94, 0.5) seg(0.06, 0.68, 0.5, 0.9) seg(0.5, 0.9, 0.94, 0.68)
	elseif kind == "cube" then
		poly({{0.5, 0.04}, {0.92, 0.27}, {0.92, 0.73}, {0.5, 0.96}, {0.08, 0.73}, {0.08, 0.27}}, true) seg(0.5, 0.5, 0.5, 0.96) seg(0.5, 0.5, 0.08, 0.27) seg(0.5, 0.5, 0.92, 0.27)
	elseif kind == "radar" then circ(0.5, 0.5, 0.92) circ(0.5, 0.5, 0.46) seg(0.5, 0.5, 0.82, 0.2) disc(0.68, 0.64, 0.1)
	elseif kind == "sparkle" then
		poly({{0.5, 0.04}, {0.62, 0.38}, {0.96, 0.5}, {0.62, 0.62}, {0.5, 0.96}, {0.38, 0.62}, {0.04, 0.5}, {0.38, 0.38}}, true)
	elseif kind == "sun" then
		circ(0.5, 0.5, 0.4)
		for i = 0, 7 do
			local a = math.rad(i * 45)
			seg(0.5 + 0.34 * math.cos(a), 0.5 + 0.34 * math.sin(a), 0.5 + 0.48 * math.cos(a), 0.5 + 0.48 * math.sin(a))
		end
	elseif kind == "plane" then poly({{0.05, 0.46}, {0.95, 0.08}, {0.62, 0.92}, {0.46, 0.58}}, true) seg(0.95, 0.08, 0.46, 0.58)
	elseif kind == "chat" then
		rbox(0.5, 0.42, 0.9, 0.62, 0.16) seg(0.3, 0.72, 0.2, 0.94) seg(0.2, 0.94, 0.46, 0.73) disc(0.3, 0.42, 0.1) disc(0.5, 0.42, 0.1) disc(0.7, 0.42, 0.1)
	elseif kind == "mouse" then rbox(0.5, 0.5, 0.5, 0.88, 0.25) seg(0.5, 0.1, 0.5, 0.42) seg(0.25, 0.42, 0.75, 0.42)
	elseif kind == "keyboard" then
		rbox(0.5, 0.5, 0.94, 0.62, 0.1)
		disc(0.24, 0.38, 0.1) disc(0.42, 0.38, 0.1) disc(0.58, 0.38, 0.1) disc(0.76, 0.38, 0.1) seg(0.3, 0.64, 0.7, 0.64)
	elseif kind == "health" then rbox(0.5, 0.56, 0.9, 0.68, 0.1) fbox(0.5, 0.14, 0.34, 0.1, 0.03) seg(0.5, 0.38, 0.5, 0.74) seg(0.32, 0.56, 0.68, 0.56)
	elseif kind == "download" then
		seg(0.5, 0.06, 0.5, 0.66) seg(0.5, 0.66, 0.26, 0.42) seg(0.5, 0.66, 0.74, 0.42) seg(0.1, 0.9, 0.9, 0.9) seg(0.1, 0.9, 0.1, 0.74) seg(0.9, 0.9, 0.9, 0.74)
	elseif kind == "upload" then
		seg(0.5, 0.66, 0.5, 0.08) seg(0.5, 0.08, 0.26, 0.32) seg(0.5, 0.08, 0.74, 0.32) seg(0.1, 0.92, 0.9, 0.92) seg(0.1, 0.92, 0.1, 0.76) seg(0.9, 0.92, 0.9, 0.76)
	elseif kind == "save" then rbox(0.5, 0.5, 0.86, 0.86, 0.08) fbox(0.5, 0.26, 0.46, 0.22, 0.02) rbox(0.5, 0.72, 0.5, 0.3, 0.04)
	elseif kind == "trash" then seg(0.1, 0.22, 0.9, 0.22) seg(0.38, 0.22, 0.38, 0.08) seg(0.38, 0.08, 0.62, 0.08) seg(0.62, 0.08, 0.62, 0.22) rbox(0.5, 0.58, 0.64, 0.7, 0.06) seg(0.4, 0.42, 0.4, 0.76) seg(0.6, 0.42, 0.6, 0.76)
	elseif kind == "monitor" then rbox(0.5, 0.44, 0.92, 0.6, 0.08) seg(0.5, 0.74, 0.5, 0.9) seg(0.28, 0.9, 0.72, 0.9)
	elseif kind == "cpu" then
		rbox(0.5, 0.5, 0.54, 0.54, 0.06) fbox(0.5, 0.5, 0.2, 0.2, 0.02)
		for _, v in ipairs({0.34, 0.5, 0.66}) do
			seg(v, 0.04, v, 0.24) seg(v, 0.76, v, 0.96) seg(0.04, v, 0.24, v) seg(0.76, v, 0.96, v)
		end
	elseif kind == "gem" then
		poly({{0.24, 0.16}, {0.76, 0.16}, {0.95, 0.4}, {0.5, 0.92}, {0.05, 0.4}}, true) seg(0.05, 0.4, 0.95, 0.4) seg(0.36, 0.16, 0.28, 0.4) seg(0.64, 0.16, 0.72, 0.4)
	elseif kind == "ghost" then
		rbox(0.5, 0.48, 0.68, 0.84, 0.3) disc(0.38, 0.4, 0.13) disc(0.62, 0.4, 0.13) seg(0.34, 0.66, 0.66, 0.66)
	elseif kind == "power" then circ(0.5, 0.56, 0.7) seg(0.5, 0.06, 0.5, 0.5)
	else block(0.5, 0.5, 0.5) end
	function obj.Set(c) for _, p in ipairs(obj.Parts) do p[1][p[2]] = c end end
	function obj.Tint(c, d) for _, p in ipairs(obj.Parts) do tween(p[1], d or 0.12, {[p[2]] = c}) end end
	return obj
end

function VField:GetIcons()
	local out = {}
	for _, n in ipairs(IC.Names) do out[#out + 1] = n end
	return out
end
function VField:HasIcon(name) return resolveIcon(name) ~= nil end
function VField:CreateIcon(parent, name, size, color, z)
	local kind = resolveIcon(name) or "dot"
	return makeIcon(parent, kind, size or 18, color or "Text", z or 5)
end

 function VField:SetTheme(name, instant) 	name = ALIAS[name] or name 	local t = THEMES[name] 	if not t then return end 	currentTheme, rainbowOn = name, false 	VField.CustomAccent, VField.Overrides = nil, {} 	themeToken += 1 	local my = themeToken 	if instant or loadingCfg then for _, k in ipairs(THEME_KEYS) do COLORS[k] = t[k] end runHooks() return end 	local from = {} 	for _, k in ipairs(THEME_KEYS) do from[k] = COLORS[k] end 	task.spawn(function() 		local t0 = os.clock() 		while themeToken == my and not dead do 			local a = math.clamp((os.clock() - t0) / 0.4, 0, 1) 			for _, k in ipairs(THEME_KEYS) do COLORS[k] = from[k]:Lerp(t[k], a) end 			runHooks() 			if a >= 1 then break end 			task.wait() 		end 	end) end function VField:SetRainbow(on) 	if on == rainbowOn then return end 	if not on then rainbowOn = false VField:SetTheme(currentTheme) return end 	rainbowOn = true 	VField.CustomAccent = nil 	themeToken += 1 	task.spawn(function() 		while rainbowOn and not dead do 			local h = (os.clock() * 0.12) % 1 			COLORS.Accent, COLORS.Bright, COLORS.Soft = Color3.fromHSV(h, 0.6, 1), Color3.fromHSV(h, 0.35, 1), Color3.fromHSV(h, 0.65, 0.3) 			runHooks() 			task.wait(0.05) 		end 	end) end function VField:SetAccent(c) 	rainbowOn = false 	VField.CustomAccent = c 	themeToken += 1 	COLORS.Accent, COLORS.Bright, COLORS.Soft = c, c:Lerp(Color3.new(1, 1, 1), 0.4), c:Lerp(COLORS.Background, 0.75) 	runHooks() end function VField:RegisterTheme(name, tbl) defineTheme(name, tbl) end function VField:GetThemes() 	local out = {} 	for _, n in ipairs(THEME_ORDER) do out[#out + 1] = n end 	out[#out + 1] = "Rainbow" 	return out end function VField:GetFlag(f) return VField.Flags[f] end function VField:Notify(c) if VField.Window then VField.Window:Notify(c) end end
function VField:SetVisibility(v) if VField.Window then VField.Window.Toggle(VField.Window, v) end end
function VField:IsVisible() return VField.Window ~= nil and VField.Window.Open == true end
function VField:GetElement(f) return VField.Window and VField.Window.Elements[f] end function VField:LoadConfiguration() if VField.Window then return VField.Window:LoadConfiguration() end end function VField:GetHWID() 	local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end) 	return ok and id or "unknown" end function VField:SetColor(key, c) 	if COLORS[key] ~= nil and typeof(c) == "Color3" then COLORS[key] = c VField.Overrides[key] = c runHooks() end end local function runKeySystem(cfg) 	local ks = cfg.KeySystem 	local folder = cfg.ConfigFolder or "VField" 	local path = folder .. "/" .. (ks.FileName or "key") .. ".txt" 	local remote, fetched = nil, false 	local function norm(s) 		s = tostring(s or "") 		s = s:gsub("^%s+", "") 		s = s:gsub("%s+$", "") 		return s 	end 	local function fetchRemote() 		if fetched or not ks.KeyUrl then return end 		fetched = true 		local ok, body = pcall(function() return game:HttpGet(ks.KeyUrl) end) 		if ok and type(body) == "string" then 			remote = {} 			for line in body:gmatch("[^\r\n]+") do remote[#remote + 1] = norm(line) end 		end 	end 	local function check(key) 		key = norm(key) 		if key == "" then return false, "Enter a key first." end 		if ks.Expires and os.time() >= ks.Expires then return false, "This key system has expired." end 		if ks.Validate then 			local ok, res, msg = pcall(ks.Validate, key) 			if ok and res == true then return true end 			return false, (ok and msg) or nil 		end 		local keys = {} 		if type(ks.Key) == "string" then keys[1] = ks.Key end 		for _, k in ipairs(ks.Keys or {}) do keys[#keys + 1] = k end 		for _, k in ipairs(remote or {}) do keys[#keys + 1] = k end 		for _, k in ipairs(keys) do 			local a, b = norm(k), key 			if ks.CaseSensitive == false then a, b = a:lower(), b:lower() end 			if a == b then return true end 		end 		return false 	end 	fetchRemote() 	if ks.SaveKey ~= false then 		local saved = fsRead(path) 		if saved and (check(saved)) then return true end 	end 	local screen = newScreen("VFieldKey") 	local cam = workspace.CurrentCamera 	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) 	local veil = make("Frame", {BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1)}, screen) 	tween(veil, 0.3, {BackgroundTransparency = 0.45}) 	local cw = math.clamp(vp.X - 24, 260, 400) 	local card = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(cw, 260), 		BackgroundColor3 = COLORS.Background, BorderSizePixel = 0}, veil) 	stroke(card, COLORS.Accent, 0.4, 1) 	make("Frame", {BackgroundColor3 = COLORS.Accent, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 3)}, card) 	T(card, ks.Title or ((cfg.Name or "V Field") .. " - Key System"), 17, COLORS.Text, FONT_HEAVY, UDim2.fromOffset(20, 16), UDim2.new(1, -60, 0, 24)) 	T(card, ks.Subtitle or "Enter your key to continue", 11, COLORS.Muted, FONT, UDim2.fromOffset(20, 40), UDim2.new(1, -40, 0, 16)) 	local note = T(card, ks.Note or "", 10, COLORS.Muted, FONT, UDim2.fromOffset(20, 62), UDim2.new(1, -40, 0, 36)) 	note.TextWrapped, note.TextYAlignment = true, Enum.TextYAlignment.Top 	local x = B(card, "", UDim2.new(1, -38, 0, 12), UDim2.fromOffset(26, 26)) 	x.BackgroundColor3, x.TextColor3, x.TextSize = COLORS.Raised, COLORS.Muted, 18
	local xi = makeIcon(x, "x", 12, COLORS.Muted, 3)
	xi.Frame.Position = UDim2.fromScale(0.5, 0.5) 	local box = make("TextBox", {BackgroundColor3 = COLORS.Raised, BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT, PlaceholderText = "Paste your key here...", 		PlaceholderColor3 = COLORS.Muted, Text = "", TextColor3 = COLORS.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, 		Position = UDim2.fromOffset(20, 106), Size = UDim2.new(1, -40, 0, 38)}, card) 	make("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, box) 	local bs = stroke(box, COLORS.Line, 0.2, 1) 	box.Focused:Connect(function() tween(bs, 0.15, {Color = COLORS.Accent}) end) 	box.FocusLost:Connect(function() tween(bs, 0.2, {Color = COLORS.Line}) end) 	local status = T(card, "", 11, COLORS.Muted, FONT, UDim2.fromOffset(20, 152), UDim2.new(1, -40, 0, 18)) 	local hasLink = type(ks.Link) == "string" and ks.Link ~= "" 	local bw = hasLink and (cw - 48) / 2 or cw - 40 	local submitBtn = B(card, "SUBMIT", UDim2.fromOffset(20, 180), UDim2.fromOffset(bw, 38)) 	submitBtn.BackgroundColor3 = COLORS.Accent 	submitBtn.TextColor3 = COLORS.Background 	if hasLink then 		local linkBtn = B(card, "GET KEY", UDim2.fromOffset(28 + bw, 180), UDim2.fromOffset(bw, 38)) 		linkBtn.MouseButton1Click:Connect(function() 			playSound("Click") 			local ok = pcall(function() setclipboard(ks.Link) end) 			status.TextColor3 = ok and STATUS.success or STATUS.warn 			status.Text = ok and "Key link copied to your clipboard." or ("Get your key at: " .. ks.Link) 		end) 	end 	local foot = T(card, "", 9, COLORS.Muted, FONT, UDim2.fromOffset(20, 230), UDim2.new(1, -40, 0, 14)) 	foot.TextXAlignment = Enum.TextXAlignment.Center 	local attempts, busy, done, result = 0, false, false, false 	local max = ks.MaxAttempts 	if max then foot.Text = ("Attempts left: %d"):format(max) end 	local function finish(ok) 		if done then return end 		done, result = true, ok 		tween(veil, 0.25, {BackgroundTransparency = 1}) 		tween(card, 0.25, {Size = UDim2.fromOffset(cw, 0)}) 		task.delay(0.3, function() screen:Destroy() end) 	end 	local function submit() 		if busy or done then return end 		busy = true 		status.TextColor3, status.Text = COLORS.Muted, "Checking key..." 		task.spawn(function() 			fetchRemote() 			local ok, msg = check(box.Text) 			if ok then 				playSound("Success") 				status.TextColor3, status.Text = STATUS.success, "Key accepted!" 				if ks.SaveKey ~= false then fsWrite(path, norm(box.Text)) end 				task.wait(0.45) 				finish(true) 			else 				attempts += 1 				playSound("Error") 				status.TextColor3 = STATUS.error 				status.Text = msg or "Invalid key." 				if max then foot.Text = ("Attempts left: %d"):format(math.max(max - attempts, 0)) end 				for i = 1, 4 do 					tween(card, 0.04, {Position = UDim2.new(0.5, i % 2 == 0 and 8 or -8, 0.5, 0)}) 					task.wait(0.04) 				end 				tween(card, 0.06, {Position = UDim2.fromScale(0.5, 0.5)}) 				if max and attempts >= max then 					task.wait(0.4) 					finish(false) 					if ks.KickOnFail then lp:Kick(ks.KickMessage or "Too many invalid key attempts.") end 				end 				busy = false 			end 		end) 	end 	submitBtn.MouseButton1Click:Connect(function() playSound("Click") submit() end) 	box.FocusLost:Connect(function(enter) if enter then submit() end end) 	x.MouseButton1Click:Connect(function() finish(false) end) 	repeat task.wait(0.1) until done 	return result end local ELEMENT_NAMES = {"CreateLabel", "CreateParagraph", "CreateDivider", "CreateButton", "CreateToggle", "CreateSlider", "CreateRangeSlider", 	"CreateProgressBar", "CreateDropdown", "CreateInput", "CreateKeybind", "CreateColorPicker", "CreateSegmented", "CreateConsole", "CreateImage", "CreateLink", "CreateIconGallery", "CreateStepper", "CreateCheckbox", "CreateRadio", "CreateChips", "CreateStat", "CreateGraph", "CreateKeyValue", "CreateCodeBlock", "CreateListBox", "CreateTable", "CreateButtonRow", "CreateSwatches", "CreateSeparator", "CreateSpacer", "CreateStatus", "CreateTextArea"} local function normalizeWindowCfg(src) 	local c = {} 	for k, v in pairs(src) do c[k] = v end 	if c.ToggleUIKeybind and not c.ToggleKey then 		local k = c.ToggleUIKeybind 		if typeof(k) == "string" then local ok, kk = pcall(function() return Enum.KeyCode[k] end) k = ok and kk or nil end 		c.ToggleKey = k 	end 	local cs = c.ConfigurationSaving 	if type(cs) == "table" and cs.Enabled then 		c.ConfigFolder = c.ConfigFolder or cs.FolderName or "VField" 		c.AutoSave = true 		c.CfgFileName = cs.FileName 	end 	local ksr = src.KeySettings 	if src.KeySystem == true and type(ksr) == "table" then 		local kk = ksr.Key 		local ks = {Enabled = true, Title = ksr.Title, Subtitle = ksr.Subtitle, Note = ksr.Note, FileName = ksr.FileName, SaveKey = ksr.SaveKey} 		if ksr.GrabKeyFromSite and type(kk) == "table" and kk[1] then ks.KeyUrl = kk[1] 		else ks.Keys = type(kk) == "table" and kk or {tostring(kk or "")} end 		c.KeySystem = ks 	elseif type(src.KeySystem) ~= "table" then 		c.KeySystem = nil 	end 	return c end function VField._preload(cfg)
	if not canFS then return end
	local nm = (tostring(cfg.CfgFileName or "autosave"):gsub("[^%w_%-]", ""))
	local folder = (cfg.ConfigFolder or "VField") .. (cfg.PerGame and ("/" .. tostring(game.PlaceId)) or "")
	local d = fsRead(folder .. "/configs/" .. nm .. ".json")
	if not d then return end
	local ok, t = pcall(function() return HttpService:JSONDecode(d) end)
	if not ok or type(t) ~= "table" then return end
	local th = t.vf_theme
	if th == "Rainbow" then VField:SetRainbow(true)
	elseif type(th) == "string" and THEMES[ALIAS[th] or th] then VField:SetTheme(th, true) end
	local function col(v) if type(v) == "table" and #v == 3 then return Color3.fromRGB(v[1], v[2], v[3]) end end
	if type(t.vf_coloroverrides) == "table" then
		for k, v in pairs(t.vf_coloroverrides) do local c = col(v) if c then VField:SetColor(k, c) end end
	end
	local a = col(t.vf_accentcustom)
	if a and not rainbowOn then VField:SetAccent(a) end
end
function VField:CreateWindow(cfg) 	cfg = normalizeWindowCfg(cfg or {}) 	dead, hooks = false, {}
	if type(cfg.Theme) == "table" then
		local t = {}
		for k, v in pairs(cfg.Theme) do t[k] = v end
		for _, k in ipairs({"Accent", "Bright", "Soft"}) do t[k] = typeof(t[k]) == "Color3" and t[k] or THEMES.Mono[k] end
		defineTheme("Custom", t)
		cfg.Theme = "Custom"
	end 	if cfg.Theme == "Rainbow" then VField:SetRainbow(true) 	elseif cfg.Theme and THEMES[ALIAS[cfg.Theme] or cfg.Theme] then 		currentTheme = ALIAS[cfg.Theme] or cfg.Theme 		for k, v in pairs(THEMES[currentTheme]) do COLORS[k] = v end 	end 	pcall(VField._preload, cfg)
	if cfg.KeySystem and cfg.KeySystem.Enabled ~= false then 		if not runKeySystem(cfg) then return nil end 		if cfg.KeySystem.OnSuccess then pcall(cfg.KeySystem.OnSuccess) end 	end 	computeLayout(cfg) 	if cfg.Lite ~= nil then VField._lite = cfg.Lite == true else VField._lite = COMPACT end 	local screen = newScreen("VFieldUI") 	local win = {Elements = {}, Tabs = {}, Conns = {}, Keybinds = {}, Binds = {}, Registry = {}, Flags = {}, Destroyed = false, NotifIndex = 0, 		Ready = false, Open = false, ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightControl, BlurOn = cfg.Blur ~= false, 		AutoSave = cfg.AutoSave ~= false, Folder = (cfg.ConfigFolder or "VField") .. (cfg.PerGame and ("/" .. tostring(game.PlaceId)) or ""), 		CfgFileName = cfg.CfgFileName, ToggleFns = {}, TabOrder = 0, CurScale = 1, NotifyOn = true, DestroyFns = {}} 	win.Flags = VField.Flags 	for k in pairs(VField.Flags) do VField.Flags[k] = nil end 	local function conn(c) win.Conns[#win.Conns + 1] = c return c end 	function win:Ready() pcall(self._RegisterCore, self) if cfg.AutoLoad == false then self.Restored = true end self.IsReady = true if cfg.AutoLoad ~= false then task.defer(function() self:LoadAutoConfig(true) end) end end 	function win:OnDestroy(fn) self.DestroyFns[#self.DestroyFns + 1] = fn end 	local blur = Lighting:FindFirstChild("VFieldBlur") or make("BlurEffect", {Name = "VFieldBlur", Size = 0}, Lighting) 	blur.Enabled = false 	local function applyBlur(show) 		local on = show and win.BlurOn 		if on then blur.Enabled = true end 		tween(blur, 0.3, {Size = on and 8 or 0}) 		if not on then task.delay(0.4, function() if not (win.Open and win.BlurOn) then blur.Enabled = false end end) end 	end 	local W, H = WINDOW_W, WINDOW_H 	local baseT = 0 	local vp0 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720) 	local main = P(make("Frame", {Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Position = UDim2.fromOffset(vp0.X / 2, vp0.Y / 2), 		Size = UDim2.fromOffset(W, H), Visible = false, ZIndex = 10}, screen), {BackgroundColor3 = "Background"}) 	local mainStroke = stroke(main, COLORS.Accent, 0.5, 1) 	hook(function() mainStroke.Color = COLORS.Accent end) 	local mainScale = make("UIScale", {Scale = 1}, main) 	local respScale, userScale = 1, 1 	local function updateScale() 		local cam = workspace.CurrentCamera 		if not cam then return end 		local vp = cam.ViewportSize 		local fit = math.min((vp.X - 24) / (W + 20), (vp.Y - 60) / (H + 20)) 		respScale = math.clamp(math.min(1, fit) * userScale, 0.35, 2) 		mainScale.Scale = respScale 		win.CurScale = respScale 	end 	updateScale() 	if workspace.CurrentCamera then conn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)) end 	function win:SetScale(m) userScale = m updateScale() end 	function win:SetBlur(on) self.BlurOn = on applyBlur(self.Open) end 	function win:SetSounds(on) snd.on = on end 	function win:SetVolume(v) snd.vol = v end 	function win:SetTransparency(a) baseT = math.clamp(a, 0, 0.8) if self.Open then tween(main, 0.2, {BackgroundTransparency = baseT}) end end 	function win:SetNotifications(on) self.NotifyOn = on end 	function win:SetToggleKey(k) self.ToggleKey = k end 	function win:OnToggle(fn) self.ToggleFns[#self.ToggleFns + 1] = fn end
	function win:SetVisibility(v) self.Toggle(v) end
	function win:IsVisible() return self.Open == true end 	function win:ResetPosition() 		local cam = workspace.CurrentCamera 		local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) 		tween(main, 0.3, {Position = UDim2.fromOffset(vp.X / 2, vp.Y / 2)}) 	end 	local lastPointer = Vector2.new() 	local function remember(input) 		local t = input.UserInputType 		if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then lastPointer = pointer(input) end 	end 	conn(UIS.InputBegan:Connect(remember)) 	conn(UIS.InputChanged:Connect(remember)) 	local function ripple(parent) 		if win.Destroyed or not parent.Parent then return end 		local ap, as = parent.AbsolutePosition, parent.AbsoluteSize 		if as.X <= 0 or as.Y <= 0 then return end 		local rx, ry = math.clamp((lastPointer.X - ap.X) / as.X, 0, 1), math.clamp((lastPointer.Y - ap.Y) / as.Y, 0, 1) 		local clip = make("Frame", {BackgroundTransparency = 1, ClipsDescendants = true, Size = UDim2.fromScale(1, 1), ZIndex = parent.ZIndex + 6}, parent) 		local wave = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = COLORS.Bright, BackgroundTransparency = 0.72, BorderSizePixel = 0, 			Position = UDim2.fromScale(rx, ry), Size = UDim2.fromOffset(2, 2), ZIndex = parent.ZIndex + 6}, clip) 		tween(wave, 0.45, {Size = UDim2.fromOffset(as.X * 2.4, as.X * 2.4), BackgroundTransparency = 1}) 		task.delay(0.5, function() if clip.Parent then clip:Destroy() end end) 	end 	local lastHover = 0 	local function hover(btn) 		btn.MouseEnter:Connect(function() 			if win.Destroyed or os.clock() - lastHover < 0.06 then return end 			lastHover = os.clock() 			playSound("Hover") 		end) 	end 	 	local tip = P(make("Frame", {BorderSizePixel = 0, Visible = false, ZIndex = 400, AutomaticSize = Enum.AutomaticSize.XY}, screen), {BackgroundColor3 = "Panel"}) 	local tipStroke = stroke(tip, COLORS.Accent, 0.3, 1) 	hook(function() tipStroke.Color = COLORS.Accent end) 	make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)}, tip) 	local tipText = T(tip, "", 10, "Text", FONT, UDim2.new(), UDim2.fromOffset(0, 0)) 	tipText.AutomaticSize, tipText.ZIndex, tipText.TextWrapped = Enum.AutomaticSize.XY, 401, false 	local tipTok = 0 	local function attachTip(gui, text) 		if not text or text == "" then return end 		gui.MouseEnter:Connect(function() 			tipTok += 1 			local my = tipTok 			task.delay(0.45, function() 				if tipTok ~= my or win.Destroyed then return end 				local shown = text if win._tipOv and win._tipOv[gui] ~= nil then shown = win._tipOv[gui] end if shown == nil or shown == "" or shown == " " then return end tipText.Text = shown 				tip.Position = UDim2.fromOffset(lastPointer.X + 14, lastPointer.Y + 18) 				tip.Visible = true 			end) 		end) 		gui.MouseLeave:Connect(function() tipTok += 1 tip.Visible = false end) 	end 	 	local header = P(make("Frame", {BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, HEADER_H), ZIndex = 2}, main), {BackgroundColor3 = "Panel"}) 	local logo = make("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(COMPACT and 10 or 16, (HEADER_H - 34) / 2), Size = UDim2.fromOffset(34, 34), ZIndex = 3, 		BackgroundColor3 = Color3.new(0, 0, 0)}, header) 	local logoStroke = stroke(logo, COLORS.Bright, 0.35, 1) 	hook(function() logoStroke.Color = COLORS.Bright end) 	loop(logoStroke, 1.2, {Transparency = 0.05, Thickness = 1.6}, Enum.EasingStyle.Sine, true) 	local logoIcon = tostring(cfg.Icon or "") 	local logoImg = logoIcon:match("^rbxassetid://") and logoIcon or (logoIcon:match("^%d+$") and ("rbxassetid://" .. logoIcon) or nil) 	if logoImg then 		local li = make("ImageLabel", {BackgroundTransparency = 1, Image = logoImg, Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 1, -6), ZIndex = 4}, logo) 		P(li, {ImageColor3 = "Bright"}) 	else 		local lt = T(logo, logoIcon ~= "" and logoIcon or string.upper(string.sub(cfg.Name or "V", 1, 1)), 18, "Bright", FONT_HEAVY, UDim2.new(), UDim2.fromScale(1, 1)) 		lt.TextXAlignment, lt.ZIndex = Enum.TextXAlignment.Center, 4 	end 	local tx = COMPACT and 52 or 60 	local titleLbl = T(header, cfg.Name or "V Field", 16, "Text", FONT_HEAVY, UDim2.fromOffset(tx, COMPACT and 6 or 10), UDim2.new(1, -(tx + 110), 0, 22)) 	titleLbl.ZIndex = 3 	local sub = T(header, cfg.Subtitle or "", 10, "Muted", FONT, UDim2.fromOffset(tx, COMPACT and 27 or 33), UDim2.new(1, -(tx + 110), 0, 16)) 	sub.ZIndex, sub.TextTruncate = 3, Enum.TextTruncate.AtEnd 	function win:SetTitle(t) titleLbl.Text = tostring(t) end 	function win:SetSubtitle(t) sub.Text = tostring(t) end 	local cs = COMPACT and 34 or 28 	local function headBtn(kind, off)
	local b = B(header, "", UDim2.new(1, -(cs + 10) - off, 0, (HEADER_H - cs) / 2), UDim2.fromOffset(cs, cs))
	b.ZIndex = 3
	local ic = makeIcon(b, kind, math.floor(cs * 0.5), "Muted", 4)
	ic.Frame.Position = UDim2.fromScale(0.5, 0.5)
	hover(b)
	b.MouseEnter:Connect(function() tween(b, 0.12, {BackgroundColor3 = COLORS.Hover}) ic.Tint(COLORS.Bright) end)
	b.MouseLeave:Connect(function() tween(b, 0.15, {BackgroundColor3 = COLORS.Raised}) ic.Tint(COLORS.Muted) end)
	return b
end
local closeBtn, minBtn = headBtn("x", 0), headBtn("minus", cs + 6) 	if not COMPACT and cfg.HeaderStats ~= false then 		local hs = T(header, "", 10, "Muted", FONT_BOLD, UDim2.new(1, -(cs * 2 + 24) - 150, 0, 0), UDim2.fromOffset(150, HEADER_H)) 		hs.TextXAlignment, hs.ZIndex = Enum.TextXAlignment.Right, 3 		task.spawn(function() 			while not win.Destroyed do 				if win.Open and win.GetFPS then 					local p = 0 pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end) 					hs.Text = ("%d FPS  |  %d ms"):format(math.floor(win:GetFPS() + 0.5), p) 				end 				task.wait(0.5) 			end 		end) 	end 	local aline = make("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, HEADER_H - 2), Size = UDim2.new(1, 0, 0, 2), ZIndex = 3}, main) 	local ag = make("UIGradient", {Offset = Vector2.new(-1, 0)}, aline) 	hook(function() ag.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLORS.Soft), ColorSequenceKeypoint.new(0.5, COLORS.Bright), ColorSequenceKeypoint.new(1, COLORS.Soft)}) end) 	loop(ag, 2.4, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Sine, false) 	local body = make("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, HEADER_H), Size = UDim2.new(1, 0, 1, -HEADER_H), ZIndex = 2, ClipsDescendants = true}, main) 	local sidebar = P(make("Frame", {BorderSizePixel = 0, Size = UDim2.new(0, SIDEBAR_W, 1, 0), ZIndex = 2}, body), {BackgroundColor3 = "Panel"}) 	local userH = COMPACT and 0 or 44 	local tabList = make("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, 		ScrollBarThickness = 2, Position = UDim2.fromOffset(COMPACT and 6 or 10, 10), Size = UDim2.new(1, COMPACT and -12 or -20, 1, -(20 + userH)), ZIndex = 3}, sidebar) 	list(tabList, 6) 	if not COMPACT then 		local ub = make("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, -userH), Size = UDim2.new(1, 0, 0, userH), ZIndex = 3}, sidebar) 		make("Frame", {BackgroundColor3 = COLORS.Line, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), ZIndex = 3}, ub) 		local av = make("ImageLabel", {BackgroundColor3 = COLORS.Raised, BorderSizePixel = 0, Position = UDim2.fromOffset(10, 8), Size = UDim2.fromOffset(28, 28), ZIndex = 4}, ub) 		task.spawn(function() 			local ok, img = pcall(function() return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) 			if ok and av.Parent then av.Image = img end 		end) 		local un = T(ub, lp.DisplayName, 11, "Text", FONT_BOLD, UDim2.fromOffset(46, 7), UDim2.new(1, -52, 0, 15)) 		un.ZIndex, un.TextTruncate = 4, Enum.TextTruncate.AtEnd 		local us = T(ub, cfg.Footer or ("V Field v" .. VField.Version), 9, "Muted", FONT, UDim2.fromOffset(46, 22), UDim2.new(1, -52, 0, 12)) 		us.ZIndex, us.TextTruncate = 4, Enum.TextTruncate.AtEnd 	end 	local content = make("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(SIDEBAR_W, 0), Size = UDim2.new(1, -SIDEBAR_W, 1, 0), ZIndex = 2}, body) 	 	local searchWrap = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, SEARCH_H), ZIndex = 3}, content) 	local sBox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT, PlaceholderText = "Search options...", Text = "", TextSize = 11 + BOOST, 		TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(PAD, 7), Size = UDim2.new(1, -PAD * 2, 1, -9), ZIndex = 4}, searchWrap), 		{BackgroundColor3 = "Raised", TextColor3 = "Text", PlaceholderColor3 = "Muted"}) 	local sStroke = stroke(sBox, COLORS.Line, 0.35, 1) 	make("UIPadding", {PaddingLeft = UDim.new(0, 28), PaddingRight = UDim.new(0, 8)}, sBox) 	local sIcon = makeIcon(sBox, "search", 14, "Muted", 5)
	sIcon.Frame.Position = UDim2.new(0, -15, 0.5, 0) 	sBox.Focused:Connect(function() tween(sStroke, 0.15, {Transparency = 0, Color = COLORS.Accent}) end) 	sBox.FocusLost:Connect(function() tween(sStroke, 0.2, {Transparency = 0.35, Color = COLORS.Line}) end) 	local SB_H = COMPACT and 18 or 22
	local pagesHolder = make("Frame", {BackgroundTransparency = 1, ClipsDescendants = true, Position = UDim2.fromOffset(0, SEARCH_H), Size = UDim2.new(1, 0, 1, -SEARCH_H - SB_H), ZIndex = 2}, content)
	-- status bar
	local sbar = P(make("Frame", {BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -SB_H), Size = UDim2.new(1, 0, 0, SB_H), ZIndex = 4}, content), {BackgroundColor3 = "Panel"})
	P(make("Frame", {BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 1), ZIndex = 5}, sbar), {BackgroundColor3 = "Line"})
	local sbL = T(sbar, "", 9, "Muted", FONT_BOLD, UDim2.fromOffset(PAD, 0), UDim2.new(0.5, -PAD, 1, 0))
	local sbR = T(sbar, "", 9, "Muted", FONT_BOLD, UDim2.new(0.5, 0, 0, 0), UDim2.new(0.5, -PAD - 22, 1, 0))
	sbL.ZIndex, sbR.ZIndex, sbR.TextXAlignment = 5, 5, Enum.TextXAlignment.Right
	local execName = "Unknown"
	pcall(function() if identifyexecutor then execName = tostring((identifyexecutor())) end end)
	task.spawn(function()
		while not win.Destroyed do
			if win.Open then
				local tabName = win.ActiveTab and win.ActiveTab.Name or "-"
				local mem = 0 pcall(function() mem = math.floor(Stats:GetTotalMemoryUsageMb()) end)
				sbL.Text = ("> %s"):format(string.upper(tostring(tabName)))
				sbR.Text = COMPACT and os.date("%H:%M") or ("%s  |  %d MB  |  %d/%d  |  %s"):format(execName, mem, #Players:GetPlayers(), Players.MaxPlayers, os.date("%H:%M:%S"))
			end
			task.wait(1)
		end
	end)
	-- accent corner brackets on the window
	if not COMPACT then
		for _, c in ipairs({{0, 0}, {1, 0}, {0, 1}, {1, 1}}) do
			for k = 1, 2 do
				local br = make("Frame", {AnchorPoint = Vector2.new(c[1], c[2]), BorderSizePixel = 0, Position = UDim2.fromScale(c[1], c[2]), Size = k == 1 and UDim2.fromOffset(12, 2) or UDim2.fromOffset(2, 12), ZIndex = 58}, main)
				P(br, {BackgroundColor3 = "Accent"})
			end
		end
	end 	 	local grip = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.fromOffset(20, 20), 		AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -1, 1, -1), ZIndex = 60}, main) 	local gripIcon = makeIcon(grip, "grip", 14, "Muted", 61)
	gripIcon.Frame.Position = UDim2.fromScale(0.5, 0.5) 	 	local revW = 176 	local reveal = make("TextButton", {Active = true, AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.fromOffset(revW, 38), Text = "", Visible = false, 		ZIndex = 100, Position = UDim2.fromOffset(math.max(10, (vp0.X - revW) / 2), 16)}, screen) 	P(reveal, {BackgroundColor3 = "Background"}) 	local revStroke = stroke(reveal, COLORS.Accent, 0.22, 1.2) 	hook(function() revStroke.Color = COLORS.Accent end) 	loop(revStroke, 1.1, {Transparency = 0.04, Thickness = 1.8}, Enum.EasingStyle.Sine, true) 	local rb = make("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(18, 18), ZIndex = 102}, reveal) 	P(rb, {BackgroundColor3 = "Bright"}) 	T(reveal, "SHOW " .. string.upper(cfg.Name or "V FIELD"), 10, "Text", FONT_HEAVY, UDim2.fromOffset(38, 0), UDim2.new(1, -44, 1, 0)).ZIndex = 102 	hover(reveal) 	local token = 0 	function win.Toggle(a, b)
		local force = a
		if a == win then force = b end
		if win.Destroyed then return end
		local show = force 		if show == nil then show = not win.Open end 		if show == win.Open then return end 		win.Open = show 		for _, f in ipairs(win.ToggleFns) do task.spawn(f, show) end 		token += 1 		local my = token 		if show then 			playSound("Open") 			main.Visible, reveal.Visible = true, false 			mainScale.Scale = respScale * 0.92 			main.BackgroundTransparency = 0.4 			tween(mainScale, 0.35, {Scale = respScale}, Enum.EasingStyle.Back) 			tween(main, 0.25, {BackgroundTransparency = baseT}) 			applyBlur(true) 		else 			playSound("Close") 			tween(mainScale, 0.2, {Scale = respScale * 0.94}, Enum.EasingStyle.Quad, Enum.EasingDirection.In) 			tween(main, 0.18, {BackgroundTransparency = 0.4}, Enum.EasingStyle.Quad, Enum.EasingDirection.In) 			applyBlur(false) 			task.delay(0.2, function() 				if not win.Destroyed and token == my then 					main.Visible, reveal.Visible = false, true 					reveal.BackgroundTransparency = 0.4 					tween(reveal, 0.3, {BackgroundTransparency = 0}, Enum.EasingStyle.Back) 				end 			end) 		end 	end 	closeBtn.MouseButton1Click:Connect(function() playSound("Click") win.Toggle(false) end) 	local minimized = false
	local function setMinimized(v)
		minimized = v
		grip.Visible = not minimized
		if minimized then
			body.Visible = false
			tween(main, 0.22, {Size = UDim2.fromOffset(W, HEADER_H)})
		else
			tween(main, 0.22, {Size = UDim2.fromOffset(W, H)})
			task.delay(0.1, function() if not minimized then body.Visible = true end end)
		end
	end
	function win:Minimize(v)
		if v == nil then v = not minimized end
		setMinimized(v)
	end
	minBtn.MouseButton1Click:Connect(function() playSound("Click") setMinimized(not minimized) end) 	 	header.InputBegan:Connect(function(input) 		if not isPress(input) then return end 		local p = pointer(input) 		if inside(closeBtn, p) or inside(minBtn, p) then return end 		local sp, so = p, Vector2.new(main.Position.X.Offset, main.Position.Y.Offset) 		tween(mainStroke, 0.15, {Transparency = 0.15}) 		win.ActiveDrag = { 			Drag = function(q) 				local cam = workspace.CurrentCamera 				local vp = cam and cam.ViewportSize or Vector2.new(800, 600) 				local hw, hh = main.AbsoluteSize.X / 2, main.AbsoluteSize.Y / 2 				local n = so + (q - sp) 				main.Position = UDim2.fromOffset(math.clamp(n.X, hw, math.max(vp.X - hw, hw)), math.clamp(n.Y, hh, math.max(vp.Y - hh, hh))) 			end, 			Release = function() tween(mainStroke, 0.25, {Transparency = 0.5}) if win.AutoSave and win.Restored then win:QueueSave() end end, 		} 	end) 	grip.InputBegan:Connect(function(input) 		if not isPress(input) then return end 		local sp, sw, sh, so = pointer(input), W, H, Vector2.new(main.Position.X.Offset, main.Position.Y.Offset) 		win.ActiveDrag = {Drag = function(q) 			local cam = workspace.CurrentCamera 			local vp = cam and cam.ViewportSize or Vector2.new(1280, 720) 			local sc = math.max(win.CurScale, 0.01) 			local d = (q - sp) / sc 			local minW, minH = COMPACT and 280 or 480, 280 			local nw = math.clamp(sw + d.X, minW, math.max(minW, vp.X / sc - 20)) 			local nh = math.clamp(sh + d.Y, minH, math.max(minH, vp.Y / sc - 20)) 			W, H = nw, nh 			main.Size = UDim2.fromOffset(nw, nh) 			main.Position = UDim2.fromOffset(so.X + (nw - sw) * sc / 2, so.Y + (nh - sh) * sc / 2) 		end, Release = function() if win.AutoSave and win.Restored then win:QueueSave() end end} 	end) 	local rdrag 	reveal.InputBegan:Connect(function(input) 		if isPress(input) then rdrag = {t = input.UserInputType, sx = input.Position.X, sy = input.Position.Y, ox = reveal.Position.X.Offset, oy = reveal.Position.Y.Offset, moved = false} end 	end) 	conn(UIS.InputChanged:Connect(function(input) 		if win.Destroyed then return end 		local t = input.UserInputType 		if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end 		local cam = workspace.CurrentCamera 		local vp = cam and cam.ViewportSize or Vector2.new(800, 600) 		if rdrag then 			local dx, dy = input.Position.X - rdrag.sx, input.Position.Y - rdrag.sy 			if math.abs(dx) > 5 or math.abs(dy) > 5 then rdrag.moved = true end 			if rdrag.moved then reveal.Position = UDim2.fromOffset(math.clamp(rdrag.ox + dx, 5, vp.X - revW - 5), math.clamp(rdrag.oy + dy, 5, vp.Y - 45)) end 		end 		if win.ActiveDrag then win.ActiveDrag.Drag(pointer(input)) end 	end)) 	conn(UIS.InputEnded:Connect(function(input) 		local t = input.UserInputType 		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then 			if win.ActiveDrag then local a = win.ActiveDrag win.ActiveDrag = nil if a.Release then a.Release() end end 		end 		if rdrag and t == rdrag.t then 			if not rdrag.moved and not win.Destroyed then playSound("Click") win.Toggle(true) end 			rdrag = nil 		end 		for _, b in ipairs(win.Keybinds) do 			local k = b.Value() 			if b.Release and k and input.KeyCode == k then task.spawn(b.Release, false) end 		end 	end)) 	conn(UIS.InputBegan:Connect(function(input, processed) 		if win.Destroyed then return end 		if win.WaitingKey then 			if input.KeyCode ~= Enum.KeyCode.Unknown then 				local w = win.WaitingKey 				win.WaitingKey = nil 				w(input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode or nil) 			end 			return 		end 		if processed then return end 		if input.KeyCode == win.ToggleKey then win.Toggle() end 		for _, b in ipairs(win.Keybinds) do 			local k = b.Value() 			if b.Callback and k and input.KeyCode == k then task.spawn(b.Callback, true) end 		end 	end)) 	function win:_RegisterCore()
		if self._core then return end
		self._core = true
		local R = self.Registry
		local function c3(v) if type(v) == "table" and #v == 3 then return Color3.fromRGB(v[1], v[2], v[3]) end end
		local function arr(c) return {math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)} end
		if not R.vf_theme then
			R.vf_theme = {kind = "data", Get = function() return rainbowOn and "Rainbow" or currentTheme end, Set = function(v)
				if v == "Rainbow" then VField:SetRainbow(true) else VField:SetRainbow(false) VField:SetTheme(v) end
			end}
		end
		R.vf_coloroverrides = {kind = "data", Get = function()
			local t = {}
			for k, c in pairs(VField.Overrides) do t[k] = arr(c) end
			return t
		end, Set = function(v)
			if type(v) ~= "table" then return end
			for k, a in pairs(v) do local c = c3(a) if c then VField:SetColor(k, c) end end
		end}
		R.vf_accentcustom = {kind = "data", Get = function() local c = VField.CustomAccent if c and not rainbowOn then return arr(c) end return false end,
			Set = function(v) local c = c3(v) if c and not rainbowOn then VField:SetAccent(c) end end}
		R.vf_layout = {kind = "data", Session = true, Get = function()
			local col = {}
			for _, tab in ipairs(win.Tabs) do
				for _, sec in ipairs(tab.Sections) do if sec.Collapsed then col[#col + 1] = tab.Name .. "/" .. sec.NameLower end end
			end
			return {x = main.Position.X.Offset, y = main.Position.Y.Offset, w = W, h = H, tab = win.ActiveTab and win.ActiveTab.Name or false, collapsed = col}
		end, Set = function(v)
			if type(v) ~= "table" then return end
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
			if not COMPACT and tonumber(v.w) and tonumber(v.h) then
				W = math.clamp(v.w, 480, math.max(480, vp.X - 20))
				H = math.clamp(v.h, 280, math.max(280, vp.Y - 20))
				if not minimized then main.Size = UDim2.fromOffset(W, H) end
			end
			if tonumber(v.x) and tonumber(v.y) then
				local sc = math.max(win.CurScale, 0.01)
				local hw, hh = W * sc / 2, (minimized and HEADER_H or H) * sc / 2
				main.Position = UDim2.fromOffset(math.clamp(v.x, hw, math.max(vp.X - hw, hw)), math.clamp(v.y, hh, math.max(vp.Y - hh, hh)))
			end
			if type(v.collapsed) == "table" then
				local set = {}
				for _, k in ipairs(v.collapsed) do set[k] = true end
				for _, tab in ipairs(win.Tabs) do
					for _, sec in ipairs(tab.Sections) do sec:SetCollapsed(set[tab.Name .. "/" .. sec.NameLower] == true) end
				end
			end
			if type(v.tab) == "string" then local t = win:GetTab(v.tab) if t then t.Select() end end
		end}
	end
	function win:CreateHud(id, size, pos, flagSave) 		local f = make("Frame", {Name = "Hud" .. id, Active = true, BackgroundTransparency = 0.12, BorderSizePixel = 0, Size = size, Position = pos, Visible = false, ZIndex = 5}, screen) 		P(f, {BackgroundColor3 = "Background"}) 		local st = stroke(f, COLORS.Accent, 0.5, 1) 		hook(function() st.Color = COLORS.Accent end) 		f.InputBegan:Connect(function(i) 			if not isPress(i) then return end 			local sp, so = pointer(i), Vector2.new(f.Position.X.Offset, f.Position.Y.Offset) 			win.ActiveDrag = {Drag = function(p) 				local cam = workspace.CurrentCamera 				local vp = cam and cam.ViewportSize or Vector2.new(800, 600) 				local n = so + (p - sp) 				f.Position = UDim2.fromOffset(math.clamp(n.X, 0, math.max(vp.X - f.AbsoluteSize.X, 0)), math.clamp(n.Y, 0, math.max(vp.Y - f.AbsoluteSize.Y, 0))) 			end, Release = function() if win.AutoSave then win:QueueSave() end end} 		end) 		if flagSave then 			win.Registry["vf_hud_" .. id] = {kind = "hud", Get = function() return {f.Position.X.Offset, f.Position.Y.Offset} end, 				Set = function(v) if type(v) == "table" and type(v[1]) == "number" then f.Position = UDim2.fromOffset(v[1], v[2]) end end} 		end 		return f 	end 	local fps = 60 	conn(RunService.Heartbeat:Connect(function(dt) fps = fps * 0.92 + (1 / math.max(dt, 0.001)) * 0.08 end)) 	local function ping() 		local p = 0 		pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end) 		return p 	end 	function win:CreateWatermark(c) 		c = c or {} 		local obj = {Text = c.Text or (cfg.Name or "V Field")} 		local f = self:CreateHud("Watermark", UDim2.fromOffset(240, 26), UDim2.fromOffset(12, 12), true) 		local l = T(f, "", 11, "Text", FONT_BOLD, UDim2.fromOffset(10, 0), UDim2.new(1, -20, 1, 0)) 		l.RichText = true 		local bar = make("Frame", {BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 2), ZIndex = 6}, f) 		P(bar, {BackgroundColor3 = "Accent"}) 		local function update() 			local c = COLORS.Bright 			local acc = ("#%02x%02x%02x"):format(math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255)) 			local plain = ("%s | %d fps | %d ms | %s"):format(obj.Text, math.floor(fps), ping(), os.date("%H:%M")) 			l.Text = ('<font color="%s">%s</font>'):format(acc, obj.Text) .. (" | %d fps | %d ms | %s"):format(math.floor(fps), ping(), os.date("%H:%M")) 			local okS, sz = pcall(function() return TextService:GetTextSize(plain, 11, FONT_BOLD, Vector2.new(2000, 30)) end) 			f.Size = UDim2.fromOffset(okS and sz.X + 24 or 220, 26) 		end 		task.spawn(function() while not win.Destroyed do if f.Visible then pcall(update) end task.wait(0.25) end end) 		function obj.SetText(t) obj.Text = t end 		function obj.SetVisible(v) f.Visible = v end 		obj.Frame = f 		f.Visible = c.Visible ~= false 		return obj 	end 	function win:CreateKeybindList() 		local obj = {} 		local f = self:CreateHud("Keybinds", UDim2.fromOffset(170, 40), UDim2.fromOffset(12, 56), true) 		T(f, "KEYBINDS", 9, "Bright", FONT_HEAVY, UDim2.fromOffset(10, 4), UDim2.new(1, -20, 0, 14)) 		local l = T(f, "", 10, "Text", FONT, UDim2.fromOffset(10, 20), UDim2.new(1, -20, 1, -24)) 		l.RichText, l.TextYAlignment = true, Enum.TextYAlignment.Top 		task.spawn(function() 			while not win.Destroyed do 				if f.Visible then 					local lines, n = {}, 0 					for _, b in ipairs(win.Binds) do 						local k = b.Key() 						if k then 							n += 1 							lines[#lines + 1] = ('<font color="%s">[%s]</font> %s'):format(b.Active() and "#50e187" or "#99999f", k.Name, b.Name) 						end 					end 					l.Text = n > 0 and table.concat(lines, "\n") or '<font color="#99999f">No binds set</font>' 					f.Size = UDim2.fromOffset(170, 28 + math.max(n, 1) * 14) 				end 				task.wait(0.2) 			end 		end) 		function obj.SetVisible(v) f.Visible = v end 		obj.Frame = f 		f.Visible = true 		return obj 	end 	local function emit(config, v) 		if config.Flag then
			win.Flags[config.Flag] = v
			local el = win.Elements[config.Flag]
			if el then el.CurrentValue = v end
		end 		if win.AutoSave then win:QueueSave() end 		if config.Flag and win.FlagListeners then local ls = win.FlagListeners[config.Flag] if ls then for _, fn in ipairs(ls) do task.spawn(fn, v) end end if win.AnyFlagListeners then for _, fn in ipairs(win.AnyFlagListeners) do task.spawn(fn, config.Flag, v) end end end 		if config.Callback then task.spawn(config.Callback, v) end 	end 	local function register(config, kind, get, set) 		if not config.Flag then return end 		win.Registry[config.Flag] = {kind = kind, Get = get, Set = set, Ignore = config.IgnoreConfig, Default = get()} 		win.Flags[config.Flag] = get() 	end 	local function sliderCore(parent, pos, size, minV, maxV, inc, init, onChange, onVisual, zi) 		local track = P(make("Frame", {BorderSizePixel = 0, Position = pos, Size = size, ZIndex = zi}, parent), {BackgroundColor3 = "Panel"}) 		stroke(track, COLORS.Line, 0.5, 1) 		local fill = P(make("Frame", {BorderSizePixel = 0, ZIndex = zi + 1}, track), {BackgroundColor3 = "Accent"}) 		local ks = COMPACT and 20 or 12 		local knob = P(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Size = UDim2.fromOffset(ks, ks), ZIndex = zi + 2}, track), {BackgroundColor3 = "Text"}) 		local kst = stroke(knob, COLORS.Accent, 0, 2) 		hook(function() kst.Color = COLORS.Accent end) 		local hit = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), 			Size = UDim2.new(1, 0, 0, COMPACT and 40 or 24), Text = "", ZIndex = zi + 3}, track) 		local obj, value, lastTick = {Track = track}, init, 0 		function obj.Get() return value end 		function obj.Set(n, silent) 			local snapped = minV + math.floor(((n - minV) / inc) + 0.5) * inc 			value = tonumber(string.format("%.10g", math.clamp(snapped, minV, maxV))) 			local r = (value - minV) / (maxV - minV) 			fill.Size = UDim2.new(r, 0, 1, 0) 			knob.Position = UDim2.new(r, 0, 0.5, 0) 			if onVisual then onVisual(value) end 			if not silent and onChange then task.spawn(onChange, value) end 		end 		function obj.Drag(p) 			local w = track.AbsoluteSize.X 			if w <= 0 then return end 			local prev = value 			obj.Set(minV + math.clamp((p.X - track.AbsolutePosition.X) / w, 0, 1) * (maxV - minV), true) 			if value ~= prev then 				if onChange then task.spawn(onChange, value) end 				local now = os.clock() 				if now - lastTick > 0.05 then lastTick = now playSound("Tick", 1, 0.8 + ((value - minV) / (maxV - minV)) * 0.9) end 			end 		end 		function obj.Release() tween(knob, 0.15, {Size = UDim2.fromOffset(ks, ks)}) end 		hit.InputBegan:Connect(function(i) 			if isPress(i) then 				win.ActiveDrag = obj 				tween(knob, 0.12, {Size = UDim2.fromOffset(ks + 4, ks + 4)}) 				obj.Drag(pointer(i)) 			end 		end) 		obj.Set(init, true) 		return obj 	end 	local function makeRow(section, config, reserved, baseH, extraBottom) 		extraBottom = extraBottom or 0 		local info = {h = baseH, open = 0, vc = {}} 		local row = P(make("Frame", {BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, baseH), ZIndex = 4, LayoutOrder = tonumber(config.LayoutOrder) or 0}, section.Items), 			{BackgroundColor3 = "Raised"}) 		local rs = stroke(row, COLORS.Line, 0.5, 1) 		hook(function() rs.Color = COLORS.Line end) 		row.MouseEnter:Connect(function() tween(row, 0.16, {BackgroundColor3 = COLORS.Hover}) tween(rs, 0.16, {Transparency = 0.2}) end) 		row.MouseLeave:Connect(function() tween(row, 0.18, {BackgroundColor3 = COLORS.Raised}) tween(rs, 0.18, {Transparency = 0.5}) end) 		attachTip(row, config.Tooltip or " ") 		local nameSize, descSize = 12 + BOOST, 10 + BOOST 		local nameH = nameSize + 6 		local name = T(row, tostring(config.Name or ""), nameSize, "Text", FONT_BOLD, UDim2.fromOffset(13, 8), UDim2.new(1, -(13 + reserved), 0, nameH)) 		name.TextTruncate, name.ZIndex, name.RichText = Enum.TextTruncate.AtEnd, 5, true 		local desc = T(row, "", descSize, "Muted", FONT, UDim2.fromOffset(13, 8 + nameH + 1), UDim2.new(1, -(13 + reserved), 0, 14)) 		desc.TextWrapped, desc.TextYAlignment, desc.ZIndex, desc.RichText = true, Enum.TextYAlignment.Top, 5, true 		local function placeVC(inst) 			inst.Position = UDim2.new(inst.Position.X.Scale, inst.Position.X.Offset, 0, (info.h - extraBottom) / 2) 		end 		function info.VC(inst) 			inst.AnchorPoint = Vector2.new(inst.AnchorPoint.X, 0.5) 			info.vc[#info.vc + 1] = inst 			placeVC(inst) 		end 		local function relayout() 			local textW = (info.w or ROW_W) - 13 - reserved - 10 			if desc.Text ~= "" then 				local h = math.ceil(measure(desc.Text, descSize, FONT, textW)) + 1 				name.Position, name.Size = UDim2.fromOffset(13, 8), UDim2.new(1, -(13 + reserved), 0, nameH) 				desc.Visible = true 				desc.Size = UDim2.new(1, -(13 + reserved), 0, h) 				info.h = math.max(baseH, 8 + nameH + 2 + h + 10 + extraBottom) 			else 				desc.Visible = false 				name.Position = UDim2.fromOffset(13, 0) 				name.Size = UDim2.new(1, -(13 + reserved), 0, baseH - extraBottom) 				info.h = baseH 			end 			row.Size = UDim2.new(1, 0, 0, info.h + info.open) 			for _, v in ipairs(info.vc) do placeVC(v) end 			if info.onLayout then info.onLayout() end 		end 		desc.Text = tostring(config.Description or "") 		relayout() 		row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() 			local w = row.AbsoluteSize.X / math.max(win.CurScale, 0.01) 			if math.abs(w - (info.w or ROW_W)) > 1 then info.w = w relayout() end 		end) 		function info.Resize(extra, animate) 			info.open = extra 			local goal = UDim2.new(1, 0, 0, info.h + extra) 			if animate then tween(row, 0.22, {Size = goal}) else row.Size = goal end 		end 		local rec = {row = row, title = strip(tostring(config.Name or "")), section = section, key = strip((config.Name or "") .. " " .. (config.Description or "")):lower(), hidden = false, match = true} 		info.rec = rec 		section.Rows[#section.Rows + 1] = rec 		return row, {NameLabel = name, SetTitle = function(t) name.Text = tostring(t or "") end, SetDescription = function(t) desc.Text = tostring(t or "") relayout() end, SetColor = function(c) name.TextColor3 = c end}, info 	end 	local function common(row, lab, info, extra, config) 		extra = extra or {} 		extra.Row, extra.SetTitle, extra.SetDescription = row, lab.SetTitle, lab.SetDescription 		extra.SetVisible = function(v) info.rec.hidden = not v row.Visible = v and info.rec.match end 		local blocker 		extra.SetDisabled = function(d) 			if d and not blocker then 				blocker = P(make("Frame", {BorderSizePixel = 0, BackgroundTransparency = 0.45, Size = UDim2.fromScale(1, 1), ZIndex = 30, Active = true}, row), {BackgroundColor3 = "Background"}) 			end 			if blocker then blocker.Visible = d end 		end 		extra.Destroy = function() row:Destroy() info.rec.hidden = true info.rec.match = false end 		do
			local curTitle = tostring((config and (config.Name or config.Title)) or "")
			local badge
			local function placeBadge()
				if not badge or not lab.NameLabel then return end
				local w = 0
				pcall(function() w = TextService:GetTextSize(strip(curTitle), 12 + BOOST, FONT_BOLD, Vector2.new(1000, 100)).X end)
				local nl = lab.NameLabel
				badge.Position = UDim2.fromOffset(13 + w + 8, nl.Position.Y.Offset + nl.Size.Y.Offset / 2)
			end
			if lab.NameLabel then
				lab.NameLabel:GetPropertyChangedSignal("Position"):Connect(placeBadge)
				lab.NameLabel:GetPropertyChangedSignal("Size"):Connect(placeBadge)
			end
			local baseSetTitle = extra.SetTitle
			extra.SetTitle = function(t) baseSetTitle(t) curTitle = tostring(t or "") placeBadge() end
			extra.SetBadge = function(text, color)
				if text == nil or text == "" then if badge then badge:Destroy() badge = nil end return end
				text = tostring(text)
				if not badge then
					badge = make("Frame", {Name = "VFBadge", BorderSizePixel = 0, BackgroundTransparency = 0.82, AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, ZIndex = 6}, row)
					make("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)}, badge)
					make("UIStroke", {Thickness = 1, Transparency = 0.4, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, badge)
					make("TextLabel", {Name = "T", BackgroundTransparency = 1, Font = FONT_HEAVY, TextSize = 8 + BOOST, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, ZIndex = 7}, badge)
				end
				local k = text:lower()
				local col = color
				if typeof(col) ~= "Color3" then
					if k == "beta" then col = STATUS.warn elseif k == "pro" then col = rgb(255, 205, 60) elseif k == "hot" or k == "risky" then col = STATUS.error elseif k == "safe" then col = STATUS.success else col = COLORS.Accent end
				end
				badge.BackgroundColor3 = col
				badge:FindFirstChildOfClass("UIStroke").Color = col
				badge.T.Text, badge.T.TextColor3 = string.upper(text), col
				placeBadge()
			end
			extra.SetTooltip = function(t) win._tipOv = win._tipOv or {} if t == nil then win._tipOv[row] = " " else win._tipOv[row] = tostring(t) end end
			extra.OnChanged = function(fn)
				if type(fn) ~= "function" or not config then return extra end
				local prev = config.Callback
				config.Callback = function(...) if prev then prev(...) end fn(...) end
				return extra
			end
			extra.Pulse = function() win:Highlight(extra, true) end
			extra.ScrollTo = function() win:Highlight(extra) end
			extra.Reset = function()
				local r = config and config.Flag and win.Registry[config.Flag]
				if r and r.Default ~= nil then pcall(r.Set, r.Default) end
			end
			extra.Lock = function(reason) extra.SetDisabled(true) if reason then extra.SetTooltip(reason) end end
			extra.Unlock = function() extra.SetDisabled(false) end
			extra.GetRow = function() return row end
			if config and config.Badge then extra.SetBadge(config.Badge) end
		end
		if config and config.Disabled then extra.SetDisabled(true) end
		if config and config.Flag then
			extra.CurrentValue = config.CurrentValue or config.CurrentOption or config.CurrentKeybind
			win.Elements[config.Flag] = extra
		end 		if not extra.Set then 			extra.Set = function(t) 				if type(t) == "table" then 					if t.Title or t.Name then lab.SetTitle(t.Title or t.Name) end 					if t.Content or t.Description then lab.SetDescription(t.Content or t.Description) end 				else lab.SetTitle(t) end 			end 		end 		for k, f in pairs(extra) do 			if type(f) == "function" then 				extra[k] = function(a, ...) 					if a == extra then return f(...) end 					return f(a, ...) 				end 			end 		end 		return extra 	end 	local function sectionMethods(section) 		function section:CreateLabel(config) 			local row, lab, info = makeRow(self, {Name = config.Title or config.Name or "", Description = config.Content or config.Description or ""}, 0, 40) 			local extra = {Set = function(t, _, col)
				if type(t) == "table" then
					if t.Title or t.Name then lab.SetTitle(t.Title or t.Name) end
					if t.Content or t.Description then lab.SetDescription(t.Content or t.Description) end
					col = col or t.Color
				elseif t ~= nil then lab.SetTitle(t) end
				if col then lab.SetColor(col) end
			end}
			if config.Color then lab.SetColor(config.Color) end
			return common(row, lab, info, extra, config) 		end 		section.CreateParagraph = section.CreateLabel 		function section:CreateDivider() 			local d = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 8), ZIndex = 4}, self.Items) 			local ln = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4}, d), {BackgroundColor3 = "Line"}) 			return {Row = d, SetVisible = function(v) d.Visible = v end, Destroy = function() d:Destroy() end} 		end 		function section:CreateButton(config) 			local bw, bh = COMPACT and 84 or 84, COMPACT and 34 or 28 			local row, lab, info = makeRow(self, config, bw + 24, 48) 			local btn = B(row, config.ButtonText or "RUN", UDim2.new(1, -(bw + 14), 0, 0), UDim2.fromOffset(bw, bh), "Soft") 			btn.TextSize, btn.ClipsDescendants, btn.ZIndex = COMPACT and 12 or 10, true, 5 			info.VC(btn) 			local bs = stroke(btn, COLORS.Accent, 0.7, 1) 			hook(function() bs.Color = COLORS.Accent end) 			hover(btn) 			btn.MouseEnter:Connect(function() tween(bs, 0.15, {Transparency = 0.2}) end) 			btn.MouseLeave:Connect(function() tween(bs, 0.2, {Transparency = 0.7}) end) 			local armed, original = false, btn.Text 			btn.MouseButton1Click:Connect(function() 				if config.Confirm and not armed then 					armed = true 					btn.Text = "SURE?" 					task.delay(2, function() if armed then armed = false btn.Text = original end end) 					return 				end 				armed, btn.Text = false, original 				playSound("Click") 				ripple(btn) 				tween(btn, 0.12, {BackgroundColor3 = COLORS.Accent, TextColor3 = COLORS.Background}) 				task.delay(0.14, function() if btn.Parent then tween(btn, 0.2, {BackgroundColor3 = COLORS.Soft, TextColor3 = COLORS.Text}) end end) 				if config.Callback then task.spawn(config.Callback) end 			end) 			return common(row, lab, info, {Button = btn, SetText = function(t) original = t btn.Text = t end, Fire = function() if config.Callback then task.spawn(config.Callback) end end}, config) 		end 		function section:CreateToggle(config) 			local sw, sh = COMPACT and 50 or 40, COMPACT and 26 or 20 			local row, lab, info = makeRow(self, config, sw + 24 + (config.Bindable and 56 or 0), 52) 			local switch = P(make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true, Text = "", 				Position = UDim2.new(1, -(sw + 14), 0, 0), Size = UDim2.fromOffset(sw, sh), ZIndex = 5}, row), {BackgroundColor3 = "Panel"}) 			info.VC(switch) 			local sws = stroke(switch, COLORS.Line, 0.3, 1) 			local knob = make("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(sh - 6, sh - 6), ZIndex = 6}, switch) 			local enabled = config.CurrentValue == true 			local function colors(anim) 				local bgc = enabled and COLORS.Soft or COLORS.Panel 				local sc = enabled and COLORS.Bright or COLORS.Line 				local kc = enabled and COLORS.Bright or COLORS.Muted 				local st = enabled and 0.1 or 0.3 				if anim then 					tween(switch, 0.2, {BackgroundColor3 = bgc}) tween(sws, 0.2, {Color = sc, Transparency = st}) tween(knob, 0.2, {BackgroundColor3 = kc}) 				else 					switch.BackgroundColor3, sws.Color, sws.Transparency, knob.BackgroundColor3 = bgc, sc, st, kc 				end 			end 			local function place(anim) 				local p = enabled and UDim2.fromOffset(sw - sh + 3, 3) or UDim2.fromOffset(3, 3) 				if anim then tween(knob, 0.22, {Position = p}, Enum.EasingStyle.Back) else knob.Position = p end 			end 			local function set(v, silent) 				enabled = v == true 				colors(true) place(true) 				if not silent then 					playSound(enabled and "ToggleOn" or "ToggleOff") 					ripple(switch) 					emit(config, enabled) 				end 			end 			colors(false) place(false) 			hook(function() colors(false) end) 			switch.MouseButton1Click:Connect(function() set(not enabled, false) end) 			hover(switch) 			local extra = {Set = set, Get = function() return enabled end} 			if config.Bindable then 				local bind = config.CurrentBind 				if typeof(bind) == "string" then local ok, k = pcall(function() return Enum.KeyCode[bind] end) bind = ok and k or nil end 				local chip = T(row, "", 9 + BOOST, "Muted", FONT_BOLD, UDim2.new(1, -(sw + 74), 0, 0), UDim2.fromOffset(56, 16)) 				chip.ZIndex, chip.TextXAlignment = 5, Enum.TextXAlignment.Right 				info.VC(chip) 				local function showBind() chip.Text = bind and ("[" .. bind.Name .. "]") or "" end 				showBind() 				table.insert(win.Keybinds, {Value = function() return bind end, Callback = function() set(not enabled, false) end}) 				table.insert(win.Binds, {Name = strip(config.Name), Key = function() return bind end, Active = function() return enabled end}) 				local function setBind(k) 					if typeof(k) == "string" then local ok, kk = pcall(function() return Enum.KeyCode[k] end) k = ok and kk or nil end 					bind = k 					showBind() 				end 				switch.MouseButton2Click:Connect(function() 					playSound("Click") 					chip.Text = "[...]" 					win.WaitingKey = function(k) setBind(k) if config.OnBind then task.spawn(config.OnBind, k and k.Name or nil) end end 				end) 				if config.Flag then 					win.Registry[config.Flag .. "_bind"] = {kind = "keybind", Get = function() return bind end, Set = setBind} 				end 				extra.SetBind, extra.GetBind = setBind, function() return bind end 			end 			register(config, "toggle", function() return enabled end, function(v) set(v, false) end) 			return common(row, lab, info, extra, config) 		end 		function section:CreateSlider(config) 			local row, lab, info = makeRow(self, config, COMPACT and 90 or 110, COMPACT and 80 or 70, COMPACT and 38 or 26) 			local minV, maxV = config.Range[1], config.Range[2] 			local vb = P(make("TextBox", {BackgroundTransparency = 1, ClearTextOnFocus = true, Font = FONT_BOLD, TextSize = 11 + BOOST, TextXAlignment = Enum.TextXAlignment.Right, 				Position = UDim2.new(1, -113, 0, 7), Size = UDim2.fromOffset(100, 20), ZIndex = 5, Text = ""}, row), {TextColor3 = "Bright"}) 			local core 			core = sliderCore(row, UDim2.new(0, 13, 1, COMPACT and -26 or -21), UDim2.new(1, -26, 0, COMPACT and 8 or 6), 				minV, maxV, (config.Increment and config.Increment > 0) and config.Increment or 1, 				math.clamp(config.CurrentValue or minV, minV, maxV), function(v) emit(config, v) end, 				function(v) vb.Text = tostring(v) .. (config.Suffix or "") end, 5) 			vb.FocusLost:Connect(function() 				local n = tonumber((vb.Text:gsub("[^%d%.%-]", ""))) 				if n then core.Set(n, false) else core.Set(core.Get(), true) end 			end) 			register(config, "slider", core.Get, function(v) if type(v) == "number" then core.Set(v, false) end end) 			return common(row, lab, info, {Set = function(v, s) core.Set(v, s) end, Get = core.Get}, config) 		end 		function section:CreateProgressBar(config) 			local row, lab, info = makeRow(self, config, 90, 60, 20) 			local vl = T(row, "", 10 + BOOST, "Bright", FONT_BOLD, UDim2.new(1, -103, 0, 7), UDim2.fromOffset(90, 20)) 			vl.ZIndex, vl.TextXAlignment = 5, Enum.TextXAlignment.Right 			local track = P(make("Frame", {BorderSizePixel = 0, Position = UDim2.new(0, 13, 1, -18), Size = UDim2.new(1, -26, 0, 6), ZIndex = 5}, row), {BackgroundColor3 = "Panel"}) 			local fill = P(make("Frame", {BorderSizePixel = 0, Size = UDim2.fromScale(0, 1), ZIndex = 6}, track), {BackgroundColor3 = "Accent"}) 			local value = 0 			local function set(v, text) 				value = math.clamp(v or 0, 0, 1) 				tween(fill, 0.2, {Size = UDim2.fromScale(value, 1)}) 				vl.Text = text or (math.floor(value * 100 + 0.5) .. "%") 			end 			set(config.CurrentValue or 0) 			return common(row, lab, info, {Set = set, Get = function() return value end}, config) 		end 		function section:CreateDropdown(config) 			local mw, mh = COMPACT and 120 or 150, COMPACT and 34 or 28 			local row, lab, info = makeRow(self, config, mw + 28, 54) 			local multi = config.Multi == true 			local options = {} 			for _, o in ipairs(config.Options or {}) do options[#options + 1] = tostring(o) end 			local selected = {} 			local function setFrom(v) 				selected = {} 				if type(v) == "table" then for _, x in ipairs(v) do selected[tostring(x)] = true end 				elseif v ~= nil and v ~= "" then selected[tostring(v)] = true end 			end 			setFrom(config.CurrentOption or ((not multi) and options[1]) or nil) 			local function getValue() 				if multi then 					local t = {} 					for _, o in ipairs(options) do if selected[o] then t[#t + 1] = o end end 					return t 				end 				for _, o in ipairs(options) do if selected[o] then return o end end 			end 			local sel = B(row, "", UDim2.new(1, -(mw + 14), 0, 0), UDim2.fromOffset(mw, mh), "Panel") 			sel.ZIndex, sel.ClipsDescendants = 5, true 			info.VC(sel) 			stroke(sel, COLORS.Line, 0.2, 1) 			hover(sel) 			local st = T(sel, "", 10 + BOOST * 2, "Text", FONT_BOLD, UDim2.fromOffset(10, 0), UDim2.new(1, -32, 1, 0))
			st.ZIndex, st.TextTruncate = 6, Enum.TextTruncate.AtEnd
			local arrow = makeIcon(sel, "down", 10, "Muted", 6)
			arrow.Frame.Position = UDim2.new(1, -14, 0.5, 0) 			local OPT_H = COMPACT and 34 or 26 			local searchable = config.Searchable ~= false and #options > 7 			local SB = searchable and (OPT_H + 4) or 0 			local panel = make("Frame", {BackgroundTransparency = 1, Visible = false, ZIndex = 6, Size = UDim2.new(1, -16, 0, 0), ClipsDescendants = true}, row) 			local sbox 			if searchable then 				sbox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT, PlaceholderText = "Filter...", Text = "", TextSize = 10 + BOOST, 					TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, OPT_H), ZIndex = 7}, panel), {BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"}) 				make("UIPadding", {PaddingLeft = UDim.new(0, 8)}, sbox) 				stroke(sbox, COLORS.Line, 0.3, 1) 			end 			local lst = P(make("ScrollingFrame", {BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, 				Position = UDim2.fromOffset(0, SB), Size = UDim2.new(1, 0, 1, -SB), ZIndex = 7}, panel), {BackgroundColor3 = "Panel"}) 			stroke(lst, COLORS.Line, 0.3, 1) 			list(lst, 2) 			local isOpen, buttons, checks = false, {}, {} 			local function setText() 				local v = getValue() 				local txt 				if multi then txt = #v == 0 and "None" or (#v <= 2 and table.concat(v, ", ") or (#v .. " selected")) 				else txt = v or "None" end 				st.Text = txt
				tween(arrow.Frame, 0.18, {Rotation = isOpen and 180 or 0}) 			end 			local function paintOpts() 				for o, b in pairs(buttons) do 					local on = selected[o] == true 					b.Text = o
					local ck = checks[o]
					if ck then ck.fill.Visible = on ck.stroke.Color = on and COLORS.Bright or COLORS.Line end 					b.BackgroundTransparency = on and 0.35 or 1 					b.BackgroundColor3 = COLORS.Soft 					b.TextColor3 = on and COLORS.Bright or COLORS.Text 				end 			end 			local function listH() 				local vis = 0 				for _, b in pairs(buttons) do if b.Visible then vis += 1 end end 				return math.min(math.max(vis, 1) * (OPT_H + 2) + 4, 150) 			end 			local function openH() return SB + listH() end 			info.onLayout = function() panel.Position = UDim2.fromOffset(8, info.h) end 			local function close() 				if not isOpen then return end 				isOpen = false 				setText() 				info.Resize(0, true) 				tween(panel, 0.15, {Size = UDim2.new(1, -16, 0, 0)}) 				task.delay(0.16, function() if not isOpen then panel.Visible = false end end) 			end 			local function open() 				isOpen = true 				setText() 				panel.Position = UDim2.fromOffset(8, info.h) 				panel.Visible = true 				tween(panel, 0.2, {Size = UDim2.new(1, -16, 0, openH())}) 				info.Resize(openH() + 8, true) 			end 			local function fire() 				local v = getValue() 				if config.CompatTable and not multi then v = v and {v} or {} end 				emit(config, v) 			end 			local function choose(o) 				if multi then 					selected[o] = not selected[o] or nil 					paintOpts() setText() fire() 				else 					selected = {[o] = true} 					paintOpts() close() setText() fire() 				end 				playSound("Click") 			end 			local function rebuild() 				for _, c in ipairs(lst:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end 				buttons, checks = {}, {}
				for i, o in ipairs(options) do 					local b = B(lst, o, nil, UDim2.new(1, -4, 0, OPT_H)) 					b.LayoutOrder, b.ZIndex = i, 8 					b.TextXAlignment, b.TextSize = Enum.TextXAlignment.Left, 10 + BOOST * 2 					make("UIPadding", {PaddingLeft = UDim.new(0, multi and 28 or 8)}, b)
					if multi then
						local boxf = make("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -20, 0.5, 0), Size = UDim2.fromOffset(12, 12), ZIndex = 9}, b)
						local bst = stroke(boxf, COLORS.Line, 0, 1)
						local fillf = make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(6, 6), BackgroundColor3 = COLORS.Bright, ZIndex = 10}, boxf)
						checks[o] = {fill = fillf, stroke = bst}
					end 					b.MouseButton1Click:Connect(function() choose(o) end) 					buttons[o] = b 				end 				paintOpts() 			end 			if sbox then 				sbox:GetPropertyChangedSignal("Text"):Connect(function() 					local q = sbox.Text:lower() 					for o, b in pairs(buttons) do b.Visible = q == "" or o:lower():find(q, 1, true) ~= nil end 					if isOpen then 						tween(panel, 0.12, {Size = UDim2.new(1, -16, 0, openH())}) 						info.Resize(openH() + 8, true) 					end 				end) 			end 			rebuild() setText() 			sel.MouseButton1Click:Connect(function() 				playSound(isOpen and "Collapse" or "Expand") 				ripple(sel) 				if isOpen then close() else open() end 			end) 			local function set(v, silent) 				setFrom(v) paintOpts() setText() 				if not silent then fire() end 			end 			register(config, "dropdown", getValue, function(v) set(v, false) end) 			return common(row, lab, info, {Set = set, Get = getValue, Refresh = function(n, keep) 				options = {} 				for _, o in ipairs(n or {}) do options[#options + 1] = tostring(o) end 				if not keep then selected = {} end 				rebuild() setText() 			end}, config) 		end 		function section:CreateInput(config) 			local bw, bh = COMPACT and 130 or 160, COMPACT and 34 or 28 			local row, lab, info = makeRow(self, config, bw + 28, 54) 			local box = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = config.ClearOnFocus == true, Font = FONT, PlaceholderText = config.PlaceholderText or "Enter text", 				Position = UDim2.new(1, -(bw + 14), 0, 0), Size = UDim2.fromOffset(bw, bh), Text = tostring(config.CurrentValue or ""), TextSize = 10 + BOOST * 2, 				TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5}, row), {BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"}) 			info.VC(box) 			make("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 8)}, box) 			local bs = stroke(box, COLORS.Line, 0.2, 1) 			local last = box.Text 			box.Focused:Connect(function() tween(bs, 0.15, {Color = COLORS.Accent}) end) 			box.FocusLost:Connect(function(enter) 				tween(bs, 0.2, {Color = COLORS.Line}) 				if config.Numeric and box.Text ~= "" and tonumber(box.Text) == nil then box.Text = last return end 				last = box.Text 				if config.Flag then win.Flags[config.Flag] = box.Text end 				if win.AutoSave then win:QueueSave() end 				if config.Callback then task.spawn(config.Callback, config.Numeric and tonumber(box.Text) or box.Text, enter) end 				if config.ClearAfter then box.Text = "" last = "" end 			end) 			register(config, "input", function() return box.Text end, function(v) box.Text = tostring(v or "") last = box.Text emit(config, box.Text) end) 			return common(row, lab, info, {Set = function(v) box.Text = tostring(v or "") last = box.Text end, Get = function() return box.Text end}, config) 		end 		function section:CreateKeybind(config) 			local kw, kh = COMPACT and 84 or 80, COMPACT and 34 or 26 			local row, lab, info = makeRow(self, config, kw + 28, 54) 			local btn = B(row, "", UDim2.new(1, -(kw + 14), 0, 0), UDim2.fromOffset(kw, kh), "Panel") 			btn.TextSize, btn.ZIndex = 10 + BOOST, 5 			info.VC(btn) 			stroke(btn, COLORS.Line, 0.2, 1) 			hover(btn) 			local keyCode = config.CurrentKeybind 			if typeof(keyCode) == "string" then local ok, k = pcall(function() return Enum.KeyCode[keyCode] end) keyCode = ok and k or nil end 			keyCode = keyCode or config.Default 			local held = false 			local function update(k, silent) 				if typeof(k) == "string" then local ok, kk = pcall(function() return Enum.KeyCode[k] end) k = ok and kk or nil end 				if k then 					keyCode = k 					if not silent then 						if config.OnSet then task.spawn(config.OnSet, k) end 						emit({Flag = config.Flag}, k) 						playSound("Success", 0.8) 					end 				end 				btn.Text = keyCode and keyCode.Name or "NONE" 			end 			update(keyCode, true) 			local hold = config.Mode == "Hold" 			if config.Callback then 				table.insert(win.Keybinds, {Value = function() return keyCode end, 					Callback = function() held = true config.Callback(hold and true or keyCode) end, 					Release = hold and function() held = false config.Callback(false) end or nil}) 			end 			table.insert(win.Binds, {Name = strip(config.Name), Key = function() return keyCode end, Active = function() return held end}) 			btn.MouseButton1Click:Connect(function() 				playSound("Click") 				ripple(btn) 				btn.Text = "..." 				win.WaitingKey = function(k) if k then update(k) else btn.Text = keyCode and keyCode.Name or "NONE" end end 			end) 			register({Flag = config.Flag, IgnoreConfig = config.IgnoreConfig}, "keybind", function() return keyCode end, function(v) update(v, false) end) 			return common(row, lab, info, {Set = update, Get = function() return keyCode end}, config) 		end 		function section:CreateColorPicker(config) 			local row, lab, info = makeRow(self, config, 74, 54) 			local color = config.CurrentValue or Color3.new(1, 1, 1) 			local h, s, v = color:ToHSV() 			local swW, swH = COMPACT and 52 or 44, COMPACT and 28 or 22 			local swatch = make("TextButton", {AutoButtonColor = false, BackgroundColor3 = color, BorderSizePixel = 0, Text = "", Position = UDim2.new(1, -(swW + 14), 0, 0), 				Size = UDim2.fromOffset(swW, swH), ZIndex = 5}, row) 			info.VC(swatch) 			local sws = stroke(swatch, COLORS.Bright, 0.3, 1) 			hook(function() sws.Color = COLORS.Bright end) 			hover(swatch) 			local SQ_H, sz = COMPACT and 110 or 96, COMPACT and 26 or 22 			local EXTRA = 4 + SQ_H + 8 + 14 + 8 + 28 + 8 + sz + 12 			local panel = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, EXTRA), Visible = false, ZIndex = 5}, row) 			info.onLayout = function() panel.Position = UDim2.fromOffset(0, info.h) end 			panel.Position = UDim2.fromOffset(0, info.h) 			local sv = make("Frame", {BackgroundColor3 = Color3.fromHSV(h, 1, 1), BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(13, 4), Size = UDim2.new(1, -26, 0, SQ_H), ZIndex = 6}, panel) 			local white = make("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 7}, sv) 			make("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})}, white) 			local black = make("Frame", {BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 8}, sv) 			make("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})}, black) 			local cur = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Size = UDim2.fromOffset(12, 12), ZIndex = 9}, sv) 			stroke(cur, Color3.new(1, 1, 1), 0, 2) 			local hb = make("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Position = UDim2.fromOffset(13, 4 + SQ_H + 8), Size = UDim2.new(1, -26, 0, 14), ZIndex = 6}, panel) 			local seq = {} 			for i = 0, 6 do seq[#seq + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)) end 			make("UIGradient", {Color = ColorSequence.new(seq)}, hb) 			local hcur = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.fromOffset(5, 20), ZIndex = 9}, hb) 			stroke(hcur, Color3.new(0, 0, 0), 0.2, 1) 			local hexY = 4 + SQ_H + 8 + 14 + 8 			local hexBox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT_BOLD, TextSize = 11, Text = "", PlaceholderText = "#RRGGBB", 				Position = UDim2.fromOffset(13, hexY), Size = UDim2.new(1, -100, 0, 28), ZIndex = 6}, panel), {BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"}) 			stroke(hexBox, COLORS.Line, 0.2, 1) 			local rainBtn = B(panel, "RGB: OFF", UDim2.new(1, -83, 0, hexY), UDim2.fromOffset(70, 28), "Panel") 			rainBtn.TextSize, rainBtn.ZIndex = 9, 6 			local function visuals() 				color = Color3.fromHSV(h, s, v) 				swatch.BackgroundColor3 = color 				sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1) 				cur.Position = UDim2.fromScale(s, 1 - v) 				hcur.Position = UDim2.new(h, 0, 0.5, 0) 				if not hexBox:IsFocused() then hexBox.Text = ("#%02X%02X%02X"):format(math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5)) end 			end 			local function fire() emit(config, color) end 			visuals() 			local function dragger(frame, fn) 				frame.InputBegan:Connect(function(i) 					if not isPress(i) then return end 					local function drag(p) 						local ap, as = frame.AbsolutePosition, frame.AbsoluteSize 						if as.X <= 0 then return end 						fn((p.X - ap.X) / as.X, (p.Y - ap.Y) / as.Y) 						visuals() fire() 					end 					win.ActiveDrag = {Drag = drag} 					drag(pointer(i)) 				end) 			end 			dragger(sv, function(x, y) s, v = math.clamp(x, 0, 1), 1 - math.clamp(y, 0, 1) end) 			dragger(hb, function(x) h = math.clamp(x, 0, 1) end) 			local function setColor(c, silent) 				h, s, v = c:ToHSV() 				visuals() 				if not silent then fire() end 			end 			hexBox.FocusLost:Connect(function() 				local t = hexBox.Text:gsub("#", "") 				if #t == 6 and tonumber(t, 16) then 					local n = tonumber(t, 16) 					setColor(Color3.fromRGB(math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256), false) 				else visuals() end 			end) 			local rainbow = false 			rainBtn.MouseButton1Click:Connect(function() 				playSound("Click") 				rainbow = not rainbow 				rainBtn.Text = rainbow and "RGB: ON" or "RGB: OFF" 				if rainbow then 					task.spawn(function() 						while rainbow and not win.Destroyed do 							h = (os.clock() * 0.25) % 1 							if s < 0.5 then s = 1 end 							if v < 0.5 then v = 1 end 							visuals() fire() 							task.wait(0.08) 						end 					end) 				end 			end) 			for i, p in ipairs(PRESETS) do 				local b = make("TextButton", {AutoButtonColor = false, BackgroundColor3 = p, BorderSizePixel = 0, Text = "", Position = UDim2.fromOffset(13 + (i - 1) * (sz + 6), hexY + 28 + 8), Size = UDim2.fromOffset(sz, sz), ZIndex = 6}, panel) 				local ps = stroke(b, COLORS.Line, 0.2, 1) 				b.MouseEnter:Connect(function() tween(ps, 0.1, {Color = COLORS.Bright, Transparency = 0}) end) 				b.MouseLeave:Connect(function() tween(ps, 0.15, {Color = COLORS.Line, Transparency = 0.2}) end) 				b.MouseButton1Click:Connect(function() playSound("Click", 0.7) rainbow = false rainBtn.Text = "RGB: OFF" setColor(p, false) end) 			end 			local isOpen = false 			swatch.MouseButton1Click:Connect(function() 				playSound(isOpen and "Collapse" or "Expand") 				ripple(swatch) 				isOpen = not isOpen 				panel.Position = UDim2.fromOffset(0, info.h) 				if isOpen then panel.Visible = true info.Resize(EXTRA, true) 				else info.Resize(0, true) task.delay(0.22, function() if not isOpen then panel.Visible = false end end) end 			end) 			register(config, "color", function() return color end, function(c) if typeof(c) == "Color3" then setColor(c, false) end end) 			return common(row, lab, info, {Set = setColor, Get = function() return color end}, config) 		end 		function section:CreateSegmented(config) 			local row, lab, info = makeRow(self, config, 0, 70, 38) 			local options = {} 			for _, o in ipairs(config.Options or {}) do options[#options + 1] = tostring(o) end 			local current = tostring(config.CurrentOption or options[1] or "") 			local holder = make("Frame", {BackgroundTransparency = 1, Position = UDim2.new(0, 13, 1, -34), Size = UDim2.new(1, -26, 0, 26), ZIndex = 5}, row) 			make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, holder) 			local btns, n = {}, math.max(#options, 1) 			local function paint() 				for o, b in pairs(btns) do 					local on = o == current 					b.BackgroundColor3 = on and COLORS.Soft or COLORS.Panel 					b.TextColor3 = on and COLORS.Bright or COLORS.Muted 				end 			end 			local function set(o, silent) 				o = tostring(o) 				if not btns[o] then return end 				current = o 				paint() 				if not silent then playSound("Click", 0.8) emit(config, current) end 			end 			for i, o in ipairs(options) do 				local b = B(holder, o, nil, UDim2.new(1 / n, -4 * (n - 1) / n, 1, 0), "Panel") 				b.LayoutOrder, b.ZIndex, b.TextSize = i, 6, 10 + BOOST 				stroke(b, COLORS.Line, 0.3, 1) 				b.MouseButton1Click:Connect(function() ripple(b) set(o, false) end) 				btns[o] = b 			end 			hook(paint) 			register(config, "segmented", function() return current end, function(v) set(v, false) end) 			return common(row, lab, info, {Set = set, Get = function() return current end}, config) 		end 		function section:CreateRangeSlider(config) 			local row, lab, info = makeRow(self, config, COMPACT and 130 or 150, COMPACT and 80 or 70, COMPACT and 38 or 26) 			local minV, maxV = config.Range[1], config.Range[2] 			local inc = (config.Increment and config.Increment > 0) and config.Increment or 1 			local cv = config.CurrentValue or {} 			local lo, hi = cv[1] or minV, cv[2] or maxV 			local vl = T(row, "", 10 + BOOST, "Bright", FONT_BOLD, UDim2.new(1, -153, 0, 7), UDim2.fromOffset(140, 20)) 			vl.ZIndex, vl.TextXAlignment = 5, Enum.TextXAlignment.Right 			local track = P(make("Frame", {BorderSizePixel = 0, Position = UDim2.new(0, 13, 1, COMPACT and -26 or -21), Size = UDim2.new(1, -26, 0, COMPACT and 8 or 6), ZIndex = 5}, row), {BackgroundColor3 = "Panel"}) 			stroke(track, COLORS.Line, 0.5, 1) 			local fill = P(make("Frame", {BorderSizePixel = 0, ZIndex = 6}, track), {BackgroundColor3 = "Accent"}) 			local ks = COMPACT and 20 or 12 			local function knob() 				local k = P(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Size = UDim2.fromOffset(ks, ks), ZIndex = 7}, track), {BackgroundColor3 = "Text"}) 				local st = stroke(k, COLORS.Accent, 0, 2) 				hook(function() st.Color = COLORS.Accent end) 				return k 			end 			local k1, k2 = knob(), knob() 			local hit = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), 				Size = UDim2.new(1, 0, 0, COMPACT and 40 or 24), Text = "", ZIndex = 8}, track) 			local function snap(n) 				local sn = minV + math.floor(((n - minV) / inc) + 0.5) * inc 				return tonumber(string.format("%.10g", math.clamp(sn, minV, maxV))) 			end 			local function visual() 				local r1, r2 = (lo - minV) / (maxV - minV), (hi - minV) / (maxV - minV) 				fill.Position, fill.Size = UDim2.new(r1, 0, 0, 0), UDim2.new(r2 - r1, 0, 1, 0) 				k1.Position, k2.Position = UDim2.new(r1, 0, 0.5, 0), UDim2.new(r2, 0, 0.5, 0) 				vl.Text = tostring(lo) .. " - " .. tostring(hi) .. (config.Suffix or "") 			end 			local function set(l, h2, silent) 				l, h2 = snap(l), snap(h2) 				if l > h2 then l, h2 = h2, l end 				lo, hi = l, h2 				visual() 				if not silent then emit(config, {lo, hi}) end 			end 			local active 			hit.InputBegan:Connect(function(i) 				if not isPress(i) then return end 				active = nil 				local function drag(p) 					local w = track.AbsoluteSize.X 					if w <= 0 then return end 					local v = snap(minV + math.clamp((p.X - track.AbsolutePosition.X) / w, 0, 1) * (maxV - minV)) 					if not active then active = math.abs(v - lo) <= math.abs(v - hi) and 1 or 2 end 					local pl, ph = lo, hi 					if active == 1 then lo = math.min(v, hi) else hi = math.max(v, lo) end 					if lo ~= pl or hi ~= ph then visual() emit(config, {lo, hi}) end 				end 				win.ActiveDrag = {Drag = drag} 				drag(pointer(i)) 			end) 			visual() 			register(config, "range", function() return {lo, hi} end, function(v) if type(v) == "table" and v[1] and v[2] then set(v[1], v[2], false) end end) 			return common(row, lab, info, {Set = function(t, silent) if type(t) == "table" then set(t[1], t[2], silent) end end, Get = function() return {lo, hi} end}, config) 		end 		function section:CreateConsole(config) 			local H = config.Height or 130 			local maxLines = config.MaxLines or 200 			local row, lab, info = makeRow(self, config, 0, 40) 			local box = P(make("ScrollingFrame", {BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, 				Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row), {BackgroundColor3 = "Panel"}) 			stroke(box, COLORS.Line, 0.4, 1) 			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1)}, box) 			make("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4)}, box) 			info.onLayout = function() box.Position = UDim2.fromOffset(13, info.h - 2) end 			info.Resize(H + 10, false) 			box.Position = UDim2.fromOffset(13, info.h - 2) 			local n = 0 			local KC = {info = COLORS.Text, success = STATUS.success, warn = STATUS.warn, error = STATUS.error} 			local obj = {} 			function obj.Log(text, kind) 				n += 1 				local stamp = config.Timestamps == false and "" or os.date("[%H:%M:%S] ") 				local l = make("TextLabel", {BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 10 + BOOST, TextWrapped = true, RichText = false, LayoutOrder = n, 					TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = KC[kind or "info"] or COLORS.Text, Text = stamp .. tostring(text), 					Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 6}, box) 				local kids = {} 				for _, c in ipairs(box:GetChildren()) do if c:IsA("TextLabel") then kids[#kids + 1] = c end end 				if #kids > maxLines then table.sort(kids, function(a, b) return a.LayoutOrder < b.LayoutOrder end) kids[1]:Destroy() end 				task.defer(function() box.CanvasPosition = Vector2.new(0, 1e6) end) 			end 			function obj.Clear() for _, c in ipairs(box:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end end 			return common(row, lab, info, obj, config) 		end 		function section:CreateImage(config) 			local H = config.Height or 120 			local row, lab, info = makeRow(self, config, 0, 40) 			local function asset(a) 				a = tostring(a or "") 				return a:match("^%d+$") and ("rbxassetid://" .. a) or a 			end 			local img = make("ImageLabel", {BackgroundTransparency = 1, BorderSizePixel = 0, Image = asset(config.Image), ScaleType = config.ScaleType or Enum.ScaleType.Fit, 				Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row) 			info.onLayout = function() img.Position = UDim2.fromOffset(13, info.h - 2) end 			info.Resize(H + 10, false) 			img.Position = UDim2.fromOffset(13, info.h - 2) 			return common(row, lab, info, {Set = function(a) img.Image = asset(a) end, Get = function() return img.Image end}, config) 		end 		function section:CreateIconGallery(config)
			local names = config.Icons or VField:GetIcons()
			local cell, gap = config.CellSize or 56, 6
			local row, lab, info = makeRow(self, config, 0, 40)
			local grid = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -26, 0, 0), ZIndex = 5}, row)
			make("UIGridLayout", {CellSize = UDim2.fromOffset(cell, cell), CellPadding = UDim2.fromOffset(gap, gap), SortOrder = Enum.SortOrder.LayoutOrder}, grid)
			for i, n in ipairs(names) do
				local b = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Text = "", LayoutOrder = i, ZIndex = 6}, grid)
				P(b, {BackgroundColor3 = "Panel"})
				local bs = stroke(b, COLORS.Line, 0.5, 1)
				hook(function() bs.Color = COLORS.Line end)
				local ic = makeIcon(b, n, math.floor(cell * 0.4), "Muted", 7)
				ic.Frame.Position = UDim2.new(0.5, 0, 0.4, 0)
				local nl = T(b, n, 8 + BOOST, "Muted", FONT, UDim2.new(0, 0, 1, -15), UDim2.new(1, 0, 0, 12))
				nl.TextXAlignment, nl.TextTruncate, nl.ZIndex = Enum.TextXAlignment.Center, Enum.TextTruncate.AtEnd, 7
				b.MouseEnter:Connect(function() tween(b, 0.12, {BackgroundColor3 = COLORS.Hover}) ic.Tint(COLORS.Bright) tween(nl, 0.12, {TextColor3 = COLORS.Text}) end)
				b.MouseLeave:Connect(function() tween(b, 0.15, {BackgroundColor3 = COLORS.Panel}) ic.Tint(COLORS.Muted) tween(nl, 0.15, {TextColor3 = COLORS.Muted}) end)
				b.MouseButton1Click:Connect(function()
					playSound("Click")
					local ok = pcall(function() setclipboard(n) end)
					win:Notify({Title = "Icon", Content = ok and ("Copied '" .. n .. "' to your clipboard.") or ("Icon name: " .. n), Kind = "info", Duration = 2})
					if config.Callback then task.spawn(config.Callback, n) end
				end)
			end
			local function fit()
				local width = (info.w or ROW_W) - 26
				local cols = math.max(1, math.floor((width + gap) / (cell + gap)))
				local rows = math.max(1, math.ceil(#names / cols))
				local h = rows * (cell + gap) - gap
				grid.Size = UDim2.new(1, -26, 0, h)
				grid.Position = UDim2.fromOffset(13, info.h - 2)
				if info.open ~= h + 10 then info.Resize(h + 10, false) end
			end
			info.onLayout = fit
			fit()
			return common(row, lab, info, {Set = function() end, Get = function() return #names end}, config)
		end
		function section:CreateLink(config) 			local c = {} 			for k, v in pairs(config) do c[k] = v end 			c.ButtonText = c.ButtonText or "COPY" 			local cb = config.Callback 			c.Callback = function() 				local ok = pcall(function() setclipboard(config.Link or "") end) 				win:Notify({Title = config.Name or "Link", Content = ok and "Copied to clipboard." or tostring(config.Link or ""), Kind = ok and "success" or "info"}) 				if cb then cb() end 			end 			return self:CreateButton(c) 		end 		-- ============================================================
		-- V FIELD ULTIMATE: extra elements
		-- ============================================================
		local function vfStroke(inst, key, tr)
			local s = stroke(inst, COLORS[key], tr, 1)
			hook(function() s.Color = COLORS[key] end)
			return s
		end
		local function vfOptions(list)
			local out = {}
			for _, o in ipairs(list or {}) do out[#out + 1] = tostring(o) end
			return out
		end
		local function vfAsColor(c)
			if typeof(c) == "Color3" then return c end
			return rgb(255, 255, 255)
		end

		function section:CreateStepper(config)
			local rng = config.Range or {config.Min or 0, config.Max or 100}
			local minV, maxV = rng[1], rng[2]
			local inc = (config.Increment and config.Increment > 0) and config.Increment or 1
			local bh = COMPACT and 34 or 28
			local bw = COMPACT and 150 or 130
			local row, lab, info = makeRow(self, config, bw + 28, 54)
			local holder = make("Frame", {BackgroundTransparency = 1, Position = UDim2.new(1, -(bw + 14), 0, 0), Size = UDim2.fromOffset(bw, bh), ZIndex = 5}, row)
			info.VC(holder)
			local minus = B(holder, "-", UDim2.new(), UDim2.fromOffset(bh, bh), "Panel")
			local plus = B(holder, "+", UDim2.new(1, -bh, 0, 0), UDim2.fromOffset(bh, bh), "Panel")
			minus.ZIndex, plus.ZIndex = 6, 6
			minus.TextSize, plus.TextSize = 14 + BOOST, 14 + BOOST
			vfStroke(minus, "Line", 0.2)
			vfStroke(plus, "Line", 0.2)
			local box = P(make("TextBox", {BackgroundTransparency = 1, Font = FONT_BOLD, TextSize = 11 + BOOST, ClearTextOnFocus = false, Text = "",
				Position = UDim2.fromOffset(bh, 0), Size = UDim2.new(1, -bh * 2, 1, 0), ZIndex = 6}, holder), {TextColor3 = "Bright"})
			local value = math.clamp(tonumber(config.CurrentValue) or minV, minV, maxV)
			local function snap(n)
				n = minV + math.floor(((n - minV) / inc) + 0.5) * inc
				return tonumber(string.format("%.10g", math.clamp(n, minV, maxV)))
			end
			local function show() box.Text = tostring(value) .. (config.Suffix or "") end
			local function set(n, silent)
				n = tonumber(n)
				if not n then show() return end
				value = snap(n)
				show()
				if not silent then emit(config, value) end
			end
			value = snap(value)
			show()
			box.FocusLost:Connect(function()
				local n = tonumber((box.Text:gsub("[^%d%.%-]", "")))
				set(n or value)
			end)
			local holdTok = 0
			local function attach(btn, dir)
				hover(btn)
				btn.MouseButton1Down:Connect(function()
					holdTok = holdTok + 1
					local my = holdTok
					playSound("Tick")
					set(value + dir * inc)
					task.delay(0.4, function()
						while holdTok == my and btn.Parent do
							set(value + dir * inc)
							task.wait(0.06)
						end
					end)
				end)
				local function stop() holdTok = holdTok + 1 end
				btn.MouseButton1Up:Connect(stop)
				btn.MouseLeave:Connect(stop)
			end
			attach(minus, -1)
			attach(plus, 1)
			register(config, "slider", function() return value end, function(v) if type(v) == "number" then set(v) end end)
			return common(row, lab, info, {Set = function(v, s) set(v, s) end, Get = function() return value end,
				SetRange = function(a, b) minV, maxV = a, b set(value, true) end}, config)
		end

		function section:CreateCheckbox(config)
			local sz = COMPACT and 26 or 20
			local row, lab, info = makeRow(self, config, sz + 28, 48)
			local boxBtn = P(make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Text = "",
				Position = UDim2.new(1, -(sz + 14), 0, 0), Size = UDim2.fromOffset(sz, sz), ZIndex = 5}, row), {BackgroundColor3 = "Panel"})
			info.VC(boxBtn)
			local bs = stroke(boxBtn, COLORS.Line, 0.2, 1)
			local fill = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(0, 0), ZIndex = 6}, boxBtn), {BackgroundColor3 = "Bright"})
			local enabled = config.CurrentValue == true
			local function paint(anim)
				local s = enabled and (sz - 8) or 0
				local sc = enabled and COLORS.Bright or COLORS.Line
				if anim then
					tween(fill, 0.16, {Size = UDim2.fromOffset(s, s)}, Enum.EasingStyle.Back)
					tween(bs, 0.16, {Color = sc})
				else
					fill.Size = UDim2.fromOffset(s, s)
					bs.Color = sc
				end
			end
			paint(false)
			hook(function() paint(false) end)
			local function set(v, silent)
				enabled = v == true
				paint(true)
				if not silent then
					playSound(enabled and "ToggleOn" or "ToggleOff")
					ripple(boxBtn)
					emit(config, enabled)
				end
			end
			boxBtn.MouseButton1Click:Connect(function() set(not enabled) end)
			hover(boxBtn)
			register(config, "toggle", function() return enabled end, function(v) set(v) end)
			return common(row, lab, info, {Set = set, Get = function() return enabled end}, config)
		end

		function section:CreateRadio(config)
			local options = vfOptions(config.Options)
			local ih = COMPACT and 34 or 26
			local n0 = #options
			local selected = options[1]
			local cur = config.CurrentOption
			if type(cur) == "table" then cur = cur[1] end
			if cur ~= nil then selected = tostring(cur) end
			local row, lab, info = makeRow(self, config, 0, 36 + n0 * ih, n0 * ih + 6)
			local list = make("Frame", {BackgroundTransparency = 1, ZIndex = 5}, row)
			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, list)
			local buttons = {}
			local function paint(anim)
				for o, b in pairs(buttons) do
					local on = o == selected
					local s = on and 8 or 0
					if anim then
						tween(b.Dot, 0.14, {Size = UDim2.fromOffset(s, s)}, Enum.EasingStyle.Back)
						tween(b.Ring, 0.14, {Color = on and COLORS.Bright or COLORS.Line})
						tween(b.Label, 0.14, {TextColor3 = on and COLORS.Text or COLORS.Muted})
					else
						b.Dot.Size = UDim2.fromOffset(s, s)
						b.Ring.Color = on and COLORS.Bright or COLORS.Line
						b.Label.TextColor3 = on and COLORS.Text or COLORS.Muted
					end
				end
			end
			local set
			local function build()
				for _, b in pairs(buttons) do b.Btn:Destroy() end
				buttons = {}
				for i, o in ipairs(options) do
					local btn = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 0, ih), LayoutOrder = i, ZIndex = 5}, list)
					local ring = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14), ZIndex = 6}, btn), {BackgroundColor3 = "Panel"})
					make("UICorner", {CornerRadius = UDim.new(1, 0)}, ring)
					local rs = stroke(ring, COLORS.Line, 0.1, 1)
					local dot = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(0, 0), ZIndex = 7}, ring), {BackgroundColor3 = "Bright"})
					make("UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
					local tl = T(btn, o, 11 + BOOST, "Muted", FONT, UDim2.fromOffset(24, 0), UDim2.new(1, -24, 1, 0))
					tl.ZIndex = 6
					buttons[o] = {Btn = btn, Ring = rs, Dot = dot, Label = tl}
					btn.MouseButton1Click:Connect(function()
						if selected ~= o then playSound("Click") ripple(btn) end
						set(o)
					end)
					hover(btn)
				end
				list.Position = UDim2.new(0, 13, 1, -(#options * ih + 6))
				list.Size = UDim2.new(1, -26, 0, #options * ih)
				paint(false)
			end
			set = function(v, silent)
				v = tostring(v)
				local found = false
				for _, o in ipairs(options) do if o == v then found = true end end
				if not found then return end
				selected = v
				paint(true)
				if not silent then emit(config, selected) end
			end
			build()
			hook(function() paint(false) end)
			register(config, "dropdown", function() return selected end, function(v) set(v) end)
			return common(row, lab, info, {Set = set, Get = function() return selected end,
				Refresh = function(newOptions, keep)
					options = vfOptions(newOptions)
					local still = false
					for _, o in ipairs(options) do if o == selected then still = true end end
					if not (keep and still) then selected = options[1] end
					build()
					info.Resize((#options - n0) * ih, true)
				end}, config)
		end

		function section:CreateChips(config)
			local options = vfOptions(config.Options)
			local maxSel = tonumber(config.Max)
			local selected = {}
			local function setFrom(v)
				selected = {}
				if type(v) == "table" then for _, x in ipairs(v) do selected[tostring(x)] = true end
				elseif v ~= nil and v ~= "" then selected[tostring(v)] = true end
			end
			setFrom(config.CurrentOption)
			local row, lab, info = makeRow(self, config, 0, 44)
			local wrap = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -26, 0, 0), ZIndex = 5}, row)
			local layout = make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Wraps = true, SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Top}, wrap)
			local chips = {}
			local function fit()
				local h = layout.AbsoluteContentSize.Y
				wrap.Size = UDim2.new(1, -26, 0, h)
				wrap.Position = UDim2.fromOffset(13, info.h - 2)
				if info.open ~= h + 10 then info.Resize(h + 10, false) end
			end
			info.onLayout = fit
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
			local function getValue()
				local t = {}
				for _, o in ipairs(options) do if selected[o] then t[#t + 1] = o end end
				return t
			end
			local function count() local n = 0 for _ in pairs(selected) do n = n + 1 end return n end
			local function paint(anim)
				for o, c in pairs(chips) do
					local on = selected[o] == true
					local bg = on and COLORS.Soft or COLORS.Panel
					local tc = on and COLORS.Bright or COLORS.Muted
					local sc = on and COLORS.Bright or COLORS.Line
					if anim then
						tween(c.Btn, 0.14, {BackgroundColor3 = bg, TextColor3 = tc})
						tween(c.Stroke, 0.14, {Color = sc})
					else
						c.Btn.BackgroundColor3, c.Btn.TextColor3, c.Stroke.Color = bg, tc, sc
					end
				end
			end
			local function build()
				for _, c in pairs(chips) do c.Btn:Destroy() end
				chips = {}
				for i, o in ipairs(options) do
					local btn = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Font = FONT_BOLD, Text = o, TextSize = 10 + BOOST,
						Size = UDim2.fromOffset(0, COMPACT and 30 or 24), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = i, ZIndex = 5}, wrap)
					make("UIPadding", {PaddingLeft = UDim.new(0, 11), PaddingRight = UDim.new(0, 11)}, btn)
					local st = stroke(btn, COLORS.Line, 0.2, 1)
					chips[o] = {Btn = btn, Stroke = st}
					hover(btn)
					btn.MouseButton1Click:Connect(function()
						if selected[o] then selected[o] = nil
						else
							if maxSel and count() >= maxSel then return end
							selected[o] = true
						end
						playSound("Tick")
						paint(true)
						emit(config, getValue())
					end)
				end
				paint(false)
				task.defer(fit)
			end
			build()
			hook(function() paint(false) end)
			register(config, "dropdown", getValue, function(v) setFrom(v) paint(true) emit(config, getValue()) end)
			return common(row, lab, info, {Set = function(v, silent) setFrom(v) paint(true) if not silent then emit(config, getValue()) end end,
				Get = getValue,
				Refresh = function(newOptions, keep)
					options = vfOptions(newOptions)
					if not keep then selected = {} end
					build()
				end}, config)
		end

		function section:CreateStat(config)
			local row, lab, info = makeRow(self, config, 150, 44)
			local vl = T(row, tostring(config.Value or "-"), 12 + BOOST, "Bright", FONT_HEAVY, UDim2.new(1, -163, 0, 0), UDim2.fromOffset(150, 20))
			vl.ZIndex, vl.TextXAlignment, vl.TextTruncate = 5, Enum.TextXAlignment.Right, Enum.TextTruncate.AtEnd
			info.VC(vl)
			local function set(text, color)
				vl.Text = tostring(text)
				if typeof(color) == "Color3" then vl.TextColor3 = color end
			end
			local fn = config.Update
			if not fn and config.Source then
				local m = win.Metrics and win.Metrics[tostring(config.Source):lower()]
				if m then fn = function() local v = m.Get() return m.Format and m.Format(v) or tostring(v) end end
			end
			local handle
			local function tick()
				if not row.Parent then if handle then handle.Stop() end return end
				local ok, a, b = pcall(fn)
				if ok and a ~= nil then set(a, b) end
			end
			if fn then handle = win:Every(tonumber(config.Interval) or 1, tick) end
			local extra = {Set = set, Get = function() return vl.Text end,
				Stop = function() if handle then handle.Stop() end end}
			return common(row, lab, info, extra, config)
		end

		function section:CreateGraph(config)
			local H = config.Height or 70
			local N = math.clamp(tonumber(config.Points) or 40, 8, 120)
			local row, lab, info = makeRow(self, config, 110, 40)
			local vl = T(row, "", 11 + BOOST, "Bright", FONT_BOLD, UDim2.new(1, -123, 0, 7), UDim2.fromOffset(110, 20))
			vl.ZIndex, vl.TextXAlignment = 5, Enum.TextXAlignment.Right
			local box = P(make("Frame", {BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row), {BackgroundColor3 = "Panel"})
			vfStroke(box, "Line", 0.4)
			info.onLayout = function() box.Position = UDim2.fromOffset(13, info.h - 2) end
			info.Resize(H + 10, false)
			box.Position = UDim2.fromOffset(13, info.h - 2)
			local bars, data = {}, {}
			for i = 1, N do
				bars[i] = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((i - 1) / N, 1, 1, -1),
					Size = UDim2.new(1 / N, -1, 0, 0), ZIndex = 6}, box), {BackgroundColor3 = "Accent"})
				data[i] = 0
			end
			local lo, hi = config.Min, config.Max
			local function redraw()
				local mn, mx = lo, hi
				if mn == nil then
					mn = math.huge
					for _, v in ipairs(data) do if v < mn then mn = v end end
					if mn == math.huge then mn = 0 end
					mn = math.min(mn, 0)
				end
				if mx == nil then
					mx = -math.huge
					for _, v in ipairs(data) do if v > mx then mx = v end end
					if mx <= mn then mx = mn + 1 end
				end
				if mx <= mn then mx = mn + 1 end
				for i = 1, N do
					bars[i].Size = UDim2.new(1 / N, -1, math.clamp((data[i] - mn) / (mx - mn), 0, 1), 0)
				end
			end
			local function push(v)
				v = tonumber(v)
				if not v then return end
				table.remove(data, 1)
				data[#data + 1] = v
				vl.Text = tostring(math.floor(v * 100 + 0.5) / 100) .. (config.Suffix or "")
				redraw()
			end
			local handle
			local source = config.Source
			local getter = type(source) == "function" and source or nil
			if not getter and source then
				local m = win.Metrics and win.Metrics[tostring(source):lower()]
				if m then getter = m.Get end
			end
			if getter then
				handle = win:Every(tonumber(config.Interval) or 1, function()
					if not row.Parent then if handle then handle.Stop() end return end
					local ok, v = pcall(getter)
					if ok then push(v) end
				end)
			end
			redraw()
			return common(row, lab, info, {Push = push, Set = push, Get = function() return data[#data] end,
				Clear = function() for i = 1, N do data[i] = 0 end vl.Text = "" redraw() end,
				Stop = function() if handle then handle.Stop() end end}, config)
		end

		function section:CreateKeyValue(config)
			local row, lab, info = makeRow(self, config, 210, 40)
			local vb = P(make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Font = FONT_BOLD, TextSize = 11 + BOOST,
				TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Text = tostring(config.Value or ""),
				Position = UDim2.new(1, -223, 0, 0), Size = UDim2.fromOffset(210, 22), ZIndex = 5}, row), {TextColor3 = "Bright"})
			info.VC(vb)
			local full = tostring(config.Value or "")
			vb.MouseButton1Click:Connect(function()
				if config.Copy == false then return end
				local ok = pcall(function() setclipboard(full) end)
				playSound("Click")
				win:Notify({Title = tostring(config.Name or "Value"), Content = ok and "Copied to clipboard." or full, Kind = ok and "success" or "info", Duration = 2})
			end)
			local function set(v) full = tostring(v or "") vb.Text = full end
			return common(row, lab, info, {Set = set, Get = function() return full end}, config)
		end

		function section:CreateCodeBlock(config)
			local H = config.Height or 110
			local copyOn = config.Copy ~= false
			local row, lab, info = makeRow(self, config, copyOn and 90 or 0, 40)
			local code = tostring(config.Code or config.Content or "")
			local textObj
			if copyOn then
				local cb = B(row, "COPY", UDim2.new(1, -(66 + 14), 0, 0), UDim2.fromOffset(66, COMPACT and 30 or 24), "Soft")
				cb.TextSize, cb.ZIndex = 10 + BOOST, 5
				info.VC(cb)
				vfStroke(cb, "Accent", 0.7)
				hover(cb)
				cb.MouseButton1Click:Connect(function()
					local ok = pcall(function() setclipboard(code) end)
					playSound("Click")
					ripple(cb)
					win:Notify({Title = "Code", Content = ok and "Copied to clipboard." or "Clipboard not available.", Kind = ok and "success" or "warn", Duration = 2})
				end)
			end
			local box = P(make("ScrollingFrame", {BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.XY, ScrollBarThickness = 3,
				ScrollingDirection = Enum.ScrollingDirection.XY, Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row), {BackgroundColor3 = "Panel"})
			vfStroke(box, "Line", 0.4)
			make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}, box)
			textObj = P(make("TextLabel", {BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 10 + BOOST, TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = false, RichText = false, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.new(0, 0, 0, 0),
				Text = code, ZIndex = 6}, box), {TextColor3 = "Text"})
			info.onLayout = function() box.Position = UDim2.fromOffset(13, info.h - 2) end
			info.Resize(H + 10, false)
			box.Position = UDim2.fromOffset(13, info.h - 2)
			return common(row, lab, info, {Set = function(c) code = tostring(c or "") textObj.Text = code end, Get = function() return code end}, config)
		end

		function section:CreateListBox(config)
			local H = config.Height or 120
			local multi = config.Multi == true
			local options = vfOptions(config.Options)
			local searchable = config.Searchable == true or (config.Searchable ~= false and #options > 6)
			local topOff = searchable and 32 or 0
			local selected = {}
			local function setFrom(v)
				selected = {}
				if type(v) == "table" then for _, x in ipairs(v) do selected[tostring(x)] = true end
				elseif v ~= nil and v ~= "" then selected[tostring(v)] = true end
			end
			setFrom(config.CurrentOption or ((not multi) and options[1]) or nil)
			local row, lab, info = makeRow(self, config, 0, 40)
			local holder = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -26, 0, H + topOff), ZIndex = 5}, row)
			info.onLayout = function() holder.Position = UDim2.fromOffset(13, info.h - 2) end
			info.Resize(H + topOff + 10, false)
			holder.Position = UDim2.fromOffset(13, info.h - 2)
			local sbox
			if searchable then
				sbox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT, TextSize = 10 + BOOST, PlaceholderText = "Search...", Text = "",
					TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 26), ZIndex = 6}, holder),
					{BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"})
				make("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 8)}, sbox)
				vfStroke(sbox, "Line", 0.3)
			end
			local scroll = P(make("ScrollingFrame", {BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
				Position = UDim2.fromOffset(0, topOff), Size = UDim2.new(1, 0, 0, H), ZIndex = 5}, holder), {BackgroundColor3 = "Panel"})
			vfStroke(scroll, "Line", 0.4)
			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, scroll)
			local items = {}
			local function getValue()
				if multi then
					local t = {}
					for _, o in ipairs(options) do if selected[o] then t[#t + 1] = o end end
					return t
				end
				for _, o in ipairs(options) do if selected[o] then return o end end
			end
			local function paint()
				for o, it in pairs(items) do
					local on = selected[o] == true
					it.BackgroundColor3 = on and COLORS.Soft or COLORS.Panel
					it.TextColor3 = on and COLORS.Bright or COLORS.Text
				end
			end
			local function build()
				for _, it in pairs(items) do it:Destroy() end
				items = {}
				for i, o in ipairs(options) do
					local b = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Font = FONT_BOLD, Text = o, TextSize = 10 + BOOST,
						TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.new(1, 0, 0, COMPACT and 30 or 24), LayoutOrder = i, ZIndex = 6}, scroll)
					make("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 8)}, b)
					items[o] = b
					b.MouseButton1Click:Connect(function()
						playSound("Tick")
						if multi then selected[o] = (not selected[o]) or nil
						else selected = {[o] = true} end
						paint()
						emit(config, getValue())
					end)
				end
				paint()
			end
			build()
			hook(paint)
			if sbox then
				sbox:GetPropertyChangedSignal("Text"):Connect(function()
					local q = sbox.Text:lower()
					for o, it in pairs(items) do it.Visible = q == "" or o:lower():find(q, 1, true) ~= nil end
				end)
			end
			register(config, "dropdown", getValue, function(v) setFrom(v) paint() emit(config, getValue()) end)
			return common(row, lab, info, {Set = function(v, silent) setFrom(v) paint() if not silent then emit(config, getValue()) end end,
				Get = getValue,
				Refresh = function(newOptions, keep)
					options = vfOptions(newOptions)
					if not keep then selected = {} end
					build()
				end}, config)
		end

		function section:CreateTable(config)
			local cols = config.Columns or {}
			local n = math.max(#cols, 1)
			local H = config.Height or 120
			local widths = config.Widths
			local rowH = COMPACT and 26 or 20
			local row, lab, info = makeRow(self, config, 0, 40)
			local box = P(make("ScrollingFrame", {BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
				Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row), {BackgroundColor3 = "Panel"})
			vfStroke(box, "Line", 0.4)
			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1)}, box)
			make("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)}, box)
			info.onLayout = function() box.Position = UDim2.fromOffset(13, info.h - 2) end
			info.Resize(H + 10, false)
			box.Position = UDim2.fromOffset(13, info.h - 2)
			local count = 0
			local function line(cells, header)
				count = count + 1
				local f = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, rowH), LayoutOrder = header and 0 or count, ZIndex = 6}, box)
				if header then f.Name = "VFHeader" else f.Name = "VFRow" end
				local x = 0
				for i = 1, n do
					local w = (widths and widths[i]) or (1 / n)
					local tl = T(f, tostring(cells[i] == nil and "" or cells[i]), 10 + BOOST, header and "Bright" or "Text", header and FONT_HEAVY or FONT, UDim2.new(x, 0, 0, 0), UDim2.new(w, -4, 1, 0))
					tl.ZIndex, tl.TextTruncate = 7, Enum.TextTruncate.AtEnd
					x = x + w
				end
				if header then
					local ul = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), ZIndex = 7}, f), {BackgroundColor3 = "Line"})
				end
			end
			if #cols > 0 then line(cols, true) end
			local obj = {}
			function obj.Clear() for _, c in ipairs(box:GetChildren()) do if c.Name == "VFRow" then c:Destroy() end end end
			function obj.AddRow(cells) line(cells or {}, false) end
			function obj.SetRows(rows)
				obj.Clear()
				for _, r in ipairs(rows or {}) do line(r, false) end
			end
			for _, r in ipairs(config.Rows or {}) do line(r, false) end
			obj.Set = obj.SetRows
			return common(row, lab, info, obj, config)
		end

		function section:CreateButtonRow(config)
			local specs = config.Buttons or {}
			local n = math.max(#specs, 1)
			local bh = COMPACT and 34 or 28
			local bw = COMPACT and 84 or 72
			local named = config.Name ~= nil and config.Name ~= ""
			local fixedW = n * (bw + 4) - 4
			local row, lab, info = makeRow(self, config, named and (fixedW + 24) or 0, 48)
			local holder = make("Frame", {BackgroundTransparency = 1, ZIndex = 5,
				Position = named and UDim2.new(1, -(fixedW + 14), 0, 0) or UDim2.fromOffset(13, 0),
				Size = named and UDim2.fromOffset(fixedW, bh) or UDim2.new(1, -26, 0, bh)}, row)
			info.VC(holder)
			local btns = {}
			for i, spec in ipairs(specs) do
				local pos, size
				if named then
					pos, size = UDim2.fromOffset((i - 1) * (bw + 4), 0), UDim2.fromOffset(bw, bh)
				else
					pos, size = UDim2.new((i - 1) / n, i == 1 and 0 or 2, 0, 0), UDim2.new(1 / n, i == 1 and -2 or -4, 1, 0)
				end
				local btn = B(holder, tostring(spec.Name or spec.ButtonText or "Button"), pos, size, "Soft")
				btn.TextSize, btn.ClipsDescendants, btn.ZIndex = 10 + BOOST, true, 6
				local bs = vfStroke(btn, "Accent", 0.7)
				hover(btn)
				btn.MouseEnter:Connect(function() tween(bs, 0.15, {Transparency = 0.2}) end)
				btn.MouseLeave:Connect(function() tween(bs, 0.2, {Transparency = 0.7}) end)
				local armed, original = false, btn.Text
				local function fire()
					if spec.Callback then task.spawn(spec.Callback) end
					if config.Callback then task.spawn(config.Callback, i, spec.Name) end
				end
				btn.MouseButton1Click:Connect(function()
					if spec.Confirm and not armed then
						armed = true
						btn.Text = "SURE?"
						task.delay(2, function() if armed then armed = false btn.Text = original end end)
						return
					end
					armed, btn.Text = false, original
					playSound("Click")
					ripple(btn)
					tween(btn, 0.12, {BackgroundColor3 = COLORS.Accent, TextColor3 = COLORS.Background})
					task.delay(0.14, function() if btn.Parent then tween(btn, 0.2, {BackgroundColor3 = COLORS.Soft, TextColor3 = COLORS.Text}) end end)
					fire()
				end)
				btns[i] = btn
			end
			return common(row, lab, info, {Buttons = btns, Fire = function(i) local s = specs[i or 1] if s and s.Callback then task.spawn(s.Callback) end end,
				SetText = function(i, t) if btns[i] then btns[i].Text = tostring(t) end end}, config)
		end

		function section:CreateSwatches(config)
			local colors = config.Colors
			if type(colors) ~= "table" or #colors == 0 then
				colors = {rgb(255, 255, 255), rgb(255, 70, 90), rgb(255, 140, 0), rgb(255, 215, 0), rgb(0, 200, 90), rgb(0, 220, 220), rgb(0, 120, 255), rgb(170, 90, 255), rgb(255, 110, 190), rgb(20, 20, 20)}
			end
			local sw = COMPACT and 30 or 22
			local row, lab, info = makeRow(self, config, 0, 44)
			local wrap = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, -26, 0, 0), ZIndex = 5}, row)
			local layout = make("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Wraps = true, SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Top}, wrap)
			local current = vfAsColor(config.CurrentValue or colors[1])
			local cells = {}
			local function same(a, b) return math.abs(a.R - b.R) + math.abs(a.G - b.G) + math.abs(a.B - b.B) < 0.02 end
			local function paint(anim)
				for _, c in ipairs(cells) do
					local on = same(c.Color, current)
					local sc = on and COLORS.Bright or COLORS.Line
					local th = on and 2 or 1
					if anim then tween(c.Stroke, 0.14, {Color = sc, Thickness = th}) else c.Stroke.Color, c.Stroke.Thickness = sc, th end
				end
			end
			local function fit()
				local h = layout.AbsoluteContentSize.Y
				wrap.Size = UDim2.new(1, -26, 0, h)
				wrap.Position = UDim2.fromOffset(13, info.h - 2)
				if info.open ~= h + 10 then info.Resize(h + 10, false) end
			end
			info.onLayout = fit
			layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
			local function set(c, silent)
				if typeof(c) ~= "Color3" then return end
				current = c
				paint(true)
				if not silent then emit(config, current) end
			end
			for i, c in ipairs(colors) do
				local b = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, Text = "", BackgroundColor3 = vfAsColor(c), Size = UDim2.fromOffset(sw, sw), LayoutOrder = i, ZIndex = 5}, wrap)
				local st = stroke(b, COLORS.Line, 0, 1)
				cells[#cells + 1] = {Btn = b, Stroke = st, Color = vfAsColor(c)}
				hover(b)
				b.MouseButton1Click:Connect(function() playSound("Tick") set(vfAsColor(c)) end)
			end
			paint(false)
			hook(function() paint(false) end)
			task.defer(fit)
			register(config, "color", function() return current end, function(v) set(v) end)
			return common(row, lab, info, {Set = set, Get = function() return current end}, config)
		end

		function section:CreateSeparator(config)
			local text = tostring(config.Text or config.Name or config.Title or "")
			local f = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), ZIndex = 4}, self.Items)
			P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4}, f), {BackgroundColor3 = "Line"})
			local lbl = P(make("TextLabel", {Font = FONT_HEAVY, TextSize = 9 + BOOST, Text = string.upper(text), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), BorderSizePixel = 0, Visible = text ~= "", ZIndex = 5}, f), {BackgroundColor3 = "Background", TextColor3 = "Muted"})
			make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, lbl)
			return {Row = f, Set = function(t) t = tostring(t or "") lbl.Text = string.upper(t) lbl.Visible = t ~= "" end,
				SetVisible = function(v) f.Visible = v end, Destroy = function() f:Destroy() end}
		end

		function section:CreateSpacer(config)
			local h = tonumber(config.Height or config.Size) or 10
			local f = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, h), ZIndex = 4}, self.Items)
			return {Row = f, Set = function(v) f.Size = UDim2.new(1, 0, 0, tonumber(v) or h) end,
				SetVisible = function(v) f.Visible = v end, Destroy = function() f:Destroy() end}
		end

		function section:CreateStatus(config)
			local row, lab, info = makeRow(self, config, 170, 40)
			local dot = make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0, 0), Size = UDim2.fromOffset(8, 8), ZIndex = 5}, row)
			make("UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
			local tl = T(row, "", 11 + BOOST, "Muted", FONT_BOLD, UDim2.new(1, -(30 + 140), 0, 0), UDim2.fromOffset(140, 20))
			tl.ZIndex, tl.TextXAlignment, tl.TextTruncate = 5, Enum.TextXAlignment.Right, Enum.TextTruncate.AtEnd
			info.VC(dot)
			info.VC(tl)
			local kind = "idle"
			local function colorFor(k)
				k = tostring(k or "idle"):lower()
				if k == "ok" or k == "online" or k == "success" or k == "on" then return STATUS.success end
				if k == "warn" or k == "warning" or k == "busy" then return STATUS.warn end
				if k == "error" or k == "offline" or k == "off" or k == "fail" then return STATUS.error end
				if k == "info" then return COLORS.Accent end
				return COLORS.Muted
			end
			local function set(k, text)
				kind = tostring(k or "idle")
				tween(dot, 0.2, {BackgroundColor3 = colorFor(kind)})
				tl.Text = tostring(text or kind:sub(1, 1):upper() .. kind:sub(2))
			end
			set(config.Status or "idle", config.Text)
			return common(row, lab, info, {Set = set, Get = function() return kind end}, config)
		end

		function section:CreateTextArea(config)
			local H = config.Height or 90
			local row, lab, info = makeRow(self, config, 0, 40)
			local box = P(make("TextBox", {BorderSizePixel = 0, MultiLine = true, ClearTextOnFocus = false, TextWrapped = true,
				Font = config.Monospace and Enum.Font.Code or FONT, TextSize = 10 + BOOST * 2, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
				PlaceholderText = config.PlaceholderText or config.Placeholder or "Type here...", Text = tostring(config.CurrentValue or ""),
				Size = UDim2.new(1, -26, 0, H), ZIndex = 5}, row), {BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"})
			make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)}, box)
			local bs = stroke(box, COLORS.Line, 0.2, 1)
			info.onLayout = function() box.Position = UDim2.fromOffset(13, info.h - 2) end
			info.Resize(H + 10, false)
			box.Position = UDim2.fromOffset(13, info.h - 2)
			box.Focused:Connect(function() tween(bs, 0.15, {Color = COLORS.Accent}) end)
			box.FocusLost:Connect(function(enter)
				tween(bs, 0.2, {Color = COLORS.Line})
				emit(config, box.Text)
			end)
			register(config, "input", function() return box.Text end, function(v) box.Text = tostring(v or "") emit(config, box.Text) end)
			return common(row, lab, info, {Set = function(v) box.Text = tostring(v or "") end, Get = function() return box.Text end,
				Append = function(t) box.Text = box.Text .. tostring(t or "") end, Clear = function() box.Text = "" end}, config)
		end

		local function normCfg(n, c) 			if type(c) == "string" then c = {Name = c, Title = c} 			elseif type(c) == "table" then local t = {} for k, v in pairs(c) do t[k] = v end c = t 			else c = {} end 			if n == "CreateColorPicker" and c.Color and not c.CurrentValue then c.CurrentValue = c.Color end 			if n == "CreateDropdown" then 				if c.MultipleOptions and c.Multi == nil then c.Multi = true end 				if type(c.CurrentOption) == "table" and not c.Multi then c.CompatTable = true c.CurrentOption = c.CurrentOption[1] end 			end 			if n == "CreateKeybind" and c.HoldToInteract and not c.Mode then c.Mode = "Hold" end 			if n == "CreateInput" and c.RemoveTextAfterFocusLost then c.ClearAfter = true end 			if (n == "CreateSlider" or n == "CreateRangeSlider") and c.Range == nil then c.Range = {c.Min or 0, c.Max or 100} end 			return c 		end 		for _, n in ipairs(ELEMENT_NAMES) do 			local orig = section[n] 			if orig then section[n] = function(self2, c) return orig(self2, normCfg(n, c)) end end 		end 	end 	local function applyFilter() 		local q = sBox.Text:lower() 		local first 		for _, tab in ipairs(win.Tabs) do 			local tabMatches = false 			for _, sec in ipairs(tab.Sections) do 				local any = false 				for _, r in ipairs(sec.Rows) do 					r.match = q == "" or r.key:find(q, 1, true) ~= nil or sec.NameLower:find(q, 1, true) ~= nil 					r.row.Visible = r.match and not r.hidden 					if r.match then any = true end 				end 				sec.Container.Visible = any or q == "" 				sec.Items.Visible = q ~= "" or not sec.Collapsed 				if any then tabMatches = true end 			end 			tab.Label.TextTransparency = (q ~= "" and not tabMatches) and 0.6 or 0 			if tabMatches and not first then first = tab end 		end 		if q ~= "" and first and win.ActiveTab and win.ActiveTab ~= first then 			local here = false 			for _, sec in ipairs(win.ActiveTab.Sections) do 				for _, r in ipairs(sec.Rows) do if r.match then here = true break end end 				if here then break end 			end 			if not here then first.Select() end 		end 	end 	sBox:GetPropertyChangedSignal("Text"):Connect(applyFilter) 	function win:CreateTab(name, icon) 		local tab = {Name = name, Sections = {}} 		local btn = B(tabList, "", nil, UDim2.new(1, 0, 0, COMPACT and 58 or 38)) 		self.TabOrder += 1 		btn.BackgroundTransparency, btn.ZIndex, btn.LayoutOrder = 1, 4, self.TabOrder 		hover(btn) 		local bar = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(3, 0), ZIndex = 6}, btn), {BackgroundColor3 = "Bright"}) 		local iconText = tostring(icon or "")
		local isAsset = iconText:match("^rbxassetid://") or iconText:match("^%d+$")
		local kindName = nil
		if not isAsset then
			kindName = resolveIcon(iconText, name)
			if not kindName and (iconText == "" or (utf8.len(iconText) or #iconText) > 2) then kindName = resolveIcon("", name) end
		end
		if not kindName and not iconText:match("^rbxassetid://") and not iconText:match("^%d+$") and (iconText == "" or (utf8.len(iconText) or #iconText) > 2) then iconText = string.upper(string.sub(tostring(name or "?"), 1, 1)) end 		local img = iconText:match("^rbxassetid://") and iconText or (iconText:match("^%d+$") and ("rbxassetid://" .. iconText) or nil) 		local il
		local iconObj
		if kindName then
			iconObj = makeIcon(btn, kindName, COMPACT and 24 or 18, "Muted", 5)
			iconObj.Frame.Position = COMPACT and UDim2.new(0.5, 0, 0, 20) or UDim2.new(0, 20, 0.5, 0)
			il = iconObj.Frame
		elseif img then 			il = make("ImageLabel", {BackgroundTransparency = 1, Image = img, ScaleType = Enum.ScaleType.Fit, AnchorPoint = Vector2.new(COMPACT and 0.5 or 0, 0.5), 				Position = COMPACT and UDim2.new(0.5, 0, 0, 20) or UDim2.new(0, 9, 0.5, 0), Size = UDim2.fromOffset(COMPACT and 26 or 20, COMPACT and 26 or 20), ZIndex = 5}, btn) 		else 			il = T(btn, iconText, COMPACT and 18 or 14, "Muted", FONT_BOLD, UDim2.fromOffset(COMPACT and 0 or 10, COMPACT and 3 or 0), COMPACT and UDim2.new(1, 0, 0, 34) or UDim2.fromOffset(20, 38)) 			il.ZIndex, il.TextXAlignment = 5, Enum.TextXAlignment.Center 		end 		local function iconColor(c) if iconObj then iconObj.Set(c) elseif il:IsA("ImageLabel") then il.ImageColor3 = c else il.TextColor3 = c end end 		local ll = T(btn, name, COMPACT and 9 or 11, "Muted", FONT_BOLD, COMPACT and UDim2.fromOffset(2, 38) or UDim2.fromOffset(40, 0), COMPACT and UDim2.new(1, -4, 0, 16) or UDim2.new(1, -46, 1, 0)) 		ll.ZIndex = 5 		if COMPACT then ll.TextXAlignment, ll.TextTruncate = Enum.TextXAlignment.Center, Enum.TextTruncate.AtEnd end 		local page = make("ScrollingFrame", {Name = name .. "Page", BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, 			ScrollBarThickness = 3, ScrollBarImageTransparency = 0.35, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 3}, pagesHolder) 		P(page, {ScrollBarImageColor3 = "Accent"}) 		make("UIPadding", {PaddingTop = UDim.new(0, math.max(PAD - 6, 4)), PaddingBottom = UDim.new(0, PAD + 1), PaddingLeft = UDim.new(0, PAD), PaddingRight = UDim.new(0, PAD)}, page) 		list(page, COMPACT and 10 or 14) 		tab.Page, tab.Button, tab.Label, tab.Bar = page, btn, ll, bar 		local function paint() 			local active = win.ActiveTab == tab 			ll.TextColor3 = active and COLORS.Text or COLORS.Muted 			iconColor(active and COLORS.Bright or COLORS.Muted) 			btn.BackgroundColor3 = active and COLORS.Soft or COLORS.Raised 		end 		tab.Paint = paint 		hook(paint) 		local function activate() 			if win.ActiveTab == tab then return end 			win.ActiveTab = tab 			for _, o in ipairs(win.Tabs) do 				o.Page.Visible = o == tab 				o.Paint() 				tween(o.Button, 0.18, {BackgroundTransparency = o == tab and 0.15 or 1}) 				tween(o.Bar, o == tab and 0.25 or 0.15, {Size = UDim2.fromOffset(3, o == tab and (COMPACT and 30 or 18) or 0)}, o == tab and Enum.EasingStyle.Back or nil) 			end 			page.Position = UDim2.fromOffset(12, 0) 			tween(page, 0.28, {Position = UDim2.fromOffset(0, 0)}) 			page.CanvasPosition = Vector2.new() 			if win.Restored and win.AutoSave then win:QueueSave() end 		end 		tab.Select = activate 		btn.MouseEnter:Connect(function() if win.ActiveTab ~= tab then tween(btn, 0.12, {BackgroundTransparency = 0.6}) end end) 		btn.MouseLeave:Connect(function() if win.ActiveTab ~= tab then tween(btn, 0.15, {BackgroundTransparency = 1}) end end) 		btn.MouseButton1Click:Connect(function() 			if win.ActiveTab ~= tab then playSound("Tab") end 			ripple(btn) 			activate() 		end) 		table.insert(self.Tabs, tab) 		if #self.Tabs == 1 then activate() end 		for _, n in ipairs(ELEMENT_NAMES) do 			tab[n] = function(a, ...) 				local sec = tab.Current or tab:CreateSection(name) 				if a == tab then return sec[n](sec, ...) end 				return sec[n](sec, a, ...) 			end 		end 		function tab:CreateSection(title) 			local section = {Tab = tab, Window = win, Rows = {}, Collapsed = false, NameLower = strip(title):lower()} 			local container = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 3}, page) 			list(container, 6) 			local heading = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Font = FONT_HEAVY, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, 				Size = UDim2.new(1, 0, 0, 20), ZIndex = 4, LayoutOrder = 0, Text = string.upper(strip(title or "SECTION"))}, container)
			make("UIPadding", {PaddingLeft = UDim.new(0, 18)}, heading)
			local chev = makeIcon(heading, "down", 9, "Bright", 5)
			chev.Frame.Position = UDim2.new(0, -10, 0.5, 0) 			P(heading, {TextColor3 = "Bright"}) 			local items = make("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 3, LayoutOrder = 1}, container) 			list(items, 7) 			section.Items, section.Container = items, container 			function section:SetCollapsed(c)
				self.Collapsed = c
				if win.Restored and win.AutoSave then win:QueueSave() end
				tween(chev.Frame, 0.18, {Rotation = c and -90 or 0})
				items.Visible = not c
			end
			function section:Set(n)
				title = tostring(n or "")
				self.NameLower = strip(title):lower()
				heading.Text = string.upper(strip(title))
			end
			section.SetTitle = section.Set 			heading.MouseButton1Click:Connect(function() 				playSound(section.Collapsed and "Expand" or "Collapse") 				section:SetCollapsed(not section.Collapsed) 			end) 			heading.MouseEnter:Connect(function() tween(heading, 0.12, {TextColor3 = COLORS.Muted}) end) 			heading.MouseLeave:Connect(function() tween(heading, 0.15, {TextColor3 = COLORS.Bright}) end) 			sectionMethods(section) 			table.insert(tab.Sections, section) 			tab.Current = section 			return section 		end 		return tab 	end 	local holder = make("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -14), Size = UDim2.fromOffset(NOTIF_W, 420), ZIndex = 200}, screen) 	make("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right}, holder) 	local GLYPH = {info = "i", success = "OK", warn = "!", error = "X"} 	local KSOUND = {info = "Notify", success = "Success", warn = "Warn", error = "Error"} 	function win:Notify(c) 		c = c or {} 		if self.Destroyed or not self.NotifyOn then return end 		local kind = GLYPH[c.Kind] and c.Kind or "info" 		playSound(KSOUND[kind]) 		self.NotifIndex += 1 		local wraps = {} 		for _, w in ipairs(holder:GetChildren()) do if w:IsA("Frame") then wraps[#wraps + 1] = w end end 		if #wraps >= 5 then table.sort(wraps, function(a, b) return a.LayoutOrder < b.LayoutOrder end) wraps[1]:Destroy() end 		local kc = STATUS[kind] or COLORS.Bright 		local hasActions = type(c.Actions) == "table" and next(c.Actions) ~= nil
		local wrap = make("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(NOTIF_W, hasActions and 98 or 66), LayoutOrder = self.NotifIndex, ZIndex = 200}, holder) 		local card = P(make("TextButton", {AutoButtonColor = false, Text = "", BackgroundTransparency = 0.04, BorderSizePixel = 0, ClipsDescendants = true, 			Position = UDim2.new(1, 60, 0, 0), Size = UDim2.fromScale(1, 1), ZIndex = 200}, wrap), {BackgroundColor3 = "Panel"}) 		stroke(card, kc, 0.55, 1) 		make("Frame", {BackgroundColor3 = kc, BorderSizePixel = 0, Size = UDim2.new(0, 3, 1, 0), ZIndex = 201}, card) 		local gb = P(make("Frame", {BorderSizePixel = 0, Position = UDim2.fromOffset(14, 19), Size = UDim2.fromOffset(28, 28), ZIndex = 201}, card), {BackgroundColor3 = "Raised"}) 		stroke(gb, kc, 0.4, 1) 		if c.Image then
			local src = tostring(c.Image)
			if src:match("^%d+$") then src = "rbxassetid://" .. src end
			make("ImageLabel", {BackgroundTransparency = 1, Image = src, Position = UDim2.fromOffset(3, 3), Size = UDim2.new(1, -6, 1, -6), ZIndex = 202}, gb)
		elseif not c.Icon and (kind == "success" or kind == "error") then
			local gi = makeIcon(gb, kind == "success" and "check" or "x", 14, kc, 202)
			gi.Frame.Position = UDim2.fromScale(0.5, 0.5)
		else
			local g = T(gb, c.Icon or GLYPH[kind], 14, kc, FONT_HEAVY, UDim2.new(), UDim2.fromScale(1, 1))
			g.ZIndex, g.TextXAlignment = 202, Enum.TextXAlignment.Center
		end 		T(card, c.Title or cfg.Name or "V Field", 12, "Text", FONT_BOLD, UDim2.fromOffset(52, 8), UDim2.new(1, -64, 0, 19)).ZIndex = 201 		local ct = T(card, c.Content or "", 10, "Muted", FONT, UDim2.fromOffset(52, 28), UDim2.new(1, -64, 0, 30)) 		ct.TextWrapped, ct.TextTruncate, ct.TextYAlignment, ct.ZIndex = true, Enum.TextTruncate.AtEnd, Enum.TextYAlignment.Top, 201 		local dur = c.Duration or (hasActions and 8 or 4) 		local timer = make("Frame", {BackgroundColor3 = kc, BackgroundTransparency = 0.35, BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2), ZIndex = 202}, card) 		tween(card, 0.4, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back) 		tween(timer, dur, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear) 		local gone = false 		local function dismiss() 			if gone then return end 			gone = true 			tween(card, 0.25, {Position = UDim2.new(1, 60, 0, 0)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In) 			task.wait(0.28) 			if wrap.Parent then wrap:Destroy() end 		end 		if hasActions then
			local list2 = {}
			for k, a in pairs(c.Actions) do list2[#list2 + 1] = {k, a} end
			table.sort(list2, function(x, y) return tostring(x[1]) < tostring(y[1]) end)
			local cnt = #list2
			local aw = (NOTIF_W - 24 - (cnt - 1) * 6) / cnt
			for i, pair in ipairs(list2) do
				local a = pair[2]
				local ab = B(card, tostring(a.Name or pair[1]), UDim2.fromOffset(12 + (i - 1) * (aw + 6), 64), UDim2.fromOffset(aw, 26), "Raised")
				ab.ZIndex, ab.TextSize = 202, 10
				ab.MouseButton1Click:Connect(function()
					playSound("Click", 0.6)
					if a.Callback then task.spawn(a.Callback) end
					task.spawn(dismiss)
				end)
			end
		end
		card.MouseButton1Click:Connect(function() playSound("Click", 0.6) task.spawn(dismiss) end) 		task.delay(dur, function() if card.Parent then dismiss() end end) 	end 	function win:Dialog(c) 		c = c or {} 		if self.Destroyed then return end 		playSound("Open") 		local cam = workspace.CurrentCamera 		local vp = cam and cam.ViewportSize or Vector2.new(800, 600) 		local veil = make("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 300}, screen) 		tween(veil, 0.2, {BackgroundTransparency = 0.45}) 		local cw = math.min(340, vp.X - 30) 		local ch = measure(c.Content or "", 11, FONT, cw - 40) 		local card = P(make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BorderSizePixel = 0, Size = UDim2.fromOffset(cw, 108 + ch + (c.Input and 44 or 0)), ZIndex = 301}, veil), {BackgroundColor3 = "Background"}) 		local cst = stroke(card, COLORS.Accent, 0.3, 1) 		make("Frame", {BackgroundColor3 = COLORS.Accent, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 3), ZIndex = 302}, card) 		T(card, c.Title or "Confirm", 15, "Text", FONT_HEAVY, UDim2.fromOffset(20, 16), UDim2.new(1, -40, 0, 22)).ZIndex = 302 		local body2 = T(card, c.Content or "", 11, "Muted", FONT, UDim2.fromOffset(20, 44), UDim2.new(1, -40, 0, ch)) 		body2.TextWrapped, body2.TextYAlignment, body2.ZIndex = true, Enum.TextYAlignment.Top, 302 		local inputBox 		if c.Input then 			inputBox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT, TextSize = 12, Text = tostring(c.Default or ""), PlaceholderText = c.Placeholder or "Type here...", 				TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(20, 50 + ch), Size = UDim2.new(1, -40, 0, 32), ZIndex = 302}, card), 				{BackgroundColor3 = "Raised", TextColor3 = "Text", PlaceholderColor3 = "Muted"}) 			make("UIPadding", {PaddingLeft = UDim.new(0, 8)}, inputBox) 			stroke(inputBox, COLORS.Line, 0.2, 1) 		end 		local btns = c.Buttons or {{Name = "OK", Primary = true}} 		local n = #btns 		local bw = (cw - 40 - (n - 1) * 8) / n 		local function close() tween(veil, 0.15, {BackgroundTransparency = 1}) task.delay(0.15, function() veil:Destroy() end) end 		for i, bd in ipairs(btns) do 			local b = B(card, bd.Name or "OK", UDim2.fromOffset(20 + (i - 1) * (bw + 8), 56 + ch + (c.Input and 44 or 0)), UDim2.fromOffset(bw, 34), bd.Primary and "Accent" or "Raised") 			b.ZIndex = 302 			if bd.Primary then P(b, {TextColor3 = "Background"}) end 			b.MouseButton1Click:Connect(function() playSound("Click") close() if bd.Callback then task.spawn(bd.Callback, inputBox and inputBox.Text or nil) end end) 		end 	end 	function win:Prompt(c) 		c = c or {} 		return self:Dialog({Title = c.Title or "Input", Content = c.Content or "", Input = true, Placeholder = c.Placeholder, Default = c.Default, 			Buttons = {{Name = "Cancel"}, {Name = c.ButtonText or "OK", Primary = true, Callback = c.Callback}}}) 	end 	function win:CreateTabGroup(title) 		self.TabOrder += 1 		local l = T(tabList, COMPACT and "" or string.upper(title or ""), 9, "Muted", FONT_HEAVY, nil, UDim2.new(1, 0, 0, COMPACT and 6 or 22)) 		l.LayoutOrder = self.TabOrder 		if not COMPACT then make("UIPadding", {PaddingLeft = UDim.new(0, 4), PaddingTop = UDim.new(0, 6)}, l) end 		return l 	end 	function win:GetTab(n) for _, t in ipairs(self.Tabs) do if t.Name == n then return t end end end 	function win:SelectTab(n) local t = self:GetTab(n) if t then t.Select() end return t end 	function win:ModifyTheme(n) VField:SetTheme(n) end 	function win:LoadConfiguration() return self:LoadConfig(self.CfgFileName or "autosave") end 	local function encode(kind, v) 		if kind == "color" then return {__c = {math.floor(v.R * 255 + 0.5), math.floor(v.G * 255 + 0.5), math.floor(v.B * 255 + 0.5)}} end 		if kind == "keybind" then return {__k = v and v.Name or false} end 		return v 	end 	local function decode(kind, v) 		if type(v) == "table" and v.__c then return Color3.fromRGB(v.__c[1], v.__c[2], v.__c[3]) end 		if type(v) == "table" and v.__k ~= nil then return v.__k or nil end 		return v 	end 	function win:ExportConfig(full) 		local t = {} 		for flag, r in pairs(self.Registry) do 			if not r.Ignore and (full or not r.Session) then 				local ok, val = pcall(r.Get) 				if ok then t[flag] = encode(r.kind, val) end 			end 		end 		return HttpService:JSONEncode(t) 	end 	function win:ImportConfig(json) 		local ok, t = pcall(function() return HttpService:JSONDecode(json) end) 		if not ok or type(t) ~= "table" then return false end 		local order = {}
		for flag in pairs(t) do order[#order + 1] = flag end
		local function rank(f) if f == "vf_theme" then return 1 elseif f == "vf_coloroverrides" then return 2 elseif f == "vf_accentcustom" then return 3 elseif f == "vf_layout" then return 9 end return 5 end
		table.sort(order, function(a, b) local ra, rb = rank(a), rank(b) if ra ~= rb then return ra < rb end return a < b end)
		loadingCfg = true
		for _, flag in ipairs(order) do
			local r = self.Registry[flag]
			if r then pcall(r.Set, decode(r.kind, t[flag])) end
		end
		loadingCfg = false
		return true 	end 	local function cfgPath(name) 		local clean = tostring(name):gsub("[^%w_%-]", "") 		return win.Folder .. "/configs/" .. clean .. ".json" 	end 	function win:SaveConfig(name, full) 		name = (name and name ~= "") and name or "default" 		return fsWrite(cfgPath(name), self:ExportConfig(full)) 	end 	function win:LoadConfig(name) 		local d = fsRead(cfgPath((name and name ~= "") and name or "default")) 		return d ~= nil and self:ImportConfig(d) 	end 	function win:DeleteConfig(name) 		local p = cfgPath(name) 		if delfile and isfile and isfile(p) then return (pcall(delfile, p)) end 		return false 	end 	function win:ListConfigs() 		local out = {} 		if listfiles and isfolder and isfolder(self.Folder .. "/configs") then 			local ok, files = pcall(listfiles, self.Folder .. "/configs") 			if ok then 				for _, f in ipairs(files) do 					local n = f:match("([^/\\]+)%.json$") 					if n then out[#out + 1] = n end 				end 			end 		end 		table.sort(out) 		return out 	end 	function win:SetAutoLoad(name) return fsWrite(self.Folder .. "/autoload.txt", name or "") end 	function win:LoadAutoConfig(quiet)
		local name = fsRead(self.Folder .. "/autoload.txt")
		if name and name ~= "" then
			local ok = self:LoadConfig(name)
			if ok and not quiet then self:Notify({Title = "Config", Content = "Auto-loaded '" .. name .. "'.", Kind = "success"}) end
		end
		if self.AutoSave then self:LoadConfig(self.CfgFileName or "autosave") end
		self.Restored = true
	end
	local saveQueued = false 	function win:QueueSave()
		if saveQueued or not canFS or self._noSave or not self.Restored then return end
		saveQueued = true
		task.delay(1.2, function()
			saveQueued = false
			if not win.Destroyed and not win._noSave then win:SaveConfig(win.CfgFileName or "autosave", true) end
		end)
	end
	function win:ResetSettings()
		self._noSave = true
		local p = cfgPath(self.CfgFileName or "autosave")
		if delfile and isfile and isfile(p) then pcall(delfile, p) end
		fsWrite(self.Folder .. "/autoload.txt", "")
		VField:SetRainbow(false)
		VField:SetTheme("Mono")
		self:ResetPosition()
		self:Notify({Title = "Settings", Content = "Saved settings cleared. Re-run the script to load every default.", Kind = "success"})
	end 	function win:CreateSettingsTab(o) 		o = o or {} 		local tab = self:CreateTab(o.Name or "Settings", o.Icon or "gear") 		local ui = tab:CreateSection("INTERFACE") 		ui:CreateDropdown({Name = "Theme", Description = "Accent and surface colors. Rainbow animates live", Options = VField:GetThemes(), CurrentOption = currentTheme, Flag = "vf_theme", 			Callback = function(v) if v == "Rainbow" then VField:SetRainbow(true) else VField:SetRainbow(false) VField:SetTheme(v) end end}) 		ui:CreateColorPicker({Name = "Custom Accent", Description = "Overrides the theme accent with any color", CurrentValue = COLORS.Accent, Flag = "vf_accent", IgnoreConfig = true, 			Callback = function(c) VField:SetAccent(c) end}) 		ui:CreateKeybind({Name = "Menu Key", Description = "Hides or shows this window", CurrentKeybind = self.ToggleKey, Flag = "vf_menukey", OnSet = function(k) win.ToggleKey = k end}) 		ui:CreateSlider({Name = "UI Scale", Description = "Makes the window smaller or bigger", Range = {0.6, 1.5}, Increment = 0.05, CurrentValue = 1, Suffix = "x", Flag = "vf_scale", Callback = function(v) win:SetScale(v) end}) 		ui:CreateSlider({Name = "Window Transparency", Description = "See-through window background", Range = {0, 0.7}, Increment = 0.05, CurrentValue = 0, Flag = "vf_alpha", Callback = function(v) win:SetTransparency(v) end}) 		ui:CreateToggle({Name = "Background Blur", Description = "Blurs the game behind the window", CurrentValue = win.BlurOn, Flag = "vf_blur", Callback = function(v) win:SetBlur(v) end}) 		ui:CreateToggle({Name = "Notifications", Description = "Shows pop-up notifications", CurrentValue = true, Flag = "vf_notify", Callback = function(v) win:SetNotifications(v) end}) 		ui:CreateButton({Name = "Reset Window Position", Description = "Centers the window again", ButtonText = "RESET", Callback = function() win:ResetPosition() end}) 		local ed = tab:CreateSection("THEME EDITOR") 		ed:SetCollapsed(true) 		for _, k in ipairs({"Background", "Panel", "Raised", "Text", "Muted", "Line"}) do 			ed:CreateColorPicker({Name = k, CurrentValue = COLORS[k], Flag = "vf_col_" .. k, IgnoreConfig = true, Callback = function(c) VField:SetColor(k, c) end}) 		end 		ed:CreateButton({Name = "Reset Theme Colors", ButtonText = "RESET", Callback = function() VField:SetTheme(currentTheme) if win.AutoSave then win:QueueSave() end end}) 		local snds = tab:CreateSection("SOUNDS") 		snds:CreateToggle({Name = "UI Sounds", Description = "Click, toggle, tab and notification sounds", CurrentValue = true, Flag = "vf_sounds", Callback = function(v) win:SetSounds(v) end}) 		snds:CreateSlider({Name = "UI Volume", Range = {0, 2}, Increment = 0.1, CurrentValue = 1, Suffix = "x", Flag = "vf_volume", Callback = function(v) win:SetVolume(v) end}) 		local hud = tab:CreateSection("OVERLAYS") 		local wm, kl 		hud:CreateToggle({Name = "Watermark", Description = "Name, FPS, ping and clock. Drag it anywhere", CurrentValue = false, Flag = "vf_watermark", 			Callback = function(v) wm = wm or win:CreateWatermark({Visible = false}) wm.SetVisible(v) end}) 		hud:CreateToggle({Name = "Keybind List", Description = "Shows every bound key and what is active", CurrentValue = false, Flag = "vf_keylist", 			Callback = function(v) kl = kl or win:CreateKeybindList() kl.SetVisible(v) end}) 		local cfgSec = tab:CreateSection("CONFIGS") 		if not canFS then cfgSec:CreateLabel({Title = "No file access", Content = "Your executor has no writefile/readfile. Export and Import still work through the clipboard."}) end 		local name, dd = "default", nil 		cfgSec:CreateInput({Name = "Config Name", Description = "Letters, numbers, - and _", CurrentValue = name, IgnoreConfig = true, Callback = function(t) if t ~= "" then name = t end end}) 		dd = cfgSec:CreateDropdown({Name = "Saved Configs", Options = win:ListConfigs(), IgnoreConfig = true, Callback = function(v) if v then name = v end end}) 		cfgSec:CreateButton({Name = "Save Config", ButtonText = "SAVE", Callback = function() 			local ok = win:SaveConfig(name) 			dd.Refresh(win:ListConfigs(), true) 			win:Notify({Title = "Config", Content = ok and ("Saved '" .. name .. "'.") or "Could not save.", Kind = ok and "success" or "error"}) 		end}) 		cfgSec:CreateButton({Name = "Load Config", ButtonText = "LOAD", Callback = function() 			local ok = win:LoadConfig(name) 			win:Notify({Title = "Config", Content = ok and ("Loaded '" .. name .. "'.") or "No such config.", Kind = ok and "success" or "warn"}) 		end}) 		cfgSec:CreateButton({Name = "Delete Config", ButtonText = "DELETE", Confirm = true, Callback = function() 			local ok = win:DeleteConfig(name) 			dd.Refresh(win:ListConfigs()) 			win:Notify({Title = "Config", Content = ok and ("Deleted '" .. name .. "'.") or "Nothing deleted.", Kind = ok and "success" or "warn"}) 		end}) 		cfgSec:CreateButton({Name = "Set As Auto-Load", Description = "Base config loaded first; your last session is restored on top of it", ButtonText = "SET", Callback = function() 			local ok = win:SetAutoLoad(name) 			win:Notify({Title = "Config", Content = ok and ("'" .. name .. "' will auto-load.") or "Could not write.", Kind = ok and "success" or "error"}) 		end}) 		cfgSec:CreateButton({Name = "Export To Clipboard", ButtonText = "COPY", Callback = function() 			local ok = pcall(function() setclipboard(win:ExportConfig()) end) 			win:Notify({Title = "Config", Content = ok and "Copied to clipboard." or "Clipboard unsupported.", Kind = ok and "success" or "warn"}) 		end}) 		cfgSec:CreateInput({Name = "Import Config", Description = "Paste exported config text, then press Enter", PlaceholderText = "Paste JSON", IgnoreConfig = true, ClearAfter = true, 			Callback = function(t, enter) 				if not enter or t == "" then return end 				local ok = win:ImportConfig(t) 				win:Notify({Title = "Config", Content = ok and "Imported." or "Invalid config text.", Kind = ok and "success" or "error"}) 			end}) 		if o.Utilities ~= false then 			local ut = tab:CreateSection("UTILITIES") 			local afk = true 			conn(lp.Idled:Connect(function() 				if not afk then return end 				pcall(function() 					local vu = game:GetService("VirtualUser") 					vu:CaptureController() 					vu:ClickButton2(Vector2.new()) 				end) 			end)) 			ut:CreateToggle({Name = "Anti-AFK", Description = "Stops Roblox from kicking you for idling", CurrentValue = true, Flag = "vf_antiafk", Callback = function(v) afk = v end}) 			ut:CreateButton({Name = "Rejoin Server", ButtonText = "REJOIN", Confirm = true, Callback = function() 				pcall(function() 					local TS = game:GetService("TeleportService") 					if #Players:GetPlayers() <= 1 then TS:Teleport(game.PlaceId, lp) else TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end 				end) 			end}) 			ut:CreateButton({Name = "Copy Job ID", ButtonText = "COPY", Callback = function() pcall(function() setclipboard(game.JobId) end) win:Notify({Title = "Copied", Content = "Job ID copied.", Kind = "success"}) end}) 			ut:CreateButton({Name = "Copy Place ID", ButtonText = "COPY", Callback = function() pcall(function() setclipboard(tostring(game.PlaceId)) end) win:Notify({Title = "Copied", Content = "Place ID copied.", Kind = "success"}) end}) 		end 		local about = tab:CreateSection("ABOUT") 		about:CreateLabel({Title = (cfg.Name or "V Field") .. " - V Field Library v" .. VField.Version, 			Content = "Right-click (PC) a bindable switch to set its key. Search finds any option. Tap a section title to collapse it. Drag the window edge corner to resize."}) 		about:CreateButton({Name = "Reset All Settings", Description = "Deletes the saved session and goes back to Mono defaults", ButtonText = "RESET", Confirm = true, Callback = function() win:ResetSettings() end}) 		about:CreateButton({Name = "Unload", Description = "Removes the menu and everything it created", ButtonText = "UNLOAD", Confirm = true, Callback = function() VField:Unload() end}) 		return tab 	end 	function win:Destroy() 		if self.Destroyed then return end 		self.Destroyed, dead, rainbowOn = true, true, false 		for _, fn in ipairs(self.DestroyFns) do pcall(fn) end 		for _, c in ipairs(self.Conns) do pcall(function() c:Disconnect() end) end 		pcall(function() tween(blur, 0.2, {Size = 0}) task.delay(0.25, function() blur:Destroy() end) end) 		screen:Destroy() 		if VField.Window == self then VField.Window = nil end 	end 	VField.Window = win 	if type(cfg.Discord) == "table" and cfg.Discord.Enabled and cfg.Discord.Invite then
		task.spawn(function()
			local code = (tostring(cfg.Discord.Invite):gsub("^https?://discord%.gg/", ""))
			local mark = win.Folder .. "/discord_" .. code:gsub("[^%w]", "") .. ".txt"
			if cfg.Discord.RememberJoins ~= false and fsRead(mark) then return end
			repeat task.wait(0.2) until win.Open or win.Destroyed
			if win.Destroyed then return end
			task.wait(0.8)
			win:Dialog({Title = cfg.Discord.Title or "Join our Discord", Content = "discord.gg/" .. code, Buttons = {
				{Name = "Later"},
				{Name = "Copy", Callback = function()
					pcall(function() setclipboard("https://discord.gg/" .. code) end)
					win:Notify({Title = "Discord", Content = "Invite copied to clipboard.", Kind = "success"})
				end},
				{Name = "Join", Primary = true, Callback = function()
					local req = (syn and syn.request) or request or http_request or (http and http.request)
					if req then
						pcall(req, {Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", Origin = "https://discord.com"},
							Body = HttpService:JSONEncode({cmd = "INVITE_BROWSER", args = {code = code}, nonce = HttpService:GenerateGUID(false)})})
					end
					pcall(function() setclipboard("https://discord.gg/" .. code) end)
					if cfg.Discord.RememberJoins ~= false then fsWrite(mark, "1") end
				end},
			}})
		end)
	end
	task.spawn(function()
		if cfg.LoadingScreen == false then win.Toggle(true) return end
		local steps = cfg.LoadingSteps or {{"Initializing core", 0.2}, {"Loading themes", 0.4}, {"Building interface", 0.65}, {"Applying settings", 0.85}, {"Finalizing", 1}}
		local tips = cfg.LoadingTips or {"Right-click a toggle to bind a key.", "Press Ctrl+K for the command palette.", "Your settings save automatically.", "Drag the corner grip to resize the window.", "Try the FPS Boost tab on slow devices."}
		local function hex(c) return ("#%02x%02x%02x"):format(math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
		local skip = false
		local veil = make("Frame", {BackgroundColor3 = COLORS.Background, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.fromScale(1, 1), ZIndex = 30, Active = true}, screen)
		tween(veil, 0.35, {BackgroundTransparency = 0.04})
		-- soft vignette
		local vig = make("Frame", {BackgroundColor3 = COLORS.Soft, BackgroundTransparency = 0.82, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 30}, veil)
		make("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 1)})}, vig)
		-- rising particles (few on phones)
		for _ = 1, COMPACT and 6 or 14 do
			task.spawn(function()
				local s = math.random(2, 5)
				local p = make("Frame", {BackgroundColor3 = COLORS.Bright, BorderSizePixel = 0, BackgroundTransparency = 1, Size = UDim2.fromOffset(s, s), Position = UDim2.fromScale(0.5, 1.05), ZIndex = 30}, veil)
				task.wait(math.random() * 2)
				while p.Parent and not win.Destroyed do
					local x, dur = math.random(), math.random(45, 90) / 10
					p.Position = UDim2.fromScale(x, 1.05)
					p.BackgroundTransparency = 0.7
					tween(p, dur, {Position = UDim2.fromScale(x + (math.random() - 0.5) * 0.1, -0.05), BackgroundTransparency = 1}, Enum.EasingStyle.Linear)
					task.wait(dur)
				end
			end)
		end
		-- faint background grid
		for g = 1, COMPACT and 5 or 9 do
			local f = g / ((COMPACT and 5 or 9) + 1)
			make("Frame", {BackgroundColor3 = COLORS.Soft, BackgroundTransparency = 0.88, BorderSizePixel = 0, Position = UDim2.fromScale(0, f), Size = UDim2.new(1, 0, 0, 1), ZIndex = 30}, veil)
			make("Frame", {BackgroundColor3 = COLORS.Soft, BackgroundTransparency = 0.88, BorderSizePixel = 0, Position = UDim2.fromScale(f, 0), Size = UDim2.new(0, 1, 1, 0), ZIndex = 30}, veil)
		end
		local CW, CH = 380, 304
		local card = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = COLORS.Panel, BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = false,
			Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(CW - 40, CH - 40), ZIndex = 31}, veil)
		local cScale = make("UIScale", {Scale = math.clamp((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800) / 440, 0.6, 1)}, card)
		local cStroke = stroke(card, COLORS.Accent, 0.3, 1)
		local cGrad = make("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, rgb(60, 60, 60)), ColorSequenceKeypoint.new(0.5, COLORS.Bright), ColorSequenceKeypoint.new(1, rgb(60, 60, 60))})}, cStroke)
		loop(cGrad, 3, {Rotation = 360}, nil, nil, true)
		tween(card, 0.55, {Size = UDim2.fromOffset(CW, CH), BackgroundTransparency = 0}, Enum.EasingStyle.Back)
		-- top accent line
		local topLine = make("Frame", {BackgroundColor3 = COLORS.Bright, BorderSizePixel = 0, Size = UDim2.new(0, 0, 0, 2), ZIndex = 33}, card)
		tween(topLine, 0.8, {Size = UDim2.new(1, 0, 0, 2)})
		-- corner brackets
		for _, c in ipairs({{0, 0}, {1, 0}, {0, 1}, {1, 1}}) do
			local ax, ay = c[1], c[2]
			local hz = make("Frame", {AnchorPoint = Vector2.new(ax, ay), BackgroundColor3 = COLORS.Bright, BorderSizePixel = 0, Position = UDim2.fromScale(ax, ay), Size = UDim2.fromOffset(14, 2), ZIndex = 34}, card)
			local vt = make("Frame", {AnchorPoint = Vector2.new(ax, ay), BackgroundColor3 = COLORS.Bright, BorderSizePixel = 0, Position = UDim2.fromScale(ax, ay), Size = UDim2.fromOffset(2, 14), ZIndex = 34}, card)
		end
		-- counter-rotating rings behind the logo
		for r = 1, 2 do
			local ring = make("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0, 49), Size = UDim2.fromOffset(r == 1 and 74 or 66, r == 1 and 74 or 66), Rotation = r == 1 and 0 or 45, ZIndex = 31}, card)
			local rs = stroke(ring, r == 1 and COLORS.Accent or COLORS.Bright, r == 1 and 0.55 or 0.75, 1)
			loop(ring, r == 1 and 7 or 5, {Rotation = r == 1 and 360 or -315}, Enum.EasingStyle.Linear, false, true)
		end
		-- logo
		local logoBox = make("Frame", {AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0, 22), Size = UDim2.fromOffset(54, 54), ZIndex = 32}, card)
		local lStroke = stroke(logoBox, COLORS.Bright, 0.15, 2)
		local ico = tostring(cfg.Icon or string.sub(cfg.Name or "V", 1, 1))
		if ico:find("rbxassetid") or ico:match("^%d+$") then
			make("ImageLabel", {BackgroundTransparency = 1, Image = ico:match("^%d+$") and ("rbxassetid://" .. ico) or ico, Size = UDim2.fromScale(1, 1), ZIndex = 33}, logoBox)
		else
			local lt = T(logoBox, string.upper(string.sub(ico, 1, 2)), 26, COLORS.Text, FONT_HEAVY, UDim2.new(), UDim2.fromScale(1, 1))
			lt.TextXAlignment, lt.ZIndex = Enum.TextXAlignment.Center, 33
		end
		loop(lStroke, 0.9, {Transparency = 0.7}, Enum.EasingStyle.Sine, true, true)
		-- title / subtitle / version
		local title = T(card, "", 22, COLORS.Text, FONT_HEAVY, UDim2.new(0, 0, 0, 86), UDim2.new(1, 0, 0, 30))
		title.TextXAlignment, title.ZIndex = Enum.TextXAlignment.Center, 32
		local lsub = T(card, cfg.LoadingSubtitle or cfg.Subtitle or "Preparing your interface", 11, COLORS.Muted, FONT, UDim2.new(0, 0, 0, 116), UDim2.new(1, 0, 0, 16))
		lsub.TextXAlignment, lsub.ZIndex = Enum.TextXAlignment.Center, 32
		local ver = T(card, "v" .. tostring(VField.Version) .. "  |  " .. (COMPACT and "MOBILE" or "DESKTOP") .. "  |  WELCOME, " .. string.upper(lp.DisplayName), 9, COLORS.Bright, FONT_BOLD, UDim2.new(0, 0, 0, 134), UDim2.new(1, 0, 0, 14))
		ver.TextXAlignment, ver.ZIndex = Enum.TextXAlignment.Center, 32
		-- progress bar with moving shine
		local track = make("Frame", {BackgroundColor3 = COLORS.Raised, BorderSizePixel = 0, ClipsDescendants = true, Position = UDim2.fromOffset(26, 160), Size = UDim2.new(1, -52, 0, 6), ZIndex = 32}, card)
		local fill = make("Frame", {BackgroundColor3 = COLORS.Bright, BorderSizePixel = 0, Size = UDim2.new(0.03, 0, 1, 0), ZIndex = 33, ClipsDescendants = true}, track)
		local shine = make("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.35, BorderSizePixel = 0, Size = UDim2.fromScale(0.5, 1), ZIndex = 34}, fill)
		local sg = make("UIGradient", {Offset = Vector2.new(-1, 0), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})}, shine)
		loop(sg, 0.9, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear, false, true)
		for t = 1, 9 do make("Frame", {BackgroundColor3 = COLORS.Panel, BorderSizePixel = 0, Position = UDim2.new(t / 10, -1, 0, 0), Size = UDim2.fromOffset(2, 6), ZIndex = 35}, track) end
		local stage = T(card, "STARTING", 9, COLORS.Muted, FONT_BOLD, UDim2.fromOffset(26, 172), UDim2.new(1, -110, 0, 16))
		stage.ZIndex = 32
		local pct = T(card, "0%", 14, COLORS.Bright, FONT_HEAVY, UDim2.new(1, -96, 0, 168), UDim2.fromOffset(70, 20))
		pct.ZIndex, pct.TextXAlignment = 32, Enum.TextXAlignment.Right
		-- checklist log
		local logL = T(card, "", 10, COLORS.Muted, Enum.Font.Code, UDim2.fromOffset(26, 192), UDim2.new(1, -52, 0, 42))
		logL.RichText, logL.TextYAlignment, logL.ZIndex = true, Enum.TextYAlignment.Top, 32
		-- system info panel
		local exec = "Unknown"
		pcall(function() if identifyexecutor then exec = tostring((identifyexecutor())) end end)
		local ac = hex(COLORS.Bright)
		local infoL = T(card, "", 9, COLORS.Muted, Enum.Font.Code, UDim2.fromOffset(26, 238), UDim2.new(1, -52, 0, 28))
		infoL.RichText, infoL.TextYAlignment, infoL.ZIndex = true, Enum.TextYAlignment.Top, 32
		local gname = tostring(game.Name ~= "" and game.Name or game.PlaceId)
		if #gname > 22 then gname = gname:sub(1, 21) .. "..." end
		infoL.Text = ('<font color="%s">USER</font> %s   <font color="%s">EXEC</font> %s\n<font color="%s">GAME</font> %s   <font color="%s">PING</font> %s'):format(ac, lp.Name, ac, exec, ac, gname, ac, "...")
		task.spawn(function()
			task.wait(0.4)
			local p = 0 pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			if infoL.Parent then infoL.Text = ('<font color="%s">USER</font> %s   <font color="%s">EXEC</font> %s\n<font color="%s">GAME</font> %s   <font color="%s">PING</font> %d ms'):format(ac, lp.Name, ac, exec, ac, gname, ac, p) end
		end)
		-- tip + skip
		local tip = T(card, "", 9, COLORS.Muted, FONT, UDim2.fromOffset(26, 276), UDim2.new(1, -140, 0, 16))
		tip.ZIndex, tip.TextTruncate = 32, Enum.TextTruncate.AtEnd
		local skipBtn = make("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Font = FONT_BOLD, Text = "SKIP", TextColor3 = COLORS.Muted, TextSize = 9,
			Position = UDim2.new(1, -86, 0, 276), Size = UDim2.fromOffset(60, 16), TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 35}, card)
		skipBtn.MouseButton1Click:Connect(function() skip = true playSound("Click", 0.8) end)
		playSound("Open", 0.8, 1.2)
		local word = cfg.LoadingTitle or string.upper(cfg.Name or "V FIELD")
		for i = 1, #word do
			if win.Destroyed then return end
			title.Text = word:sub(1, i)
			playSound("Tick", 0.4, 1.4 + i * 0.05)
			task.wait(skip and 0 or 0.04)
		end
		local prog, lines = 0, {}
		local function setProg(x) prog = x fill.Size = UDim2.new(math.max(x, 0.03), 0, 1, 0) pct.Text = ("%d%%"):format(math.floor(x * 100)) end
		for si, step in ipairs(steps) do
			if win.Destroyed then return end
			stage.Text = string.upper(step[1])
			tip.Text = "TIP  " .. tips[(si - 1) % #tips + 1]
			playSound("Tick", 0.8, 0.9 + si * 0.1)
			local from, to, dur, t0 = prog, step[2], skip and 0.01 or (0.22 + math.random() * 0.25), os.clock()
			while not win.Destroyed do
				local a = math.clamp((os.clock() - t0) / dur, 0, 1)
				setProg(from + (to - from) * (1 - (1 - a) ^ 3))
				stage.Text = string.upper(step[1]) .. string.rep(".", math.floor(os.clock() * 3) % 4)
				if a >= 1 or skip then break end
				task.wait()
			end
			if skip then setProg(to) end
			lines[#lines + 1] = ('<font color="%s">[ OK ]</font> %s'):format(hex(COLORS.Bright), step[1])
			while #lines > 3 do table.remove(lines, 1) end
			logL.Text = table.concat(lines, "\n")
			if si == #steps - 1 then
				local w0 = os.clock()
				while not win.IsReady and os.clock() - w0 < 3 and not win.Destroyed do task.wait(0.05) end
			end
		end
		if win.Destroyed then return end
		setProg(1)
		stage.Text, stage.TextColor3 = "READY", COLORS.Bright
		tip.Text = "Press " .. tostring(win.ToggleKey and win.ToggleKey.Name or "RightControl") .. " to hide or show the menu"
		playSound("Success", 1, 1.0)
		-- flash wipe
		local wipe = make("Frame", {BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.6, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0), ZIndex = 36}, card)
		tween(wipe, 0.35, {Size = UDim2.new(1, 0, 1, 0)})
		task.wait(0.3)
		tween(wipe, 0.25, {BackgroundTransparency = 1})
		task.wait(skip and 0.05 or 0.3)
		tween(veil, 0.45, {BackgroundTransparency = 1})
		tween(vig, 0.45, {BackgroundTransparency = 1})
		tween(card, 0.35, {Size = UDim2.fromOffset(CW + 30, 0), BackgroundTransparency = 1}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		for _, d in ipairs(card:GetDescendants()) do
			if d:IsA("TextLabel") or d:IsA("TextButton") then tween(d, 0.25, {TextTransparency = 1})
			elseif d:IsA("ImageLabel") then tween(d, 0.25, {ImageTransparency = 1})
			elseif d:IsA("Frame") then tween(d, 0.25, {BackgroundTransparency = 1})
			elseif d:IsA("UIStroke") then tween(d, 0.25, {Transparency = 1}) end
		end
		task.wait(0.45)
		if veil.Parent then veil:Destroy() end
		if not win.Destroyed then win.Toggle(true) end
	end)
		
		-- ============================================================
	-- V FIELD ULTIMATE: window features
	-- ============================================================
	do
		-- live metrics + timers ---------------------------------------------
		local fpsV, startClock = 60, os.clock()
		conn(RunService.Heartbeat:Connect(function(dt) fpsV = fpsV * 0.9 + (1 / math.max(dt, 0.001)) * 0.1 end))
		function win:GetFPS() return fpsV end
		win.Metrics = {
			fps = {Get = function() return math.floor(fpsV + 0.5) end, Format = function(v) return v .. " FPS" end},
			ping = {Get = function() local p = 0 pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end) return p end, Format = function(v) return v .. " ms" end},
			memory = {Get = function() local m = 0 pcall(function() m = math.floor(Stats:GetTotalMemoryUsageMb()) end) return m end, Format = function(v) return v .. " MB" end},
			players = {Get = function() return #Players:GetPlayers() end, Format = function(v) return v .. " / " .. tostring(Players.MaxPlayers) end},
			uptime = {Get = function() return math.floor(os.clock() - startClock) end,
				Format = function(v) return string.format("%02d:%02d:%02d", math.floor(v / 3600), math.floor((v % 3600) / 60), v % 60) end},
			time = {Get = function() return os.time() end, Format = function(v) return os.date("%H:%M:%S", v) end},
		}
		function win:AddMetric(name, getFn, formatFn)
			self.Metrics[tostring(name):lower()] = {Get = getFn, Format = formatFn}
		end
		function win:Every(sec, fn, runNow)
			local alive = true
			task.spawn(function()
				if runNow ~= false then pcall(fn) end
				while alive and not win.Destroyed do
					task.wait(math.max(tonumber(sec) or 1, 0.03))
					if alive and not win.Destroyed then pcall(fn) end
				end
			end)
			return {Stop = function() alive = false end}
		end
		function win:After(sec, fn)
			local alive = true
			task.delay(tonumber(sec) or 0, function() if alive and not win.Destroyed then pcall(fn) end end)
			return {Cancel = function() alive = false end}
		end
		function win:Connect(signal, fn)
			local c = signal:Connect(fn)
			conn(c)
			return c
		end

		-- flag API -------------------------------------------------------------
		win.FlagListeners, win.AnyFlagListeners = {}, {}
		function win:OnFlag(flag, fn)
			local l = self.FlagListeners[flag]
			if not l then l = {} self.FlagListeners[flag] = l end
			l[#l + 1] = fn
			return {Disconnect = function() for i, f in ipairs(l) do if f == fn then table.remove(l, i) break end end end}
		end
		function win:OnAnyFlag(fn)
			local l = self.AnyFlagListeners
			l[#l + 1] = fn
			return {Disconnect = function() for i, f in ipairs(l) do if f == fn then table.remove(l, i) break end end end}
		end
		function win:SetFlag(flag, v)
			local r = self.Registry[flag]
			if r then pcall(r.Set, v) return true end
			return false
		end
		function win:GetFlag(flag) return self.Flags[flag] end
		function win:ResetFlag(flag)
			local r = self.Registry[flag]
			if r and r.Default ~= nil then pcall(r.Set, r.Default) return true end
			return false
		end
		function win:ResetAll()
			for flag, r in pairs(self.Registry) do
				if not flag:find("^vf_") and r.Default ~= nil and not r.Session then pcall(r.Set, r.Default) end
			end
		end
		function win:GetFlags()
			local t = {}
			for flag, r in pairs(self.Registry) do
				if not flag:find("^vf_") then
					local ok, v = pcall(r.Get)
					if ok then t[flag] = v end
				end
			end
			return t
		end
		function win:BulkSet(tbl)
			for k, v in pairs(tbl or {}) do self:SetFlag(k, v) end
		end

		-- highlight / jump to an element ---------------------------------------
		local function locate(target)
			local row
			if type(target) == "string" then
				local el = win.Elements[target]
				row = el and el.Row
			elseif type(target) == "table" then
				row = target.Row or target.row
			elseif typeof(target) == "Instance" then
				row = target
			end
			if not row then return end
			for _, tab in ipairs(win.Tabs) do
				for _, sec in ipairs(tab.Sections) do
					for _, r in ipairs(sec.Rows) do
						if r.row == row then return tab, sec, row end
					end
				end
			end
		end
		function win:Highlight(target, noScroll)
			local tab, sec, row = locate(target)
			if not row then return false end
			if not win.Open then win.Toggle(true) end
			if win.ActiveTab ~= tab then tab.Select() end
			if sec.Collapsed then sec:SetCollapsed(false) end
			task.delay(0.08, function()
				if not row.Parent then return end
				if not noScroll then
					local pg = tab.Page
					local dy = row.AbsolutePosition.Y - pg.AbsolutePosition.Y
					pg.CanvasPosition = Vector2.new(0, math.max(0, pg.CanvasPosition.Y + dy / math.max(win.CurScale, 0.01) - 30))
				end
				for _ = 1, 3 do
					if not row.Parent then return end
					tween(row, 0.18, {BackgroundColor3 = COLORS.Soft})
					task.wait(0.2)
					tween(row, 0.25, {BackgroundColor3 = COLORS.Raised})
					task.wait(0.28)
				end
			end)
			return true
		end

		-- notification history ---------------------------------------------------
		win.NotifyHistory, win.NotifyListeners = {}, {}
		local baseNotify = win.Notify
		function win:Notify(c)
			c = c or {}
			local rec = {Title = c.Title, Content = c.Content, Kind = c.Kind or "info", Time = os.time()}
			local h = win.NotifyHistory
			h[#h + 1] = rec
			if #h > 100 then table.remove(h, 1) end
			for _, fn in ipairs(win.NotifyListeners) do task.spawn(fn, rec) end
			return baseNotify(self, c)
		end
		function win:OnNotify(fn) self.NotifyListeners[#self.NotifyListeners + 1] = fn end
		function win:GetNotificationHistory()
			local out = {}
			for i, r in ipairs(self.NotifyHistory) do out[i] = r end
			return out
		end
		function win:ClearNotificationHistory() self.NotifyHistory = {} end

		-- hotkeys ------------------------------------------------------------------
		local function toKey(k)
			if typeof(k) == "string" then
				local ok, kk = pcall(function() return Enum.KeyCode[k] end)
				return ok and kk or nil
			end
			return k
		end
		function win:AddHotkey(key, fn, name)
			key = toKey(key)
			local entry = {Value = function() return key end, Callback = function() task.spawn(fn) end}
			local bind = {Name = tostring(name or "Hotkey"), Key = function() return key end, Active = function() return false end}
			table.insert(self.Keybinds, entry)
			table.insert(self.Binds, bind)
			local h = {}
			function h.SetKey(k2) key = toKey(k2) end
			function h.GetKey() return key end
			function h.Remove()
				key = nil
				for i, e in ipairs(win.Keybinds) do if e == entry then table.remove(win.Keybinds, i) break end end
				for i, b in ipairs(win.Binds) do if b == bind then table.remove(win.Binds, i) break end end
			end
			return h
		end
		function win:ShowKeybinds()
			local lines, shown = {}, 0
			for _, b in ipairs(self.Binds) do
				local k = b.Key and b.Key()
				if k then
					shown = shown + 1
					if shown <= 14 then lines[#lines + 1] = string.format("%s   [%s]", tostring(b.Name), k.Name) end
				end
			end
			lines[#lines + 1] = string.format("Menu   [%s]", self.ToggleKey and self.ToggleKey.Name or "None")
			if shown > 14 then lines[#lines + 1] = "+" .. (shown - 14) .. " more" end
			self:Dialog({Title = "Keybinds", Content = table.concat(lines, "\n"), Buttons = {{Name = "Close", Primary = true}}})
		end

		-- dialog helpers -------------------------------------------------------------
		function win:Confirm(title, content, onYes, onNo)
			self:Dialog({Title = title, Content = content, Buttons = {{Name = "No", Callback = onNo}, {Name = "Yes", Primary = true, Callback = onYes}}})
		end
		function win:Alert(title, content, onClose)
			self:Dialog({Title = title, Content = content, Buttons = {{Name = "OK", Primary = true, Callback = onClose}}})
		end
		function win:Choice(title, content, options, cb)
			local btns = {{Name = "Cancel"}}
			for _, o in ipairs(options or {}) do
				btns[#btns + 1] = {Name = tostring(o), Primary = #btns == 1, Callback = function() if cb then cb(o) end end}
			end
			self:Dialog({Title = title, Content = content, Buttons = btns})
		end
		function win:Tour(steps, onDone)
			steps = steps or {}
			local i = 1
			local function show()
				local st = steps[i]
				if not st then if onDone then pcall(onDone) end return end
				if st.Tab then win:SelectTab(st.Tab) end
				if st.Flag or st.Target then win:Highlight(st.Flag or st.Target) end
				local btns = {{Name = "Skip"}}
				if i > 1 then btns[#btns + 1] = {Name = "Back", Callback = function() i = i - 1 show() end} end
				btns[#btns + 1] = {Name = i == #steps and "Done" or "Next", Primary = true, Callback = function() i = i + 1 show() end}
				win:Dialog({Title = string.format("%s  (%d/%d)", st.Title or "Step", i, #steps), Content = st.Text or st.Content or "", Buttons = btns})
			end
			show()
		end

		-- config extras ----------------------------------------------------------------
		function win:ConfigExists(name) return fsRead(cfgPath(name)) ~= nil end
		function win:DuplicateConfig(from, to)
			local d = fsRead(cfgPath(from))
			if not d then return false end
			return fsWrite(cfgPath(to), d)
		end
		function win:RenameConfig(old, new)
			if self:DuplicateConfig(old, new) then self:DeleteConfig(old) return true end
			return false
		end
		function win:CopyConfig()
			return (pcall(function() setclipboard(self:ExportConfig()) end))
		end
		function win:PasteConfig()
			local ok, s = pcall(function() return getclipboard() end)
			if ok and type(s) == "string" then return self:ImportConfig(s) end
			return false
		end

		-- window movement / attention ----------------------------------------------------
		function win:Shake(power)
			power = tonumber(power) or 8
			local base = main.Position
			task.spawn(function()
				for i = 1, 8 do
					if win.Destroyed then return end
					local d = (i % 2 == 0 and 1 or -1) * power * (1 - i / 9)
					main.Position = UDim2.new(base.X.Scale, base.X.Offset + d, base.Y.Scale, base.Y.Offset)
					task.wait(0.03)
				end
				main.Position = base
			end)
		end
		function win:Snap(where)
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
			local sz = main.AbsoluteSize
			local m = 14
			local w2, h2 = sz.X / 2, sz.Y / 2
			local map = {
				topleft = {m + w2, m + h2}, topright = {vp.X - m - w2, m + h2}, bottomleft = {m + w2, vp.Y - m - h2}, bottomright = {vp.X - m - w2, vp.Y - m - h2},
				center = {vp.X / 2, vp.Y / 2}, top = {vp.X / 2, m + h2}, bottom = {vp.X / 2, vp.Y - m - h2}, left = {m + w2, vp.Y / 2}, right = {vp.X - m - w2, vp.Y / 2},
			}
			local key = tostring(where or "center"):lower():gsub("[%s_%-]", "")
			local p = map[key]
			if not p then return false end
			tween(main, 0.3, {Position = UDim2.fromOffset(p[1], p[2])})
			if win.AutoSave then win:QueueSave() end
			return true
		end
	end
	do
		local function toKey(k)
			if typeof(k) == "string" then
				local ok, kk = pcall(function() return Enum.KeyCode[k] end)
				return ok and kk or nil
			end
			return k
		end
		-- context menu ---------------------------------------------------------------
		function win:ContextMenu(items, pos)
			if self.Destroyed or type(items) ~= "table" then return end
			pos = pos or lastPointer
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
			local veil = make("TextButton", {AutoButtonColor = false, Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 340}, screen)
			local menu = make("Frame", {BorderSizePixel = 0, BackgroundColor3 = COLORS.Panel, Size = UDim2.fromOffset(180, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 341}, screen)
			stroke(menu, COLORS.Accent, 0.4, 1)
			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, menu)
			make("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)}, menu)
			local function close() veil:Destroy() menu:Destroy() end
			veil.MouseButton1Click:Connect(close)
			veil.MouseButton2Click:Connect(close)
			local est = 6
			for i, it in ipairs(items) do
				if it == "-" then
					est = est + 5
					local sep = make("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 5), LayoutOrder = i, ZIndex = 342}, menu)
					make("Frame", {BorderSizePixel = 0, BackgroundColor3 = COLORS.Line, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -16, 0, 1), ZIndex = 343}, sep)
				else
					est = est + 28
					local disabled = it.Disabled == true
					local col = disabled and COLORS.Muted or (it.Danger and STATUS.error or COLORS.Text)
					local b = make("TextButton", {AutoButtonColor = false, BackgroundColor3 = COLORS.Panel, BorderSizePixel = 0, Font = FONT_BOLD, Text = tostring(it.Name or "Item"),
						TextSize = 11, TextColor3 = col, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = i, ZIndex = 342}, menu)
					make("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 10)}, b)
					if not disabled then
						b.MouseEnter:Connect(function() tween(b, 0.1, {BackgroundColor3 = COLORS.Soft}) end)
						b.MouseLeave:Connect(function() tween(b, 0.12, {BackgroundColor3 = COLORS.Panel}) end)
						b.MouseButton1Click:Connect(function()
							playSound("Click")
							close()
							if it.Callback then task.spawn(it.Callback) end
						end)
					end
				end
			end
			menu.Position = UDim2.fromOffset(math.clamp(pos.X, 4, math.max(vp.X - 184, 4)), math.clamp(pos.Y, 4, math.max(vp.Y - est - 4, 4)))
			playSound("Expand", 0.6)
			return {Close = close}
		end

		-- command palette (Ctrl+K) -----------------------------------------------------
		local palette = {Open = false, Enabled = true, Key = Enum.KeyCode.K, Commands = {}}
		win.Palette = palette
		function win:AddCommand(c)
			c = c or {}
			table.insert(palette.Commands, c)
			return c
		end
		local pveil, pcard, pbox, plist
		local pitems, psel = {}, 1
		local function closePalette()
			palette.Open = false
			if pveil then pveil.Visible = false end
			if pcard then pcard.Visible = false end
			if pbox then pbox:ReleaseFocus() end
		end
		local function themeCommands()
			local out = {}
			for _, t in ipairs(VField:GetThemes()) do
				out[#out + 1] = {Name = "Theme: " .. t, Sub = "Command", Run = function()
					if t == "Rainbow" then VField:SetRainbow(true) else VField:SetRainbow(false) VField:SetTheme(t) end
				end}
			end
			return out
		end
		local function builtinCommands()
			return {
				{Name = "Reset window position", Sub = "Command", Run = function() win:ResetPosition() end},
				{Name = "Show keybinds", Sub = "Command", Run = function() win:ShowKeybinds() end},
				{Name = "Reset all settings to defaults", Sub = "Command", Run = function() win:Confirm("Reset all?", "Every setting goes back to its default value.", function() win:ResetAll() end) end},
				{Name = "Unload V Field", Sub = "Command", Run = function() win:Confirm("Unload?", "This closes the menu completely.", function() VField:Unload() end) end},
			}
		end
		local function gather(q)
			q = (q or ""):lower()
			local res = {}
			local function match(text)
				for tok in q:gmatch("%S+") do if not text:find(tok, 1, true) then return false end end
				return true
			end
			local function score(name)
				local n = name:lower()
				if q == "" then return 1 end
				if n:sub(1, #q) == q then return 3 end
				if n:find(q, 1, true) then return 2 end
				return 1
			end
			for _, tab in ipairs(win.Tabs) do
				if tab.Button.Visible then
					local nm = "Go to " .. tab.Name
					if match(nm:lower()) then res[#res + 1] = {Name = nm, Sub = "Tab", Score = score(tab.Name), Run = function() tab.Select() end} end
					for _, sec in ipairs(tab.Sections) do
						for _, r in ipairs(sec.Rows) do
							if r.title and r.title ~= "" and not r.hidden then
								local hay = r.key .. " " .. tab.Name:lower()
								if match(hay) then
									res[#res + 1] = {Name = r.title, Sub = tab.Name, Score = score(r.title), Run = function() win:Highlight(r.row) end}
								end
							end
						end
					end
				end
			end
			local cmds = {}
			for _, c in ipairs(themeCommands()) do cmds[#cmds + 1] = c end
			for _, c in ipairs(builtinCommands()) do cmds[#cmds + 1] = c end
			for _, c in ipairs(palette.Commands) do
				cmds[#cmds + 1] = {Name = tostring(c.Name or "Command"), Sub = c.Sub or "Command", Run = c.Callback or c.Run or function() end, Description = c.Description}
			end
			for _, c in ipairs(cmds) do
				if match((c.Name .. " " .. (c.Description or "")):lower()) then
					c.Score = score(c.Name)
					res[#res + 1] = c
				end
			end
			table.sort(res, function(a, b)
				if a.Score ~= b.Score then return a.Score > b.Score end
				return a.Name < b.Name
			end)
			while #res > 40 do table.remove(res) end
			return res
		end
		local function paintSel()
			if not plist then return end
			for _, b in ipairs(plist:GetChildren()) do
				if b:IsA("TextButton") then
					b.BackgroundColor3 = b.LayoutOrder == psel and COLORS.Soft or COLORS.Raised
				end
			end
			local y = (psel - 1) * 31
			local top, h = plist.CanvasPosition.Y, plist.AbsoluteSize.Y / math.max(win.CurScale, 0.01)
			if y < top then plist.CanvasPosition = Vector2.new(0, y)
			elseif y + 30 > top + h then plist.CanvasPosition = Vector2.new(0, y + 30 - h) end
		end
		local function runItem(i)
			local it = pitems[i]
			if not it then return end
			closePalette()
			playSound("Click")
			task.defer(function() pcall(it.Run) end)
		end
		local function render()
			for _, c in ipairs(plist:GetChildren()) do if c:IsA("TextButton") or c.Name == "VFEmpty" then c:Destroy() end end
			pitems = gather(pbox.Text)
			psel = math.clamp(psel, 1, math.max(#pitems, 1))
			for i, it in ipairs(pitems) do
				local b = make("TextButton", {AutoButtonColor = false, BorderSizePixel = 0, BackgroundColor3 = COLORS.Raised, Text = "", Size = UDim2.new(1, 0, 0, 30), LayoutOrder = i, ZIndex = 322}, plist)
				local nm = T(b, it.Name, 11, COLORS.Text, FONT_BOLD, UDim2.fromOffset(10, 0), UDim2.new(1, -110, 1, 0))
				nm.ZIndex, nm.TextTruncate = 323, Enum.TextTruncate.AtEnd
				local sb = T(b, it.Sub or "", 9, COLORS.Muted, FONT, UDim2.new(1, -100, 0, 0), UDim2.fromOffset(90, 30))
				sb.ZIndex, sb.TextXAlignment, sb.TextTruncate = 323, Enum.TextXAlignment.Right, Enum.TextTruncate.AtEnd
				b.MouseEnter:Connect(function() psel = i paintSel() end)
				b.MouseButton1Click:Connect(function() runItem(i) end)
			end
			if #pitems == 0 then
				local e = make("TextLabel", {BackgroundTransparency = 1, Font = FONT, Text = "No results", TextSize = 11, TextColor3 = COLORS.Muted, Size = UDim2.new(1, 0, 0, 30), ZIndex = 323, LayoutOrder = 1}, plist)
				e.Name = "VFEmpty"
			end
			paintSel()
		end
		local function buildPalette()
			if pveil then return end
			pveil = make("TextButton", {AutoButtonColor = false, Text = "", BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.5, BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 300}, screen)
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
			local cw = math.clamp(vp.X - 24, 240, 420)
			pcard = P(make("Frame", {BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, math.max(vp.Y * 0.14, 30)),
				Size = UDim2.fromOffset(cw, 330), Visible = false, Active = true, ZIndex = 320}, screen), {BackgroundColor3 = "Background"})
			local cs = stroke(pcard, COLORS.Accent, 0.3, 1)
			hook(function() cs.Color = COLORS.Accent end)
			pbox = P(make("TextBox", {BorderSizePixel = 0, ClearTextOnFocus = false, Font = FONT_BOLD, TextSize = 13, PlaceholderText = "Search settings, tabs and commands...", Text = "",
				TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 34), ZIndex = 321}, pcard),
				{BackgroundColor3 = "Panel", TextColor3 = "Text", PlaceholderColor3 = "Muted"})
			make("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, pbox)
			plist = P(make("ScrollingFrame", {BorderSizePixel = 0, BackgroundTransparency = 1, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3,
				Position = UDim2.fromOffset(10, 52), Size = UDim2.new(1, -20, 1, -84), ZIndex = 321}, pcard), {ScrollBarImageColor3 = "Accent"})
			make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1)}, plist)
			local hint = T(pcard, "Up / Down to move   Enter to run   Esc to close", 9, "Muted", FONT, UDim2.new(0, 10, 1, -26), UDim2.new(1, -20, 0, 20))
			hint.ZIndex = 321
			pveil.MouseButton1Click:Connect(closePalette)
			pbox:GetPropertyChangedSignal("Text"):Connect(function() psel = 1 render() end)
			pbox.FocusLost:Connect(function(enter) if enter and palette.Open then runItem(psel) end end)
		end
		function win:OpenCommandPalette()
			if self.Destroyed then return end
			if not self.Open then self.Toggle(true) end
			buildPalette()
			palette.Open = true
			pveil.Visible, pcard.Visible = true, true
			pbox.Text = ""
			psel = 1
			render()
			playSound("Open", 0.6, 1.3)
			task.defer(function() pbox:CaptureFocus() end)
		end
		function win:CloseCommandPalette() closePalette() end
		function win:EnableCommandPalette(on) palette.Enabled = on ~= false if not palette.Enabled then closePalette() end end
		function win:SetCommandPaletteKey(k) palette.Key = toKey(k) or palette.Key end
		conn(UIS.InputBegan:Connect(function(input)
			if win.Destroyed then return end
			if palette.Open then
				if input.KeyCode == Enum.KeyCode.Down then psel = math.min(psel + 1, math.max(#pitems, 1)) paintSel()
				elseif input.KeyCode == Enum.KeyCode.Up then psel = math.max(psel - 1, 1) paintSel()
				elseif input.KeyCode == Enum.KeyCode.Escape then closePalette() end
				return
			end
			if palette.Enabled and win.Open and input.KeyCode == palette.Key and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then
				win:OpenCommandPalette()
			end
		end))
		win:OnToggle(function(open) if not open then closePalette() end end)
		local baseReady = win.Ready
		function win:Ready()
			baseReady(self)
			if cfg.CommandPalette == false then palette.Enabled = false end
		end
	end
	do
		-- tab extras ---------------------------------------------------------------------
		local baseCreateTab = win.CreateTab
		function win:CreateTab(name, icon)
			local tab = baseCreateTab(self, name, icon)
			local badge
			function tab:SetBadge(text, color)
				if text == nil or text == "" then
					if badge then badge:Destroy() badge = nil end
					return
				end
				if not badge then
					badge = make("Frame", {Name = "VFTabBadge", BorderSizePixel = 0, BackgroundTransparency = 0.15, Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, ZIndex = 8}, tab.Button)
					if COMPACT then
						badge.AnchorPoint, badge.Position = Vector2.new(1, 0), UDim2.new(1, -3, 0, 3)
					else
						badge.AnchorPoint, badge.Position = Vector2.new(1, 0.5), UDim2.new(1, -8, 0.5, 0)
					end
					make("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)}, badge)
					make("TextLabel", {Name = "T", BackgroundTransparency = 1, Font = FONT_HEAVY, TextSize = 8 + BOOST, TextColor3 = Color3.new(1, 1, 1),
						Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, ZIndex = 9}, badge)
				end
				local k = tostring(text):lower()
				local col = color
				if typeof(col) ~= "Color3" then
					if k == "beta" then col = STATUS.warn elseif k == "hot" or k == "risky" then col = STATUS.error elseif k == "safe" then col = STATUS.success else col = COLORS.Accent end
				end
				badge.BackgroundColor3 = col
				badge.T.Text = tostring(text)
				badge.T.TextColor3 = (col.R * 0.3 + col.G * 0.59 + col.B * 0.11) > 0.6 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
			end
			function tab:SetVisible(v)
				tab.Button.Visible = v ~= false
				if v == false and win.ActiveTab == tab then
					for _, o in ipairs(win.Tabs) do
						if o ~= tab and o.Button.Visible then o.Select() break end
					end
				end
			end
			function tab:SetName(n)
				tab.Name = tostring(n)
				tab.Label.Text = tostring(n)
			end
			function tab:Remove()
				for i, o in ipairs(win.Tabs) do if o == tab then table.remove(win.Tabs, i) break end end
				local wasActive = win.ActiveTab == tab
				tab.Button:Destroy()
				tab.Page:Destroy()
				if wasActive then
					win.ActiveTab = nil
					for _, o in ipairs(win.Tabs) do if o.Button.Visible then o.Select() break end end
				end
			end
			if COMPACT then tab.Button.ClipsDescendants = false end
			return tab
		end
		function win:SetTabBadge(name, text, color) local t = self:GetTab(name) if t then t:SetBadge(text, color) end return t end
		function win:SetTabVisible(name, v) local t = self:GetTab(name) if t then t:SetVisible(v) end return t end
		function win:RenameTab(old, new) local t = self:GetTab(old) if t then t:SetName(new) end return t end
		function win:RemoveTab(name) local t = self:GetTab(name) if t then t:Remove() end end

		-- appearance -----------------------------------------------------------------------
		local roundR, roundConn = 0, nil
		local function roundOne(d)
			if (d:IsA("Frame") or d:IsA("TextButton") or d:IsA("TextBox")) and not d:FindFirstChildOfClass("UICorner") then
				if d:IsA("TextBox") or d.BackgroundTransparency < 0.98 then
					local c = Instance.new("UICorner")
					c.Name = "VFRound"
					c.CornerRadius = UDim.new(0, roundR)
					c.Parent = d
				end
			end
		end
		function win:SetCornerRadius(r)
			r = math.clamp(tonumber(r) or 0, 0, 14)
			roundR = r
			if roundConn then roundConn:Disconnect() roundConn = nil end
			for _, d in ipairs(screen:GetDescendants()) do
				if d:IsA("UICorner") and d.Name == "VFRound" then
					if r == 0 then d:Destroy() else d.CornerRadius = UDim.new(0, r) end
				end
			end
			if r > 0 then
				for _, d in ipairs(screen:GetDescendants()) do pcall(roundOne, d) end
				roundConn = screen.DescendantAdded:Connect(function(d) pcall(roundOne, d) end)
				conn(roundConn)
			end
		end

		local fontReg, fontBold, fontConn = nil, nil, nil
		local function fontOne(d)
			if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
				local orig = d:GetAttribute("VF_Font")
				if not orig then orig = d.Font.Name d:SetAttribute("VF_Font", orig) end
				if fontReg == nil then
					pcall(function() d.Font = Enum.Font[orig] end)
				elseif orig == "Code" then
					-- code blocks keep their monospace font
				elseif orig == "Gotham" then
					d.Font = fontReg
				else
					d.Font = fontBold or fontReg
				end
			end
		end
		function win:SetFont(regular, bold)
			local function resolve(f)
				if typeof(f) == "EnumItem" then return f end
				if type(f) == "string" then
					local ok, e = pcall(function() return Enum.Font[f] end)
					if ok then return e end
				end
				return nil
			end
			fontReg, fontBold = resolve(regular), resolve(bold)
			if fontConn then fontConn:Disconnect() fontConn = nil end
			for _, d in ipairs(screen:GetDescendants()) do pcall(fontOne, d) end
			if fontReg then
				fontConn = screen.DescendantAdded:Connect(function(d) pcall(fontOne, d) end)
				conn(fontConn)
			end
		end
	end
	do
		function win:CreateUtilityTab(opts)
			opts = opts or {}
			local tab = self:CreateTab(opts.Name or "Utilities", opts.Icon or "hammer")
			local function say(t, c, k) self:Notify({Title = t, Content = c, Kind = k or "info", Duration = 2.5}) end

			local live = tab:CreateSection("Live Stats")
			live:CreateStat({Name = "FPS", Source = "fps", Interval = 0.5})
			live:CreateStat({Name = "Ping", Source = "ping", Interval = 1})
			live:CreateStat({Name = "Memory", Source = "memory", Interval = 2})
			live:CreateStat({Name = "Players", Source = "players", Interval = 2})
			live:CreateStat({Name = "Session Time", Source = "uptime", Interval = 1})
			live:CreateGraph({Name = "FPS History", Source = "fps", Interval = 0.5, Suffix = " FPS", Height = 60, Min = 0})
			live:CreateGraph({Name = "Ping History", Source = "ping", Interval = 1, Suffix = " ms", Height = 60, Min = 0})

			local srv = tab:CreateSection("Server")
			srv:CreateKeyValue({Name = "Place ID", Value = tostring(game.PlaceId)})
			srv:CreateKeyValue({Name = "Job ID", Value = tostring(game.JobId)})
			srv:CreateButton({Name = "Server Hop", Description = "Joins another public server of this game", ButtonText = "HOP", Confirm = true, Callback = function()
				local TeleportService = game:GetService("TeleportService")
				local ok, body = pcall(function()
					return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
				end)
				local data = ok and type(body) == "string" and select(2, pcall(function() return HttpService:JSONDecode(body) end)) or nil
				if type(data) ~= "table" or type(data.data) ~= "table" then say("Server Hop", "Could not fetch the server list.", "error") return end
				local pick
				for _, s in ipairs(data.data) do
					if s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 0) then pick = s break end
				end
				if not pick then say("Server Hop", "No other open server found.", "warn") return end
				say("Server Hop", "Teleporting...", "info")
				pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.id, lp) end)
			end})
			local jobInput = ""
			srv:CreateInput({Name = "Join Job ID", PlaceholderText = "Paste a Job ID", Callback = function(t) jobInput = tostring(t or "") end})
			srv:CreateButton({Name = "Join That Server", ButtonText = "JOIN", Callback = function()
				if jobInput == "" then say("Join", "Paste a Job ID first.", "warn") return end
				pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobInput, lp) end)
			end})
			srv:CreateButton({Name = "Copy Join Snippet", Description = "Lua line that rejoins this exact server", ButtonText = "COPY", Callback = function()
				local code = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
				local ok = pcall(function() setclipboard(code) end)
				say("Copied", ok and "Join snippet copied." or "Clipboard not available.", ok and "success" or "warn")
			end})

			local perf = tab:CreateSection("Performance")
			perf:CreateSlider({Name = "FPS Cap", Range = {10, 360}, Increment = 5, CurrentValue = 60, Flag = "vfu_fpscap", Description = "Needs an executor with setfpscap",
				Callback = function(v) if setfpscap then pcall(setfpscap, v) end end})
			local lowState
			perf:CreateToggle({Name = "Low Graphics", Description = "Lowest quality level and no shadows", Flag = "vfu_lowgfx", CurrentValue = false, Callback = function(v)
				pcall(function()
					if v then
						lowState = lowState or {q = settings().Rendering.QualityLevel, s = Lighting.GlobalShadows}
						settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
						Lighting.GlobalShadows = false
					elseif lowState then
						settings().Rendering.QualityLevel = lowState.q
						Lighting.GlobalShadows = lowState.s
					end
				end)
			end})
			perf:CreateToggle({Name = "Disable 3D Rendering", Description = "Saves battery and GPU while AFK", Flag = "vfu_no3d", CurrentValue = false, IgnoreConfig = true,
				Callback = function(v) pcall(function() RunService:Set3dRenderingEnabled(not v) end) end})

			local ui = tab:CreateSection("Interface")
			ui:CreateSlider({Name = "Corner Radius", Range = {0, 12}, Increment = 1, CurrentValue = 0, Flag = "vfu_radius", Callback = function(v) self:SetCornerRadius(v) end})
			ui:CreateSlider({Name = "Animation Speed", Range = {0.25, 3}, Increment = 0.25, CurrentValue = 1, Suffix = "x", Flag = "vfu_animspeed", Callback = function(v) VField:SetAnimationSpeed(v) end})
			ui:CreateDropdown({Name = "Font", Options = {"Gotham", "Ubuntu", "Arimo", "Nunito", "Fredoka", "Jura", "Michroma", "Oswald", "Roboto", "SourceSans", "RobotoMono"},
				CurrentOption = "Gotham", Flag = "vfu_font", Callback = function(o) self:SetFont(o ~= "Gotham" and o or nil) end})
			ui:CreateDropdown({Name = "Window Position", Options = {"Center", "TopLeft", "TopRight", "BottomLeft", "BottomRight"}, CurrentOption = "Center", IgnoreConfig = true,
				Callback = function(o) self:Snap(o) end})
			ui:CreateButtonRow({Buttons = {
				{Name = "Command Palette", Callback = function() self:OpenCommandPalette() end},
				{Name = "Keybinds", Callback = function() self:ShowKeybinds() end},
				{Name = "Random Theme", Callback = function() VField:RandomTheme() end},
			}})

			local notif = tab:CreateSection("Notification Log")
			local con = notif:CreateConsole({Name = "Recent Notifications", Height = 110, MaxLines = 60})
			for _, r in ipairs(self.NotifyHistory) do con.Log(tostring(r.Title or "") .. ": " .. tostring(r.Content or ""), r.Kind) end
			self:OnNotify(function(r) con.Log(tostring(r.Title or "") .. ": " .. tostring(r.Content or ""), r.Kind) end)
			notif:CreateButton({Name = "Clear Log", ButtonText = "CLEAR", Callback = function() con.Clear() self:ClearNotificationHistory() end})

			local cfgs = tab:CreateSection("Settings Tools")
			cfgs:CreateButtonRow({Buttons = {
				{Name = "Copy Settings", Callback = function() say("Settings", self:CopyConfig() and "Copied to clipboard." or "Clipboard not available.", "info") end},
				{Name = "Paste Settings", Callback = function() say("Settings", self:PasteConfig() and "Imported from clipboard." or "Nothing valid to import.", "info") end},
				{Name = "Reset All", Confirm = true, Callback = function() self:ResetAll() say("Settings", "Everything reset to defaults.", "success") end},
			}})
			return tab
		end
	end
	return win end function VField:Unload() 	dead, rainbowOn = true, false 	if VField.Window then pcall(function() VField.Window:Destroy() end) end 	local gp = getGuiParent() 	for _, c in ipairs({gp, getPlayerGui()}) do 		for _, n in ipairs({"VFieldUI", "VFieldKey"}) do 			local o = c:FindFirstChild(n) 			if o then o:Destroy() end 		end 	end 	env.VFieldLib = nil end do
	function VField:GetTheme() return currentTheme end
	function VField:CycleTheme(dir)
		local idx = table.find(THEME_ORDER, currentTheme) or 1
		idx = ((idx - 1 + (dir or 1)) % #THEME_ORDER) + 1
		VField:SetRainbow(false)
		VField:SetTheme(THEME_ORDER[idx])
		return THEME_ORDER[idx]
	end
	function VField:RandomTheme()
		local n = THEME_ORDER[math.random(1, #THEME_ORDER)]
		VField:SetRainbow(false)
		VField:SetTheme(n)
		return n
	end
	function VField:MakeTheme(name, accent, light)
		if typeof(accent) ~= "Color3" then return nil end
		local h, s, v = accent:ToHSV()
		local t = {Accent = accent}
		if light then
			t.Bright = Color3.fromHSV(h, math.clamp(s * 0.95, 0, 1), math.min(v, 0.85))
			t.Soft = Color3.fromHSV(h, math.clamp(s * 0.25, 0, 1), 0.97)
			t.Background, t.Panel, t.Raised, t.Hover = rgb(242, 242, 245), rgb(228, 228, 233), rgb(250, 250, 252), rgb(212, 212, 220)
			t.Text, t.Muted, t.Line = rgb(20, 20, 26), rgb(98, 98, 110), rgb(188, 188, 198)
		else
			t.Bright = Color3.fromHSV(h, math.clamp(s * 0.5, 0, 1), 1)
			t.Soft = Color3.fromHSV(h, math.clamp(s, 0, 1), 0.34)
			local ds = math.clamp(s * 0.35, 0, 0.5)
			t.Background = Color3.fromHSV(h, ds, 0.06)
			t.Panel = Color3.fromHSV(h, ds, 0.1)
			t.Raised = Color3.fromHSV(h, ds, 0.15)
			t.Hover = Color3.fromHSV(h, ds, 0.21)
			t.Line = Color3.fromHSV(h, ds, 0.31)
		end
		defineTheme(name, t)
		return name
	end
	local function toHex(c) return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
	function VField:ExportTheme()
		local t = {Name = currentTheme}
		for _, k in ipairs(THEME_KEYS) do t[k] = toHex(COLORS[k]) end
		return HttpService:JSONEncode(t)
	end
	function VField:ImportTheme(json, name)
		local ok, t = pcall(function() return HttpService:JSONDecode(json) end)
		if not ok or type(t) ~= "table" then return false end
		local out = {}
		for _, k in ipairs(THEME_KEYS) do
			local hx = t[k]
			if type(hx) == "string" and #hx >= 6 then
				local r, g, b = tonumber(hx:sub(-6, -5), 16), tonumber(hx:sub(-4, -3), 16), tonumber(hx:sub(-2), 16)
				if r and g and b then out[k] = rgb(r, g, b) end
			end
		end
		if next(out) == nil then return false end
		name = tostring(name or t.Name or "Imported")
		defineTheme(name, out)
		VField:SetRainbow(false)
		VField:SetTheme(name)
		return name
	end
	function VField:OnThemeChanged(fn)
		hooks[#hooks + 1] = function() fn(COLORS, currentTheme) end
	end
	function VField:SetAnimationSpeed(s)
		VField._anim = 1 / math.clamp(tonumber(s) or 1, 0.05, 50)
	end
	function VField:SetSoundId(kind, id, vol, speed)
		local d = SOUNDS[kind]
		if not d then return false end
		if id ~= nil then
			id = tostring(id)
			d[1] = id:match("^%d+$") and ("rbxassetid://" .. id) or id
		end
		if vol then d[2] = vol end
		if speed then d[3] = speed end
		return true
	end
	function VField:GetSoundKinds()
		local out = {}
		for k in pairs(SOUNDS) do out[#out + 1] = k end
		table.sort(out)
		return out
	end
	function VField:GetFeatureCount()
		local n = 0
		for k, v in pairs(VField) do if type(v) == "function" then n = n + 1 end end
		return n
	end
end
VField.Destroy = VField.Unload return VField
