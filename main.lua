require "print_r"
require "time"

local curses = require 'curses'
local list = require 'linkedList'

mt = {}
mt.__add =  function(a, b)
				local res = {}
				for k in pairs(a) do
					res[k] = a[k] + b[k]
				end
				return res
			end

-- Set.mt.__eq = function (a,b)
--     return a <= b and b <= a
-- end

local right = {x = 1, y = 0}
local up =    {x = 0, y = -1}
local left =  {x = -1, y = 0}
local down =  {x = 0, y = 1}

setmetatable(right, mt)
setmetatable(up, mt)
setmetatable(left, mt)
setmetatable(down, mt)

local board = {}
local boardSize = {width = 10, height = 10}
local char = {}

local snake = {list = {}, dir = down}
local food = {x = {}, y = {}, present = false}

function printAll()
	local it = snake.list
	repeat
		print(it.value.x, it.value.y)
		it = it.next
	until it == snake.list
end

function move()
	local head = snake.list.value

	snake.list = snake.list.prev

	-- snake.list.value.x = head.x + snake.dir.x
	-- snake.list.value.y = head.y + snake.dir.y
	snake.list.value = head + snake.dir
end

function checkFood()

	local head = snake.list

	if (head.value.x == food.x and head.value.y == food.y) then
		return true
	end
end

function checkCollision()
	local head = snake.list
	local it = head.next

	if checkFood() then
		-- print(food.x, food.y)
		list.push_back(snake.list, {})
		food.present = false
	end
	if (head.value.x < 0 or head.value.y < 0 or
		head.value.x > boardSize.width + 1 or head.value.y > boardSize.height + 1) then
		return true
	end
	repeat
		if (head.value.x == it.value.x and head.value.y == it.value.y) then
			return true
		end
		it = it.next
	until it == head

	return false
end

function setSnake()
	local a = boardSize.width / 2 + 1
	local b = boardSize.height / 2

	body = list.push_back(nil, {x = a, y = b})
	list.push_back(body, {x = a, y = b - 1})
	list.push_back(body, {x = a, y = b - 2})
	list.push_back(body, {x = a, y = b - 3})

	snake.list = body
end

function setFood()
	if food.present then return end
	local x
	local y

	repeat
		x = math.random(boardSize.width)
		y = math.random(boardSize.height)
		local it = snake.list

		food.present = true
		repeat
			if (x == it.value.x and y == it.value.y) then
				food.present = false
			end
			it = it.next
		until it == snake.list	
	until food.present == true

	food.x = x
	food.y = y
end

function init()
	math.randomseed(os.time())
	setSnake()

	curses.initscr()
	curses.cbreak()
	curses.echo(false)
	curses.nl(false)
	curses.curs_set(0)


	local border = {x = boardSize.width + 2, y = boardSize.height + 2}
	for x = 0, border.x do
		board[x] = {}
		for y = 0, border.y do
			board[x][y] = ' '
			if x == 0 or x == border.x or y == 0 or y == border.y then
				board[x][y] = '*'
			end
		end
	end

	stdscr = curses.stdscr()
	stdscr:nodelay(true)
	stdscr:keypad()
end

function draw_point(x, y, color, point_char)
	point_char = point_char or '@'
	if color then
		set_color(color)
	end
	stdscr:mvaddstr(y, x, point_char)
	stdscr:mvaddstr(y, x, point_char)
end

function set_color(c)
	stdscr:attron(c)
end

function drawScreen()
	stdscr:erase()

	for x = 0, boardSize.width + 2 do
		for y = 0, boardSize.height + 2 do
			local board_val = board[x][y]
			local pt_char = board[x][y] or ' '
			draw_point(x, y, COLOR_WHITE, pt_char)
		end
	end

	setFood()
	if food.present then
		draw_point(food.x, food.y, COLOR_RED, "$")
	end

	local it = snake.list
	repeat
		draw_point(it.value.x, it.value.y, COLOR_RED)
		it = it.next
	until it == snake.list

	stdscr:refresh()
end

function handleInput()
	local key = stdscr:getch()
	if key == nil then
		return
	end
	if key == string.byte('q') then
		curses.endwin()
        os.exit(0)
	end
	-- if key == string.byte('p') then
	-- 	-- add pause 
	-- end
	local moves = { [curses.KEY_LEFT]	= left,
					[curses.KEY_RIGHT]	= right,
					[curses.KEY_UP]		= up,
					[curses.KEY_DOWN]	= down,
					[string.byte('a')]	= left,
					[string.byte('d')]	= right,
					[string.byte('w')]  = up,
					[string.byte('s')]  = down }

	if moves[key] then
		snake.dir = moves[key]
	end
end

init()


while true do
	if timer:diff() then
		handleInput()
		move()
		
		drawScreen()
		if checkCollision() then
			os.exit()
		end
	end
end
