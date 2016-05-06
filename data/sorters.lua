
--	table.sort(tmp, function(a, b) if db.growUp then return self:C_RemainingComparer(a, b) else return self:C_ReversalRemainingComparer(a, b) end end)

--function Aesa:C_RemainingComparer(a, b)
--	return b.remaining < a.remaining
--end

--["1"] = "Ascending (CD left)",
function Vect:ComparerAscendingCDLeft(a, b)
	local time = GetTime();
	if a.endTime < b.endTime then
		return true;
	else
		return false;
	end
end

--["2"] = "Descending (CD left)",
function Vect:ComparerDescendingCDLeft(a, b)
	local time = GetTime();
	if a.endTime < b.endTime then
		return false;
	else
		return true;
	end
end

--["3"] = "Ascending (CD total)",
function Vect:ComparerAscendingCDTotal(a, b)
	if a.cd < b.cd then
		return true;
	else
		return false;
	end
end

--["4"] = "Descending (CD total)",
function Vect:ComparerDescendingCDTotal(a, b)
	if a.cd < b.cd then
		return false;
	else
		return true;
	end
end

--["5"] = "Recent first",
function Vect:ComparerRecentFirst(a, b)
	if a.currentTime < b.currentTime then
		return false;
	else
		return true;
	end
end

--["6"] = "Recent Last",
function Vect:ComparerRecentLast(a, b)
	if a.currentTime < b.currentTime then
		return true;
	else
		return false;
	end
end
