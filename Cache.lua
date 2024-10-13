getgenv().invalidated = {}
getgenv().cache = {
    invalidate = function(object)
        local function clone(object)
			local old_archivable = object.Archivable
			local clone

			object.Archivable = true
			clone = object:Clone()
			object.Archivable = old_archivable

			return clone
		end

		local clone = clone(object)
		local oldParent = object.Parent

		table.insert(invalidated, object)

		object:Destroy()
		clone.Parent = oldParent
    end,
    iscached = function(object)
        return table.find(invalidated, object) == nil
    end,
    replace = function(object, new_object)
        if object:IsA("BasePart") and new_object:IsA("BasePart") then
			invalidate(object)
			table.insert(invalidated, new_object)
		end
    end
}