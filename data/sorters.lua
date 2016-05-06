
--["1"] = "Ascending (CD left)",
function Rect:ComparerAscendingCDLeft(a, b)
	if a.endTime < b.endTime then
		return true;
	else
		return false;
	end
end

--["2"] = "Descending (CD left)",
function Rect:ComparerDescendingCDLeft(a, b)
	if a.endTime < b.endTime then
		return false;
	else
		return true;
	end
end

--["3"] = "Ascending (CD total)",
function Rect:ComparerAscendingCDTotal(a, b)
	if a.cd < b.cd then
		return true;
	else
		return false;
	end
end

--["4"] = "Descending (CD total)",
function Rect:ComparerDescendingCDTotal(a, b)
	if a.cd < b.cd then
		return false;
	else
		return true;
	end
end

--["5"] = "Recent first",
function Rect:ComparerRecentFirst(a, b)
	if a.currentTime < b.currentTime then
		return false;
	else
		return true;
	end
end

--["6"] = "Recent Last",
function Rect:ComparerRecentLast(a, b)
	if a.currentTime < b.currentTime then
		return true;
	else
		return false;
	end
end

--CD Type sorters

--["1"] = "Ascending (CD left)",
function Rect:ComparerAscendingCDLeftT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.endTime < b.endTime then
			return true;
		else
			return false;
		end
	end
end

--["2"] = "Descending (CD left)",
function Rect:ComparerDescendingCDLeftT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.endTime < b.endTime then
			return false;
		else
			return true;
		end
	end
end

--["3"] = "Ascending (CD total)",
function Rect:ComparerAscendingCDTotalT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.cd < b.cd then
			return true;
		else
			return false;
		end
	end
end

--["4"] = "Descending (CD total)",
function Rect:ComparerDescendingCDTotalT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.cd < b.cd then
			return false;
		else
			return true;
		end
	end
end

--["5"] = "Recent first",
function Rect:ComparerRecentFirstT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.currentTime < b.currentTime then
			return false;
		else
			return true;
		end
	end
end

--["6"] = "Recent Last",
function Rect:ComparerRecentLastT(a, b)
	local db = Rect.db.profile;

	if (db["cdtypesortorder"][a.spellCategory] < db["cdtypesortorder"][b.spellCategory]) then
		return true;
	elseif (db["cdtypesortorder"][a.spellCategory] > db["cdtypesortorder"][b.spellCategory]) then
		return false
	else -- they are ==
		if a.currentTime < b.currentTime then
			return true;
		else
			return false;
		end
	end
end
