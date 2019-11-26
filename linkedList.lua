local linkedList = {}

function linkedList.construct(...)
	local args = {...}
	local list = linkedList.new(args[1])
	for i = 2, #args do
		linkedList.push_back(list, args[i])
	end
	return list
end

function linkedList.new(val)
	local node = {}
	node.value = val
	node.next = node
	node.prev = node
	return node
end

function linkedList:push_front(node, val)
	local newnode = linkedList.new(val)

	if node ~= nil then
		newnode.next = node
		newnode.prev = node.prev

		node.prev.next = newnode
		node.prev = newnode
	end

	return newnode
end

function linkedList.push_back(node, val)
	local newnode = linkedList.new(val)

	if node == nil then
		return newnode
	else
		newnode.next = node
		newnode.prev = node.prev

		node.prev.next = newnode
		node.prev = newnode
	end

	return node
end

function linkedList.erase(node)
	local tmp = node.next
	node.prev.next = node.next
	node = nil
	return tmp
end

function linkedList.len(node)
	local i = 0

	local it = node
	repeat
		i = i + 1
		it = it.next
	until it == node

	return i
end

function linkedList.print(node)
	local it = node
	repeat
		print(it.value)
		it = it.next
	until it == node
end

-- function linkedList:print()
-- 	local it = self
-- 	repeat
-- 		if it == nil then break end
-- 		print(it.value)
-- 		it = it.next
-- 	until it == self
-- end

return linkedList