game:GetService("StarterGui"):SetCore("SendNotification",{Title = "WARNING!",Text = "EXECUTE THIS SCRIPT IN LOBBY OR IN MATCH, DONT EXECUTE SCRIPT IN MAIN MENU! THIS WILL BREAK THE HUB! SCRIPT WILL START IN 10 SECONDS AFTER THIS MESSAGE DISSAPEARS. THANK YOU!" ,Duration = 10, Icon = "rbxassetid://4483345998"})
wait(10)

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 81) then
			local FlatIdent_95CAC = 0;
			while true do
				if (FlatIdent_95CAC == 0) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local FlatIdent_76979 = 0;
			local a;
			while true do
				if (FlatIdent_76979 == 0) then
					a = Char(StrToNumber(byte, 16));
					if repeatNext then
						local b = Rep(a, repeatNext);
						repeatNext = nil;
						return b;
					else
						return a;
					end
					break;
				end
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local FlatIdent_69270 = 0;
			local Res;
			while true do
				if (FlatIdent_69270 == 0) then
					Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
					return Res - (Res % 1);
				end
			end
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local FlatIdent_6D4CB = 0;
		local a;
		while true do
			if (FlatIdent_6D4CB == 1) then
				return a;
			end
			if (FlatIdent_6D4CB == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_6D4CB = 1;
			end
		end
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local FlatIdent_12703 = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_12703 == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_12703 = 1;
			end
			if (FlatIdent_12703 == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
		end
	end
	local function gFloat()
		local FlatIdent_475BC = 0;
		local Left;
		local Right;
		local IsNormal;
		local Mantissa;
		local Exponent;
		local Sign;
		while true do
			if (FlatIdent_475BC == 3) then
				if (Exponent == 0) then
					if (Mantissa == 0) then
						return Sign * 0;
					else
						local FlatIdent_1076E = 0;
						while true do
							if (FlatIdent_1076E == 0) then
								Exponent = 1;
								IsNormal = 0;
								break;
							end
						end
					end
				elseif (Exponent == 2047) then
					return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
				end
				return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
			end
			if (FlatIdent_475BC == 1) then
				IsNormal = 1;
				Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
				FlatIdent_475BC = 2;
			end
			if (FlatIdent_475BC == 2) then
				Exponent = gBit(Right, 21, 31);
				Sign = ((gBit(Right, 32) == 1) and -1) or 1;
				FlatIdent_475BC = 3;
			end
			if (FlatIdent_475BC == 0) then
				Left = gBits32();
				Right = gBits32();
				FlatIdent_475BC = 1;
			end
		end
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local FlatIdent_7F35E = 0;
			local Type;
			local Cons;
			while true do
				if (1 == FlatIdent_7F35E) then
					if (Type == 1) then
						Cons = gBits8() ~= 0;
					elseif (Type == 2) then
						Cons = gFloat();
					elseif (Type == 3) then
						Cons = gString();
					end
					Consts[Idx] = Cons;
					break;
				end
				if (FlatIdent_7F35E == 0) then
					Type = gBits8();
					Cons = nil;
					FlatIdent_7F35E = 1;
				end
			end
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local FlatIdent_455BF = 0;
				local Type;
				local Mask;
				local Inst;
				while true do
					if (FlatIdent_455BF == 2) then
						if (gBit(Mask, 1, 1) == 1) then
							Inst[2] = Consts[Inst[2]];
						end
						if (gBit(Mask, 2, 2) == 1) then
							Inst[3] = Consts[Inst[3]];
						end
						FlatIdent_455BF = 3;
					end
					if (FlatIdent_455BF == 1) then
						Inst = {gBits16(),gBits16(),nil,nil};
						if (Type == 0) then
							local FlatIdent_8CEDF = 0;
							while true do
								if (FlatIdent_8CEDF == 0) then
									Inst[3] = gBits16();
									Inst[4] = gBits16();
									break;
								end
							end
						elseif (Type == 1) then
							Inst[3] = gBits32();
						elseif (Type == 2) then
							Inst[3] = gBits32() - (2 ^ 16);
						elseif (Type == 3) then
							Inst[3] = gBits32() - (2 ^ 16);
							Inst[4] = gBits16();
						end
						FlatIdent_455BF = 2;
					end
					if (FlatIdent_455BF == 0) then
						Type = gBit(Descriptor, 2, 3);
						Mask = gBit(Descriptor, 4, 6);
						FlatIdent_455BF = 1;
					end
					if (FlatIdent_455BF == 3) then
						if (gBit(Mask, 3, 3) == 1) then
							Inst[4] = Consts[Inst[4]];
						end
						Instrs[Idx] = Inst;
						break;
					end
				end
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				local FlatIdent_25DF3 = 0;
				while true do
					if (FlatIdent_25DF3 == 1) then
						if (Enum <= 186) then
							if (Enum <= 92) then
								if (Enum <= 45) then
									if (Enum <= 22) then
										if (Enum <= 10) then
											if (Enum <= 4) then
												if (Enum <= 1) then
													if (Enum == 0) then
														local Results;
														local Edx;
														local Results, Limit;
														local B;
														local A;
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Results, Limit = _R(Stk[A](Stk[A + 1]));
														Top = (Limit + A) - 1;
														Edx = 0;
														for Idx = A, Top do
															Edx = Edx + 1;
															Stk[Idx] = Results[Edx];
														end
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Results = {Stk[A](Unpack(Stk, A + 1, Top))};
														Edx = 0;
														for Idx = A, Inst[4] do
															local FlatIdent_66799 = 0;
															while true do
																if (FlatIdent_66799 == 0) then
																	Edx = Edx + 1;
																	Stk[Idx] = Results[Edx];
																	break;
																end
															end
														end
														VIP = VIP + 1;
														Inst = Instr[VIP];
														VIP = Inst[3];
													else
														local B;
														local A;
														A = Inst[2];
														Stk[A] = Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
													end
												elseif (Enum <= 2) then
													local B;
													local A;
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
												elseif (Enum == 3) then
													local B;
													local A;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
												else
													local B;
													local A;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
												end
											elseif (Enum <= 7) then
												if (Enum <= 5) then
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if (Stk[Inst[2]] == Inst[4]) then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
												elseif (Enum == 6) then
													local A = Inst[2];
													local C = Inst[4];
													local CB = A + 2;
													local Result = {Stk[A](Stk[A + 1], Stk[CB])};
													for Idx = 1, C do
														Stk[CB + Idx] = Result[Idx];
													end
													local R = Result[1];
													if R then
														Stk[CB] = R;
														VIP = Inst[3];
													else
														VIP = VIP + 1;
													end
												else
													local FlatIdent_817B0 = 0;
													local B;
													local A;
													while true do
														if (FlatIdent_817B0 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															B = Stk[Inst[3]];
															FlatIdent_817B0 = 2;
														end
														if (FlatIdent_817B0 == 0) then
															B = nil;
															A = nil;
															A = Inst[2];
															Stk[A] = Stk[A](Stk[A + 1]);
															FlatIdent_817B0 = 1;
														end
														if (FlatIdent_817B0 == 4) then
															Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
															VIP = VIP + 1;
															Inst = Instr[VIP];
															if not Stk[Inst[2]] then
																VIP = VIP + 1;
															else
																VIP = Inst[3];
															end
															break;
														end
														if (FlatIdent_817B0 == 3) then
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															FlatIdent_817B0 = 4;
														end
														if (FlatIdent_817B0 == 2) then
															Stk[A + 1] = B;
															Stk[A] = B[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_817B0 = 3;
														end
													end
												end
											elseif (Enum <= 8) then
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
											elseif (Enum > 9) then
												local FlatIdent_8B523 = 0;
												local B;
												local A;
												while true do
													if (3 == FlatIdent_8B523) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														FlatIdent_8B523 = 4;
													end
													if (FlatIdent_8B523 == 0) then
														B = nil;
														A = nil;
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_8B523 = 1;
													end
													if (4 == FlatIdent_8B523) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														break;
													end
													if (1 == FlatIdent_8B523) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_8B523 = 2;
													end
													if (2 == FlatIdent_8B523) then
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_8B523 = 3;
													end
												end
											else
												local Edx;
												local Results;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Results = {Stk[A](Stk[A + 1])};
												Edx = 0;
												for Idx = A, Inst[4] do
													local FlatIdent_2F37F = 0;
													while true do
														if (FlatIdent_2F37F == 0) then
															Edx = Edx + 1;
															Stk[Idx] = Results[Edx];
															break;
														end
													end
												end
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
											end
										elseif (Enum <= 16) then
											if (Enum <= 13) then
												if (Enum <= 11) then
													local K;
													local B;
													local A;
													A = Inst[2];
													Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													B = Inst[3];
													K = Stk[B];
													for Idx = B + 1, Inst[4] do
														K = K .. Stk[Idx];
													end
													Stk[Inst[2]] = K;
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
												elseif (Enum > 12) then
													local FlatIdent_5998C = 0;
													while true do
														if (FlatIdent_5998C == 0) then
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_5998C = 1;
														end
														if (5 == FlatIdent_5998C) then
															VIP = Inst[3];
															break;
														end
														if (FlatIdent_5998C == 1) then
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_5998C = 2;
														end
														if (FlatIdent_5998C == 3) then
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_5998C = 4;
														end
														if (FlatIdent_5998C == 4) then
															Stk[Inst[2]][Inst[3]] = Inst[4];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_5998C = 5;
														end
														if (FlatIdent_5998C == 2) then
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_5998C = 3;
														end
													end
												else
													local FlatIdent_22216 = 0;
													local B;
													local A;
													while true do
														if (FlatIdent_22216 == 4) then
															Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
															VIP = VIP + 1;
															Inst = Instr[VIP];
															if not Stk[Inst[2]] then
																VIP = VIP + 1;
															else
																VIP = Inst[3];
															end
															break;
														end
														if (FlatIdent_22216 == 2) then
															Stk[A + 1] = B;
															Stk[A] = B[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_22216 = 3;
														end
														if (FlatIdent_22216 == 3) then
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															FlatIdent_22216 = 4;
														end
														if (FlatIdent_22216 == 0) then
															B = nil;
															A = nil;
															A = Inst[2];
															Stk[A] = Stk[A](Stk[A + 1]);
															FlatIdent_22216 = 1;
														end
														if (FlatIdent_22216 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															B = Stk[Inst[3]];
															FlatIdent_22216 = 2;
														end
													end
												end
											elseif (Enum <= 14) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											elseif (Enum == 15) then
												local A = Inst[2];
												Stk[A] = Stk[A]();
											else
												Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
											end
										elseif (Enum <= 19) then
											if (Enum <= 17) then
												local FlatIdent_FA88 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_FA88 == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														FlatIdent_FA88 = 1;
													end
													if (FlatIdent_FA88 == 5) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_FA88 = 6;
													end
													if (FlatIdent_FA88 == 2) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_FA88 = 3;
													end
													if (FlatIdent_FA88 == 1) then
														Stk[A] = Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_FA88 = 2;
													end
													if (6 == FlatIdent_FA88) then
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_FA88 == 4) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_FA88 = 5;
													end
													if (FlatIdent_FA88 == 3) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_FA88 = 4;
													end
												end
											elseif (Enum == 18) then
												local FlatIdent_86900 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_86900 == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86900 = 5;
													end
													if (FlatIdent_86900 == 5) then
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_86900 = 6;
													end
													if (FlatIdent_86900 == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_86900 = 1;
													end
													if (FlatIdent_86900 == 3) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														FlatIdent_86900 = 4;
													end
													if (FlatIdent_86900 == 6) then
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														break;
													end
													if (FlatIdent_86900 == 2) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_86900 = 3;
													end
													if (FlatIdent_86900 == 1) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86900 = 2;
													end
												end
											else
												local FlatIdent_276C2 = 0;
												local A;
												while true do
													if (FlatIdent_276C2 == 3) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_276C2 = 4;
													end
													if (FlatIdent_276C2 == 1) then
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_276C2 = 2;
													end
													if (FlatIdent_276C2 == 0) then
														A = nil;
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_276C2 = 1;
													end
													if (FlatIdent_276C2 == 6) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														VIP = Inst[3];
														break;
													end
													if (FlatIdent_276C2 == 2) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														FlatIdent_276C2 = 3;
													end
													if (4 == FlatIdent_276C2) then
														A = Inst[2];
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_276C2 = 5;
													end
													if (FlatIdent_276C2 == 5) then
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_276C2 = 6;
													end
												end
											end
										elseif (Enum <= 20) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 21) then
											local FlatIdent_2593F = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_2593F == 2) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2593F = 3;
												end
												if (FlatIdent_2593F == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_2593F = 2;
												end
												if (FlatIdent_2593F == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													FlatIdent_2593F = 1;
												end
												if (FlatIdent_2593F == 4) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_2593F == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_2593F = 4;
												end
											end
										else
											local FlatIdent_985A2 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_985A2 == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													break;
												end
												if (FlatIdent_985A2 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_985A2 = 5;
												end
												if (FlatIdent_985A2 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_985A2 = 1;
												end
												if (3 == FlatIdent_985A2) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_985A2 = 4;
												end
												if (FlatIdent_985A2 == 6) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													FlatIdent_985A2 = 7;
												end
												if (1 == FlatIdent_985A2) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Env[Inst[3]] = Stk[Inst[2]];
													FlatIdent_985A2 = 2;
												end
												if (FlatIdent_985A2 == 5) then
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_985A2 = 6;
												end
												if (FlatIdent_985A2 == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_985A2 = 3;
												end
											end
										end
									elseif (Enum <= 33) then
										if (Enum <= 27) then
											if (Enum <= 24) then
												if (Enum > 23) then
													local FlatIdent_145D2 = 0;
													local T;
													local A;
													local K;
													local B;
													while true do
														if (FlatIdent_145D2 == 2) then
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															VIP = VIP + 1;
															FlatIdent_145D2 = 3;
														end
														if (FlatIdent_145D2 == 1) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Inst[3]] = Inst[4];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_145D2 = 2;
														end
														if (FlatIdent_145D2 == 6) then
															Inst = Instr[VIP];
															Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															FlatIdent_145D2 = 7;
														end
														if (FlatIdent_145D2 == 4) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															B = Inst[3];
															K = Stk[B];
															for Idx = B + 1, Inst[4] do
																K = K .. Stk[Idx];
															end
															FlatIdent_145D2 = 5;
														end
														if (5 == FlatIdent_145D2) then
															Stk[Inst[2]] = K;
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
															VIP = VIP + 1;
															FlatIdent_145D2 = 6;
														end
														if (FlatIdent_145D2 == 7) then
															T = Stk[A];
															B = Inst[3];
															for Idx = 1, B do
																T[Idx] = Stk[A + Idx];
															end
															break;
														end
														if (FlatIdent_145D2 == 3) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3];
															FlatIdent_145D2 = 4;
														end
														if (FlatIdent_145D2 == 0) then
															T = nil;
															A = nil;
															K = nil;
															B = nil;
															Stk[Inst[2]][Inst[3]] = Inst[4];
															FlatIdent_145D2 = 1;
														end
													end
												else
													local B;
													local A;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
												end
											elseif (Enum <= 25) then
												local FlatIdent_71E8F = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_71E8F == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_71E8F = 4;
													end
													if (FlatIdent_71E8F == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_71E8F = 2;
													end
													if (FlatIdent_71E8F == 4) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_71E8F == 2) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_71E8F = 3;
													end
													if (FlatIdent_71E8F == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														Stk[A] = Stk[A](Stk[A + 1]);
														FlatIdent_71E8F = 1;
													end
												end
											elseif (Enum > 26) then
												local B;
												local A;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
											else
												local FlatIdent_6066D = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_6066D == 2) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_6066D = 3;
													end
													if (3 == FlatIdent_6066D) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_6066D = 4;
													end
													if (FlatIdent_6066D == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_6066D = 2;
													end
													if (FlatIdent_6066D == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														Stk[A] = Stk[A](Stk[A + 1]);
														FlatIdent_6066D = 1;
													end
													if (4 == FlatIdent_6066D) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
												end
											end
										elseif (Enum <= 30) then
											if (Enum <= 28) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											elseif (Enum > 29) then
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
											else
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 31) then
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										elseif (Enum == 32) then
											local FlatIdent_A446 = 0;
											while true do
												if (FlatIdent_A446 == 6) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_A446 = 7;
												end
												if (FlatIdent_A446 == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_A446 = 6;
												end
												if (0 == FlatIdent_A446) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_A446 = 1;
												end
												if (FlatIdent_A446 == 3) then
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													FlatIdent_A446 = 4;
												end
												if (FlatIdent_A446 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_A446 = 5;
												end
												if (8 == FlatIdent_A446) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_A446 == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													FlatIdent_A446 = 8;
												end
												if (FlatIdent_A446 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_A446 = 3;
												end
												if (FlatIdent_A446 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_A446 = 2;
												end
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 39) then
										if (Enum <= 36) then
											if (Enum <= 34) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												do
													return;
												end
											elseif (Enum > 35) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local FlatIdent_270C = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_270C == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														FlatIdent_270C = 2;
													end
													if (FlatIdent_270C == 6) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_270C = 7;
													end
													if (FlatIdent_270C == 0) then
														B = nil;
														A = nil;
														Stk[Inst[2]] = Env[Inst[3]];
														FlatIdent_270C = 1;
													end
													if (FlatIdent_270C == 2) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_270C = 3;
													end
													if (FlatIdent_270C == 3) then
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														FlatIdent_270C = 4;
													end
													if (FlatIdent_270C == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_270C = 5;
													end
													if (FlatIdent_270C == 7) then
														if Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_270C == 5) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_270C = 6;
													end
												end
											end
										elseif (Enum <= 37) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 38) then
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										else
											local FlatIdent_74B46 = 0;
											local A;
											local T;
											local B;
											while true do
												if (FlatIdent_74B46 == 1) then
													B = Inst[3];
													for Idx = 1, B do
														T[Idx] = Stk[A + Idx];
													end
													break;
												end
												if (FlatIdent_74B46 == 0) then
													A = Inst[2];
													T = Stk[A];
													FlatIdent_74B46 = 1;
												end
											end
										end
									elseif (Enum <= 42) then
										if (Enum <= 40) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 41) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 43) then
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum == 44) then
										local Edx;
										local Results, Limit;
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 68) then
									if (Enum <= 56) then
										if (Enum <= 50) then
											if (Enum <= 47) then
												if (Enum == 46) then
													local FlatIdent_3E44E = 0;
													local B;
													local A;
													while true do
														if (FlatIdent_3E44E == 0) then
															B = nil;
															A = nil;
															Stk[Inst[2]] = Env[Inst[3]];
															VIP = VIP + 1;
															FlatIdent_3E44E = 1;
														end
														if (FlatIdent_3E44E == 3) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															Stk[A](Unpack(Stk, A + 1, Inst[3]));
															FlatIdent_3E44E = 4;
														end
														if (FlatIdent_3E44E == 2) then
															Stk[A] = B[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Inst[3] ~= 0;
															FlatIdent_3E44E = 3;
														end
														if (4 == FlatIdent_3E44E) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															VIP = Inst[3];
															break;
														end
														if (FlatIdent_3E44E == 1) then
															Inst = Instr[VIP];
															A = Inst[2];
															B = Stk[Inst[3]];
															Stk[A + 1] = B;
															FlatIdent_3E44E = 2;
														end
													end
												else
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
												end
											elseif (Enum <= 48) then
												local FlatIdent_4BE81 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_4BE81 == 3) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_4BE81 = 4;
													end
													if (FlatIdent_4BE81 == 7) then
														Stk[Inst[2]][Inst[3]] = Inst[4];
														break;
													end
													if (6 == FlatIdent_4BE81) then
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4BE81 = 7;
													end
													if (FlatIdent_4BE81 == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_4BE81 = 2;
													end
													if (5 == FlatIdent_4BE81) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4BE81 = 6;
													end
													if (0 == FlatIdent_4BE81) then
														B = nil;
														A = nil;
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														FlatIdent_4BE81 = 1;
													end
													if (FlatIdent_4BE81 == 2) then
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4BE81 = 3;
													end
													if (FlatIdent_4BE81 == 4) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4BE81 = 5;
													end
												end
											elseif (Enum == 49) then
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
											else
												local B;
												local A;
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
											end
										elseif (Enum <= 53) then
											if (Enum <= 51) then
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
											elseif (Enum > 52) then
												local FlatIdent_59521 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_59521 == 1) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_59521 = 2;
													end
													if (2 == FlatIdent_59521) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_59521 = 3;
													end
													if (FlatIdent_59521 == 5) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_59521 = 6;
													end
													if (FlatIdent_59521 == 3) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_59521 = 4;
													end
													if (FlatIdent_59521 == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_59521 = 5;
													end
													if (FlatIdent_59521 == 7) then
														Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_59521 = 8;
													end
													if (FlatIdent_59521 == 6) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_59521 = 7;
													end
													if (FlatIdent_59521 == 8) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_59521 == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_59521 = 1;
													end
												end
											else
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
											end
										elseif (Enum <= 54) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 55) then
											local FlatIdent_2E3CE = 0;
											local K;
											local B;
											local A;
											while true do
												if (FlatIdent_2E3CE == 3) then
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2E3CE = 4;
												end
												if (FlatIdent_2E3CE == 1) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_2E3CE = 2;
												end
												if (FlatIdent_2E3CE == 2) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2E3CE = 3;
												end
												if (FlatIdent_2E3CE == 5) then
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_2E3CE = 6;
												end
												if (6 == FlatIdent_2E3CE) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Stk[A + 1]);
													FlatIdent_2E3CE = 7;
												end
												if (0 == FlatIdent_2E3CE) then
													K = nil;
													B = nil;
													A = nil;
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2E3CE = 1;
												end
												if (4 == FlatIdent_2E3CE) then
													B = Inst[3];
													K = Stk[B];
													for Idx = B + 1, Inst[4] do
														K = K .. Stk[Idx];
													end
													Stk[Inst[2]] = K;
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2E3CE = 5;
												end
												if (7 == FlatIdent_2E3CE) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
											end
										elseif (Inst[2] == Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum <= 62) then
										if (Enum <= 59) then
											if (Enum <= 57) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											elseif (Enum == 58) then
												local FlatIdent_4E1DE = 0;
												local B;
												local A;
												while true do
													if (0 == FlatIdent_4E1DE) then
														B = nil;
														A = nil;
														A = Inst[2];
														Stk[A] = Stk[A](Stk[A + 1]);
														FlatIdent_4E1DE = 1;
													end
													if (FlatIdent_4E1DE == 2) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4E1DE = 3;
													end
													if (FlatIdent_4E1DE == 4) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_4E1DE == 3) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_4E1DE = 4;
													end
													if (FlatIdent_4E1DE == 1) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_4E1DE = 2;
													end
												end
											else
												VIP = Inst[3];
											end
										elseif (Enum <= 60) then
											Stk[Inst[2]]();
										elseif (Enum > 61) then
											local FlatIdent_81DE9 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_81DE9 == 4) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_81DE9 = 5;
												end
												if (FlatIdent_81DE9 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													FlatIdent_81DE9 = 1;
												end
												if (FlatIdent_81DE9 == 6) then
													Stk[Inst[2]][Inst[3]] = Inst[4];
													break;
												end
												if (FlatIdent_81DE9 == 5) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_81DE9 = 6;
												end
												if (FlatIdent_81DE9 == 3) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_81DE9 = 4;
												end
												if (FlatIdent_81DE9 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_81DE9 = 2;
												end
												if (FlatIdent_81DE9 == 2) then
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_81DE9 = 3;
												end
											end
										else
											local B;
											local A;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
										end
									elseif (Enum <= 65) then
										if (Enum <= 63) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Enum > 64) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 66) then
										Stk[Inst[2]] = Inst[3];
									elseif (Enum == 67) then
										Stk[Inst[2]] = Env[Inst[3]];
									else
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									end
								elseif (Enum <= 80) then
									if (Enum <= 74) then
										if (Enum <= 71) then
											if (Enum <= 69) then
												local FlatIdent_6A6C4 = 0;
												local B;
												local A;
												while true do
													if (2 == FlatIdent_6A6C4) then
														Inst = Instr[VIP];
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_6A6C4 = 3;
													end
													if (FlatIdent_6A6C4 == 0) then
														B = nil;
														A = nil;
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_6A6C4 = 1;
													end
													if (FlatIdent_6A6C4 == 1) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_6A6C4 = 2;
													end
													if (FlatIdent_6A6C4 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														break;
													end
													if (FlatIdent_6A6C4 == 3) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														FlatIdent_6A6C4 = 4;
													end
												end
											elseif (Enum > 70) then
												local FlatIdent_8384B = 0;
												local A;
												while true do
													if (FlatIdent_8384B == 0) then
														A = Inst[2];
														do
															return Stk[A](Unpack(Stk, A + 1, Top));
														end
														break;
													end
												end
											else
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 72) then
											local A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										elseif (Enum > 73) then
											local FlatIdent_63A3A = 0;
											while true do
												if (FlatIdent_63A3A == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_63A3A = 3;
												end
												if (FlatIdent_63A3A == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													do
														return;
													end
													break;
												end
												if (FlatIdent_63A3A == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_63A3A = 2;
												end
												if (FlatIdent_63A3A == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													FlatIdent_63A3A = 4;
												end
												if (FlatIdent_63A3A == 0) then
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_63A3A = 1;
												end
											end
										else
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 77) then
										if (Enum <= 75) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 76) then
											local FlatIdent_44652 = 0;
											while true do
												if (FlatIdent_44652 == 4) then
													if Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_44652 == 3) then
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_44652 = 4;
												end
												if (FlatIdent_44652 == 2) then
													Env[Inst[3]] = Stk[Inst[2]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_44652 = 3;
												end
												if (FlatIdent_44652 == 1) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_44652 = 2;
												end
												if (FlatIdent_44652 == 0) then
													Env[Inst[3]] = Stk[Inst[2]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_44652 = 1;
												end
											end
										else
											local FlatIdent_7C89 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_7C89 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_7C89 = 1;
												end
												if (FlatIdent_7C89 == 1) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_7C89 = 2;
												end
												if (FlatIdent_7C89 == 2) then
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_7C89 = 3;
												end
												if (FlatIdent_7C89 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													break;
												end
												if (FlatIdent_7C89 == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													FlatIdent_7C89 = 4;
												end
											end
										end
									elseif (Enum <= 78) then
										local FlatIdent_401F9 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_401F9 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												FlatIdent_401F9 = 2;
											end
											if (FlatIdent_401F9 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												FlatIdent_401F9 = 1;
											end
											if (FlatIdent_401F9 == 8) then
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_401F9 == 5) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_401F9 = 6;
											end
											if (FlatIdent_401F9 == 6) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_401F9 = 7;
											end
											if (FlatIdent_401F9 == 7) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_401F9 = 8;
											end
											if (FlatIdent_401F9 == 4) then
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												FlatIdent_401F9 = 5;
											end
											if (FlatIdent_401F9 == 2) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												FlatIdent_401F9 = 3;
											end
											if (FlatIdent_401F9 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_401F9 = 4;
											end
										end
									elseif (Enum > 79) then
										local FlatIdent_15E91 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_15E91 == 6) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_15E91 = 7;
											end
											if (FlatIdent_15E91 == 7) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
											if (FlatIdent_15E91 == 2) then
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_15E91 = 3;
											end
											if (FlatIdent_15E91 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												FlatIdent_15E91 = 1;
											end
											if (FlatIdent_15E91 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_15E91 = 2;
											end
											if (FlatIdent_15E91 == 5) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_15E91 = 6;
											end
											if (FlatIdent_15E91 == 4) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_15E91 = 5;
											end
											if (FlatIdent_15E91 == 3) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_15E91 = 4;
											end
										end
									else
										local FlatIdent_943B = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_943B == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_943B = 6;
											end
											if (FlatIdent_943B == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_943B = 4;
											end
											if (6 == FlatIdent_943B) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_943B == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_943B = 5;
											end
											if (FlatIdent_943B == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_943B = 1;
											end
											if (FlatIdent_943B == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_943B = 2;
											end
											if (FlatIdent_943B == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_943B = 3;
											end
										end
									end
								elseif (Enum <= 86) then
									if (Enum <= 83) then
										if (Enum <= 81) then
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 82) then
											local FlatIdent_82BF = 0;
											local B;
											local A;
											while true do
												if (5 == FlatIdent_82BF) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_82BF = 6;
												end
												if (1 == FlatIdent_82BF) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_82BF = 2;
												end
												if (3 == FlatIdent_82BF) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_82BF = 4;
												end
												if (FlatIdent_82BF == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_82BF = 3;
												end
												if (FlatIdent_82BF == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_82BF = 1;
												end
												if (FlatIdent_82BF == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_82BF = 5;
												end
												if (6 == FlatIdent_82BF) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
											end
										else
											local FlatIdent_66193 = 0;
											local Edx;
											local Results;
											local Limit;
											local B;
											local A;
											while true do
												if (FlatIdent_66193 == 6) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_66193 = 7;
												end
												if (FlatIdent_66193 == 7) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_66193 = 8;
												end
												if (FlatIdent_66193 == 8) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													FlatIdent_66193 = 9;
												end
												if (FlatIdent_66193 == 11) then
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (3 == FlatIdent_66193) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_66193 = 4;
												end
												if (0 == FlatIdent_66193) then
													Edx = nil;
													Results, Limit = nil;
													B = nil;
													A = nil;
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_66193 = 1;
												end
												if (FlatIdent_66193 == 10) then
													for Idx = A, Top do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Top));
													VIP = VIP + 1;
													FlatIdent_66193 = 11;
												end
												if (FlatIdent_66193 == 9) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Results, Limit = _R(Stk[A](Stk[A + 1]));
													Top = (Limit + A) - 1;
													Edx = 0;
													FlatIdent_66193 = 10;
												end
												if (FlatIdent_66193 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_66193 = 6;
												end
												if (FlatIdent_66193 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_66193 = 3;
												end
												if (FlatIdent_66193 == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_66193 = 2;
												end
												if (FlatIdent_66193 == 4) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_66193 = 5;
												end
											end
										end
									elseif (Enum <= 84) then
										local FlatIdent_3423 = 0;
										while true do
											if (0 == FlatIdent_3423) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 1;
											end
											if (FlatIdent_3423 == 9) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												break;
											end
											if (FlatIdent_3423 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 3;
											end
											if (5 == FlatIdent_3423) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 6;
											end
											if (1 == FlatIdent_3423) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 2;
											end
											if (FlatIdent_3423 == 8) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 9;
											end
											if (4 == FlatIdent_3423) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 5;
											end
											if (7 == FlatIdent_3423) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 8;
											end
											if (FlatIdent_3423 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 7;
											end
											if (FlatIdent_3423 == 3) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3423 = 4;
											end
										end
									elseif (Enum > 85) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 89) then
									if (Enum <= 87) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum == 88) then
										local A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
									else
										local K;
										local B;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
									end
								elseif (Enum <= 90) then
									local B;
									local A;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
								elseif (Enum > 91) then
									local B;
									local A;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
								else
									local FlatIdent_60AAB = 0;
									local Results;
									local Edx;
									local Limit;
									local B;
									local A;
									while true do
										if (FlatIdent_60AAB == 3) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											FlatIdent_60AAB = 4;
										end
										if (FlatIdent_60AAB == 6) then
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_60AAB == 0) then
											Results = nil;
											Edx = nil;
											Results, Limit = nil;
											B = nil;
											A = nil;
											FlatIdent_60AAB = 1;
										end
										if (FlatIdent_60AAB == 2) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											FlatIdent_60AAB = 3;
										end
										if (FlatIdent_60AAB == 1) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_60AAB = 2;
										end
										if (FlatIdent_60AAB == 5) then
											Results = {Stk[A](Unpack(Stk, A + 1, Top))};
											Edx = 0;
											for Idx = A, Inst[4] do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_60AAB = 6;
										end
										if (FlatIdent_60AAB == 4) then
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_60AAB = 5;
										end
									end
								end
							elseif (Enum <= 139) then
								if (Enum <= 115) then
									if (Enum <= 103) then
										if (Enum <= 97) then
											if (Enum <= 94) then
												if (Enum == 93) then
													local FlatIdent_6E9BC = 0;
													local Results;
													local Edx;
													local Limit;
													local B;
													local A;
													while true do
														if (FlatIdent_6E9BC == 8) then
															Inst = Instr[VIP];
															A = Inst[2];
															Results = {Stk[A](Unpack(Stk, A + 1, Top))};
															Edx = 0;
															FlatIdent_6E9BC = 9;
														end
														if (3 == FlatIdent_6E9BC) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Env[Inst[3]];
															VIP = VIP + 1;
															FlatIdent_6E9BC = 4;
														end
														if (FlatIdent_6E9BC == 1) then
															A = nil;
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_6E9BC = 2;
														end
														if (FlatIdent_6E9BC == 7) then
															Top = (Limit + A) - 1;
															Edx = 0;
															for Idx = A, Top do
																local FlatIdent_B716 = 0;
																while true do
																	if (FlatIdent_B716 == 0) then
																		Edx = Edx + 1;
																		Stk[Idx] = Results[Edx];
																		break;
																	end
																end
															end
															VIP = VIP + 1;
															FlatIdent_6E9BC = 8;
														end
														if (FlatIdent_6E9BC == 9) then
															for Idx = A, Inst[4] do
																Edx = Edx + 1;
																Stk[Idx] = Results[Edx];
															end
															VIP = VIP + 1;
															Inst = Instr[VIP];
															VIP = Inst[3];
															break;
														end
														if (FlatIdent_6E9BC == 6) then
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															Results, Limit = _R(Stk[A](Stk[A + 1]));
															FlatIdent_6E9BC = 7;
														end
														if (FlatIdent_6E9BC == 2) then
															Stk[Inst[2]]();
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = Env[Inst[3]];
															FlatIdent_6E9BC = 3;
														end
														if (FlatIdent_6E9BC == 4) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_6E9BC = 5;
														end
														if (FlatIdent_6E9BC == 0) then
															Results = nil;
															Edx = nil;
															Results, Limit = nil;
															B = nil;
															FlatIdent_6E9BC = 1;
														end
														if (FlatIdent_6E9BC == 5) then
															A = Inst[2];
															B = Stk[Inst[3]];
															Stk[A + 1] = B;
															Stk[A] = B[Inst[4]];
															FlatIdent_6E9BC = 6;
														end
													end
												else
													local B;
													local A;
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
												end
											elseif (Enum <= 95) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											elseif (Enum > 96) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local A;
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
											end
										elseif (Enum <= 100) then
											if (Enum <= 98) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											elseif (Enum == 99) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local FlatIdent_3A079 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_3A079 == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_3A079 = 1;
													end
													if (FlatIdent_3A079 == 2) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_3A079 = 3;
													end
													if (FlatIdent_3A079 == 7) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														break;
													end
													if (FlatIdent_3A079 == 6) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_3A079 = 7;
													end
													if (FlatIdent_3A079 == 1) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_3A079 = 2;
													end
													if (3 == FlatIdent_3A079) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_3A079 = 4;
													end
													if (FlatIdent_3A079 == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_3A079 = 5;
													end
													if (FlatIdent_3A079 == 5) then
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_3A079 = 6;
													end
												end
											end
										elseif (Enum <= 101) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Enum > 102) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										else
											local FlatIdent_413A0 = 0;
											local B;
											local A;
											while true do
												if (5 == FlatIdent_413A0) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_413A0 = 6;
												end
												if (6 == FlatIdent_413A0) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_413A0 = 7;
												end
												if (FlatIdent_413A0 == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_413A0 = 3;
												end
												if (FlatIdent_413A0 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_413A0 = 5;
												end
												if (FlatIdent_413A0 == 8) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_413A0 == 7) then
													Env[Inst[3]] = Stk[Inst[2]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_413A0 = 8;
												end
												if (FlatIdent_413A0 == 0) then
													B = nil;
													A = nil;
													Env[Inst[3]] = Stk[Inst[2]];
													FlatIdent_413A0 = 1;
												end
												if (FlatIdent_413A0 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													FlatIdent_413A0 = 2;
												end
												if (FlatIdent_413A0 == 3) then
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_413A0 = 4;
												end
											end
										end
									elseif (Enum <= 109) then
										if (Enum <= 106) then
											if (Enum <= 104) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											elseif (Enum > 105) then
												local FlatIdent_104FA = 0;
												local Edx;
												local Results;
												local Limit;
												local B;
												local A;
												while true do
													if (FlatIdent_104FA == 7) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_104FA = 8;
													end
													if (FlatIdent_104FA == 10) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A](Unpack(Stk, A + 1, Top));
														FlatIdent_104FA = 11;
													end
													if (FlatIdent_104FA == 5) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_104FA = 6;
													end
													if (FlatIdent_104FA == 0) then
														Edx = nil;
														Results, Limit = nil;
														B = nil;
														A = nil;
														FlatIdent_104FA = 1;
													end
													if (FlatIdent_104FA == 13) then
														A = Inst[2];
														Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_104FA = 14;
													end
													if (FlatIdent_104FA == 8) then
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_104FA = 9;
													end
													if (FlatIdent_104FA == 3) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_104FA = 4;
													end
													if (FlatIdent_104FA == 11) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_104FA = 12;
													end
													if (FlatIdent_104FA == 2) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_104FA = 3;
													end
													if (FlatIdent_104FA == 9) then
														Results, Limit = _R(Stk[A](Stk[A + 1]));
														Top = (Limit + A) - 1;
														Edx = 0;
														for Idx = A, Top do
															local FlatIdent_9761C = 0;
															while true do
																if (0 == FlatIdent_9761C) then
																	Edx = Edx + 1;
																	Stk[Idx] = Results[Edx];
																	break;
																end
															end
														end
														FlatIdent_104FA = 10;
													end
													if (FlatIdent_104FA == 12) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_104FA = 13;
													end
													if (FlatIdent_104FA == 6) then
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														FlatIdent_104FA = 7;
													end
													if (FlatIdent_104FA == 1) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														FlatIdent_104FA = 2;
													end
													if (FlatIdent_104FA == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_104FA = 5;
													end
													if (FlatIdent_104FA == 14) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														VIP = Inst[3];
														break;
													end
												end
											else
												local B;
												local A;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 107) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 108) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 112) then
										if (Enum <= 110) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 111) then
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local Edx;
											local Results, Limit;
											local B;
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											do
												return;
											end
										end
									elseif (Enum <= 113) then
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
									elseif (Enum == 114) then
										local FlatIdent_B6A2 = 0;
										local B;
										local T;
										local A;
										while true do
											if (FlatIdent_B6A2 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_B6A2 = 5;
											end
											if (FlatIdent_B6A2 == 6) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_B6A2 = 7;
											end
											if (FlatIdent_B6A2 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_B6A2 = 6;
											end
											if (3 == FlatIdent_B6A2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_B6A2 = 4;
											end
											if (FlatIdent_B6A2 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_B6A2 = 3;
											end
											if (FlatIdent_B6A2 == 7) then
												T = Stk[A];
												B = Inst[3];
												for Idx = 1, B do
													T[Idx] = Stk[A + Idx];
												end
												break;
											end
											if (FlatIdent_B6A2 == 0) then
												B = nil;
												T = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Inst[4];
												FlatIdent_B6A2 = 1;
											end
											if (FlatIdent_B6A2 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												FlatIdent_B6A2 = 2;
											end
										end
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 127) then
									if (Enum <= 121) then
										if (Enum <= 118) then
											if (Enum <= 116) then
												local FlatIdent_568D2 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_568D2 == 0) then
														B = nil;
														A = nil;
														A = Inst[2];
														B = Stk[Inst[3]];
														FlatIdent_568D2 = 1;
													end
													if (FlatIdent_568D2 == 6) then
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														VIP = Inst[3];
														break;
													end
													if (FlatIdent_568D2 == 1) then
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_568D2 = 2;
													end
													if (FlatIdent_568D2 == 3) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														FlatIdent_568D2 = 4;
													end
													if (FlatIdent_568D2 == 2) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_568D2 = 3;
													end
													if (FlatIdent_568D2 == 5) then
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_568D2 = 6;
													end
													if (FlatIdent_568D2 == 4) then
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_568D2 = 5;
													end
												end
											elseif (Enum > 117) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local FlatIdent_2D245 = 0;
												local K;
												local B;
												local A;
												while true do
													if (1 == FlatIdent_2D245) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2D245 = 2;
													end
													if (FlatIdent_2D245 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2D245 = 5;
													end
													if (FlatIdent_2D245 == 6) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2D245 = 7;
													end
													if (FlatIdent_2D245 == 2) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														FlatIdent_2D245 = 3;
													end
													if (FlatIdent_2D245 == 0) then
														K = nil;
														B = nil;
														A = nil;
														A = Inst[2];
														Stk[A](Stk[A + 1]);
														FlatIdent_2D245 = 1;
													end
													if (FlatIdent_2D245 == 3) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														FlatIdent_2D245 = 4;
													end
													if (FlatIdent_2D245 == 7) then
														VIP = Inst[3];
														break;
													end
													if (FlatIdent_2D245 == 5) then
														B = Inst[3];
														K = Stk[B];
														for Idx = B + 1, Inst[4] do
															K = K .. Stk[Idx];
														end
														Stk[Inst[2]] = K;
														VIP = VIP + 1;
														FlatIdent_2D245 = 6;
													end
												end
											end
										elseif (Enum <= 119) then
											local Edx;
											local Results, Limit;
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										elseif (Enum > 120) then
											local FlatIdent_4A7B7 = 0;
											local Results;
											local Edx;
											local Limit;
											local B;
											local A;
											while true do
												if (FlatIdent_4A7B7 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Results, Limit = _R(Stk[A](Stk[A + 1]));
													FlatIdent_4A7B7 = 4;
												end
												if (0 == FlatIdent_4A7B7) then
													Results = nil;
													Edx = nil;
													Results, Limit = nil;
													B = nil;
													FlatIdent_4A7B7 = 1;
												end
												if (FlatIdent_4A7B7 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_4A7B7 = 3;
												end
												if (6 == FlatIdent_4A7B7) then
													for Idx = A, Inst[4] do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_4A7B7 == 5) then
													Inst = Instr[VIP];
													A = Inst[2];
													Results = {Stk[A](Unpack(Stk, A + 1, Top))};
													Edx = 0;
													FlatIdent_4A7B7 = 6;
												end
												if (FlatIdent_4A7B7 == 1) then
													A = nil;
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4A7B7 = 2;
												end
												if (FlatIdent_4A7B7 == 4) then
													Top = (Limit + A) - 1;
													Edx = 0;
													for Idx = A, Top do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													FlatIdent_4A7B7 = 5;
												end
											end
										else
											local FlatIdent_3A6B4 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_3A6B4 == 5) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_3A6B4 = 6;
												end
												if (FlatIdent_3A6B4 == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_3A6B4 = 1;
												end
												if (3 == FlatIdent_3A6B4) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3A6B4 = 4;
												end
												if (FlatIdent_3A6B4 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_3A6B4 = 3;
												end
												if (FlatIdent_3A6B4 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3A6B4 = 5;
												end
												if (FlatIdent_3A6B4 == 6) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_3A6B4 == 1) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3A6B4 = 2;
												end
											end
										end
									elseif (Enum <= 124) then
										if (Enum <= 122) then
											local FlatIdent_49492 = 0;
											local B;
											local A;
											while true do
												if (5 == FlatIdent_49492) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_49492 = 6;
												end
												if (FlatIdent_49492 == 6) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_49492 == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_49492 = 4;
												end
												if (FlatIdent_49492 == 1) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_49492 = 2;
												end
												if (FlatIdent_49492 == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_49492 = 1;
												end
												if (FlatIdent_49492 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_49492 = 5;
												end
												if (FlatIdent_49492 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_49492 = 3;
												end
											end
										elseif (Enum > 123) then
											if (Stk[Inst[2]] == Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
										end
									elseif (Enum <= 125) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 126) then
										local FlatIdent_15653 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_15653 == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_15653 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_15653 = 2;
											end
											if (FlatIdent_15653 == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_15653 = 3;
											end
											if (FlatIdent_15653 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_15653 = 1;
											end
											if (FlatIdent_15653 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_15653 = 4;
											end
										end
									else
										local FlatIdent_245AA = 0;
										local A;
										while true do
											if (FlatIdent_245AA == 0) then
												A = nil;
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												FlatIdent_245AA = 1;
											end
											if (FlatIdent_245AA == 1) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_245AA = 2;
											end
											if (4 == FlatIdent_245AA) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
												break;
											end
											if (FlatIdent_245AA == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_245AA = 3;
											end
											if (FlatIdent_245AA == 3) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Stk[A + 1]);
												FlatIdent_245AA = 4;
											end
										end
									end
								elseif (Enum <= 133) then
									if (Enum <= 130) then
										if (Enum <= 128) then
											local B;
											local A;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
										elseif (Enum > 129) then
											local B;
											local A;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										else
											local FlatIdent_7E24D = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_7E24D == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_7E24D = 4;
												end
												if (FlatIdent_7E24D == 2) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_7E24D = 3;
												end
												if (FlatIdent_7E24D == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_7E24D = 2;
												end
												if (FlatIdent_7E24D == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													FlatIdent_7E24D = 1;
												end
												if (4 == FlatIdent_7E24D) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
											end
										end
									elseif (Enum <= 131) then
										local FlatIdent_2582F = 0;
										local A;
										local Results;
										local Edx;
										while true do
											if (FlatIdent_2582F == 1) then
												Edx = 0;
												for Idx = A, Inst[4] do
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
												end
												break;
											end
											if (FlatIdent_2582F == 0) then
												A = Inst[2];
												Results = {Stk[A](Unpack(Stk, A + 1, Top))};
												FlatIdent_2582F = 1;
											end
										end
									elseif (Enum == 132) then
										local FlatIdent_82400 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_82400 == 1) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												FlatIdent_82400 = 2;
											end
											if (2 == FlatIdent_82400) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												FlatIdent_82400 = 3;
											end
											if (FlatIdent_82400 == 4) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												FlatIdent_82400 = 5;
											end
											if (FlatIdent_82400 == 6) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												break;
											end
											if (FlatIdent_82400 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_82400 = 4;
											end
											if (FlatIdent_82400 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_82400 = 1;
											end
											if (FlatIdent_82400 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_82400 = 6;
											end
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Env[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 136) then
									if (Enum <= 134) then
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									elseif (Enum > 135) then
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Env[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
									else
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 137) then
									local FlatIdent_5B743 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_5B743 == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_5B743 = 3;
										end
										if (FlatIdent_5B743 == 1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5B743 = 2;
										end
										if (FlatIdent_5B743 == 6) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_5B743 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5B743 = 4;
										end
										if (FlatIdent_5B743 == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_5B743 = 6;
										end
										if (FlatIdent_5B743 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_5B743 = 1;
										end
										if (FlatIdent_5B743 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5B743 = 5;
										end
									end
								elseif (Enum == 138) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local FlatIdent_8D4AA = 0;
									while true do
										if (FlatIdent_8D4AA == 0) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_8D4AA = 1;
										end
										if (FlatIdent_8D4AA == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											FlatIdent_8D4AA = 4;
										end
										if (FlatIdent_8D4AA == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_8D4AA = 2;
										end
										if (FlatIdent_8D4AA == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
										if (2 == FlatIdent_8D4AA) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8D4AA = 3;
										end
									end
								end
							elseif (Enum <= 162) then
								if (Enum <= 150) then
									if (Enum <= 144) then
										if (Enum <= 141) then
											if (Enum == 140) then
												local FlatIdent_4ADD0 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_4ADD0 == 6) then
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_4ADD0 == 4) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4ADD0 = 5;
													end
													if (FlatIdent_4ADD0 == 1) then
														Stk[A] = Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4ADD0 = 2;
													end
													if (FlatIdent_4ADD0 == 3) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_4ADD0 = 4;
													end
													if (FlatIdent_4ADD0 == 2) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_4ADD0 = 3;
													end
													if (FlatIdent_4ADD0 == 5) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_4ADD0 = 6;
													end
													if (0 == FlatIdent_4ADD0) then
														B = nil;
														A = nil;
														A = Inst[2];
														FlatIdent_4ADD0 = 1;
													end
												end
											else
												local FlatIdent_103F0 = 0;
												local B;
												local A;
												while true do
													if (3 == FlatIdent_103F0) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_103F0 = 4;
													end
													if (FlatIdent_103F0 == 1) then
														Stk[A] = Stk[A](Stk[A + 1]);
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_103F0 = 2;
													end
													if (0 == FlatIdent_103F0) then
														B = nil;
														A = nil;
														A = Inst[2];
														FlatIdent_103F0 = 1;
													end
													if (2 == FlatIdent_103F0) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_103F0 = 3;
													end
													if (FlatIdent_103F0 == 6) then
														Inst = Instr[VIP];
														if not Stk[Inst[2]] then
															VIP = VIP + 1;
														else
															VIP = Inst[3];
														end
														break;
													end
													if (FlatIdent_103F0 == 5) then
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														FlatIdent_103F0 = 6;
													end
													if (FlatIdent_103F0 == 4) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_103F0 = 5;
													end
												end
											end
										elseif (Enum <= 142) then
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 143) then
											local FlatIdent_288A9 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_288A9 == 4) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (0 == FlatIdent_288A9) then
													B = nil;
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													FlatIdent_288A9 = 1;
												end
												if (FlatIdent_288A9 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_288A9 = 2;
												end
												if (FlatIdent_288A9 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_288A9 = 4;
												end
												if (2 == FlatIdent_288A9) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_288A9 = 3;
												end
											end
										else
											local FlatIdent_6AC43 = 0;
											local B;
											local A;
											while true do
												if (1 == FlatIdent_6AC43) then
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_6AC43 = 2;
												end
												if (FlatIdent_6AC43 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6AC43 = 1;
												end
												if (FlatIdent_6AC43 == 2) then
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6AC43 = 3;
												end
												if (FlatIdent_6AC43 == 6) then
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													break;
												end
												if (FlatIdent_6AC43 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3] ~= 0;
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6AC43 = 6;
												end
												if (FlatIdent_6AC43 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													FlatIdent_6AC43 = 5;
												end
												if (FlatIdent_6AC43 == 3) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_6AC43 = 4;
												end
											end
										end
									elseif (Enum <= 147) then
										if (Enum <= 145) then
											local B;
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 146) then
											local FlatIdent_8F802 = 0;
											local Results;
											local Edx;
											local Limit;
											local B;
											local A;
											while true do
												if (FlatIdent_8F802 == 2) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_8F802 = 3;
												end
												if (FlatIdent_8F802 == 7) then
													Top = (Limit + A) - 1;
													Edx = 0;
													for Idx = A, Top do
														local FlatIdent_62AEC = 0;
														while true do
															if (FlatIdent_62AEC == 0) then
																Edx = Edx + 1;
																Stk[Idx] = Results[Edx];
																break;
															end
														end
													end
													VIP = VIP + 1;
													FlatIdent_8F802 = 8;
												end
												if (FlatIdent_8F802 == 8) then
													Inst = Instr[VIP];
													A = Inst[2];
													Results = {Stk[A](Unpack(Stk, A + 1, Top))};
													Edx = 0;
													FlatIdent_8F802 = 9;
												end
												if (FlatIdent_8F802 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8F802 = 5;
												end
												if (FlatIdent_8F802 == 9) then
													for Idx = A, Inst[4] do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_8F802 == 6) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Results, Limit = _R(Stk[A](Stk[A + 1]));
													FlatIdent_8F802 = 7;
												end
												if (FlatIdent_8F802 == 5) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_8F802 = 6;
												end
												if (FlatIdent_8F802 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_8F802 = 4;
												end
												if (FlatIdent_8F802 == 1) then
													A = nil;
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8F802 = 2;
												end
												if (FlatIdent_8F802 == 0) then
													Results = nil;
													Edx = nil;
													Results, Limit = nil;
													B = nil;
													FlatIdent_8F802 = 1;
												end
											end
										else
											local FlatIdent_3CB60 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_3CB60 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3] ~= 0;
													FlatIdent_3CB60 = 4;
												end
												if (FlatIdent_3CB60 == 6) then
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_3CB60 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]] = Env[Inst[3]];
													FlatIdent_3CB60 = 1;
												end
												if (FlatIdent_3CB60 == 5) then
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_3CB60 = 6;
												end
												if (FlatIdent_3CB60 == 2) then
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_3CB60 = 3;
												end
												if (FlatIdent_3CB60 == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_3CB60 = 5;
												end
												if (FlatIdent_3CB60 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_3CB60 = 2;
												end
											end
										end
									elseif (Enum <= 148) then
										local A = Inst[2];
										local Index = Stk[A];
										local Step = Stk[A + 2];
										if (Step > 0) then
											if (Index > Stk[A + 1]) then
												VIP = Inst[3];
											else
												Stk[A + 3] = Index;
											end
										elseif (Index < Stk[A + 1]) then
											VIP = Inst[3];
										else
											Stk[A + 3] = Index;
										end
									elseif (Enum > 149) then
										local FlatIdent_1907D = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_1907D == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1907D = 2;
											end
											if (FlatIdent_1907D == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_1907D = 3;
											end
											if (FlatIdent_1907D == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_1907D = 1;
											end
											if (FlatIdent_1907D == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1907D = 5;
											end
											if (5 == FlatIdent_1907D) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_1907D = 6;
											end
											if (FlatIdent_1907D == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_1907D == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_1907D = 4;
											end
										end
									else
										Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
									end
								elseif (Enum <= 156) then
									if (Enum <= 153) then
										if (Enum <= 151) then
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]] * Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										elseif (Enum > 152) then
											local FlatIdent_3ACBD = 0;
											local A;
											while true do
												if (FlatIdent_3ACBD == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_3ACBD = 3;
												end
												if (1 == FlatIdent_3ACBD) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Stk[A + 1]);
													FlatIdent_3ACBD = 2;
												end
												if (FlatIdent_3ACBD == 0) then
													A = nil;
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_3ACBD = 1;
												end
												if (FlatIdent_3ACBD == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Env[Inst[3]] = Stk[Inst[2]];
													FlatIdent_3ACBD = 4;
												end
												if (FlatIdent_3ACBD == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													break;
												end
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 154) then
										Env[Inst[3]] = Stk[Inst[2]];
									elseif (Enum == 155) then
										local K;
										local B;
										local A;
										A = Inst[2];
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										B = Inst[3];
										K = Stk[B];
										for Idx = B + 1, Inst[4] do
											K = K .. Stk[Idx];
										end
										Stk[Inst[2]] = K;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Stk[A + 1]);
									else
										local A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 159) then
									if (Enum <= 157) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 158) then
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									else
										local Results;
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results = {Stk[A](Unpack(Stk, A + 1, Top))};
										Edx = 0;
										for Idx = A, Inst[4] do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									end
								elseif (Enum <= 160) then
									local FlatIdent_30945 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_30945 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_30945 = 4;
										end
										if (FlatIdent_30945 == 4) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_30945 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											FlatIdent_30945 = 1;
										end
										if (FlatIdent_30945 == 2) then
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_30945 = 3;
										end
										if (FlatIdent_30945 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											FlatIdent_30945 = 2;
										end
									end
								elseif (Enum == 161) then
									local Edx;
									local Results;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Stk[A + 1])};
									Edx = 0;
									for Idx = A, Inst[4] do
										local FlatIdent_1EA42 = 0;
										while true do
											if (FlatIdent_1EA42 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local FlatIdent_621D7 = 0;
									while true do
										if (FlatIdent_621D7 == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_621D7 = 4;
										end
										if (1 == FlatIdent_621D7) then
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_621D7 = 2;
										end
										if (FlatIdent_621D7 == 0) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_621D7 = 1;
										end
										if (2 == FlatIdent_621D7) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_621D7 = 3;
										end
										if (FlatIdent_621D7 == 4) then
											if (Stk[Inst[2]] == Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
									end
								end
							elseif (Enum <= 174) then
								if (Enum <= 168) then
									if (Enum <= 165) then
										if (Enum <= 163) then
											local FlatIdent_4A8B1 = 0;
											while true do
												if (FlatIdent_4A8B1 == 4) then
													Stk[Inst[2]] = Inst[3];
													break;
												end
												if (FlatIdent_4A8B1 == 1) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4A8B1 = 2;
												end
												if (3 == FlatIdent_4A8B1) then
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4A8B1 = 4;
												end
												if (FlatIdent_4A8B1 == 2) then
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4A8B1 = 3;
												end
												if (FlatIdent_4A8B1 == 0) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_4A8B1 = 1;
												end
											end
										elseif (Enum > 164) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local FlatIdent_68107 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_68107 == 1) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_68107 = 2;
												end
												if (5 == FlatIdent_68107) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_68107 = 6;
												end
												if (FlatIdent_68107 == 6) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_68107 == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_68107 = 4;
												end
												if (0 == FlatIdent_68107) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_68107 = 1;
												end
												if (FlatIdent_68107 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_68107 = 5;
												end
												if (FlatIdent_68107 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_68107 = 3;
												end
											end
										end
									elseif (Enum <= 166) then
										local FlatIdent_7DC44 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_7DC44 == 4) then
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_7DC44 = 5;
											end
											if (FlatIdent_7DC44 == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7DC44 = 3;
											end
											if (1 == FlatIdent_7DC44) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7DC44 = 2;
											end
											if (FlatIdent_7DC44 == 6) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												break;
											end
											if (0 == FlatIdent_7DC44) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_7DC44 = 1;
											end
											if (FlatIdent_7DC44 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_7DC44 = 4;
											end
											if (FlatIdent_7DC44 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_7DC44 = 6;
											end
										end
									elseif (Enum > 167) then
										local FlatIdent_31071 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_31071 == 5) then
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												break;
											end
											if (1 == FlatIdent_31071) then
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_31071 = 2;
											end
											if (FlatIdent_31071 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_31071 = 1;
											end
											if (FlatIdent_31071 == 3) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_31071 = 4;
											end
											if (FlatIdent_31071 == 4) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_31071 = 5;
											end
											if (2 == FlatIdent_31071) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_31071 = 3;
											end
										end
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 171) then
									if (Enum <= 169) then
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										do
											return;
										end
									elseif (Enum > 170) then
										local FlatIdent_888E7 = 0;
										local B;
										local A;
										while true do
											if (3 == FlatIdent_888E7) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_888E7 = 4;
											end
											if (1 == FlatIdent_888E7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_888E7 = 2;
											end
											if (FlatIdent_888E7 == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_888E7 = 3;
											end
											if (0 == FlatIdent_888E7) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_888E7 = 1;
											end
											if (FlatIdent_888E7 == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
										end
									else
										local FlatIdent_64DA4 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_64DA4 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_64DA4 = 1;
											end
											if (FlatIdent_64DA4 == 1) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_64DA4 = 2;
											end
											if (FlatIdent_64DA4 == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												FlatIdent_64DA4 = 4;
											end
											if (FlatIdent_64DA4 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
											if (FlatIdent_64DA4 == 2) then
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_64DA4 = 3;
											end
											if (FlatIdent_64DA4 == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												FlatIdent_64DA4 = 5;
											end
										end
									end
								elseif (Enum <= 172) then
									local FlatIdent_6915 = 0;
									local Edx;
									local Results;
									local Limit;
									local B;
									local A;
									while true do
										if (FlatIdent_6915 == 4) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_6915 = 5;
										end
										if (FlatIdent_6915 == 6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6915 = 7;
										end
										if (FlatIdent_6915 == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											FlatIdent_6915 = 6;
										end
										if (FlatIdent_6915 == 7) then
											A = Inst[2];
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_6915 = 8;
										end
										if (FlatIdent_6915 == 0) then
											Edx = nil;
											Results, Limit = nil;
											B = nil;
											A = nil;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											FlatIdent_6915 = 1;
										end
										if (2 == FlatIdent_6915) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_6915 = 3;
										end
										if (FlatIdent_6915 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6915 = 2;
										end
										if (FlatIdent_6915 == 8) then
											Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_6915 == 3) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_6915 = 4;
										end
									end
								elseif (Enum == 173) then
									local FlatIdent_23F67 = 0;
									local B;
									local A;
									while true do
										if (4 == FlatIdent_23F67) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_23F67 = 5;
										end
										if (FlatIdent_23F67 == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_23F67 = 3;
										end
										if (3 == FlatIdent_23F67) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_23F67 = 4;
										end
										if (FlatIdent_23F67 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_23F67 = 1;
										end
										if (FlatIdent_23F67 == 1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_23F67 = 2;
										end
										if (FlatIdent_23F67 == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_23F67 = 6;
										end
										if (FlatIdent_23F67 == 6) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
									end
								else
									local FlatIdent_604DF = 0;
									while true do
										if (FlatIdent_604DF == 5) then
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 6;
										end
										if (FlatIdent_604DF == 0) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 1;
										end
										if (FlatIdent_604DF == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 3;
										end
										if (3 == FlatIdent_604DF) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 4;
										end
										if (FlatIdent_604DF == 6) then
											do
												return;
											end
											break;
										end
										if (FlatIdent_604DF == 1) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 2;
										end
										if (FlatIdent_604DF == 4) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_604DF = 5;
										end
									end
								end
							elseif (Enum <= 180) then
								if (Enum <= 177) then
									if (Enum <= 175) then
										Stk[Inst[2]][Inst[3]] = Inst[4];
									elseif (Enum > 176) then
										local FlatIdent_82F85 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_82F85 == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_82F85 == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_82F85 = 3;
											end
											if (3 == FlatIdent_82F85) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_82F85 = 4;
											end
											if (FlatIdent_82F85 == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_82F85 = 6;
											end
											if (FlatIdent_82F85 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_82F85 = 1;
											end
											if (FlatIdent_82F85 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_82F85 = 5;
											end
											if (FlatIdent_82F85 == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_82F85 = 2;
											end
										end
									else
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									end
								elseif (Enum <= 178) then
									for Idx = Inst[2], Inst[3] do
										Stk[Idx] = nil;
									end
								elseif (Enum > 179) then
									Stk[Inst[2]] = Inst[3] ~= 0;
								else
									local FlatIdent_50ED1 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_50ED1 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_50ED1 = 5;
										end
										if (FlatIdent_50ED1 == 6) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_50ED1 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_50ED1 = 1;
										end
										if (FlatIdent_50ED1 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_50ED1 = 4;
										end
										if (FlatIdent_50ED1 == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_50ED1 = 3;
										end
										if (1 == FlatIdent_50ED1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_50ED1 = 2;
										end
										if (5 == FlatIdent_50ED1) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_50ED1 = 6;
										end
									end
								end
							elseif (Enum <= 183) then
								if (Enum <= 181) then
									local FlatIdent_10737 = 0;
									local A;
									while true do
										if (FlatIdent_10737 == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											FlatIdent_10737 = 6;
										end
										if (FlatIdent_10737 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											FlatIdent_10737 = 5;
										end
										if (0 == FlatIdent_10737) then
											A = nil;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_10737 = 1;
										end
										if (6 == FlatIdent_10737) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_10737 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_10737 = 3;
										end
										if (FlatIdent_10737 == 1) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_10737 = 2;
										end
										if (FlatIdent_10737 == 3) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_10737 = 4;
										end
									end
								elseif (Enum > 182) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 184) then
								local FlatIdent_59E4C = 0;
								while true do
									if (FlatIdent_59E4C == 1) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59E4C = 2;
									end
									if (5 == FlatIdent_59E4C) then
										VIP = Inst[3];
										break;
									end
									if (FlatIdent_59E4C == 2) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59E4C = 3;
									end
									if (FlatIdent_59E4C == 0) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59E4C = 1;
									end
									if (FlatIdent_59E4C == 3) then
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59E4C = 4;
									end
									if (FlatIdent_59E4C == 4) then
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_59E4C = 5;
									end
								end
							elseif (Enum == 185) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
							else
								local FlatIdent_E350 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_E350 == 2) then
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										FlatIdent_E350 = 3;
									end
									if (FlatIdent_E350 == 0) then
										B = nil;
										A = nil;
										A = Inst[2];
										FlatIdent_E350 = 1;
									end
									if (FlatIdent_E350 == 5) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_E350 = 6;
									end
									if (6 == FlatIdent_E350) then
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
										break;
									end
									if (FlatIdent_E350 == 1) then
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_E350 = 2;
									end
									if (FlatIdent_E350 == 3) then
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_E350 = 4;
									end
									if (FlatIdent_E350 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_E350 = 5;
									end
								end
							end
						elseif (Enum <= 279) then
							if (Enum <= 232) then
								if (Enum <= 209) then
									if (Enum <= 197) then
										if (Enum <= 191) then
											if (Enum <= 188) then
												if (Enum > 187) then
													local FlatIdent_4114B = 0;
													local B;
													local A;
													while true do
														if (FlatIdent_4114B == 5) then
															Inst = Instr[VIP];
															A = Inst[2];
															B = Stk[Inst[3]];
															Stk[A + 1] = B;
															Stk[A] = B[Inst[4]];
															VIP = VIP + 1;
															FlatIdent_4114B = 6;
														end
														if (FlatIdent_4114B == 6) then
															Inst = Instr[VIP];
															Stk[Inst[2]] = {};
															break;
														end
														if (FlatIdent_4114B == 4) then
															Stk[Inst[2]][Inst[3]] = Inst[4];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
															VIP = VIP + 1;
															FlatIdent_4114B = 5;
														end
														if (FlatIdent_4114B == 0) then
															B = nil;
															A = nil;
															Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															FlatIdent_4114B = 1;
														end
														if (FlatIdent_4114B == 3) then
															Stk[Inst[2]][Inst[3]] = Inst[4];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]][Inst[3]] = Inst[4];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_4114B = 4;
														end
														if (FlatIdent_4114B == 2) then
															Stk[A] = B[Inst[4]];
															VIP = VIP + 1;
															Inst = Instr[VIP];
															Stk[Inst[2]] = {};
															VIP = VIP + 1;
															Inst = Instr[VIP];
															FlatIdent_4114B = 3;
														end
														if (FlatIdent_4114B == 1) then
															Stk[A](Unpack(Stk, A + 1, Inst[3]));
															VIP = VIP + 1;
															Inst = Instr[VIP];
															A = Inst[2];
															B = Stk[Inst[3]];
															Stk[A + 1] = B;
															FlatIdent_4114B = 2;
														end
													end
												else
													local B;
													local A;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
												end
											elseif (Enum <= 189) then
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Env[Inst[3]] = Stk[Inst[2]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
											elseif (Enum > 190) then
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
											else
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											end
										elseif (Enum <= 194) then
											if (Enum <= 192) then
												local B;
												local A;
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												VIP = Inst[3];
											elseif (Enum > 193) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local FlatIdent_7C382 = 0;
												local A;
												while true do
													if (FlatIdent_7C382 == 4) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														FlatIdent_7C382 = 5;
													end
													if (FlatIdent_7C382 == 6) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														FlatIdent_7C382 = 7;
													end
													if (2 == FlatIdent_7C382) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Stk[Inst[3]];
														VIP = VIP + 1;
														FlatIdent_7C382 = 3;
													end
													if (FlatIdent_7C382 == 7) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														VIP = Inst[3];
														break;
													end
													if (FlatIdent_7C382 == 0) then
														A = nil;
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														FlatIdent_7C382 = 1;
													end
													if (FlatIdent_7C382 == 1) then
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														FlatIdent_7C382 = 2;
													end
													if (FlatIdent_7C382 == 5) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]][Inst[3]] = Inst[4];
														FlatIdent_7C382 = 6;
													end
													if (3 == FlatIdent_7C382) then
														Inst = Instr[VIP];
														A = Inst[2];
														Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
														FlatIdent_7C382 = 4;
													end
												end
											end
										elseif (Enum <= 195) then
											do
												return;
											end
										elseif (Enum == 196) then
											local FlatIdent_89850 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_89850 == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_89850 = 1;
												end
												if (FlatIdent_89850 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_89850 = 3;
												end
												if (FlatIdent_89850 == 5) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_89850 = 6;
												end
												if (FlatIdent_89850 == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_89850 = 5;
												end
												if (FlatIdent_89850 == 1) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_89850 = 2;
												end
												if (FlatIdent_89850 == 6) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_89850 == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_89850 = 4;
												end
											end
										else
											local B;
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										end
									elseif (Enum <= 203) then
										if (Enum <= 200) then
											if (Enum <= 198) then
												local FlatIdent_86A91 = 0;
												while true do
													if (FlatIdent_86A91 == 2) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 3;
													end
													if (FlatIdent_86A91 == 6) then
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 7;
													end
													if (FlatIdent_86A91 == 7) then
														Stk[Inst[2]] = Env[Inst[3]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 8;
													end
													if (FlatIdent_86A91 == 1) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 2;
													end
													if (FlatIdent_86A91 == 3) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 4;
													end
													if (FlatIdent_86A91 == 0) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 1;
													end
													if (FlatIdent_86A91 == 9) then
														Stk[Inst[2]] = Inst[3];
														break;
													end
													if (FlatIdent_86A91 == 4) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 5;
													end
													if (8 == FlatIdent_86A91) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 9;
													end
													if (FlatIdent_86A91 == 5) then
														Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_86A91 = 6;
													end
												end
											elseif (Enum > 199) then
												local B;
												local A;
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3] ~= 0;
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
											else
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 201) then
											local FlatIdent_100D9 = 0;
											local Results;
											local Edx;
											local Limit;
											local B;
											local A;
											while true do
												if (FlatIdent_100D9 == 2) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													FlatIdent_100D9 = 3;
												end
												if (3 == FlatIdent_100D9) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_100D9 = 4;
												end
												if (FlatIdent_100D9 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Results, Limit = _R(Stk[A](Stk[A + 1]));
													Top = (Limit + A) - 1;
													FlatIdent_100D9 = 6;
												end
												if (FlatIdent_100D9 == 1) then
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_100D9 = 2;
												end
												if (FlatIdent_100D9 == 4) then
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_100D9 = 5;
												end
												if (FlatIdent_100D9 == 8) then
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_100D9 == 6) then
													Edx = 0;
													for Idx = A, Top do
														local FlatIdent_93E2 = 0;
														while true do
															if (0 == FlatIdent_93E2) then
																Edx = Edx + 1;
																Stk[Idx] = Results[Edx];
																break;
															end
														end
													end
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_100D9 = 7;
												end
												if (FlatIdent_100D9 == 7) then
													Results = {Stk[A](Unpack(Stk, A + 1, Top))};
													Edx = 0;
													for Idx = A, Inst[4] do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_100D9 = 8;
												end
												if (FlatIdent_100D9 == 0) then
													Results = nil;
													Edx = nil;
													Results, Limit = nil;
													B = nil;
													A = nil;
													FlatIdent_100D9 = 1;
												end
											end
										elseif (Enum > 202) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local FlatIdent_7B58B = 0;
											local B;
											local A;
											while true do
												if (0 == FlatIdent_7B58B) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													FlatIdent_7B58B = 1;
												end
												if (FlatIdent_7B58B == 5) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													break;
												end
												if (FlatIdent_7B58B == 1) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_7B58B = 2;
												end
												if (FlatIdent_7B58B == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													FlatIdent_7B58B = 4;
												end
												if (FlatIdent_7B58B == 4) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_7B58B = 5;
												end
												if (FlatIdent_7B58B == 2) then
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_7B58B = 3;
												end
											end
										end
									elseif (Enum <= 206) then
										if (Enum <= 204) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 205) then
											local FlatIdent_56BBA = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_56BBA == 5) then
													Inst = Instr[VIP];
													if Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_56BBA == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_56BBA = 1;
												end
												if (FlatIdent_56BBA == 4) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_56BBA = 5;
												end
												if (FlatIdent_56BBA == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_56BBA = 2;
												end
												if (FlatIdent_56BBA == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_56BBA = 4;
												end
												if (FlatIdent_56BBA == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_56BBA = 3;
												end
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 207) then
										local A = Inst[2];
										Stk[A](Stk[A + 1]);
									elseif (Enum > 208) then
										local FlatIdent_44C6 = 0;
										local A;
										while true do
											if (9 == FlatIdent_44C6) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												break;
											end
											if (FlatIdent_44C6 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 9;
											end
											if (FlatIdent_44C6 == 6) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 7;
											end
											if (FlatIdent_44C6 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 5;
											end
											if (FlatIdent_44C6 == 7) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 8;
											end
											if (FlatIdent_44C6 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 1;
											end
											if (FlatIdent_44C6 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 3;
											end
											if (FlatIdent_44C6 == 1) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 2;
											end
											if (FlatIdent_44C6 == 3) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 4;
											end
											if (FlatIdent_44C6 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												FlatIdent_44C6 = 6;
											end
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 220) then
									if (Enum <= 214) then
										if (Enum <= 211) then
											if (Enum > 210) then
												local FlatIdent_2D06D = 0;
												local B;
												local A;
												while true do
													if (3 == FlatIdent_2D06D) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														Stk[Inst[2]] = Inst[3] ~= 0;
														FlatIdent_2D06D = 4;
													end
													if (FlatIdent_2D06D == 5) then
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_2D06D = 6;
													end
													if (4 == FlatIdent_2D06D) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_2D06D = 5;
													end
													if (FlatIdent_2D06D == 0) then
														B = nil;
														A = nil;
														Stk[Inst[2]] = Env[Inst[3]];
														FlatIdent_2D06D = 1;
													end
													if (6 == FlatIdent_2D06D) then
														VIP = Inst[3];
														break;
													end
													if (FlatIdent_2D06D == 2) then
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														Stk[A] = B[Inst[4]];
														FlatIdent_2D06D = 3;
													end
													if (1 == FlatIdent_2D06D) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_2D06D = 2;
													end
												end
											else
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											end
										elseif (Enum <= 212) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 213) then
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										else
											local FlatIdent_95B21 = 0;
											local Results;
											local Edx;
											local Limit;
											local B;
											local A;
											while true do
												if (FlatIdent_95B21 == 1) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]]();
													VIP = VIP + 1;
													FlatIdent_95B21 = 2;
												end
												if (FlatIdent_95B21 == 4) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_95B21 = 5;
												end
												if (FlatIdent_95B21 == 6) then
													Results, Limit = _R(Stk[A](Stk[A + 1]));
													Top = (Limit + A) - 1;
													Edx = 0;
													for Idx = A, Top do
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
													end
													VIP = VIP + 1;
													FlatIdent_95B21 = 7;
												end
												if (FlatIdent_95B21 == 0) then
													Results = nil;
													Edx = nil;
													Results, Limit = nil;
													B = nil;
													A = nil;
													FlatIdent_95B21 = 1;
												end
												if (FlatIdent_95B21 == 5) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_95B21 = 6;
												end
												if (FlatIdent_95B21 == 2) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													FlatIdent_95B21 = 3;
												end
												if (FlatIdent_95B21 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_95B21 = 4;
												end
												if (7 == FlatIdent_95B21) then
													Inst = Instr[VIP];
													A = Inst[2];
													Results = {Stk[A](Unpack(Stk, A + 1, Top))};
													Edx = 0;
													for Idx = A, Inst[4] do
														local FlatIdent_5299F = 0;
														while true do
															if (FlatIdent_5299F == 0) then
																Edx = Edx + 1;
																Stk[Idx] = Results[Edx];
																break;
															end
														end
													end
													FlatIdent_95B21 = 8;
												end
												if (FlatIdent_95B21 == 8) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
											end
										end
									elseif (Enum <= 217) then
										if (Enum <= 215) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
										elseif (Enum > 216) then
											local Edx;
											local Results, Limit;
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local A;
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
										end
									elseif (Enum <= 218) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Enum == 219) then
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local T;
										local A;
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 226) then
									if (Enum <= 223) then
										if (Enum <= 221) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										elseif (Enum > 222) then
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										else
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										end
									elseif (Enum <= 224) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
									elseif (Enum > 225) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3] ~= 0;
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
									end
								elseif (Enum <= 229) then
									if (Enum <= 227) then
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										for Idx = Inst[2], Inst[3] do
											Stk[Idx] = nil;
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum == 228) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										Stk[Inst[2]] = #Stk[Inst[3]];
									end
								elseif (Enum <= 230) then
									local FlatIdent_5B631 = 0;
									local B;
									local A;
									while true do
										if (4 == FlatIdent_5B631) then
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_5B631 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											FlatIdent_5B631 = 1;
										end
										if (FlatIdent_5B631 == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_5B631 = 4;
										end
										if (2 == FlatIdent_5B631) then
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_5B631 = 3;
										end
										if (FlatIdent_5B631 == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											FlatIdent_5B631 = 2;
										end
									end
								elseif (Enum == 231) then
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 255) then
								if (Enum <= 243) then
									if (Enum <= 237) then
										if (Enum <= 234) then
											if (Enum > 233) then
												local B;
												local A;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
											else
												local FlatIdent_7C884 = 0;
												local B;
												local A;
												while true do
													if (FlatIdent_7C884 == 2) then
														Stk[A](Unpack(Stk, A + 1, Inst[3]));
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7C884 = 3;
													end
													if (FlatIdent_7C884 == 4) then
														Stk[A] = B[Inst[4]];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7C884 = 5;
													end
													if (1 == FlatIdent_7C884) then
														VIP = VIP + 1;
														Inst = Instr[VIP];
														A = Inst[2];
														FlatIdent_7C884 = 2;
													end
													if (FlatIdent_7C884 == 0) then
														B = nil;
														A = nil;
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														FlatIdent_7C884 = 1;
													end
													if (FlatIdent_7C884 == 7) then
														Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
														break;
													end
													if (FlatIdent_7C884 == 6) then
														Stk[Inst[2]] = Inst[3];
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7C884 = 7;
													end
													if (FlatIdent_7C884 == 5) then
														Stk[Inst[2]] = {};
														VIP = VIP + 1;
														Inst = Instr[VIP];
														FlatIdent_7C884 = 6;
													end
													if (FlatIdent_7C884 == 3) then
														A = Inst[2];
														B = Stk[Inst[3]];
														Stk[A + 1] = B;
														FlatIdent_7C884 = 4;
													end
												end
											end
										elseif (Enum <= 235) then
											local B;
											local A;
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										elseif (Enum > 236) then
											local B;
											local A;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
										else
											local K;
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											B = Inst[3];
											K = Stk[B];
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
										end
									elseif (Enum <= 240) then
										if (Enum <= 238) then
											Stk[Inst[2]] = Stk[Inst[3]];
										elseif (Enum > 239) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										else
											local FlatIdent_50678 = 0;
											local A;
											while true do
												if (FlatIdent_50678 == 5) then
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													FlatIdent_50678 = 6;
												end
												if (FlatIdent_50678 == 4) then
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_50678 = 5;
												end
												if (FlatIdent_50678 == 6) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_50678 == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													FlatIdent_50678 = 3;
												end
												if (FlatIdent_50678 == 3) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_50678 = 4;
												end
												if (FlatIdent_50678 == 1) then
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													FlatIdent_50678 = 2;
												end
												if (FlatIdent_50678 == 0) then
													A = nil;
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_50678 = 1;
												end
											end
										end
									elseif (Enum <= 241) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 242) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
									end
								elseif (Enum <= 249) then
									if (Enum <= 246) then
										if (Enum <= 244) then
											local FlatIdent_2284F = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_2284F == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_2284F = 1;
												end
												if (FlatIdent_2284F == 4) then
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2284F = 5;
												end
												if (FlatIdent_2284F == 5) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_2284F = 6;
												end
												if (FlatIdent_2284F == 7) then
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (6 == FlatIdent_2284F) then
													Stk[Inst[2]] = Inst[3] ~= 0;
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_2284F = 7;
												end
												if (FlatIdent_2284F == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													FlatIdent_2284F = 3;
												end
												if (FlatIdent_2284F == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_2284F = 4;
												end
												if (FlatIdent_2284F == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Inst[4];
													FlatIdent_2284F = 2;
												end
											end
										elseif (Enum == 245) then
											local FlatIdent_6BA80 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_6BA80 == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													FlatIdent_6BA80 = 1;
												end
												if (4 == FlatIdent_6BA80) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_6BA80 == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_6BA80 = 4;
												end
												if (1 == FlatIdent_6BA80) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_6BA80 = 2;
												end
												if (FlatIdent_6BA80 == 2) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_6BA80 = 3;
												end
											end
										else
											local FlatIdent_8BA67 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_8BA67 == 2) then
													Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8BA67 = 3;
												end
												if (FlatIdent_8BA67 == 4) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8BA67 = 5;
												end
												if (FlatIdent_8BA67 == 6) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8BA67 = 7;
												end
												if (FlatIdent_8BA67 == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_8BA67 = 2;
												end
												if (FlatIdent_8BA67 == 5) then
													Stk[Inst[2]] = {};
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_8BA67 = 6;
												end
												if (FlatIdent_8BA67 == 7) then
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													break;
												end
												if (0 == FlatIdent_8BA67) then
													B = nil;
													A = nil;
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													FlatIdent_8BA67 = 1;
												end
												if (3 == FlatIdent_8BA67) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_8BA67 = 4;
												end
											end
										end
									elseif (Enum <= 247) then
										local FlatIdent_1A665 = 0;
										local A;
										local B;
										while true do
											if (FlatIdent_1A665 == 0) then
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_1A665 = 1;
											end
											if (FlatIdent_1A665 == 1) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												break;
											end
										end
									elseif (Enum > 248) then
										local FlatIdent_73B1E = 0;
										local A;
										while true do
											if (FlatIdent_73B1E == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												FlatIdent_73B1E = 4;
											end
											if (0 == FlatIdent_73B1E) then
												A = nil;
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_73B1E = 1;
											end
											if (FlatIdent_73B1E == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												FlatIdent_73B1E = 5;
											end
											if (FlatIdent_73B1E == 1) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_73B1E = 2;
											end
											if (FlatIdent_73B1E == 2) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												FlatIdent_73B1E = 3;
											end
											if (FlatIdent_73B1E == 5) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
										end
									else
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
									end
								elseif (Enum <= 252) then
									if (Enum <= 250) then
										local FlatIdent_405CA = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_405CA == 1) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_405CA = 2;
											end
											if (6 == FlatIdent_405CA) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_405CA = 7;
											end
											if (FlatIdent_405CA == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												break;
											end
											if (FlatIdent_405CA == 5) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_405CA = 6;
											end
											if (FlatIdent_405CA == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_405CA = 4;
											end
											if (FlatIdent_405CA == 2) then
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_405CA = 3;
											end
											if (FlatIdent_405CA == 4) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_405CA = 5;
											end
											if (0 == FlatIdent_405CA) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_405CA = 1;
											end
										end
									elseif (Enum == 251) then
										local FlatIdent_2EE94 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_2EE94 == 3) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_2EE94 = 4;
											end
											if (FlatIdent_2EE94 == 4) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_2EE94 = 5;
											end
											if (FlatIdent_2EE94 == 6) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_2EE94 = 7;
											end
											if (FlatIdent_2EE94 == 2) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = #Stk[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_2EE94 = 3;
											end
											if (FlatIdent_2EE94 == 1) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_2EE94 = 2;
											end
											if (7 == FlatIdent_2EE94) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if (Stk[Inst[2]] == Stk[Inst[4]]) then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_2EE94 == 5) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_2EE94 = 6;
											end
											if (FlatIdent_2EE94 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2EE94 = 1;
											end
										end
									else
										local FlatIdent_6D110 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_6D110 == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6D110 = 3;
											end
											if (FlatIdent_6D110 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_6D110 = 4;
											end
											if (4 == FlatIdent_6D110) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_6D110 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_6D110 = 1;
											end
											if (1 == FlatIdent_6D110) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_6D110 = 2;
											end
										end
									end
								elseif (Enum <= 253) then
									local B;
									local A;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
								elseif (Enum > 254) then
									local FlatIdent_44FA7 = 0;
									local A;
									while true do
										if (0 == FlatIdent_44FA7) then
											A = Inst[2];
											do
												return Unpack(Stk, A, Top);
											end
											break;
										end
									end
								else
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										local FlatIdent_76C4A = 0;
										while true do
											if (FlatIdent_76C4A == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 267) then
								if (Enum <= 261) then
									if (Enum <= 258) then
										if (Enum <= 256) then
											local B;
											local A;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Env[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if (Stk[Inst[2]] == Inst[4]) then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum == 257) then
											local B;
											local A;
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
										else
											local A;
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Env[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
										end
									elseif (Enum <= 259) then
										local FlatIdent_70D68 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_70D68 == 9) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												break;
											end
											if (6 == FlatIdent_70D68) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_70D68 = 7;
											end
											if (FlatIdent_70D68 == 5) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_70D68 = 6;
											end
											if (FlatIdent_70D68 == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_70D68 = 4;
											end
											if (2 == FlatIdent_70D68) then
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_70D68 = 3;
											end
											if (FlatIdent_70D68 == 1) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_70D68 = 2;
											end
											if (4 == FlatIdent_70D68) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_70D68 = 5;
											end
											if (FlatIdent_70D68 == 7) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_70D68 = 8;
											end
											if (FlatIdent_70D68 == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_70D68 = 1;
											end
											if (FlatIdent_70D68 == 8) then
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_70D68 = 9;
											end
										end
									elseif (Enum == 260) then
										local FlatIdent_726E7 = 0;
										local B;
										local K;
										while true do
											if (FlatIdent_726E7 == 0) then
												B = Inst[3];
												K = Stk[B];
												FlatIdent_726E7 = 1;
											end
											if (FlatIdent_726E7 == 1) then
												for Idx = B + 1, Inst[4] do
													K = K .. Stk[Idx];
												end
												Stk[Inst[2]] = K;
												break;
											end
										end
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 264) then
									if (Enum <= 262) then
										local FlatIdent_5DAF = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_5DAF == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5DAF = 5;
											end
											if (FlatIdent_5DAF == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_5DAF == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5DAF = 4;
											end
											if (FlatIdent_5DAF == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_5DAF = 2;
											end
											if (FlatIdent_5DAF == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_5DAF = 6;
											end
											if (FlatIdent_5DAF == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_5DAF = 3;
											end
											if (FlatIdent_5DAF == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_5DAF = 1;
											end
										end
									elseif (Enum > 263) then
										local A;
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									else
										local FlatIdent_2778E = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_2778E == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (3 == FlatIdent_2778E) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2778E = 4;
											end
											if (FlatIdent_2778E == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_2778E = 1;
											end
											if (FlatIdent_2778E == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2778E = 2;
											end
											if (FlatIdent_2778E == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2778E = 5;
											end
											if (FlatIdent_2778E == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_2778E = 6;
											end
											if (FlatIdent_2778E == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_2778E = 3;
											end
										end
									end
								elseif (Enum <= 265) then
									local FlatIdent_2E6A0 = 0;
									while true do
										if (FlatIdent_2E6A0 == 5) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_2E6A0 == 4) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E6A0 = 5;
										end
										if (FlatIdent_2E6A0 == 0) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E6A0 = 1;
										end
										if (FlatIdent_2E6A0 == 2) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E6A0 = 3;
										end
										if (FlatIdent_2E6A0 == 3) then
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E6A0 = 4;
										end
										if (FlatIdent_2E6A0 == 1) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_2E6A0 = 2;
										end
									end
								elseif (Enum > 266) then
									if (Stk[Inst[2]] == Stk[Inst[4]]) then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								end
							elseif (Enum <= 273) then
								if (Enum <= 270) then
									if (Enum <= 268) then
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Env[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 269) then
										local FlatIdent_2DFF7 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_2DFF7 == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2DFF7 = 3;
											end
											if (FlatIdent_2DFF7 == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_2DFF7 = 2;
											end
											if (FlatIdent_2DFF7 == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_2DFF7 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_2DFF7 = 1;
											end
											if (FlatIdent_2DFF7 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_2DFF7 = 4;
											end
										end
									else
										local FlatIdent_17CCF = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_17CCF == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_17CCF = 4;
											end
											if (FlatIdent_17CCF == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_17CCF = 3;
											end
											if (FlatIdent_17CCF == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_17CCF = 2;
											end
											if (FlatIdent_17CCF == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_17CCF == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_17CCF = 1;
											end
										end
									end
								elseif (Enum <= 271) then
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum == 272) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local FlatIdent_8A411 = 0;
									while true do
										if (FlatIdent_8A411 == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_8A411 = 5;
										end
										if (FlatIdent_8A411 == 5) then
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
										if (1 == FlatIdent_8A411) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_8A411 = 2;
										end
										if (FlatIdent_8A411 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_8A411 = 3;
										end
										if (FlatIdent_8A411 == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_8A411 = 4;
										end
										if (FlatIdent_8A411 == 0) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_8A411 = 1;
										end
									end
								end
							elseif (Enum <= 276) then
								if (Enum <= 274) then
									local K;
									local B;
									B = Inst[3];
									K = Stk[B];
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
								elseif (Enum > 275) then
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A = Inst[2];
									local Step = Stk[A + 2];
									local Index = Stk[A] + Step;
									Stk[A] = Index;
									if (Step > 0) then
										if (Index <= Stk[A + 1]) then
											VIP = Inst[3];
											Stk[A + 3] = Index;
										end
									elseif (Index >= Stk[A + 1]) then
										VIP = Inst[3];
										Stk[A + 3] = Index;
									end
								end
							elseif (Enum <= 277) then
								local B;
								local A;
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 278) then
								local FlatIdent_62A3E = 0;
								local Edx;
								local Results;
								local Limit;
								local B;
								local A;
								while true do
									if (FlatIdent_62A3E == 4) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										FlatIdent_62A3E = 5;
									end
									if (0 == FlatIdent_62A3E) then
										Edx = nil;
										Results, Limit = nil;
										B = nil;
										A = nil;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_62A3E = 1;
									end
									if (FlatIdent_62A3E == 7) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										break;
									end
									if (FlatIdent_62A3E == 6) then
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_62A3E = 7;
									end
									if (FlatIdent_62A3E == 2) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										FlatIdent_62A3E = 3;
									end
									if (FlatIdent_62A3E == 1) then
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_62A3E = 2;
									end
									if (FlatIdent_62A3E == 5) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										FlatIdent_62A3E = 6;
									end
									if (FlatIdent_62A3E == 3) then
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											local FlatIdent_5A208 = 0;
											while true do
												if (0 == FlatIdent_5A208) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_62A3E = 4;
									end
								end
							else
								local B;
								local A;
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum <= 326) then
							if (Enum <= 302) then
								if (Enum <= 290) then
									if (Enum <= 284) then
										if (Enum <= 281) then
											if (Enum > 280) then
												local B;
												local A;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
											else
												local A = Inst[2];
												local T = Stk[A];
												for Idx = A + 1, Inst[3] do
													Insert(T, Stk[Idx]);
												end
											end
										elseif (Enum <= 282) then
											local A = Inst[2];
											local Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											local Edx = 0;
											for Idx = A, Top do
												local FlatIdent_4BE74 = 0;
												while true do
													if (FlatIdent_4BE74 == 0) then
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
														break;
													end
												end
											end
										elseif (Enum > 283) then
											local FlatIdent_75BCF = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_75BCF == 3) then
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_75BCF = 4;
												end
												if (FlatIdent_75BCF == 4) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_75BCF = 5;
												end
												if (2 == FlatIdent_75BCF) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													FlatIdent_75BCF = 3;
												end
												if (FlatIdent_75BCF == 1) then
													Stk[A] = Stk[A](Stk[A + 1]);
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_75BCF = 2;
												end
												if (FlatIdent_75BCF == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													FlatIdent_75BCF = 1;
												end
												if (FlatIdent_75BCF == 6) then
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (5 == FlatIdent_75BCF) then
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_75BCF = 6;
												end
											end
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 287) then
										if (Enum <= 285) then
											local FlatIdent_704E3 = 0;
											while true do
												if (FlatIdent_704E3 == 0) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_704E3 = 1;
												end
												if (FlatIdent_704E3 == 4) then
													Inst = Instr[VIP];
													Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Env[Inst[3]];
													FlatIdent_704E3 = 5;
												end
												if (FlatIdent_704E3 == 3) then
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													FlatIdent_704E3 = 4;
												end
												if (6 == FlatIdent_704E3) then
													Stk[Inst[2]]();
													VIP = VIP + 1;
													Inst = Instr[VIP];
													VIP = Inst[3];
													break;
												end
												if (FlatIdent_704E3 == 5) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_704E3 = 6;
												end
												if (FlatIdent_704E3 == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													FlatIdent_704E3 = 2;
												end
												if (FlatIdent_704E3 == 2) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_704E3 = 3;
												end
											end
										elseif (Enum > 286) then
											local B;
											local A;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
										else
											local FlatIdent_52769 = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_52769 == 4) then
													Inst = Instr[VIP];
													A = Inst[2];
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													FlatIdent_52769 = 5;
												end
												if (FlatIdent_52769 == 1) then
													Inst = Instr[VIP];
													Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_52769 = 2;
												end
												if (FlatIdent_52769 == 5) then
													Inst = Instr[VIP];
													if Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
												if (FlatIdent_52769 == 2) then
													A = Inst[2];
													B = Stk[Inst[3]];
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													FlatIdent_52769 = 3;
												end
												if (FlatIdent_52769 == 3) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													FlatIdent_52769 = 4;
												end
												if (FlatIdent_52769 == 0) then
													B = nil;
													A = nil;
													Stk[Inst[2]] = Env[Inst[3]];
													VIP = VIP + 1;
													FlatIdent_52769 = 1;
												end
											end
										end
									elseif (Enum <= 288) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 289) then
										local B;
										local A;
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
									else
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									end
								elseif (Enum <= 296) then
									if (Enum <= 293) then
										if (Enum <= 291) then
											local K;
											local B;
											local A;
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											B = Inst[3];
											K = Stk[B];
											for Idx = B + 1, Inst[4] do
												K = K .. Stk[Idx];
											end
											Stk[Inst[2]] = K;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]]();
										elseif (Enum == 292) then
											local B;
											local Edx;
											local Results, Limit;
											local A;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Results, Limit = _R(Stk[A](Stk[A + 1]));
											Top = (Limit + A) - 1;
											Edx = 0;
											for Idx = A, Top do
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
											end
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 294) then
										local Results;
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Stk[A + 1]));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results = {Stk[A](Unpack(Stk, A + 1, Top))};
										Edx = 0;
										for Idx = A, Inst[4] do
											local FlatIdent_618A8 = 0;
											while true do
												if (FlatIdent_618A8 == 0) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum == 295) then
										if (Inst[2] <= Stk[Inst[4]]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local A = Inst[2];
										Top = (A + Varargsz) - 1;
										for Idx = A, Top do
											local VA = Vararg[Idx - A];
											Stk[Idx] = VA;
										end
									end
								elseif (Enum <= 299) then
									if (Enum <= 297) then
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										VIP = Inst[3];
									elseif (Enum > 298) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									else
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 300) then
									local NewProto = Proto[Inst[3]];
									local NewUvals;
									local Indexes = {};
									NewUvals = Setmetatable({}, {__index=function(_, Key)
										local Val = Indexes[Key];
										return Val[1][Val[2]];
									end,__newindex=function(_, Key, Value)
										local Val = Indexes[Key];
										Val[1][Val[2]] = Value;
									end});
									for Idx = 1, Inst[4] do
										VIP = VIP + 1;
										local Mvm = Instr[VIP];
										if (Mvm[1] == 238) then
											Indexes[Idx - 1] = {Stk,Mvm[3]};
										else
											Indexes[Idx - 1] = {Upvalues,Mvm[3]};
										end
										Lupvals[#Lupvals + 1] = Indexes;
									end
									Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
								elseif (Enum == 301) then
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local B;
									local A;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
								end
							elseif (Enum <= 314) then
								if (Enum <= 308) then
									if (Enum <= 305) then
										if (Enum <= 303) then
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										elseif (Enum > 304) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
										else
											local B;
											local A;
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
										end
									elseif (Enum <= 306) then
										local Edx;
										local Results, Limit;
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											local FlatIdent_77C61 = 0;
											while true do
												if (0 == FlatIdent_77C61) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
									elseif (Enum == 307) then
										local FlatIdent_207AF = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_207AF == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_207AF = 1;
											end
											if (1 == FlatIdent_207AF) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_207AF = 2;
											end
											if (FlatIdent_207AF == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = {};
												FlatIdent_207AF = 4;
											end
											if (FlatIdent_207AF == 2) then
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_207AF = 3;
											end
											if (FlatIdent_207AF == 4) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
										end
									else
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if (Stk[Inst[2]] == Inst[4]) then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									end
								elseif (Enum <= 311) then
									if (Enum <= 309) then
										local FlatIdent_826F5 = 0;
										local A;
										while true do
											if (FlatIdent_826F5 == 2) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												FlatIdent_826F5 = 3;
											end
											if (FlatIdent_826F5 == 0) then
												A = nil;
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_826F5 = 1;
											end
											if (FlatIdent_826F5 == 1) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												FlatIdent_826F5 = 2;
											end
											if (FlatIdent_826F5 == 5) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
											if (3 == FlatIdent_826F5) then
												Inst = Instr[VIP];
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_826F5 = 4;
											end
											if (FlatIdent_826F5 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_826F5 = 5;
											end
										end
									elseif (Enum == 310) then
										Stk[Inst[2]] = {};
									else
										local FlatIdent_3A96A = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_3A96A == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_3A96A = 2;
											end
											if (FlatIdent_3A96A == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_3A96A = 1;
											end
											if (FlatIdent_3A96A == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_3A96A == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_3A96A = 3;
											end
											if (FlatIdent_3A96A == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_3A96A = 4;
											end
										end
									end
								elseif (Enum <= 312) then
									local FlatIdent_475DA = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_475DA == 3) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_475DA = 4;
										end
										if (FlatIdent_475DA == 2) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_475DA = 3;
										end
										if (FlatIdent_475DA == 4) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_475DA = 5;
										end
										if (FlatIdent_475DA == 1) then
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_475DA = 2;
										end
										if (5 == FlatIdent_475DA) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = {};
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_475DA = 6;
										end
										if (FlatIdent_475DA == 0) then
											B = nil;
											A = nil;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_475DA = 1;
										end
										if (FlatIdent_475DA == 6) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											break;
										end
									end
								elseif (Enum == 313) then
									local FlatIdent_237AA = 0;
									local Edx;
									local Results;
									local A;
									while true do
										if (7 == FlatIdent_237AA) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
										if (FlatIdent_237AA == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_237AA = 5;
										end
										if (FlatIdent_237AA == 1) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_237AA = 2;
										end
										if (FlatIdent_237AA == 3) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_237AA = 4;
										end
										if (FlatIdent_237AA == 6) then
											A = Inst[2];
											Results = {Stk[A](Stk[A + 1])};
											Edx = 0;
											for Idx = A, Inst[4] do
												local FlatIdent_2ABD9 = 0;
												while true do
													if (FlatIdent_2ABD9 == 0) then
														Edx = Edx + 1;
														Stk[Idx] = Results[Edx];
														break;
													end
												end
											end
											FlatIdent_237AA = 7;
										end
										if (0 == FlatIdent_237AA) then
											Edx = nil;
											Results = nil;
											A = nil;
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											FlatIdent_237AA = 1;
										end
										if (FlatIdent_237AA == 5) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_237AA = 6;
										end
										if (FlatIdent_237AA == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_237AA = 3;
										end
									end
								else
									local FlatIdent_61B67 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_61B67 == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_61B67 = 3;
										end
										if (FlatIdent_61B67 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_61B67 = 1;
										end
										if (FlatIdent_61B67 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_61B67 = 5;
										end
										if (3 == FlatIdent_61B67) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_61B67 = 4;
										end
										if (FlatIdent_61B67 == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_61B67 = 6;
										end
										if (FlatIdent_61B67 == 6) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_61B67 == 1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_61B67 = 2;
										end
									end
								end
							elseif (Enum <= 320) then
								if (Enum <= 317) then
									if (Enum <= 315) then
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 316) then
										local FlatIdent_6A140 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_6A140 == 6) then
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												FlatIdent_6A140 = 7;
											end
											if (FlatIdent_6A140 == 2) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_6A140 = 3;
											end
											if (FlatIdent_6A140 == 1) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6A140 = 2;
											end
											if (FlatIdent_6A140 == 5) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Env[Inst[3]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6A140 = 6;
											end
											if (4 == FlatIdent_6A140) then
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												FlatIdent_6A140 = 5;
											end
											if (0 == FlatIdent_6A140) then
												B = nil;
												A = nil;
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_6A140 = 1;
											end
											if (FlatIdent_6A140 == 7) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
												VIP = VIP + 1;
												FlatIdent_6A140 = 8;
											end
											if (FlatIdent_6A140 == 8) then
												Inst = Instr[VIP];
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_6A140 = 9;
											end
											if (FlatIdent_6A140 == 9) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												break;
											end
											if (3 == FlatIdent_6A140) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_6A140 = 4;
											end
										end
									else
										local B;
										local T;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										T = Stk[A];
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
									end
								elseif (Enum <= 318) then
									local FlatIdent_1B19A = 0;
									while true do
										if (9 == FlatIdent_1B19A) then
											Stk[Inst[2]] = Inst[3];
											break;
										end
										if (FlatIdent_1B19A == 0) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_1B19A = 1;
										end
										if (FlatIdent_1B19A == 2) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1B19A = 3;
										end
										if (FlatIdent_1B19A == 1) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_1B19A = 2;
										end
										if (FlatIdent_1B19A == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1B19A = 9;
										end
										if (FlatIdent_1B19A == 3) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_1B19A = 4;
										end
										if (FlatIdent_1B19A == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_1B19A = 6;
										end
										if (FlatIdent_1B19A == 6) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											FlatIdent_1B19A = 7;
										end
										if (FlatIdent_1B19A == 4) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											FlatIdent_1B19A = 5;
										end
										if (FlatIdent_1B19A == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_1B19A = 8;
										end
									end
								elseif (Enum > 319) then
									local FlatIdent_39DBF = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_39DBF == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_39DBF = 6;
										end
										if (2 == FlatIdent_39DBF) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_39DBF = 3;
										end
										if (FlatIdent_39DBF == 1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_39DBF = 2;
										end
										if (FlatIdent_39DBF == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_39DBF = 4;
										end
										if (FlatIdent_39DBF == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_39DBF = 5;
										end
										if (6 == FlatIdent_39DBF) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_39DBF == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_39DBF = 1;
										end
									end
								elseif (Stk[Inst[2]] ~= Stk[Inst[4]]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum <= 323) then
								if (Enum <= 321) then
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum == 322) then
									local B;
									local A;
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 324) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							elseif (Enum > 325) then
								local FlatIdent_32176 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_32176 == 0) then
										B = nil;
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										FlatIdent_32176 = 1;
									end
									if (FlatIdent_32176 == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_32176 = 4;
									end
									if (FlatIdent_32176 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_32176 = 2;
									end
									if (FlatIdent_32176 == 4) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
										break;
									end
									if (FlatIdent_32176 == 2) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_32176 = 3;
									end
								end
							else
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 349) then
							if (Enum <= 337) then
								if (Enum <= 331) then
									if (Enum <= 328) then
										if (Enum > 327) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											do
												return;
											end
										else
											local FlatIdent_693EF = 0;
											local B;
											local A;
											while true do
												if (FlatIdent_693EF == 3) then
													Stk[Inst[2]] = Inst[3];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													FlatIdent_693EF = 4;
												end
												if (FlatIdent_693EF == 0) then
													B = nil;
													A = nil;
													A = Inst[2];
													Stk[A] = Stk[A](Stk[A + 1]);
													FlatIdent_693EF = 1;
												end
												if (2 == FlatIdent_693EF) then
													Stk[A + 1] = B;
													Stk[A] = B[Inst[4]];
													VIP = VIP + 1;
													Inst = Instr[VIP];
													FlatIdent_693EF = 3;
												end
												if (FlatIdent_693EF == 1) then
													VIP = VIP + 1;
													Inst = Instr[VIP];
													A = Inst[2];
													B = Stk[Inst[3]];
													FlatIdent_693EF = 2;
												end
												if (FlatIdent_693EF == 4) then
													Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
													VIP = VIP + 1;
													Inst = Instr[VIP];
													if not Stk[Inst[2]] then
														VIP = VIP + 1;
													else
														VIP = Inst[3];
													end
													break;
												end
											end
										end
									elseif (Enum <= 329) then
										local FlatIdent_589FE = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_589FE == 1) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_589FE = 2;
											end
											if (FlatIdent_589FE == 5) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_589FE = 6;
											end
											if (3 == FlatIdent_589FE) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_589FE = 4;
											end
											if (FlatIdent_589FE == 4) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_589FE = 5;
											end
											if (FlatIdent_589FE == 2) then
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_589FE = 3;
											end
											if (FlatIdent_589FE == 6) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												break;
											end
											if (FlatIdent_589FE == 0) then
												B = nil;
												A = nil;
												Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
												FlatIdent_589FE = 1;
											end
										end
									elseif (Enum == 330) then
										local FlatIdent_2DF5 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_2DF5 == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (FlatIdent_2DF5 == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2DF5 = 2;
											end
											if (FlatIdent_2DF5 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_2DF5 = 1;
											end
											if (FlatIdent_2DF5 == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_2DF5 = 6;
											end
											if (FlatIdent_2DF5 == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2DF5 = 4;
											end
											if (FlatIdent_2DF5 == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_2DF5 = 3;
											end
											if (FlatIdent_2DF5 == 4) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2DF5 = 5;
											end
										end
									else
										local A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									end
								elseif (Enum <= 334) then
									if (Enum <= 332) then
										local B;
										local A;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum > 333) then
										local FlatIdent_578B5 = 0;
										local A;
										local T;
										while true do
											if (FlatIdent_578B5 == 1) then
												for Idx = A + 1, Top do
													Insert(T, Stk[Idx]);
												end
												break;
											end
											if (FlatIdent_578B5 == 0) then
												A = Inst[2];
												T = Stk[A];
												FlatIdent_578B5 = 1;
											end
										end
									else
										local FlatIdent_8276C = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_8276C == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8276C = 4;
											end
											if (0 == FlatIdent_8276C) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_8276C = 1;
											end
											if (FlatIdent_8276C == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_8276C = 6;
											end
											if (FlatIdent_8276C == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8276C = 2;
											end
											if (FlatIdent_8276C == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (4 == FlatIdent_8276C) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8276C = 5;
											end
											if (FlatIdent_8276C == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_8276C = 3;
											end
										end
									end
								elseif (Enum <= 335) then
									if Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								elseif (Enum == 336) then
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										local FlatIdent_7280F = 0;
										while true do
											if (FlatIdent_7280F == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										local FlatIdent_6F939 = 0;
										while true do
											if (FlatIdent_6F939 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								else
									local A = Inst[2];
									local Results = {Stk[A](Stk[A + 1])};
									local Edx = 0;
									for Idx = A, Inst[4] do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
								end
							elseif (Enum <= 343) then
								if (Enum <= 340) then
									if (Enum <= 338) then
										local B;
										local A;
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 339) then
										local B;
										local A;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									else
										local FlatIdent_8D93 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_8D93 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												Stk[A] = Stk[A](Stk[A + 1]);
												FlatIdent_8D93 = 1;
											end
											if (FlatIdent_8D93 == 2) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_8D93 = 3;
											end
											if (FlatIdent_8D93 == 4) then
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (1 == FlatIdent_8D93) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_8D93 = 2;
											end
											if (FlatIdent_8D93 == 3) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_8D93 = 4;
											end
										end
									end
								elseif (Enum <= 341) then
									local FlatIdent_53EE6 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_53EE6 == 4) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_53EE6 = 5;
										end
										if (6 == FlatIdent_53EE6) then
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_53EE6 = 7;
										end
										if (0 == FlatIdent_53EE6) then
											B = nil;
											A = nil;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_53EE6 = 1;
										end
										if (FlatIdent_53EE6 == 2) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_53EE6 = 3;
										end
										if (1 == FlatIdent_53EE6) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_53EE6 = 2;
										end
										if (5 == FlatIdent_53EE6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_53EE6 = 6;
										end
										if (FlatIdent_53EE6 == 3) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											FlatIdent_53EE6 = 4;
										end
										if (FlatIdent_53EE6 == 7) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											break;
										end
									end
								elseif (Enum > 342) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 346) then
								if (Enum <= 344) then
									local FlatIdent_11068 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_11068 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_11068 = 4;
										end
										if (FlatIdent_11068 == 6) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_11068 == 1) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_11068 = 2;
										end
										if (FlatIdent_11068 == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_11068 = 6;
										end
										if (FlatIdent_11068 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_11068 = 1;
										end
										if (FlatIdent_11068 == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_11068 = 3;
										end
										if (FlatIdent_11068 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_11068 = 5;
										end
									end
								elseif (Enum > 345) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local FlatIdent_26DD5 = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_26DD5 == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											FlatIdent_26DD5 = 1;
										end
										if (FlatIdent_26DD5 == 3) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_26DD5 = 4;
										end
										if (FlatIdent_26DD5 == 5) then
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_26DD5 = 6;
										end
										if (6 == FlatIdent_26DD5) then
											Inst = Instr[VIP];
											if not Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (FlatIdent_26DD5 == 4) then
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_26DD5 = 5;
										end
										if (1 == FlatIdent_26DD5) then
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_26DD5 = 2;
										end
										if (2 == FlatIdent_26DD5) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_26DD5 = 3;
										end
									end
								end
							elseif (Enum <= 347) then
								local FlatIdent_44E82 = 0;
								local A;
								local Cls;
								while true do
									if (FlatIdent_44E82 == 1) then
										for Idx = 1, #Lupvals do
											local List = Lupvals[Idx];
											for Idz = 0, #List do
												local FlatIdent_6D46D = 0;
												local Upv;
												local NStk;
												local DIP;
												while true do
													if (FlatIdent_6D46D == 1) then
														DIP = Upv[2];
														if ((NStk == Stk) and (DIP >= A)) then
															Cls[DIP] = NStk[DIP];
															Upv[1] = Cls;
														end
														break;
													end
													if (FlatIdent_6D46D == 0) then
														Upv = List[Idz];
														NStk = Upv[1];
														FlatIdent_6D46D = 1;
													end
												end
											end
										end
										break;
									end
									if (FlatIdent_44E82 == 0) then
										A = Inst[2];
										Cls = {};
										FlatIdent_44E82 = 1;
									end
								end
							elseif (Enum == 348) then
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local B;
								local A;
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								if not Stk[Inst[2]] then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							end
						elseif (Enum <= 361) then
							if (Enum <= 355) then
								if (Enum <= 352) then
									if (Enum <= 350) then
										local B;
										local A;
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
									elseif (Enum == 351) then
										local FlatIdent_22CAB = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_22CAB == 2) then
												A = Inst[2];
												B = Stk[Inst[3]];
												Stk[A + 1] = B;
												FlatIdent_22CAB = 3;
											end
											if (FlatIdent_22CAB == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												FlatIdent_22CAB = 1;
											end
											if (FlatIdent_22CAB == 3) then
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_22CAB = 4;
											end
											if (FlatIdent_22CAB == 5) then
												A = Inst[2];
												Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
												VIP = VIP + 1;
												FlatIdent_22CAB = 6;
											end
											if (FlatIdent_22CAB == 1) then
												Stk[A] = Stk[A](Stk[A + 1]);
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_22CAB = 2;
											end
											if (FlatIdent_22CAB == 6) then
												Inst = Instr[VIP];
												if not Stk[Inst[2]] then
													VIP = VIP + 1;
												else
													VIP = Inst[3];
												end
												break;
											end
											if (4 == FlatIdent_22CAB) then
												Stk[Inst[2]] = Inst[3];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_22CAB = 5;
											end
										end
									else
										local FlatIdent_2CD81 = 0;
										local B;
										local A;
										while true do
											if (FlatIdent_2CD81 == 6) then
												Stk[A](Unpack(Stk, A + 1, Inst[3]));
												break;
											end
											if (FlatIdent_2CD81 == 0) then
												B = nil;
												A = nil;
												A = Inst[2];
												B = Stk[Inst[3]];
												FlatIdent_2CD81 = 1;
											end
											if (FlatIdent_2CD81 == 2) then
												Stk[Inst[2]] = {};
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												FlatIdent_2CD81 = 3;
											end
											if (FlatIdent_2CD81 == 4) then
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2CD81 = 5;
											end
											if (FlatIdent_2CD81 == 3) then
												VIP = VIP + 1;
												Inst = Instr[VIP];
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												FlatIdent_2CD81 = 4;
											end
											if (FlatIdent_2CD81 == 1) then
												Stk[A + 1] = B;
												Stk[A] = B[Inst[4]];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												FlatIdent_2CD81 = 2;
											end
											if (FlatIdent_2CD81 == 5) then
												Stk[Inst[2]][Inst[3]] = Inst[4];
												VIP = VIP + 1;
												Inst = Instr[VIP];
												A = Inst[2];
												FlatIdent_2CD81 = 6;
											end
										end
									end
								elseif (Enum <= 353) then
									local FlatIdent_7163B = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_7163B == 2) then
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											FlatIdent_7163B = 3;
										end
										if (FlatIdent_7163B == 8) then
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											break;
										end
										if (FlatIdent_7163B == 1) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A]();
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_7163B = 2;
										end
										if (FlatIdent_7163B == 6) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Stk[A + 1]);
											VIP = VIP + 1;
											FlatIdent_7163B = 7;
										end
										if (FlatIdent_7163B == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_7163B = 8;
										end
										if (0 == FlatIdent_7163B) then
											B = nil;
											A = nil;
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
											VIP = VIP + 1;
											FlatIdent_7163B = 1;
										end
										if (FlatIdent_7163B == 3) then
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											FlatIdent_7163B = 4;
										end
										if (FlatIdent_7163B == 5) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											FlatIdent_7163B = 6;
										end
										if (FlatIdent_7163B == 4) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_7163B = 5;
										end
									end
								elseif (Enum > 354) then
									Stk[Inst[2]] = Upvalues[Inst[3]];
								else
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								end
							elseif (Enum <= 358) then
								if (Enum <= 356) then
									local FlatIdent_89EEE = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_89EEE == 0) then
											B = nil;
											A = nil;
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_89EEE = 1;
										end
										if (FlatIdent_89EEE == 4) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											FlatIdent_89EEE = 5;
										end
										if (FlatIdent_89EEE == 1) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_89EEE = 2;
										end
										if (5 == FlatIdent_89EEE) then
											Inst = Instr[VIP];
											if Stk[Inst[2]] then
												VIP = VIP + 1;
											else
												VIP = Inst[3];
											end
											break;
										end
										if (3 == FlatIdent_89EEE) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3];
											VIP = VIP + 1;
											FlatIdent_89EEE = 4;
										end
										if (FlatIdent_89EEE == 2) then
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											FlatIdent_89EEE = 3;
										end
									end
								elseif (Enum > 357) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local B;
									local A;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								end
							elseif (Enum <= 359) then
								local B;
								local A;
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							elseif (Enum > 360) then
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
							else
								local A;
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
							end
						elseif (Enum <= 367) then
							if (Enum <= 364) then
								if (Enum <= 362) then
									local Results;
									local Edx;
									local Results, Limit;
									local B;
									local A;
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]]();
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results, Limit = _R(Stk[A](Stk[A + 1]));
									Top = (Limit + A) - 1;
									Edx = 0;
									for Idx = A, Top do
										Edx = Edx + 1;
										Stk[Idx] = Results[Edx];
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Results = {Stk[A](Unpack(Stk, A + 1, Top))};
									Edx = 0;
									for Idx = A, Inst[4] do
										local FlatIdent_503B5 = 0;
										while true do
											if (FlatIdent_503B5 == 0) then
												Edx = Edx + 1;
												Stk[Idx] = Results[Edx];
												break;
											end
										end
									end
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								elseif (Enum > 363) then
									local B;
									local A;
									A = Inst[2];
									Stk[A] = Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									if not Stk[Inst[2]] then
										VIP = VIP + 1;
									else
										VIP = Inst[3];
									end
								else
									local A;
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									VIP = Inst[3];
								end
							elseif (Enum <= 365) then
								local FlatIdent_86F89 = 0;
								local Edx;
								local Results;
								local Limit;
								local B;
								local A;
								while true do
									if (FlatIdent_86F89 == 1) then
										Stk[Inst[2]] = Env[Inst[3]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										FlatIdent_86F89 = 2;
									end
									if (FlatIdent_86F89 == 6) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
										FlatIdent_86F89 = 7;
									end
									if (7 == FlatIdent_86F89) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A]();
										break;
									end
									if (FlatIdent_86F89 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_86F89 = 5;
									end
									if (FlatIdent_86F89 == 2) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_86F89 = 3;
									end
									if (FlatIdent_86F89 == 3) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_86F89 = 4;
									end
									if (FlatIdent_86F89 == 0) then
										Edx = nil;
										Results, Limit = nil;
										B = nil;
										A = nil;
										FlatIdent_86F89 = 1;
									end
									if (5 == FlatIdent_86F89) then
										Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										Edx = 0;
										for Idx = A, Top do
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
										end
										FlatIdent_86F89 = 6;
									end
								end
							elseif (Enum > 366) then
								local FlatIdent_3D885 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_3D885 == 0) then
										B = nil;
										A = nil;
										A = Inst[2];
										Stk[A] = Stk[A](Stk[A + 1]);
										FlatIdent_3D885 = 1;
									end
									if (FlatIdent_3D885 == 3) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										FlatIdent_3D885 = 4;
									end
									if (FlatIdent_3D885 == 2) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_3D885 = 3;
									end
									if (FlatIdent_3D885 == 4) then
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
										break;
									end
									if (FlatIdent_3D885 == 1) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_3D885 = 2;
									end
								end
							else
								local B;
								local A;
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3] ~= 0;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum <= 370) then
							if (Enum <= 368) then
								local FlatIdent_30938 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_30938 == 0) then
										B = nil;
										A = nil;
										A = Inst[2];
										FlatIdent_30938 = 1;
									end
									if (FlatIdent_30938 == 6) then
										Inst = Instr[VIP];
										if not Stk[Inst[2]] then
											VIP = VIP + 1;
										else
											VIP = Inst[3];
										end
										break;
									end
									if (FlatIdent_30938 == 1) then
										Stk[A] = Stk[A](Stk[A + 1]);
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_30938 = 2;
									end
									if (FlatIdent_30938 == 4) then
										Stk[Inst[2]] = Inst[3];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_30938 = 5;
									end
									if (FlatIdent_30938 == 2) then
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										FlatIdent_30938 = 3;
									end
									if (FlatIdent_30938 == 3) then
										Stk[A] = B[Inst[4]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_30938 = 4;
									end
									if (FlatIdent_30938 == 5) then
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_30938 = 6;
									end
								end
							elseif (Enum == 369) then
								local A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
							else
								local FlatIdent_334A4 = 0;
								local B;
								local A;
								while true do
									if (FlatIdent_334A4 == 7) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										FlatIdent_334A4 = 8;
									end
									if (FlatIdent_334A4 == 1) then
										Inst = Instr[VIP];
										A = Inst[2];
										Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
										VIP = VIP + 1;
										FlatIdent_334A4 = 2;
									end
									if (FlatIdent_334A4 == 0) then
										B = nil;
										A = nil;
										Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
										VIP = VIP + 1;
										FlatIdent_334A4 = 1;
									end
									if (FlatIdent_334A4 == 8) then
										Inst = Instr[VIP];
										Stk[Inst[2]] = Env[Inst[3]];
										break;
									end
									if (3 == FlatIdent_334A4) then
										A = Inst[2];
										B = Stk[Inst[3]];
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										FlatIdent_334A4 = 4;
									end
									if (FlatIdent_334A4 == 6) then
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										FlatIdent_334A4 = 7;
									end
									if (FlatIdent_334A4 == 5) then
										Inst = Instr[VIP];
										Stk[Inst[2]][Inst[3]] = Inst[4];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_334A4 = 6;
									end
									if (FlatIdent_334A4 == 2) then
										Inst = Instr[VIP];
										Env[Inst[3]] = Stk[Inst[2]];
										VIP = VIP + 1;
										Inst = Instr[VIP];
										FlatIdent_334A4 = 3;
									end
									if (FlatIdent_334A4 == 4) then
										VIP = VIP + 1;
										Inst = Instr[VIP];
										Stk[Inst[2]] = {};
										VIP = VIP + 1;
										FlatIdent_334A4 = 5;
									end
								end
							end
						elseif (Enum <= 371) then
							local FlatIdent_4D759 = 0;
							local B;
							local A;
							while true do
								if (FlatIdent_4D759 == 5) then
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									break;
								end
								if (FlatIdent_4D759 == 1) then
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									FlatIdent_4D759 = 2;
								end
								if (FlatIdent_4D759 == 2) then
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									FlatIdent_4D759 = 3;
								end
								if (FlatIdent_4D759 == 0) then
									B = nil;
									A = nil;
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
									VIP = VIP + 1;
									FlatIdent_4D759 = 1;
								end
								if (FlatIdent_4D759 == 3) then
									Stk[A] = B[Inst[4]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = {};
									FlatIdent_4D759 = 4;
								end
								if (4 == FlatIdent_4D759) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									FlatIdent_4D759 = 5;
								end
							end
						elseif (Enum == 372) then
							local B;
							local A;
							A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							if not Stk[Inst[2]] then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							do
								return;
							end
						end
						VIP = VIP + 1;
						break;
					end
					if (FlatIdent_25DF3 == 0) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_25DF3 = 1;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!22012Q00030A3Q006C6F6164737472696E6703043Q0067616D6503073Q00482Q7470476574034B3Q00682Q7470733A2Q2F7261772E67697468756275736572636F6E74656E742E636F6D2F50726F3Q3650726F2F4472612Q6761626C654F72696F6E4C69622F6D61696E2F6D61696E2E6C756103103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403313Q00536372697074204C6F6164696E672E204974206D61792074616B6520666F722061726F756E642035207365636F6E64732E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00244003023Q005F4703063Q0053637269707403113Q004E6578657220487562202D2054523A554403063Q00737472696E6703063Q00666F726D6174036C3Q0067616D653A47657453657276696365282754656C65706F72745365727669636527293A54656C65706F7274546F506C616365496E7374616E63652825732C20272573272C2067616D653A476574536572766963652827506C617965727327292E4C6F63616C506C617965722903073Q00506C616365496403053Q004A6F62496403533Q00682Q7470733A2Q2F7261772E67697468756275736572636F6E74656E742E636F6D2F50726F3Q3650726F2F485749445F57686974654C6973742F726566732F68656164732F6D61696E2F6D61696E2E6C756103203Q00682Q7470733A2Q2F706173746566792E612Q702F7748785A397A6D342F726177030A3Q004765745365727669636503133Q00526278416E616C797469637353657276696365030B3Q00476574436C69656E74496403073Q00506C6179657273030B3Q004C6F63616C506C6179657203073Q005072656D69756D03023Q004E6F03053Q0070616972732Q033Q0059657303123Q004D61726B6574706C6163655365727669636503153Q00557365724F776E7347616D6550612Q734173796E6303063Q00557365724964023Q00DC624ACE4103163Q004F6E6C7920696E20736C6170206661726D206775692E022Q00801D4BB4CE41031A3Q004F6E6C7920696E206E6578657220687562202D2054523A55442E030D3Q0072636F6E736F6C657072696E7403053Q007072696E74030C3Q00736574636C6970626F617264030B3Q0072636F6E736F6C2Q652Q72030C3Q0072636F6E736F6C657761726E03043Q007761726E03053Q00652Q726F7203043Q00536B6964030C3Q004E6F2C2068652069736E277403093Q004C6F63616C496E666F032B3Q00557365722069736E277420736B692Q6465722C206C6F63616C20696E666F20776F6E277420612Q70656172030C3Q00682Q6F6B66756E6374696F6E030B3Q006E65772Q636C6F73757265028Q0003123Q00436865636B20E28496312053752Q63652Q7303063Q00436865636B31026Q00F03F03043Q006E657874030F3Q00436865636B20E2849631204661696C030C3Q00682Q74705F7265717565737403073Q007265717565737403083Q00482Q7470506F73742Q033Q0073796E03793Q00682Q7470733A2Q2F646973636F72642E636F6D2F6170692F776562682Q6F6B732F31333233322Q373134303235383435393634382F4C2Q765245764D55312D324E3841336E6C5A4F574841664673457153415443774C33786E6857524F724967415A6553395F6E6F58695A4F636C486D526F677138767A352D03083Q00757365726E616D65030C3Q004E6F74696669636174696F6E03073Q00636F6E74656E74030A3Q004065766572796F6E6520030A3Q002065786563757465642003013Q002E03063Q00656D6265647303053Q007469746C6503123Q00496E666F726D6174696F6E2061626F75742003133Q002069732070726F7669646564206C6F7765722E030B3Q006465736372697074696F6E03133Q004973204865204120536B692Q6465723F202Q2A03113Q002Q2A204C6F63616C20496E666F3A202Q2A030F3Q002Q2A20557365726E616D653A202Q2A030D3Q002Q2A205573657249643A202Q2A03123Q002Q2A20412Q636F756E74204167653A202Q2A030A3Q00412Q636F756E7441676503103Q0020646179732Q2A2050696E673A202Q2A03053Q00537461747303073Q004E6574776F726B030F3Q0053657276657253746174734974656D03093Q00446174612050696E67030E3Q0047657456616C7565537472696E67030B3Q002Q2A20485749443A202Q2A03133Q002Q2A205072656D69756D20557365723F202Q2A03133Q002Q2A20436865636B706F696E7420313A202Q2A03023Q002Q2A03043Q007479706503043Q007269636803053Q00636F6C6F72023Q00E01F006C4103063Q00662Q6F74657203043Q0074657874034Q00026Q00084003063Q00436865636B3203123Q00436865636B20E28496322053752Q63652Q73026Q001040030B3Q00482Q747053657276696365030A3Q004A534F4E456E636F6465030C3Q00636F6E74656E742D7479706503103Q00612Q706C69636174696F6E2F6A736F6E027Q00402Q033Q0055726C03043Q00426F647903063Q004D6574686F6403043Q00504F535403073Q0048656164657273030F3Q00436865636B20E2849632204661696C030E3Q0043752Q72656E744772617669747903093Q00576F726B737061636503073Q0047726176697479010003103Q00596F7520617265207072656D69756D21026Q0014402Q01032B3Q004E6578657220487562202D2054686520526F626C6F7869613A20556E74696C204461776E202D2076322E30030A3Q004D616B6557696E646F7703093Q00496E74726F5465787403093Q00496E74726F49636F6E030B3Q00486964655072656D69756D030A3Q0053617665436F6E666967030C3Q00436F6E666967466F6C64657203083Q005475746F7269616C03073Q005761726E696E6703153Q0055736520617420796F7572206F776E207269736B2E03073Q004D616B6554616203043Q004D61696E03043Q0049636F6E030B3Q005072656D69756D4F6E6C7903093Q00412Q64546F2Q676C65030E3Q00526576657273656420526F6C657303073Q0044656661756C7403083Q0043612Q6C6261636B030C3Q00412Q6450617261677261706803083Q005741524E494E4721034A3Q004265666F7265206265636F6D696E672061206B692Q6C6572206F722061207375727669766F722C2063682Q6F7365207768696368206F6E6520796F752070726566657220746F207573652Q033Q006B6C7203073Q005361774E2Q6F62030B3Q00412Q6444726F70646F776E030D3Q0043682Q6F7365204B692Q6C657203083Q00536177204E2Q6F6203073Q004F7074696F6E7303073Q003178317831783103073Q00432Q6F6C6B6964030C3Q004472616B6F626C6F2Q78657203083Q004A6F686E20446F6503093Q004775657374203Q3603063Q004B692Q6C657203093Q00412Q6442752Q746F6E030D3Q004265636F6D65204B692Q6C65722Q033Q00737276030A3Q004275696C6465726D616E030F3Q0043682Q6F7365205375727669766F72030A3Q00536865646C6574736B7903053Q004775657374030D3Q00427269636B2042612Q746C6572030A3Q004261636F6E204861697203073Q00426C6F2Q78657203083Q004A616E6520446F6503083Q005375727669766F72030F3Q004265636F6D65205375727669766F7203503Q00446F6E2774207573652061646D696E206368617261637465727320756E6C652Q7320796F75206B6E6F7720686F7720746F20627970612Q732074686569722077686974656C6973742073797374656D2103053Q006B6C72616403133Q0043682Q6F73652041646D696E204B692Q6C657203093Q00536F6E69632E45786503093Q005370756E6368626F6203113Q00416D6F6E6720757320496D706F7374657203043Q00532Q656B03043Q004772656703053Q00536F6E69632Q033Q0052415203073Q00566F727A6C696E030B3Q0043594E504154484554494303083Q004B692Q6C6572616403133Q004265636F6D652041646D696E204B692Q6C657203053Q00737276616403053Q0046656C697803153Q0043682Q6F73652041646D696E205375727669766F7203043Q004E2Q6F6203093Q0053746172204669726503083Q004B6E75636B6C6573030A3Q005375727669766F72616403153Q004265636F6D652041646D696E205375727669766F7203063Q00427970612Q73035F3Q00427970612Q7320416E74692D436865617420696620796F752077616E7420746F2E204254572069742773206E6F7420627970612Q73696E672077686974656C6973742073797374656D20666F722061646D696E20636861726163746572732E032C3Q00427970612Q7320416E74692D43686561742028636865636B20636F6E736F6C6520616674657220746861742903053Q0054726F2Q6C03153Q004175746F2D45736361706520496E20506F7274616C03223Q004175746F2D412Q7461636B204B692Q6C65722028204F6E6C79204D656C2Q65212029032C3Q00476F642D4D6F6465202820596F75206E2Q656420746F20706C6179206F6E20736865646C6574736B792E2029030A3Q00412Q6454657874626F78030E3Q00506C6179657220546F204772616203053Q00496E707574030D3Q0054657874446973612Q70656172030B3Q004772616220506C61796572030D3Q00526F61722045766572796F6E6503143Q0047726F756E6420536C616D2045766572796F6E6503023Q00414B031E3Q004175746F2D4B692Q6C2045766572796F6E65207B205072656D69756D207D03023Q00415203263Q004175746F2D52657669766520446F776E656420506C6179657273207B205072656D69756D207D03053Q004C6F63616C03093Q00412Q64536C69646572030B3Q00486974626F782053697A652Q033Q004D696E2Q033Q004D6178026Q00594003053Q00436F6C6F7203063Q00436F6C6F723303073Q0066726F6D524742025Q00E06F4003093Q00496E6372656D656E7403093Q0056616C75654E616D6503053Q005374756473030D3Q00457870616E6420486974626F78030F3Q0045535020412Q6C20506C617965727303093Q00455350205461736B7303023Q00545003243Q0054656C65706F72742045766572796F6E6520746F20596F75207B205072656D69756D207D03103Q004368616E67652057616C6B73702Q6564026Q003440025Q00408F4003093Q0057616C6B53702Q656403103Q004368616E6765204A756D70506F776572026Q00494003093Q004A756D70506F77657203113Q004368616E67652048697020486569676874030A3Q0048697020486569676874030E3Q004368616E67652047726176697479025Q00407F40030D3Q004368616E6765204865616C746803063Q004865616C746803043Q00416E746903133Q00416E7469204A756D7020432Q6F6C646F776E2003113Q00416E74692043616D657261205368616B65032B3Q0044657374726F79205472617073207B206275696C6465726D616E206D696E657320616E64206574632E207D032A3Q00416E746920436F6E7472696275746F72732F546573746572732F446576656C6F706572732F4F776E6572030E3Q00676574636F2Q6E656374696F6E7303083Q00416E74692041464B03093Q00416E7469204B69636B032A3Q00416E7469205265636F7264204F6E6C792044657465637473204D652Q736167657320496E20436861742E03143Q00416E7469205265636F7264207B2046722Q65207D030B3Q004765744368696C6472656E03073Q004368612Q74656403073Q00436F2Q6E656374030B3Q00506C61796572412Q64656403093Q005265636F72644D6178031B3Q00416E7469205265636F7264204D4158207B205072656D69756D207D03083Q0054656C65706F727403113Q0054656C65706F727420546F204C6F2Q627903123Q0054656C65706F727420546F204B692Q6C657203183Q0054656C65706F727420546F204B692Q6C657220537061776E031A3Q0054656C65706F727420546F205375727669766F7220537061776E03103Q0054656C65706F727420546F205461736B03103Q0054656C65706F727420546F204578697403053Q00507269636503163Q005072656D69756D20636F737420323020726F6275782E030C3Q00496E73637472756374696F6E03283Q00416674657220627579696E67207072656D69756D2C2072652D65786563757465207363726970742E030B3Q00427579205072656D69756D030D3Q0041626F7574205072656D69756D03EB3Q00416674657220627579696E6720746869732067616D6570612Q732C20796F752077692Q6C2067657420612Q63652Q7320746F20612Q6C207072656D69756D20666561747572657320696E206E6578657220687562202D2074686520726F626C6F7869613A20756E74696C206461776E2E204E4F544943452120596F7520776F6E277420676574207072656D69756D206F6E20796F7572206F7468657220616C7420612Q636F756E74732C206F6E6C7920612Q636F756E7420776865726520796F7520626F756768742067616D6570612Q732066726F6D2077692Q6C2062652077686974656C69737465642E03143Q00436865636B2069662077686974656C697374656403103Q004E657720557064617465204C65616B73031F3Q005468657365204C65616B7320466F756E6420496E2047616D652046696C657303063Q00456E6A6F792E030C3Q004E65772047616D656D6F646503183Q004E65772047616D656D6F64653A20426F2Q7366696768742E03043Q00426F2Q7303203Q00426F2Q7366696768743A20412Q6C20506C617965727320767320526F626C6F7803083Q004E6577204D617073036E3Q004E65772F4F6C6420506F2Q7369626C65204D6170733A20312E20536E6F776372616E6520322E20536E6F7779205374726F6E67686F6C6420332E204861756E746564204D616E73696F6E20342E20485120352E20546865205275696E7320362E2043726F2Q73726F61647320563203093Q004E657720547261707303303Q004E657720506F2Q7369626C652054726170733A20312E20537562737061636520747269706D696E6520322E20426F6D62030B3Q004E6577204B692Q6C65727303383Q004E657720506F2Q7369626C65204B692Q6C6572733A20312E2054756265727320286261636B2920322E205361776E2Q6F6220286261636B29030D3Q004E6577205375727669766F727303293Q004E657720506F2Q7369626C65205375727669766F72733A20312E204E2Q6F6220322E20526F626C6F7803053Q004F7468657203073Q004372656469747303133Q00536372697074204279204E657865723132333403193Q00466F726365205265736574207B204F56452Q5249444521207D030C3Q00456E61626C6520526573657403093Q00436C6F736520487562030E3Q00496E66696E697479205969656C6403073Q004669782043616D0063042Q00126D012Q00013Q00122Q000100023Q00202Q00010001000300122Q000300046Q000100039Q0000026Q0001000200203100013Q00054Q00033Q000400302Q00030006000700302Q00030008000900302Q0003000A000B00302Q0003000C000D4Q0001000300010012870001000E3Q00302Q0001000F001000122Q000100113Q00202Q00010001001200122Q000200133Q00122Q000300023Q00202Q00030003001400122Q000400023Q00202Q0004000400154Q00010004000200126D010200013Q00122Q000300023Q00202Q00030003000300122Q000500166Q000300056Q00023Q00024Q00020001000200126D010300013Q00122Q000400023Q00202Q00040004000300122Q000600176Q000400066Q00033Q00024Q000300010002001243000400023Q0020F7000400040018001242000600194Q00480004000600020020F700040004001A2Q0058000400020002001243000500023Q0020F70005000500180012420007001B4Q00A100050007000200202Q00050005001C00202Q00050005000600122Q0006001E3Q00122Q0006001D3Q00122Q0006001F6Q000700026Q00060002000800044Q0040000100060B010A00400001000400043B3Q00400001001243000B001D3Q00267C000B00400001001E00043B3Q00400001001242000B00203Q00129A000B001D3Q00043B3Q00420001002Q06000600380001000200043B3Q003800010012430006001F4Q00EE000700034Q005101060002000800043B3Q004E000100060B010A004E0001000500043B3Q004E0001001243000B001D3Q00267C000B004E0001001E00043B3Q004E0001001242000B00203Q00129A000B001D3Q00043B3Q00500001002Q06000600460001000200043B3Q00460001001243000600023Q0020BE00060006001800122Q000800216Q00060008000200202Q00060006002200122Q000800023Q00202Q00080008001B00202Q00080008001C00202Q00080008002300122Q000900246Q00060009000200064F0106006300013Q00043B3Q006300010012430006001D3Q00267C000600630001001E00043B3Q00630001001242000600253Q00129A0006001D3Q00043B3Q00750001001243000600023Q0020BE00060006001800122Q000800216Q00060008000200202Q00060006002200122Q000800023Q00202Q00080008001B00202Q00080008001C00202Q00080008002300122Q000900266Q00060009000200064F0106007500013Q00043B3Q007500010012430006001D3Q00267C000600750001001E00043B3Q00750001001242000600273Q00129A0006001D4Q0036010600073Q00123C010700283Q00122Q000800293Q00122Q0009002A3Q00122Q000A002B3Q00122Q000B002C3Q00122Q000C002D3Q00122Q000D002E6Q000600070001001242000700303Q00124C0007002F3Q00122Q000700323Q00122Q000700313Q00122Q000700333Q00062Q000700B200013Q00043B3Q00B20001001243000700343Q00064F010700B200013Q00043B3Q00B20001001242000700354Q00B2000800083Q00267C0007008A0001003500043B3Q008A0001001242000800353Q00267C000800950001003500043B3Q009500010012430009002D3Q001299000A00366Q00090002000100122Q000900363Q00122Q000900373Q00122Q000800383Q00267C0008008D0001003800043B3Q008D0001001243000900394Q00EE000A00064Q00B2000B000B3Q00043B3Q00AB0001001242000E00354Q00B2000F000F3Q00267C000E009D0001003500043B3Q009D00012Q00B2000F000F3Q001243001000334Q00EE0011000D3Q001243001200343Q00062C01133Q000100012Q00EE3Q000F4Q001A011200134Q004B01103Q00022Q00EE000F00103Q00043B3Q00AA000100043B3Q009D00012Q005B010E5Q002Q060009009B0001000200043B3Q009B000100043B3Q00BC000100043B3Q008D000100043B3Q00BC000100043B3Q008A000100043B3Q00BC0001001242000700353Q00267C000700B30001003500043B3Q00B300010012430008002D3Q00126B0109003A6Q00080002000100122Q0008003A3Q00122Q000800373Q00044Q00BC000100043B3Q00B300010012430007003B3Q00063B010700C90001000100043B3Q00C900010012430007003C3Q00063B010700C90001000100043B3Q00C900010012430007003D3Q00063B010700C90001000100043B3Q00C900010012430007003E3Q00205F00070007003C00064F010700582Q013Q00043B3Q00582Q01001242000700354Q00B20008000C3Q00267C000700252Q01003500043B3Q00252Q01001242000D00353Q00267C000D00D20001003800043B3Q00D20001001242000700383Q00043B3Q00252Q0100267C000D00CE0001003500043B3Q00CE00010012420008003F4Q0054000E3Q000300302Q000E0040004100122Q000F00433Q00122Q001000023Q00202Q00100010001B00202Q00100010001C00202Q00100010000600122Q001100443Q00122Q0012000E3Q00202Q00120012000F001242001300454Q0012010F000F001300102Q000E0042000F4Q000F00016Q00103Q000500122Q001100483Q00122Q001200023Q00202Q00120012001B00202Q00120012001C00202Q00120012000600122Q001300494Q00040111001100130010DF00100047001100122Q0011004B3Q00122Q0012002F3Q00122Q0013004C3Q00122Q001400313Q00122Q0015004D3Q00122Q001600023Q00202Q00160016001B00202Q00160016001C00202Q0016001600060012420017004E3Q001244001800023Q00202Q00180018001B00202Q00180018001C00202Q00180018002300122Q0019004F3Q00122Q001A00023Q00202Q001A001A001B00202Q001A001A001C00202Q001A001A005000122Q001B00513Q001243001C00023Q0020F2001C001C001800122Q001E00526Q001C001E000200202Q001C001C005300202Q001C001C005400202Q001C001C005500202Q001C001C00564Q001C0002000200122Q001D00573Q00122Q001E00023Q0020F7001E001E0018001259002000196Q001E0020000200202Q001E001E001A4Q001E0002000200122Q001F00583Q00122Q0020001D3Q00122Q002100593Q00122Q002200373Q00122Q0023005A6Q00110011002300101F0010004A00110030180010005B005C00302Q0010005D005E4Q00113Q000100122Q001200616Q001300013Q00122Q001400616Q00120012001400102Q00110060001200102Q0010005F00114Q000F0001000100101F000E0046000F2Q00EE0009000E3Q001242000D00383Q00043B3Q00CE000100267C0007002D2Q01006200043B3Q002D2Q01001243000D003C4Q0002010E000C6Q000D0002000100122Q000D00643Q00122Q000D00633Q00122Q000700653Q00267C000700332Q01006500043B3Q00332Q01001243000D002D3Q001242000E00644Q00CF000D0002000100043B3Q00682Q0100267C000700412Q01003800043B3Q00412Q01001243000D00023Q002064000D000D001800122Q000F00666Q000D000F000200202Q000D000D00674Q000F00096Q000D000F00024Q000A000D6Q000D3Q000100302Q000D006800694Q000B000D3Q0012420007006A3Q00267C000700CB0001006A00043B3Q00CB0001001243000D003B3Q00063B010D004E2Q01000100043B3Q004E2Q01001243000D003C3Q00063B010D004E2Q01000100043B3Q004E2Q01001243000D003D3Q00063B010D004E2Q01000100043B3Q004E2Q01001243000D003E3Q00205F000D000D003C00129A000D003C4Q002F000D3Q000400102Q000D006B000800102Q000D006C000A00302Q000D006D006E00102Q000D006F000B4Q000C000D3Q00122Q000700623Q00044Q00CB000100043B3Q00682Q01001242000700354Q00B2000800083Q00267C0007005A2Q01003500043B3Q005A2Q01001242000800353Q00267C0008005D2Q01003500043B3Q005D2Q01001242000900703Q00127E000900633Q00122Q0009002D3Q00122Q000A00706Q00090002000100044Q00682Q0100043B3Q005D2Q0100043B3Q00682Q0100043B3Q005A2Q010012430007000E3Q001243000800023Q00205F00080008007200205F00080008007300101F000700710008000295000700013Q0012C50008000E3Q00302Q0008001D007400122Q000800263Q00122Q000900023Q00202Q00090009001B00202Q00090009001C00122Q000A00023Q00202Q000A000A001800122Q000C00216Q000A000C000200126D010B00013Q00122Q000C00023Q00202Q000C000C000300122Q000E00166Q000C000E6Q000B3Q00024Q000B0001000200126D010C00013Q00122Q000D00023Q00202Q000D000D000300122Q000F00176Q000D000F6Q000C3Q00024Q000C00010002001243000D00023Q0020F7000D000D0018001242000F00194Q0048000D000F00020020F7000D000D001A2Q0058000D00020002001243000E00023Q0020F7000E000E00180012420010001B4Q0009000E0010000200202Q000E000E001C00202Q000E000E000600122Q000F001F6Q0010000B6Q000F0002001100044Q00AF2Q0100063F011300A52Q01000D00043B3Q00A52Q01001243001400023Q0020BE00140014001800122Q001600216Q00140016000200202Q00140014002200122Q001600023Q00202Q00160016001B00202Q00160016001C00202Q00160016002300122Q001700266Q00140017000200064F011400AF2Q013Q00043B3Q00AF2Q010020F700143Q00052Q00EF00163Q000400302Q00160006000700302Q00160008007500302Q0016000A000B00302Q0016000C00764Q00140016000100122Q0014000E3Q00302Q0014001D007700044Q00B12Q01002Q06000F00962Q01000200043B3Q00962Q01001243000F001F4Q00EE0010000C4Q0051010F0002001100043B3Q00C52Q0100060B011300C52Q01000E00043B3Q00C52Q010012430014000E3Q00205F00140014001D00267C001400C52Q01007400043B3Q00C52Q010020F700143Q00052Q00EF00163Q000400302Q00160006000700302Q00160008007500302Q0016000A000B00302Q0016000C00764Q00140016000100122Q0014000E3Q00302Q0014001D007700044Q00C72Q01002Q06000F00B52Q01000200043B3Q00B52Q01001242000F00783Q00208400103Q00794Q00123Q000600302Q0012007A001000302Q0012007B000B00102Q00120006000F00302Q0012007C007400302Q0012007D007700302Q0012007E007F4Q00100012000200203100113Q00054Q00133Q000400302Q00130006008000302Q00130008008100302Q0013000A000B00302Q0013000C00764Q0011001300010020D70011001000824Q00133Q000300302Q00130006008300302Q00130084000B00302Q0013008500744Q00110013000200202Q0012001100864Q00143Q000300302Q00140006008700302Q001400880074000295001500023Q0010030114008900154Q00120014000100202Q00120011008A00122Q0014008B3Q00122Q0015008C6Q00120015000100122Q0012000E3Q00302Q0012008D008E00202Q00120011008F4Q00143Q00040030AF0014000600900030720014008800914Q001500063Q00122Q001600913Q00122Q001700933Q00122Q001800943Q00122Q001900953Q00122Q001A00963Q00122Q001B00976Q00150006000100101F001400920015000295001500033Q0010710014008900154Q00120014000100202Q0012001100994Q00143Q000200302Q00140006009A00062C01150004000100012Q00EE7Q0010330014008900154Q00120014000200122Q001200983Q00122Q0012000E3Q00302Q0012009B009C00202Q00120011008F4Q00143Q000400302Q00140006009D00302Q00140088009C4Q001500073Q0012420016009C3Q0012DC0017009E3Q00122Q0018009F3Q00122Q001900A03Q00122Q001A00A13Q00122Q001B00A23Q00122Q001C00A36Q00150007000100101F001400920015000295001500053Q0010710014008900154Q00120014000100202Q0012001100994Q00143Q000200302Q0014000600A500062C01150006000100012Q00EE7Q0010A60014008900154Q00120014000200122Q001200A43Q00202Q00120011008A00122Q0014008B3Q00122Q001500A66Q00120015000100122Q0012000E3Q00302Q001200A7008E00202Q00120011008F2Q003601143Q00040030260014000600A800302Q0014008800A94Q001500093Q00122Q001600AA3Q00122Q001700AB3Q00122Q001800AC3Q00122Q001900AD3Q00122Q001A00A93Q00122Q001B00AE3Q00122Q001C00AF3Q001242001D00B03Q001242001E00B14Q002700150009000100101F001400920015000295001500073Q0010710014008900154Q00120014000100202Q0012001100994Q00143Q000200302Q0014000600B300062C01150008000100012Q00EE7Q0010330014008900154Q00120014000200122Q001200B23Q00122Q0012000E3Q00302Q001200B400B500202Q00120011008F4Q00143Q000400302Q0014000600B600302Q0014008800B54Q001500043Q001242001600B53Q001242001700B73Q001242001800B83Q001242001900B94Q002700150004000100101F001400920015000295001500093Q0010710014008900154Q00120014000100202Q0012001100994Q00143Q000200302Q0014000600BB00062C0115000A000100012Q00EE7Q0010150014008900154Q00120014000200122Q001200BA3Q00202Q00120011008A00122Q001400BC3Q00122Q001500BD6Q00120015000100202Q0012001100994Q00143Q000200302Q0014000600BE0002950015000B3Q0010710014008900154Q00120014000100202Q0012001000824Q00143Q000300302Q0014000600BF0030AF00140084000B0030AF0014008500742Q00480012001400020020F70013001200862Q003601153Q00030030AF0015000600C00030AF0015008800740002950016000C3Q0010710015008900164Q00130015000100202Q0013001200864Q00153Q000300302Q0015000600C10030AF0015008800740002950016000D3Q0010710015008900164Q00130015000100202Q0013001200864Q00153Q000300302Q0015000600C20030AF0015008800740002950016000E3Q0010710015008900164Q00130015000100202Q0013001200C34Q00153Q000400302Q0015000600C40030AF0015008800C50030AF001500C600740002950016000F3Q0010710015008900164Q00130015000100202Q0013001200994Q00153Q000200302Q0015000600C700062C01160010000100012Q00EE7Q0010710015008900164Q00130015000100202Q0013001200994Q00153Q000200302Q0015000600C800062C01160011000100012Q00EE7Q0010710015008900164Q00130015000100202Q0013001200994Q00153Q000200302Q0015000600C900062C01160012000100012Q00EE7Q0010710015008900164Q00130015000100202Q0013001200864Q00153Q000300302Q0015000600CB0030AF00150088007400062C01160013000100012Q00EE7Q0010880015008900164Q00130015000200122Q001300CA3Q00202Q0013001200864Q00153Q000300302Q0015000600CD00302Q00150088007400062C01160014000100012Q00EE7Q00101E0015008900164Q00130015000200122Q001300CC3Q00202Q0013001000824Q00153Q000300302Q0015000600CE00302Q00150084000B00302Q0015008500744Q00130015000200202Q0014001300CF2Q003601163Q00080030080116000600D000302Q001600D1003800302Q001600D200D300302Q00160088007600122Q001700D53Q00202Q0017001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200101F001600D400170030AF001600D800380030AF001600D900DA000295001700153Q0010710016008900174Q00140016000100202Q0014001300994Q00163Q000300302Q0016000600DB0030AF001600880074000295001700163Q0010710016008900174Q00140016000100202Q0014001300994Q00163Q000200302Q0016000600DC000295001700173Q0010710016008900174Q00140016000100202Q0014001300994Q00163Q000200302Q0016000600DD000295001700183Q0010710016008900174Q00140016000100202Q0014001300864Q00163Q000300302Q0016000600DF0030AF00160088007400062C01170019000100012Q00EE7Q0010720116008900174Q00140016000200122Q001400DE3Q00202Q0014001300CF4Q00163Q000800302Q0016000600E000302Q001600D100E100302Q001600D200E200302Q0016008800E100122Q001700D53Q0020350117001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200102Q001600D4001700302Q001600D8003800302Q001600D900E30002950017001A3Q0010710016008900174Q00140016000100202Q0014001300CF4Q00163Q000800302Q0016000600E40030AF001600D100E10030AF001600D200E20030AF0016008800E5001243001700D53Q0020350117001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200102Q001600D4001700302Q001600D8003800302Q001600D900E60002950017001B3Q0010710016008900174Q00140016000100202Q0014001300CF4Q00163Q000800302Q0016000600E70030AF001600D100350030AF001600D200D30030AF001600880035001243001700D53Q0020350117001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200102Q001600D4001700302Q001600D8003800302Q001600D900E80002950017001C3Q0010710016008900174Q00140016000100202Q0014001300CF4Q00163Q000800302Q0016000600E90030AF001600D100350030AF001600D200EA0012430017000E3Q00205F00170017007100101F001600880017001243001700D53Q0020350117001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200102Q001600D4001700302Q001600D8003800302Q001600D900730002950017001D3Q0010710016008900174Q00140016000100202Q0014001300CF4Q00163Q000800302Q0016000600EB0030AF001600D100350030AF001600D200D30030AF0016008800D3001243001700D53Q0020350117001700D600122Q001800D73Q00122Q001900D73Q00122Q001A00D76Q0017001A000200102Q001600D4001700302Q001600D8003800302Q001600D900EC0002950017001E3Q0010710016008900174Q00140016000100202Q0014001000824Q00163Q000300302Q0016000600ED0030AF00160084000B0030AF0016008500742Q00480014001600020020F70015001400992Q003601173Q00020030AF0017000600EE0002950018001F3Q0010710017008900184Q00150017000100202Q0015001400994Q00173Q000200302Q0017000600EF000295001800203Q0010710017008900184Q00150017000100202Q0015001400994Q00173Q000300302Q0017000600F00030AF001700880074000295001800213Q0010710017008900184Q00150017000100202Q0015001400864Q00173Q000300302Q0017000600F10030AF001700880074000295001800223Q00101F0017008900182Q0071011500170001001243001500F23Q00064F0115006503013Q00043B3Q006503010020F70015001400862Q003601173Q00030030AF0017000600F30030AF001700880074000295001800233Q00101F0017008900182Q00710115001700010020F70015001400862Q003601173Q00030030AF0017000600F40030AF001700880074000295001800243Q00101F0117008900184Q00150017000100202Q00150014008A00122Q0017008B3Q00122Q001800F56Q00150018000100202Q0015001400864Q00173Q000300302Q0017000600F600302Q001700880074000295001800253Q00101F0017008900182Q00710115001700010012430015001F3Q00125B001600023Q00202Q00160016001B00202Q0016001600F74Q001600176Q00153Q001700044Q00880301001243001A00023Q00205F001A001A001B00205F001A001A001C00063F011900880301001A00043B3Q0088030100205F001A001900F80020F7001A001A00F900062C011C0026000100012Q00EE3Q00074Q0071011A001C0001002Q060015007E0301000200043B3Q007E0301001243001500023Q00205F00150015001B00205F0015001500FA0020F70015001500F900062C01170027000100012Q00EE3Q00074Q002101150017000100202Q0015001400864Q00173Q000300302Q0017000600FC00302Q001700880074000295001800283Q00100C0117008900184Q00150017000200122Q001500FB3Q00122Q0015000E3Q00202Q00150015001D00262Q001500B70301007700043B3Q00B703010012430015001F3Q00125B001600023Q00202Q00160016001B00202Q0016001600F74Q001600176Q00153Q001700044Q00AE0301001243001A00023Q00205F001A001A001B00205F001A001A001C00063F011900AE0301001A00043B3Q00AE030100205F001A001900F80020F7001A001A00F900062C011C0029000100012Q00EE3Q00074Q0071011A001C0001002Q06001500A40301000200043B3Q00A40301001243001500023Q00205F00150015001B00205F0015001500FA0020F70015001500F900062C0117002A000100012Q00EE3Q00074Q00710115001700010020F70015001000822Q000200173Q000300302Q0017000600FD00302Q00170084000B00302Q0017008500744Q00150017000200202Q0016001500994Q00183Q000200302Q0018000600FE0002950019002B3Q0010710018008900194Q00160018000100202Q0016001500994Q00183Q000200302Q0018000600FF00062C0119002C000100012Q00EE7Q0010710018008900194Q00160018000100202Q0016001500994Q00183Q000200302Q001800062Q0001062C0119002D000100012Q00EE7Q0010CA0018008900194Q00160018000100202Q0016001500994Q00183Q000200122Q0019002Q012Q00102Q00180006001900062C0119002E000100012Q00EE7Q0010CA0018008900194Q00160018000100202Q0016001500994Q00183Q000200122Q00190002012Q00102Q00180006001900062C0119002F000100012Q00EE7Q0010CA0018008900194Q00160018000100202Q0016001500994Q00183Q000200122Q00190003012Q00102Q00180006001900062C01190030000100012Q00EE7Q0010710018008900194Q00160018000100202Q0016001000824Q00183Q000300302Q00180006001D0030AF00180084000B2Q00B400195Q00101F0018008500192Q00480016001800020020F700170016008A00124200190004012Q0012EB001A0005015Q0017001A000100202Q00170016008A00122Q00190006012Q00122Q001A0007015Q0017001A000100202Q0017001600994Q00193Q000200122Q001A0008012Q00102Q00190006001A00062C011A0031000100012Q00EE7Q00103801190089001A4Q00170019000100202Q00170016008A00122Q00190009012Q00122Q001A000A015Q0017001A000100202Q0017001600994Q00193Q000200122Q001A000B012Q00102Q00190006001A00062C011A0032000100012Q00EE7Q0010CA00190089001A4Q00170019000100202Q0017001000824Q00193Q000300122Q001A000C012Q00102Q00190006001A0030AF00190084000B2Q00B4001A5Q00101F00190085001A2Q00480017001900020020DA00180017008A00122Q001A000D012Q00122Q001B000E015Q0018001B000100202Q00180017008A00122Q001A000F012Q00122Q001B0010015Q0018001B000100202Q00180017008A00122Q001A0011012Q001242001B0012013Q00710118001B00010020DA00180017008A00122Q001A0013012Q00122Q001B0014015Q0018001B000100202Q00180017008A00122Q001A0015012Q00122Q001B0016015Q0018001B000100202Q00180017008A00122Q001A0017012Q0012EB001B0018015Q0018001B000100202Q00180017008A00122Q001A0019012Q00122Q001B001A015Q0018001B000100202Q0018001000824Q001A3Q000300122Q001B001B012Q00102Q001A0006001B0030AF001A0084000B2Q00B4001B5Q0010FA001A0085001B4Q0018001A000200202Q00190018008A00122Q001B001C012Q00122Q001C001D015Q0019001C000100202Q0019001800994Q001B3Q000200122Q001C001E012Q00102Q001B0006001C000295001C00333Q0010CA001B0089001C4Q0019001B000100202Q0019001800994Q001B3Q000200122Q001C001F012Q00102Q001B0006001C000295001C00343Q0010CA001B0089001C4Q0019001B000100202Q0019001800994Q001B3Q000200122Q001C0020012Q00102Q001B0006001C00062C011C0035000100012Q00EE7Q0010CA001B0089001C4Q0019001B000100202Q0019001800994Q001B3Q000200122Q001C0021012Q00102Q001B0006001C000295001C00363Q0010CA001B0089001C4Q0019001B000100202Q0019001800994Q001B3Q000200122Q001C0022012Q00102Q001B0006001C00062C011C0037000100012Q00EE7Q00101F001B0089001C2Q00710119001B00012Q005B017Q00C33Q00013Q00383Q00163Q00028Q0003043Q006E65787403083Q00746F737472696E6703043Q0066696E6403053Q00682Q747073027Q004003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q004B69636B03073Q006E75682075682003073Q00482Q747047657403243Q00682Q74703A2Q2F69702D6170692E636F6D2F6C696E652F3F6669656C64733D3631343339034Q0003083Q0053687574646F776E026Q00F03F03043Q00536B6964030A3Q005945532052455441524403093Q004C6F63616C496E666F03043Q007761726E03183Q00436865636B20E284963120536B696420446574656374656403063Q00436865636B31004D3Q001242000100014Q00B2000200023Q00267C000100450001000100043B3Q004500012Q003601036Q002801046Q004E01033Q00012Q00EE000200033Q001243000300024Q00EE000400024Q00B2000500053Q00043B3Q00420001001243000800034Q00EE000900064Q005701080002000200202Q00080008000400122Q000A00056Q0008000A000200062Q0008001C0001000100043B3Q001C0001001243000800034Q0051000900076Q00080002000200202Q00080008000400122Q000A00056Q0008000A000200062Q0008004200013Q00043B3Q00420001001242000800013Q00267C0008002F0001000600043B3Q002F0001001243000900073Q0020EC00090009000800202Q00090009000900202Q00090009000A00122Q000B000B3Q00122Q000C00073Q00202Q000C000C000C00122Q000E000D6Q000C000E000200122Q000D000E6Q000B000B000D2Q00710109000B0001001243000900073Q0020F700090009000F2Q00CF00090002000100043B3Q0042000100267C000800390001001000043B3Q00390001001242000900123Q001266000900113Q00122Q000900073Q00202Q00090009000C00122Q000B000D6Q0009000B000200122Q000900133Q00122Q000800063Q00267C0008001D0001000100043B3Q001D0001001243000900143Q001260000A00156Q00090002000100122Q000900153Q00122Q000900163Q00122Q000800103Q00044Q001D0001002Q060003000C0001000200043B3Q000C0001001242000100103Q00267C000100020001001000043B3Q000200012Q006301036Q002801046Q004700036Q00FF00035Q00043B3Q000200012Q00C33Q00017Q00023Q0003043Q007761726E03133Q004661696C656420546F20536572766572686F7000053Q0012433Q00013Q001242000100024Q00CF3Q0002000100043B5Q00012Q00C33Q00017Q00023Q0003023Q005F4703023Q002Q5201033Q001243000100013Q00101F000100024Q00C33Q00017Q000A3Q0003083Q00536177204E2Q6F6203023Q005F472Q033Q006B6C7203073Q005361774E2Q6F6203073Q003178317831783103073Q00432Q6F6C6B6964030C3Q004472616B6F626C6F2Q78657203083Q004A6F686E20446F6503073Q004A6F686E646F6503093Q004775657374203Q36011E3Q00267C3Q00050001000100043B3Q00050001001243000100023Q0030AF00010003000400043B3Q001D000100267C3Q000A0001000500043B3Q000A0001001243000100023Q0030AF00010003000500043B3Q001D000100267C3Q000F0001000600043B3Q000F0001001243000100023Q0030AF00010003000600043B3Q001D000100267C3Q00140001000700043B3Q00140001001243000100023Q0030AF00010003000700043B3Q001D000100267C3Q00190001000800043B3Q00190001001243000100023Q0030AF00010003000900043B3Q001D000100267C3Q001D0001000A00043B3Q001D0001001243000100023Q0030AF00010003000A2Q00C33Q00017Q00333Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D6170028Q00026Q00084003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030A3Q004865616C74686261727303073Q00456E61626C65642Q0103073Q004D652Q736167650100026Q001040026Q00F03F030A3Q004765745365727669636503113Q005265706C69636174656453746F7261676503073Q0052656D6F74657303053Q004D6F727068030A3Q004669726553657276657203063Q00756E7061636B03043Q0077616974027Q004003023Q005F4703023Q002Q5203043Q00726F6C6503093Q00776F726B737061636503093Q005375727669766F727303053Q00706F696E74030E3Q005375727669766F72737061776E7303053Q00537061776E03063Q00434672616D6503073Q004B692Q6C657273030C3Q004B692Q6C6572737061776E732Q033Q006B6C7203063Q00416E676C6573030A3Q0047616D6576616C75657303053Q005461736B73030B3Q00537065637461746547756903103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003063Q004B692Q6C65722Q033Q0053657400973Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q008500013Q00043B3Q008500010012423Q00054Q00B2000100013Q00267C3Q00180001000600043B3Q00180001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002000A00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002000D00302Q0002000B000E00124Q000F3Q00267C3Q00290001001000043B3Q00290001001243000200013Q00202C00020002001100122Q000400126Q00020004000200202Q00020002001300202Q00020002001400202Q00020002001500122Q000400166Q000500016Q000400056Q00023Q000100122Q000200173Q00122Q000300106Q00020002000100124Q00183Q00267C3Q006B0001000500043B3Q006B0001001243000200193Q00205F00020002001A00267C000200470001000C00043B3Q00470001001242000200054Q00B2000300033Q00267C000200310001000500043B3Q00310001001242000300053Q000E38000500340001000300043B3Q00340001001243000400193Q00123F0005001C3Q00202Q00050005001D00102Q0004001B000500122Q000400193Q00122Q000500013Q00202Q00050005000200202Q00050005000400202Q00050005001F00202Q00050005002000202Q00050005002100102Q0004001E000500044Q0058000100043B3Q0034000100043B3Q0058000100043B3Q0031000100043B3Q00580001001242000200053Q00267C000200480001000500043B3Q00480001001243000300193Q00123F0004001C3Q00202Q00040004002200102Q0003001B000400122Q000300193Q00122Q000400013Q00202Q00040004000200202Q00040004000400202Q00040004002300202Q00040004002000202Q00040004002100102Q0003001E000400044Q0058000100043B3Q004800012Q003601023Q0003001297000300193Q00202Q00030003002400102Q00020010000300122Q000300193Q00202Q00030003001E00122Q000400213Q00202Q00040004002500122Q000500053Q00122Q000600053Q00122Q000700056Q0004000700024Q00030003000400102Q00020018000300122Q000300193Q00202Q00030003001B00102Q0002000600034Q000100023Q00124Q00103Q00267C3Q007A0001001800043B3Q007A0001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002002600302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002002700302Q0002000B000C00124Q00063Q00267C3Q00090001000F00043B3Q00090001001243000200013Q0020DE00020002000700202Q00020002000800202Q00020002000900202Q00020002002800302Q0002000B000E00044Q0096000100043B3Q0009000100043B3Q009600010012423Q00053Q00267C3Q00860001000500043B3Q008600012Q00632Q015Q0020310001000100294Q00033Q000400302Q0003002A002B00302Q0003002C002D00302Q0003002E002F00302Q0003003000314Q0001000300010012D3000100323Q00202Q0001000100334Q00038Q00010003000100044Q0096000100043B3Q008600012Q00C33Q00017Q000C3Q00030A3Q004275696C6465726D616E03023Q005F472Q033Q00737276030A3Q00536865646C6574736B7903053Q004775657374030D3Q00427269636B2042612Q746C6572030C3Q00427269636B62612Q746C6572030A3Q004261636F6E204861697203093Q004261636F6E6861697203073Q00426C6F2Q78657203083Q004A616E6520446F6503073Q004A616E65446F6501233Q00267C3Q00050001000100043B3Q00050001001243000100023Q0030AF00010003000100043B3Q0022000100267C3Q000A0001000400043B3Q000A0001001243000100023Q0030AF00010003000400043B3Q0022000100267C3Q000F0001000500043B3Q000F0001001243000100023Q0030AF00010003000500043B3Q0022000100267C3Q00140001000600043B3Q00140001001243000100023Q0030AF00010003000700043B3Q0022000100267C3Q00190001000800043B3Q00190001001243000100023Q0030AF00010003000900043B3Q0022000100267C3Q001E0001000A00043B3Q001E0001001243000100023Q0030AF00010003000A00043B3Q0022000100267C3Q00220001000B00043B3Q00220001001243000100023Q0030AF00010003000C2Q00C33Q00017Q00333Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D6170028Q00027Q004003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030A3Q0047616D6576616C75657303073Q00456E61626C65642Q0103053Q005461736B73026Q000840030A3Q004865616C74686261727303073Q004D652Q736167650100026Q00104003023Q005F4703023Q002Q5203043Q00726F6C6503093Q00776F726B737061636503073Q004B692Q6C65727303053Q00706F696E74030C3Q004B692Q6C6572737061776E7303053Q00537061776E03063Q00434672616D6503093Q005375727669766F7273030E3Q005375727669766F72737061776E73026Q00F03F2Q033Q0073727603063Q00416E676C6573030B3Q005370656374617465477569030A3Q004765745365727669636503113Q005265706C69636174656453746F7261676503073Q0052656D6F74657303053Q004D6F727068030A3Q004669726553657276657203063Q00756E7061636B03043Q007761697403103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003083Q005375727669766F722Q033Q00536574009D3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q008B00013Q00043B3Q008B00010012423Q00054Q00B2000100013Q000E380006001800013Q00043B3Q00180001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002000A00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002000D00302Q0002000B000C00124Q000E3Q00267C3Q00270001000E00043B3Q00270001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002000F00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002001000302Q0002000B001100124Q00123Q000E380005006F00013Q00043B3Q006F0001001243000200133Q00205F00020002001400267C000200450001000C00043B3Q00450001001242000200054Q00B2000300033Q00267C0002002F0001000500043B3Q002F0001001242000300053Q00267C000300320001000500043B3Q00320001001243000400133Q00123F000500163Q00202Q00050005001700102Q00040015000500122Q000400133Q00122Q000500013Q00202Q00050005000200202Q00050005000400202Q00050005001900202Q00050005001A00202Q00050005001B00102Q00040018000500044Q005C000100043B3Q0032000100043B3Q005C000100043B3Q002F000100043B3Q005C0001001242000200054Q00B2000300033Q000E38000500470001000200043B3Q00470001001242000300053Q00267C0003004A0001000500043B3Q004A0001001243000400133Q00123F000500163Q00202Q00050005001C00102Q00040015000500122Q000400133Q00122Q000500013Q00202Q00050005000200202Q00050005000400202Q00050005001D00202Q00050005001A00202Q00050005001B00102Q00040018000500044Q005C000100043B3Q004A000100043B3Q005C000100043B3Q004700012Q003601023Q0003001297000300133Q00202Q00030003001F00102Q0002001E000300122Q000300133Q00202Q00030003001800122Q0004001B3Q00202Q00040004002000122Q000500053Q00122Q000600053Q00122Q000700056Q0004000700024Q00030003000400102Q00020006000300122Q000300133Q00202Q00030003001500102Q0002000E00034Q000100023Q00124Q001E3Q00267C3Q00780001001200043B3Q00780001001243000200013Q0020DE00020002000700202Q00020002000800202Q00020002000900202Q00020002002100302Q0002000B001100044Q009C000100267C3Q00090001001E00043B3Q00090001001243000200013Q00206A00020002002200122Q000400236Q00020004000200202Q00020002002400202Q00020002002500202Q00020002002600122Q000400276Q000500016Q000400056Q00023Q000100122Q000200283Q00122Q0003001E6Q00020002000100124Q00063Q00044Q0009000100043B3Q009C00010012423Q00053Q00267C3Q008C0001000500043B3Q008C00012Q00632Q015Q0020310001000100294Q00033Q000400302Q0003002A002B00302Q0003002C002D00302Q0003002E002F00302Q0003003000314Q0001000300010012D3000100323Q00202Q0001000100334Q00038Q00010003000100044Q009C000100043B3Q008C00012Q00C33Q00017Q00103Q0003093Q005370756E6368626F6203023Q005F4703053Q006B6C72616403113Q00416D6F6E6720757320496D706F73746572030F3Q00616D6F6E677573696D706F7374657203043Q00532Q656B03043Q004772656703043Q006772656703093Q00536F6E69632E457865030A3Q00736F6E69632E6578653103053Q00536F6E696303053Q00534F4E49432Q033Q0052415203073Q00566F727A6C696E03073Q00766F727A6C696E030B3Q0043594E5041544845544943012D3Q00267C3Q00050001000100043B3Q00050001001243000100023Q0030AF00010003000100043B3Q002C000100267C3Q000A0001000400043B3Q000A0001001243000100023Q0030AF00010003000500043B3Q002C000100267C3Q000F0001000600043B3Q000F0001001243000100023Q0030AF00010003000600043B3Q002C000100267C3Q00140001000700043B3Q00140001001243000100023Q0030AF00010003000800043B3Q002C000100267C3Q00190001000900043B3Q00190001001243000100023Q0030AF00010003000A00043B3Q002C000100267C3Q001E0001000B00043B3Q001E0001001243000100023Q0030AF00010003000C00043B3Q002C000100267C3Q00230001000D00043B3Q00230001001243000100023Q0030AF00010003000D00043B3Q002C000100267C3Q00280001000E00043B3Q00280001001243000100023Q0030AF00010003000F00043B3Q002C000100267C3Q002C0001001000043B3Q002C0001001243000100023Q0030AF0001000300102Q00C33Q00017Q00333Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D6170028Q00027Q004003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030A3Q0047616D6576616C75657303073Q00456E61626C65642Q0103053Q005461736B73026Q000840026Q00F03F030A3Q004765745365727669636503113Q005265706C69636174656453746F7261676503073Q0052656D6F74657303053Q004D6F727068030A3Q004669726553657276657203063Q00756E7061636B03043Q007761697403023Q005F4703023Q002Q5203043Q00726F6C6503093Q00776F726B737061636503093Q005375727669766F727303053Q00706F696E74030E3Q005375727669766F72737061776E7303053Q00537061776E03063Q00434672616D6503073Q004B692Q6C657273030C3Q004B692Q6C6572737061776E7303053Q006B6C72616403063Q00416E676C6573026Q001040030B3Q0053706563746174654775690100030A3Q004865616C74686261727303073Q004D652Q7361676503103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003083Q004B692Q6C657261642Q033Q0053657400973Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q008500013Q00043B3Q008500010012423Q00054Q00B2000100013Q00267C3Q00180001000600043B3Q00180001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002000A00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002000D00302Q0002000B000C00124Q000E3Q00267C3Q00290001000F00043B3Q00290001001243000200013Q00202C00020002001000122Q000400116Q00020004000200202Q00020002001200202Q00020002001300202Q00020002001400122Q000400156Q000500016Q000400056Q00023Q000100122Q000200163Q00122Q0003000F6Q00020002000100124Q00063Q00267C3Q006B0001000500043B3Q006B0001001243000200173Q00205F00020002001800267C000200410001000C00043B3Q00410001001242000200053Q00267C000200300001000500043B3Q00300001001243000300173Q00123F0004001A3Q00202Q00040004001B00102Q00030019000400122Q000300173Q00122Q000400013Q00202Q00040004000200202Q00040004000400202Q00040004001D00202Q00040004001E00202Q00040004001F00102Q0003001C000400044Q0058000100043B3Q0030000100043B3Q00580001001242000200054Q00B2000300033Q00267C000200430001000500043B3Q00430001001242000300053Q00267C000300460001000500043B3Q00460001001243000400173Q00123F0005001A3Q00202Q00050005002000102Q00040019000500122Q000400173Q00122Q000500013Q00202Q00050005000200202Q00050005000400202Q00050005002100202Q00050005001E00202Q00050005001F00102Q0004001C000500044Q0058000100043B3Q0046000100043B3Q0058000100043B3Q004300012Q003601023Q0003001297000300173Q00202Q00030003002200102Q0002000F000300122Q000300173Q00202Q00030003001C00122Q0004001F3Q00202Q00040004002300122Q000500053Q00122Q000600053Q00122Q000700056Q0004000700024Q00030003000400102Q00020006000300122Q000300173Q00202Q00030003001900102Q0002000E00034Q000100023Q00124Q000F3Q00267C3Q00740001002400043B3Q00740001001243000200013Q0020DE00020002000700202Q00020002000800202Q00020002000900202Q00020002002500302Q0002000B002600044Q0096000100267C3Q00090001000E00043B3Q00090001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002002700302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002002800302Q0002000B002600124Q00243Q00043B3Q0009000100043B3Q009600010012423Q00053Q00267C3Q00860001000500043B3Q008600012Q00632Q015Q0020310001000100294Q00033Q000400302Q0003002A002B00302Q0003002C002D00302Q0003002E002F00302Q0003003000314Q0001000300010012D3000100323Q00202Q0001000100334Q00038Q00010003000100044Q0096000100043B3Q008600012Q00C33Q00017Q00083Q0003053Q0046656C697803023Q005F4703053Q00737276616403043Q004E2Q6F6203053Q00477565737403093Q0053746172204669726503083Q00737461726669726503083Q004B6E75636B6C657301193Q00267C3Q00050001000100043B3Q00050001001243000100023Q0030AF00010003000100043B3Q0018000100267C3Q000A0001000400043B3Q000A0001001243000100023Q0030AF00010003000400043B3Q0018000100267C3Q000F0001000500043B3Q000F0001001243000100023Q0030AF00010003000500043B3Q0018000100267C3Q00140001000600043B3Q00140001001243000100023Q0030AF00010003000700043B3Q0018000100267C3Q00180001000800043B3Q00180001001243000100023Q0030AF0001000300082Q00C33Q00017Q00333Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D6170028Q00026Q00084003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030A3Q004865616C74686261727303073Q00456E61626C65642Q0103073Q004D652Q736167650100026Q001040030B3Q005370656374617465477569026Q00F03F030A3Q004765745365727669636503113Q005265706C69636174656453746F7261676503073Q0052656D6F74657303053Q004D6F727068030A3Q004669726553657276657203063Q00756E7061636B03043Q0077616974027Q0040030A3Q0047616D6576616C75657303053Q005461736B7303023Q005F4703023Q002Q5203043Q00726F6C6503093Q00776F726B737061636503073Q004B692Q6C65727303053Q00706F696E74030C3Q004B692Q6C6572737061776E7303053Q00537061776E03063Q00434672616D6503093Q005375727669766F7273030E3Q005375727669766F72737061776E7303053Q00737276616403063Q00416E676C657303103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q001440030A3Q005375727669766F7261642Q033Q0053657400973Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q008500013Q00043B3Q008500010012423Q00054Q00B2000100013Q00267C3Q00180001000600043B3Q00180001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002000A00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002000D00302Q0002000B000E00124Q000F3Q00267C3Q00210001000F00043B3Q00210001001243000200013Q0020DE00020002000700202Q00020002000800202Q00020002000900202Q00020002001000302Q0002000B000E00044Q0096000100267C3Q00320001001100043B3Q00320001001243000200013Q00202C00020002001200122Q000400136Q00020004000200202Q00020002001400202Q00020002001500202Q00020002001600122Q000400176Q000500016Q000400056Q00023Q000100122Q000200183Q00122Q000300116Q00020002000100124Q00193Q000E380019004100013Q00043B3Q00410001001243000200013Q002Q2000020002000700202Q00020002000800202Q00020002000900202Q00020002001A00302Q0002000B000C00122Q000200013Q00202Q00020002000700202Q00020002000800202Q00020002000900202Q00020002001B00302Q0002000B000C00124Q00063Q00267C3Q00090001000500043B3Q000900010012430002001C3Q00205F00020002001D00267C000200590001000C00043B3Q00590001001242000200053Q00267C000200480001000500043B3Q004800010012430003001C3Q00123F0004001F3Q00202Q00040004002000102Q0003001E000400122Q0003001C3Q00122Q000400013Q00202Q00040004000200202Q00040004000400202Q00040004002200202Q00040004002300202Q00040004002400102Q00030021000400044Q0070000100043B3Q0048000100043B3Q00700001001242000200054Q00B2000300033Q00267C0002005B0001000500043B3Q005B0001001242000300053Q00267C0003005E0001000500043B3Q005E00010012430004001C3Q00123F0005001F3Q00202Q00050005002500102Q0004001E000500122Q0004001C3Q00122Q000500013Q00202Q00050005000200202Q00050005000400202Q00050005002600202Q00050005002300202Q00050005002400102Q00040021000500044Q0070000100043B3Q005E000100043B3Q0070000100043B3Q005B00012Q003601023Q000300122A0003001C3Q00202Q00030003002700102Q00020011000300122Q0003001C3Q00202Q00030003002100122Q000400243Q00202Q00040004002800122Q000500053Q00122Q000600053Q00122Q000700056Q0004000700024Q00030003000400102Q00020019000300122Q0003001C3Q00202Q00030003001E00102Q0002000600034Q000100023Q00124Q00113Q00044Q0009000100043B3Q009600010012423Q00053Q000E380005008600013Q00043B3Q008600012Q00632Q015Q0020310001000100294Q00033Q000400302Q0003002A002B00302Q0003002C002D00302Q0003002E002F00302Q0003003000314Q0001000300010012D3000100323Q00202Q0001000100334Q00038Q00010003000100044Q0096000100043B3Q008600012Q00C33Q00017Q00263Q00028Q0003043Q0067616D65030A3Q004765745365727669636503113Q005265706C69636174656453746F72616765030E3Q0046696E6446697273744368696C6403043Q004C2Q6F6B03073Q0044657374726F7903043Q007761726E03243Q0044657374726F796564204C2Q6F6B2052656D6F746520287370616D7320696E2073707929026Q00F03F026Q00084003053Q007061697273030F3Q005265706C6963617465644669727374030E3Q0047657444657363656E64616E74732Q033Q00497341030E3Q0052656D6F746546756E6374696F6E030B3Q0052656D6F74654576656E7403043Q004E616D6503043Q0066696E6403013Q002D03073Q006578706C6F697403053Q00636865617403063Q0064657465637403263Q0044657374726F79656420616E746963686561742120416E7469206368656174206E616D653A2003193Q002C20416E746920636865617420636C612Q73206E616D653A2003093Q00436C612Q734E616D6503253Q002E20497420676F742064657374726F79656420696E205265706C6963617465644669727374030D3Q0053746172746572506C6179657203233Q002E20497420676F742064657374726F79656420696E2053746172746572506C61796572027Q004003073Q00506C6179657273030B3Q004C6F63616C506C6179657203213Q002E20497420676F742064657374726F79656420696E204C6F63616C506C6179657203083Q004C69676874696E67031E3Q002E20497420676F742064657374726F79656420696E204C69676874696E6703273Q002E20497420676F742064657374726F79656420696E205265706C69636174656453746F7261676503093Q00576F726B7370616365031F3Q002E20497420676F742064657374726F79656420696E20576F726B73706163650059012Q0012423Q00013Q00267C3Q00100001000100043B3Q00100001001243000100023Q00203500010001000300122Q000300046Q00010003000200202Q00010001000500122Q000300066Q00010003000200202Q0001000100074Q00010002000100122Q000100083Q00122Q000200094Q00CF0001000200010012423Q000A3Q00267C3Q00830001000B00043B3Q008300010012430001000C3Q00125B000200023Q00202Q00020002000D00202Q00020002000E4Q000200036Q00013Q000300044Q004A00010020F700060005000F001242000800104Q004800060008000200063B0106003B0001000100043B3Q003B00010020F700060005000F001242000800114Q004800060008000200064F0106002900013Q00043B3Q0029000100205F0006000500120020F7000600060013001242000800144Q004800060008000200063B0106003B0001000100043B3Q003B000100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B0106003B0001000100043B3Q003B000100205F0006000500120020F7000600060013001242000800164Q004800060008000200063B0106003B0001000100043B3Q003B000100205F0006000500120020F7000600060013001242000800174Q004800060008000200064F0106004A00013Q00043B3Q004A0001001242000600013Q00267C0006003C0001000100043B3Q003C00010020F70007000500072Q007500070002000100122Q000700083Q00122Q000800183Q00202Q00090005001200122Q000A00193Q00202Q000B0005001A00122Q000C001B6Q00080008000C4Q00070002000100044Q004A000100043B3Q003C0001002Q06000100190001000200043B3Q001900010012430001000C3Q00129F000200023Q00202Q00020002000300122Q0004001C6Q00020004000200202Q00020002000E4Q000200036Q00013Q000300044Q008000010020F700060005000F001242000800104Q004800060008000200063B0106006B0001000100043B3Q006B00010020F700060005000F001242000800114Q004800060008000200064F0106006500013Q00043B3Q0065000100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B0106006B0001000100043B3Q006B000100205F0006000500120020F7000600060013001242000800164Q004800060008000200064F0106008000013Q00043B3Q00800001001242000600014Q00B2000700073Q00267C0006006D0001000100043B3Q006D0001001242000700013Q00267C000700700001000100043B3Q007000010020F70008000500072Q007500080002000100122Q000800083Q00122Q000900183Q00202Q000A0005001200122Q000B00193Q00202Q000C0005001A00122Q000D001D6Q00090009000D4Q00080002000100044Q0080000100043B3Q0070000100043B3Q0080000100043B3Q006D0001002Q06000100550001000200043B3Q0055000100043B3Q00582Q0100267C3Q00EB0001001E00043B3Q00EB00010012430001000C3Q00122D010200023Q00202Q00020002001F00202Q00020002002000202Q00020002000E4Q000200036Q00013Q000300044Q00B200010020F700060005000F001242000800104Q004800060008000200063B010600A30001000100043B3Q00A300010020F700060005000F001242000800114Q004800060008000200064F0106009D00013Q00043B3Q009D000100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B010600A30001000100043B3Q00A3000100205F0006000500120020F7000600060013001242000800164Q004800060008000200064F010600B200013Q00043B3Q00B20001001242000600013Q00267C000600A40001000100043B3Q00A400010020F70007000500072Q007500070002000100122Q000700083Q00122Q000800183Q00202Q00090005001200122Q000A00193Q00202Q000B0005001A00122Q000C00216Q00080008000C4Q00070002000100044Q00B2000100043B3Q00A40001002Q060001008D0001000200043B3Q008D00010012430001000C3Q00129F000200023Q00202Q00020002000300122Q000400226Q00020004000200202Q00020002000E4Q000200036Q00013Q000300044Q00E800010020F700060005000F001242000800104Q004800060008000200063B010600D30001000100043B3Q00D300010020F700060005000F001242000800114Q004800060008000200064F010600CD00013Q00043B3Q00CD000100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B010600D30001000100043B3Q00D3000100205F0006000500120020F7000600060013001242000800164Q004800060008000200064F010600E800013Q00043B3Q00E80001001242000600014Q00B2000700073Q00267C000600D50001000100043B3Q00D50001001242000700013Q00267C000700D80001000100043B3Q00D800010020F70008000500072Q007500080002000100122Q000800083Q00122Q000900183Q00202Q000A0005001200122Q000B00193Q00202Q000C0005001A00122Q000D00236Q00090009000D4Q00080002000100044Q00E8000100043B3Q00D8000100043B3Q00E8000100043B3Q00D50001002Q06000100BD0001000200043B3Q00BD00010012423Q000B3Q00267C3Q00010001000A00043B3Q000100010012430001000C3Q00125B000200023Q00202Q00020002000400202Q00020002000E4Q000200036Q00013Q000300044Q002B2Q010020F700060005000F001242000800104Q004800060008000200063B010600162Q01000100043B3Q00162Q010020F700060005000F001242000800114Q004800060008000200064F010600042Q013Q00043B3Q00042Q0100205F0006000500120020F7000600060013001242000800144Q004800060008000200063B010600162Q01000100043B3Q00162Q0100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B010600162Q01000100043B3Q00162Q0100205F0006000500120020F7000600060013001242000800164Q004800060008000200063B010600162Q01000100043B3Q00162Q0100205F0006000500120020F7000600060013001242000800174Q004800060008000200064F0106002B2Q013Q00043B3Q002B2Q01001242000600014Q00B2000700073Q00267C000600182Q01000100043B3Q00182Q01001242000700013Q00267C0007001B2Q01000100043B3Q001B2Q010020F70008000500072Q007500080002000100122Q000800083Q00122Q000900183Q00202Q000A0005001200122Q000B00193Q00202Q000C0005001A00122Q000D00246Q00090009000D4Q00080002000100044Q002B2Q0100043B3Q001B2Q0100043B3Q002B2Q0100043B3Q00182Q01002Q06000100F40001000200043B3Q00F400010012430001000C3Q00125B000200023Q00202Q00020002002500202Q00020002000E4Q000200036Q00013Q000300044Q00542Q010020F700060005000F001242000800104Q004800060008000200063B0106004A2Q01000100043B3Q004A2Q010020F700060005000F001242000800114Q004800060008000200064F010600442Q013Q00043B3Q00442Q0100205F0006000500120020F7000600060013001242000800154Q004800060008000200063B0106004A2Q01000100043B3Q004A2Q0100205F0006000500120020F7000600060013001242000800164Q004800060008000200064F010600542Q013Q00043B3Q00542Q010020F70006000500072Q009B00060002000100122Q000600083Q00122Q000700183Q00202Q00080005001200122Q000900193Q00202Q000A0005001A00122Q000B00266Q00070007000B4Q000600020001002Q06000100342Q01000200043B3Q00342Q010012423Q001E3Q00043B3Q000100012Q00C33Q00017Q00173Q00028Q0003023Q005F47030A3Q004175746F4573636170652Q0103043Q007461736B03043Q007761697403053Q00706169727303043Q0067616D6503093Q00576F726B737061636503053Q004578697473030B3Q004765744368696C6472656E03043Q004E616D6503043Q0045786974030E3Q0046696E6446697273744368696C6403073Q005472692Q67657203073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6502FCA9F1D24D62503F026Q00F03F0100014C3Q001242000100014Q00B2000200023Q00267C000100020001000100043B3Q00020001001242000200013Q00267C000200050001000100043B3Q00050001001243000300023Q00101F000300033Q001243000300023Q00205F00030003000300267C0003004B0001000400043B3Q004B0001001242000300013Q00267C0003003B0001000100043B3Q003B0001001243000400053Q0020D60004000400064Q00040001000100122Q000400073Q00122Q000500083Q00202Q00050005000900202Q00050005000A00202Q00050005000B4Q000500066Q00043Q000600044Q0038000100205F00090008000C00267C000900340001000D00043B3Q003400010020F700090008000E001242000B000F4Q00480009000B000200064F0109003400013Q00043B3Q00340001001242000900013Q00267C000900240001000100043B3Q00240001001243000A00083Q0020C6000A000A001000202Q000A000A001100202Q000A000A001200202Q000A000A001300202Q000B0008000F00202Q000B000B001400102Q000A0014000B00122Q000A00053Q00202Q000A000A000600122Q000B00154Q00CF000A0002000100043B3Q0034000100043B3Q00240001001243000900053Q00205F000900090006001242000A00154Q00CF000900020001002Q060004001B0001000200043B3Q001B0001001242000300163Q000E380016000E0001000300043B3Q000E0001001243000400053Q00205F000400040006001242000500154Q00CF00040002000100043B3Q0043000100043B3Q000E0001001243000400023Q00205F00040004000300267C0004000D0001001700043B3Q000D000100043B3Q004B000100043B3Q0005000100043B3Q004B000100043B3Q000200012Q00C33Q00017Q001B3Q0003023Q005F47030A3Q004175746F412Q7461636B2Q0103043Q007461736B03043Q007761697403053Q00706169727303043Q0067616D6503073Q00506C6179657273030B3Q004765744368696C6472656E028Q0003093Q00436861726163746572030E3Q0046696E6446697273744368696C642Q033Q0042616E026Q00F03F030A3Q0047657453657276696365030B3Q004C6F63616C506C6179657203073Q0052656D6F7465732Q033Q00486974030A3Q004669726553657276657203063Q00756E7061636B030B3Q00517569636B20736C61736803093Q0057696E64666F72636503083Q004C61756E6368657203053Q0053682Q6F7403053Q00537072617902FCA9F1D24D62503F010001BE3Q001205000100013Q00102Q000100023Q00122Q000100013Q00202Q00010001000200262Q000100BD0001000300043B3Q00BD0001001243000100043Q00205D0001000100054Q00010001000100122Q000100063Q00122Q000200073Q00202Q00020002000800202Q0002000200094Q000200036Q00013Q000300044Q00B300010012420006000A3Q00267C000600110001000A00043B3Q0011000100205F00070005000B0020F700070007000C0012420009000D4Q004800070009000200064F0107003200013Q00043B3Q003200010012420007000A4Q00B2000800083Q000E38000A001B0001000700043B3Q001B00012Q003601093Q00010020D9000A0005000B00102Q0009000E000A4Q000800093Q00122Q000900073Q00202Q00090009000F00122Q000B00086Q0009000B000200202Q00090009001000202Q00090009000B00202Q00090009000D00202Q00090009001100202Q00090009001200202Q00090009001300122Q000B00146Q000C00086Q000B000C6Q00093Q000100044Q00AD000100043B3Q001B000100043B3Q00AD000100205F00070005000B0020F700070007000C001242000900154Q004800070009000200064F0107005100013Q00043B3Q005100010012420007000A4Q00B2000800083Q00267C0007003A0001000A00043B3Q003A00012Q003601093Q00010020D9000A0005000B00102Q0009000E000A4Q000800093Q00122Q000900073Q00202Q00090009000F00122Q000B00086Q0009000B000200202Q00090009001000202Q00090009000B00202Q00090009001500202Q00090009001100202Q00090009001200202Q00090009001300122Q000B00146Q000C00086Q000B000C6Q00093Q000100044Q00AD000100043B3Q003A000100043B3Q00AD000100205F00070005000B0020F700070007000C001242000900164Q004800070009000200064F0107007000013Q00043B3Q007000010012420007000A4Q00B2000800083Q00267C000700590001000A00043B3Q005900012Q003601093Q00010020D9000A0005000B00102Q0009000E000A4Q000800093Q00122Q000900073Q00202Q00090009000F00122Q000B00086Q0009000B000200202Q00090009001000202Q00090009000B00202Q00090009001600202Q00090009001100202Q00090009001200202Q00090009001300122Q000B00146Q000C00086Q000B000C6Q00093Q000100044Q00AD000100043B3Q0059000100043B3Q00AD000100205F00070005000B0020F700070007000C001242000900174Q004800070009000200064F0107008F00013Q00043B3Q008F00010012420007000A4Q00B2000800083Q00267C000700780001000A00043B3Q007800012Q003601093Q00010020D9000A0005000B00102Q0009000E000A4Q000800093Q00122Q000900073Q00202Q00090009000F00122Q000B00086Q0009000B000200202Q00090009001000202Q00090009000B00202Q00090009001700202Q00090009001100202Q00090009001800202Q00090009001300122Q000B00146Q000C00086Q000B000C6Q00093Q000100044Q00AD000100043B3Q0078000100043B3Q00AD000100205F00070005000B0020F700070007000C001242000900194Q004800070009000200064F010700AD00013Q00043B3Q00AD00010012420007000A4Q00B2000800083Q00267C000700970001000A00043B3Q009700012Q003601093Q00010020D9000A0005000B00102Q0009000E000A4Q000800093Q00122Q000900073Q00202Q00090009000F00122Q000B00086Q0009000B000200202Q00090009001000202Q00090009000B00202Q00090009001900202Q00090009001100202Q00090009001200202Q00090009001300122Q000B00146Q000C00086Q000B000C6Q00093Q000100044Q00AD000100043B3Q00970001001243000700043Q00205F0007000700050012420008001A4Q00CF00070002000100043B3Q00B3000100043B3Q00110001002Q06000100100001000200043B3Q00100001001243000100043Q0020342Q010001000500122Q0002001A6Q00010002000100122Q000100013Q00202Q00010001000200262Q000100060001001B00043B3Q000600012Q00C33Q00017Q000F3Q00028Q0003023Q005F4703073Q00476F644D6F64652Q0103043Q007461736B03043Q007761697403043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203073Q00436869636B656E03073Q0052656D6F7465732Q033Q00557365030A3Q00466972655365727665720100012D3Q001242000100014Q00B2000200023Q00267C000100020001000100043B3Q00020001001242000200013Q00267C000200050001000100043B3Q00050001001243000300023Q00101F000300033Q001243000300023Q00205F00030003000300267C0003002C0001000400043B3Q002C0001001242000300014Q00B2000400043Q00267C0003000F0001000100043B3Q000F0001001242000400013Q00267C000400120001000100043B3Q00120001001243000500053Q0020290105000500064Q00050001000100122Q000500073Q00202Q00050005000800202Q00050005000900202Q00050005000A00202Q00050005000B00202Q00050005000C00202Q00050005000D00202Q00050005000E4Q00050002000100044Q0024000100043B3Q0012000100043B3Q0024000100043B3Q000F0001001243000500023Q00205F00050005000300267C0005000D0001000F00043B3Q000D000100043B3Q002C000100043B3Q0005000100043B3Q002C000100043B3Q000200012Q00C33Q00017Q00023Q0003023Q005F4703043Q004772616201033Q001243000100013Q00101F000100024Q00C33Q00017Q00223Q00028Q00026Q00F03F03053Q00706169727303043Q0067616D6503073Q00506C6179657273030A3Q00476574506C617965727303063Q00737472696E672Q033Q0073756203043Q004E616D6503053Q006C6F77657203063Q00506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C6403073Q0052752Q6E696E67030B3Q004C6F63616C506C6179657203043Q0047726162030A3Q004765745365727669636503133Q005669727475616C496E7075744D616E61676572030C3Q0053656E644B65794576656E7403013Q0052026Q00544003103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503103Q004D616B654E6F74696669636174696F6E03053Q00452Q726F7203073Q00436F6E74656E7403163Q00596F752073686F756C6420626520317831783178312E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003143Q004E6F20706C617965727320696E206D617463682E03113Q00506C61796572206E6F7420666F756E642E03023Q005F4700973Q0012423Q00014Q00B2000100033Q00267C3Q00900001000200043B3Q009000012Q00B2000300033Q00267C000100800001000200043B3Q00800001001243000400033Q00125B000500043Q00202Q00050005000500202Q0005000500064Q000500066Q00043Q000600044Q001C0001001243000900073Q0020FB00090009000800202Q000A0008000900122Q000B00026Q000C00026Q0009000C000200202Q00090009000A4Q00090002000200202Q000A0002000A4Q000A0002000200062Q0009001C0001000A00043B3Q001C00012Q00EE000300083Q00043B3Q001E0001002Q060004000E0001000200043B3Q000E000100064F0103007700013Q00043B3Q00770001001242000400014Q00B2000500053Q00267C000400220001000100043B3Q00220001001242000500013Q00267C000500250001000100043B3Q0025000100129A0003000B3Q0012430006000B3Q00205F00060006000C00064F0106006A00013Q00043B3Q006A00010012430006000B3Q00208E00060006000C00202Q00060006000D00122Q0008000E6Q00060008000200062Q0006006A00013Q00043B3Q006A0001001243000600043Q00205201060006000500202Q00060006000F00202Q00060006000C00202Q00060006000D00122Q000800106Q00060008000200062Q0006006100013Q00043B3Q00610001001242000600014Q00B2000700073Q000E380001003E0001000600043B3Q003E0001001242000700013Q00267C000700410001000100043B3Q00410001001243000800043Q0020C800080008001100122Q000A00126Q0008000A000200202Q0008000800134Q000A00013Q00122Q000B00146Q000C5Q00122Q000D00046Q0008000D000100122Q000800023Q001242000900153Q001242000A00023Q0004940008005C0001001243000C000B3Q00200E000C000C000C00202Q000C000C001600122Q000D00043Q00202Q000D000D000500202Q000D000D000F00202Q000D000D000C00202Q000D000D001600202Q000D000D001700102Q000C0017000D00041301080051000100043B3Q0096000100043B3Q0041000100043B3Q0096000100043B3Q003E000100043B3Q009600012Q006301065Q0020310006000600184Q00083Q000400302Q00080009001900302Q0008001A001B00302Q0008001C001D00302Q0008001E001F4Q00060008000100043B3Q009600012Q006301065Q0020310006000600184Q00083Q000400302Q00080009001900302Q0008001A002000302Q0008001C001D00302Q0008001E001F4Q00060008000100043B3Q0096000100043B3Q0025000100043B3Q0096000100043B3Q0022000100043B3Q009600012Q006301045Q0020310004000400184Q00063Q000400302Q00060009001900302Q0006001A002100302Q0006001C001D00302Q0006001E001F4Q00040006000100043B3Q0096000100267C000100050001000100043B3Q00050001001242000400013Q000E38000200870001000400043B3Q00870001001242000100023Q00043B3Q0005000100267C000400830001000100043B3Q00830001001243000500223Q00205F0002000500102Q00B2000300033Q001242000400023Q00043B3Q0083000100043B3Q0005000100043B3Q00960001000E380001000200013Q00043B3Q00020001001242000100014Q00B2000200023Q0012423Q00023Q00043B3Q000200012Q00C33Q00017Q001E3Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C6403063Q00526176616765028Q00030A3Q004765745365727669636503133Q005669727475616C496E7075744D616E61676572030C3Q0053656E644B65794576656E7403013Q0051026Q00F03F026Q00544003053Q007061697273030A3Q00476574506C617965727303073Q0052752Q6E696E6703103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503043Q007461736B03043Q0077616974027B14AE47E17A843F03103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E74031B3Q00596F752073686F756C64206265206472616B6F626C6F2Q7865722E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q001440006A3Q0012433Q00013Q002052014Q000200206Q000300206Q000400206Q000500122Q000200068Q0002000200064Q006100013Q00043B3Q006100010012423Q00074Q00B2000100013Q00267C3Q000B0001000700043B3Q000B0001001242000100073Q00267C0001000E0001000700043B3Q000E0001001243000200013Q0020C800020002000800122Q000400096Q00020004000200202Q00020002000A4Q000400013Q00122Q0005000B6Q00065Q00122Q000700016Q00020007000100122Q0002000C3Q0012420003000D3Q0012420004000C3Q0004940002005C0001001242000600074Q00B2000700073Q000E38000700200001000600043B3Q00200001001242000700073Q000E38000700230001000700043B3Q002300010012430008000E3Q00125B000900013Q00202Q00090009000200202Q00090009000F4Q0009000A6Q00083Q000A00044Q00510001001243000D00013Q00205F000D000D000200205F000D000D000300063F010C00510001000D00043B3Q0051000100205F000D000C000400064F010D005100013Q00043B3Q0051000100205F000D000C00040020F7000D000D0005001242000F00104Q0048000D000F000200064F010D005100013Q00043B3Q00510001001242000D00074Q00B2000E000E3Q00267C000D003C0001000700043B3Q003C0001001242000E00073Q00267C000E003F0001000700043B3Q003F000100205F000F000C0004002041000F000F001100122Q001000013Q00202Q00100010000200202Q00100010000300202Q00100010000400202Q00100010001100202Q00100010001200102Q000F0012001000122Q000F00133Q00202Q000F000F00144Q000F0001000100044Q0051000100043B3Q003F000100043B3Q0051000100043B3Q003C0001002Q060008002C0001000200043B3Q002C0001001243000800133Q00205F000800080014001242000900154Q00CF00080002000100043B3Q005B000100043B3Q0023000100043B3Q005B000100043B3Q002000010004130102001E000100043B3Q0069000100043B3Q000E000100043B3Q0069000100043B3Q000B000100043B3Q006900012Q0063016Q0020315Q00164Q00023Q000400302Q00020017001800302Q00020019001A00302Q0002001B001C00302Q0002001D001E6Q000200012Q00C33Q00017Q001E3Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C6403043Q00536C616D028Q00030A3Q004765745365727669636503133Q005669727475616C496E7075744D616E61676572030C3Q0053656E644B65794576656E7403013Q0052026Q00F03F026Q00544003053Q007061697273030A3Q00476574506C617965727303073Q0052752Q6E696E6703103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503043Q007461736B03043Q0077616974027B14AE47E17A843F03103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403173Q00596F752073686F756C64206265206A6F686E20646F652E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144000593Q0012433Q00013Q002052014Q000200206Q000300206Q000400206Q000500122Q000200068Q0002000200064Q005000013Q00043B3Q005000010012423Q00073Q00267C3Q000A0001000700043B3Q000A0001001243000100013Q0020C800010001000800122Q000300096Q00010003000200202Q00010001000A4Q000300013Q00122Q0004000B6Q00055Q00122Q000600016Q00010006000100122Q0001000C3Q0012420002000D3Q0012420003000C3Q0004940001004D00010012430005000E3Q00125B000600013Q00202Q00060006000200202Q00060006000F4Q000600076Q00053Q000700044Q00460001001243000A00013Q00205F000A000A000200205F000A000A000300063F010900460001000A00043B3Q0046000100205F000A0009000400064F010A004600013Q00043B3Q0046000100205F000A000900040020F7000A000A0005001242000C00104Q0048000A000C000200064F010A004600013Q00043B3Q00460001001242000A00074Q00B2000B000B3Q000E38000700310001000A00043B3Q00310001001242000B00073Q00267C000B00340001000700043B3Q0034000100205F000C00090004002041000C000C001100122Q000D00013Q00202Q000D000D000200202Q000D000D000300202Q000D000D000400202Q000D000D001100202Q000D000D001200102Q000C0012000D00122Q000C00133Q00202Q000C000C00144Q000C0001000100044Q0046000100043B3Q0034000100043B3Q0046000100043B3Q00310001002Q06000500210001000200043B3Q00210001001243000500133Q00205F000500050014001242000600154Q00CF0005000200010004132Q01001A000100043B3Q0058000100043B3Q000A000100043B3Q005800012Q0063016Q0020315Q00164Q00023Q000400302Q00020017001800302Q00020019001A00302Q0002001B001C00302Q0002001D001E6Q000200012Q00C33Q00017Q00243Q00028Q0003023Q005F4703083Q004175746F4B692Q6C2Q0103043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C64030D3Q004D6F6E7374657276616C756573030D3Q004D6F6E73746572737461696E7303073Q005072656D69756D03043Q007461736B03043Q007761697403053Q007061697273030A3Q00476574506C617965727303073Q0052752Q6E696E6703103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D65026Q00F03F030A3Q004765745365727669636503133Q005669727475616C496E7075744D616E61676572030C3Q0053656E644B65794576656E7403013Q0046010003103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403133Q00596F75206172656E2774207072656D69756D2E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003023Q00414B2Q033Q0053657401783Q001242000100014Q00B2000200023Q00267C000100020001000100043B3Q00020001001242000200013Q00267C000200050001000100043B3Q00050001001243000300023Q00101F000300033Q001243000300023Q00205F00030003000300267C000300160001000400043B3Q00160001001243000300053Q00201401030003000600202Q00030003000700202Q00030003000800202Q00030003000900122Q0005000A6Q00030005000200062Q0003001F0001000100043B3Q001F0001001243000300053Q00205201030003000600202Q00030003000700202Q00030003000800202Q00030003000900122Q0005000B6Q00030005000200062Q0003007700013Q00043B3Q00770001001243000300023Q00205F00030003000C00267C000300620001000400043B3Q00620001001242000300013Q00267C000300240001000100043B3Q002400010012430004000D3Q00205D00040004000E4Q00040001000100122Q0004000F3Q00122Q000500053Q00202Q00050005000600202Q0005000500104Q000500066Q00043Q000600044Q00590001001243000900053Q00205F00090009000600205F00090009000700063F010800590001000900043B3Q0059000100205F0009000800080020F7000900090009001242000B00114Q00480009000B000200064F0109005900013Q00043B3Q00590001001242000900013Q00267C0009004B0001000100043B3Q004B000100205F000A0008000800205F000A000A0012001209010B00053Q00202Q000B000B000600202Q000B000B000700202Q000B000B000800202Q000B000B001200202Q000B000B001300102Q000A0013000B00122Q000A000D3Q00202Q000A000A000E4Q000A0001000100122Q000900143Q00267C0009003C0001001400043B3Q003C0001001243000A00053Q002049000A000A001500122Q000C00166Q000A000C000200202Q000A000A00174Q000C00013Q00122Q000D00186Q000E5Q00122Q000F00056Q000A000F000100044Q0059000100043B3Q003C0001002Q06000400300001000200043B3Q0030000100043B3Q005D000100043B3Q00240001001243000400023Q00205F00040004000300267C000400230001001900043B3Q0023000100043B3Q00770001001242000300013Q00267C000300630001000100043B3Q006300012Q006301045Q00203100040004001A4Q00063Q000400302Q0006001B001C00302Q0006001D001E00302Q0006001F002000302Q0006002100224Q0004000600010012D3000400233Q00202Q0004000400244Q00068Q00040006000100044Q0077000100043B3Q0063000100043B3Q0077000100043B3Q0005000100043B3Q0077000100043B3Q000200012Q00C33Q00017Q002E3Q0003023Q005F47030A3Q004175746F5265766976652Q0103043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C6403073Q0052752Q6E696E6703073Q005072656D69756D028Q0003043Q007461736B03043Q007761697403053Q00706169727303093Q00576F726B737061636503063Q00446F776E6564030B3Q004765744368696C6472656E03103Q0048756D616E6F6964522Q6F745061727403063Q0056616C75657303053Q0056616C756503063Q00434672616D6503053Q00546F72736F026Q00F03F027Q004003093Q0052696768742041726D03093Q005269676874204C6567026Q000840026Q001040030A3Q004765745365727669636503133Q005669727475616C496E7075744D616E61676572030C3Q0053656E644B65794576656E7403013Q005203083Q004C6566742041726D03083Q004C656674204C6567010003103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403133Q00596F75206172656E2774207072656D69756D2E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003023Q0041522Q033Q0053657401B13Q001205000100013Q00102Q000100023Q00122Q000100013Q00202Q00010001000200262Q000100B00001000300043B3Q00B00001001243000100043Q0020522Q010001000500202Q00010001000600202Q00010001000700202Q00010001000800122Q000300096Q00010003000200062Q000100B000013Q00043B3Q00B00001001243000100013Q00205F00010001000A00267C000100990001000300043B3Q009900010012420001000B3Q00267C000100140001000B00043B3Q001400010012430002000C3Q0020D600020002000D4Q00020001000100122Q0002000E3Q00122Q000300043Q00202Q00030003000F00202Q00030003001000202Q0003000300114Q000300046Q00023Q000400044Q0090000100205F00070006001200064F0107009000013Q00043B3Q009000010020F7000700060008001242000900134Q004800070009000200064F0107009000013Q00043B3Q0090000100205F0007000600130020F7000700070008001242000900104Q004800070009000200064F0107009000013Q00043B3Q0090000100205F00070006001300205F00070007001000205F00070007001400267C000700900001000300043B3Q009000010012420007000B4Q00B2000800083Q00267C000700360001000B00043B3Q003600010012420008000B3Q00267C0008004C0001000B00043B3Q004C000100205F00090006001200123E010A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00202Q00090006001600122Q000A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00122Q000800173Q00267C0008005F0001001800043B3Q005F000100205F00090006001900123E010A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00202Q00090006001A00122Q000A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00122Q0008001B3Q00267C0008006D0001001B00043B3Q006D000100205F000900060019001209010A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00122Q0009000C3Q00202Q00090009000D4Q00090001000100122Q0008001C3Q00267C0008007A0001001C00043B3Q007A0001001243000900043Q00204900090009001D00122Q000B001E6Q0009000B000200202Q00090009001F4Q000B00013Q00122Q000C00206Q000D5Q00122Q000E00046Q0009000E000100044Q0090000100267C000800390001001700043B3Q0039000100205F00090006002100123E010A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00202Q00090006002200122Q000A00043Q00202Q000A000A000500202Q000A000A000600202Q000A000A000700202Q000A000A001200202Q000A000A001500102Q00090015000A00122Q000800183Q00043B3Q0039000100043B3Q0090000100043B3Q00360001002Q06000200210001000200043B3Q0021000100043B3Q0094000100043B3Q00140001001243000200013Q00205F00020002000200267C000200130001002300043B3Q0013000100043B3Q00B000010012420001000B4Q00B2000200023Q00267C0001009B0001000B00043B3Q009B00010012420002000B3Q00267C0002009E0001000B00043B3Q009E00012Q006301035Q0020310003000300244Q00053Q000400302Q00050025002600302Q00050027002800302Q00050029002A00302Q0005002B002C4Q0003000500010012D30003002D3Q00202Q00030003002E4Q00058Q00030005000100044Q00B0000100043B3Q009E000100043B3Q00B0000100043B3Q009B00012Q00C33Q00017Q00023Q0003023Q005F4703063Q00486974626F7801033Q001243000100013Q00101F000100024Q00C33Q00017Q00123Q0003053Q00706169727303043Q0067616D6503073Q00506C6179657273030A3Q00476574506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572028Q00026Q00F03F03103Q0048756D616E6F6964522Q6F745061727403043Q0053697A6503073Q00566563746F72332Q033Q006E657703023Q005F4703063Q00486974626F78030A3Q0043616E436F2Q6C6964650100030C3Q005472616E73706172656E6379026Q33E33F01323Q001243000100013Q00125B000200023Q00202Q00020002000300202Q0002000200044Q000200036Q00013Q000300044Q002F0001001243000600023Q00205F00060006000300205F00060006000500063F0105002F0001000600043B3Q002F000100205F00060005000600064F0106002F00013Q00043B3Q002F0001001242000600074Q00B2000700073Q00267C000600110001000700043B3Q00110001001242000700073Q00267C000700230001000800043B3Q0023000100205F0008000500060020D100080008000900122Q0009000B3Q00202Q00090009000C00122Q000A000D3Q00202Q000A000A000E00122Q000B000D3Q00202Q000B000B000E00122Q000C000D3Q00202Q000C000C000E4Q0009000C000200101F0008000A000900043B3Q002F000100267C000700140001000700043B3Q0014000100205F00080005000600207D00080008000900302Q0008000F001000202Q00080005000600202Q00080008000900302Q00080011001200122Q000700083Q00044Q0014000100043B3Q002F000100043B3Q00110001002Q06000100070001000200043B3Q000700012Q00C33Q00017Q000A3Q00028Q00026Q00F03F03043Q0067616D65030A3Q004765745365727669636503073Q00506C6179657273027Q0040030B3Q00506C61796572412Q64656403073Q00436F2Q6E65637403053Q007061697273030A3Q00476574506C617965727300343Q0012423Q00014Q00B2000100033Q000E380001000700013Q00043B3Q00070001001242000100014Q00B2000200023Q0012423Q00023Q000E380002000200013Q00043B3Q000200012Q00B2000300033Q00267C0001001B0001000100043B3Q001B0001001242000400013Q000E38000200110001000400043B3Q00110001001242000100023Q00043B3Q001B0001000E380001000D0001000400043B3Q000D0001001243000500033Q0020E300050005000400122Q000700056Q0005000700024Q000200056Q000300033Q00122Q000400023Q00044Q000D000100267C000100220001000600043B3Q0022000100205F0004000200070020F70004000400082Q00EE000600034Q007101040006000100043B3Q0033000100267C0001000A0001000200043B3Q000A000100029500035Q001279000400093Q00202Q00050002000A4Q000500066Q00043Q000600044Q002D00012Q00EE000900034Q00EE000A00084Q00CF000900020001002Q060004002A0001000200043B3Q002A0001001242000100063Q00043B3Q000A000100043B3Q0033000100043B3Q000200012Q00C33Q00013Q00013Q00053Q00028Q00026Q00F03F03093Q00436861726163746572030E3Q00436861726163746572412Q64656403073Q00436F2Q6E656374011F3Q001242000100014Q00B2000200023Q00267C000100100001000100043B3Q00100001001242000300013Q00267C0003000B0001000100043B3Q000B00012Q00B2000200023Q00062C01023Q000100012Q00EE7Q001242000300023Q00267C000300050001000200043B3Q00050001001242000100023Q00043B3Q0010000100043B3Q0005000100267C000100020001000200043B3Q0002000100205F00033Q000300064F0103001800013Q00043B3Q001800012Q00EE000300023Q00205F00043Q00032Q00CF00030002000100205F00033Q00040020F70003000300052Q00EE000500024Q007101030005000100043B3Q001E000100043B3Q000200012Q00C33Q00013Q00013Q00183Q00028Q00027Q004003093Q0046692Q6C436F6C6F7203093Q005465616D436F6C6F7203053Q00436F6C6F72030C3Q004F75746C696E65436F6C6F7203063Q00436F6C6F723303073Q0066726F6D524742025Q00E06F40026Q00084003083Q00496E7374616E63652Q033Q006E657703093Q00486967686C69676874030A3Q0041726368697661626C652Q01026Q00F03F03103Q0046692Q6C5472616E73706172656E6379026Q00E03F03133Q004F75746C696E655472616E73706172656E637903093Q0044657074684D6F646503043Q00456E756D03123Q00486967686C6967687444657074684D6F6465030B3Q00416C776179734F6E546F7003073Q00456E61626C656401293Q001242000100014Q00B2000200023Q00267C000100100001000200043B3Q001000012Q006301035Q0020D500030003000400202Q00030003000500102Q00020003000300122Q000300073Q00202Q00030003000800122Q000400093Q00122Q000500093Q00122Q000600096Q00030006000200102Q00020006000300122Q0001000A3Q00267C0001001A0001000100043B3Q001A00010012430003000B3Q0020B500030003000C00122Q0004000D6Q00058Q0003000500024Q000200033Q00302Q0002000E000F00122Q000100103Q00267C0001001F0001000A00043B3Q001F00010030AF0002001100120030AF00020013000100043B3Q0028000100267C000100020001001000043B3Q00020001001243000300153Q0020A300030003001600202Q00030003001700102Q00020014000300302Q00020018000F00122Q000100023Q00043B3Q000200012Q00C33Q00017Q001F3Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003053Q00706169727303053Q005461736B7303073Q0043752Q72656E74030B3Q004765744368696C6472656E2Q033Q0049734103053Q004D6F64656C028Q00026Q00F03F03093Q0044657074684D6F646503043Q00456E756D03123Q00486967686C6967687444657074684D6F6465030B3Q00416C776179734F6E546F7003073Q00456E61626C65642Q01027Q0040026Q00084003133Q004F75746C696E655472616E73706172656E637903093Q0046692Q6C436F6C6F7203063Q00436F6C6F723303073Q0066726F6D524742025Q00C06240025Q00E06F4003103Q0046692Q6C5472616E73706172656E637903083Q00496E7374616E63652Q033Q006E657703093Q00486967686C69676874030A3Q0041726368697661626C65003D3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q003C00013Q00043B3Q003C00010012433Q00053Q001293000100013Q00202Q00010001000200202Q00010001000400202Q00010001000600202Q00010001000700202Q0001000100084Q000100029Q00000200044Q003A00010020F70005000400090012420007000A4Q004800050007000200064F0105003A00013Q00043B3Q003A00010012420005000B4Q00B2000600063Q00267C000500200001000C00043B3Q002000010012430007000E3Q0020A300070007000F00202Q00070007001000102Q0006000D000700302Q00060011001200122Q000500133Q00267C000500240001001400043B3Q002400010030AF00060015000B00043B3Q003A000100267C0005002F0001001300043B3Q002F0001001243000700173Q00200A01070007001800122Q0008000B3Q00122Q000900193Q00122Q000A001A6Q0007000A000200102Q00060016000700302Q0006001B000C00122Q000500143Q00267C000500180001000B00043B3Q001800010012430007001C3Q0020C100070007001D00122Q0008001E6Q000900046Q0007000900024Q000600073Q00302Q0006001F001200122Q0005000C3Q00044Q00180001002Q063Q00110001000200043B3Q001100012Q00C33Q00017Q001D3Q0003023Q005F4703083Q0054656C65706F72742Q0103073Q005072656D69756D028Q0003043Q007461736B03043Q007761697403053Q00706169727303043Q0067616D6503073Q00506C6179657273030A3Q00476574506C6179657273030B3Q004C6F63616C506C6179657203093Q00436861726163746572030E3Q0046696E6446697273744368696C6403073Q0052752Q6E696E6703103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D65010003103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403133Q00596F75206172656E2774207072656D69756D2E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003023Q0054502Q033Q0053657401633Q001205000100013Q00102Q000100023Q00122Q000100013Q00202Q00010001000200262Q000100620001000300043B3Q00620001001243000100013Q00205F00010001000400267C0001004B0001000300043B3Q004B0001001242000100054Q00B2000200023Q00267C0001000C0001000500043B3Q000C0001001242000200053Q00267C0002000F0001000500043B3Q000F0001001243000300063Q00205D0003000300074Q00030001000100122Q000300083Q00122Q000400093Q00202Q00040004000A00202Q00040004000B4Q000400056Q00033Q000500044Q00400001001243000800093Q00205F00080008000A00205F00080008000C00063F010700400001000800043B3Q0040000100205F00080007000D00064F0108004000013Q00043B3Q0040000100205F00080007000D0020F700080008000E001242000A000F4Q00480008000A000200064F0108004000013Q00043B3Q00400001001242000800054Q00B2000900093Q000E380005002B0001000800043B3Q002B0001001242000900053Q00267C0009002E0001000500043B3Q002E000100205F000A0007000D002041000A000A001000122Q000B00093Q00202Q000B000B000A00202Q000B000B000C00202Q000B000B000D00202Q000B000B001000202Q000B000B001100102Q000A0011000B00122Q000A00063Q00202Q000A000A00074Q000A0001000100044Q0040000100043B3Q002E000100043B3Q0040000100043B3Q002B0001002Q060003001B0001000200043B3Q001B000100043B3Q0046000100043B3Q000F000100043B3Q0046000100043B3Q000C0001001243000300013Q00205F00030003000200267C0003000A0001001200043B3Q000A000100043B3Q00620001001242000100054Q00B2000200023Q00267C0001004D0001000500043B3Q004D0001001242000200053Q00267C000200500001000500043B3Q005000012Q006301035Q0020310003000300134Q00053Q000400302Q00050014001500302Q00050016001700302Q00050018001900302Q0005001A001B4Q0003000500010012D30003001C3Q00202Q00030003001D4Q00058Q00030005000100044Q0062000100043B3Q0050000100043B3Q0062000100043B3Q004D00012Q00C33Q00017Q00063Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203083Q0048756D616E6F696403093Q0057616C6B53702Q656401073Q0012482Q0100013Q00202Q00010001000200202Q00010001000300202Q00010001000400202Q00010001000500102Q000100068Q00017Q00063Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203083Q0048756D616E6F696403093Q004A756D70506F77657201073Q0012482Q0100013Q00202Q00010001000200202Q00010001000300202Q00010001000400202Q00010001000500102Q000100068Q00017Q00063Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203083Q0048756D616E6F696403093Q0048697048656967687401073Q0012482Q0100013Q00202Q00010001000200202Q00010001000300202Q00010001000400202Q00010001000500102Q000100068Q00017Q00033Q0003043Q0067616D6503093Q00576F726B737061636503073Q004772617669747901043Q001243000100013Q00205F00010001000200101F000100034Q00C33Q00017Q00063Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203083Q0048756D616E6F696403063Q004865616C746801073Q0012482Q0100013Q00202Q00010001000200202Q00010001000300202Q00010001000400202Q00010001000500102Q000100068Q00017Q000A3Q0003043Q007461736B03043Q0077616974029A5Q99B93F03043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030E3Q0046696E6446697273744368696C64030D3Q004A756D7020432Q6F6C646F776E03073Q0044657374726F7900183Q0012433Q00013Q00205F5Q0002001242000100034Q00583Q0002000200064F012Q001700013Q00043B3Q001700010012433Q00043Q002052014Q000500206Q000600206Q000700206Q000800122Q000200098Q0002000200066Q00013Q00043B5Q00010012433Q00043Q00201B5Q000500206Q000600206Q000700206Q000900206Q000A6Q0002000100046Q00012Q00C33Q00017Q000A3Q0003043Q007461736B03043Q0077616974029A5Q99B93F03043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030E3Q0046696E6446697273744368696C64030B3Q0043616D6572617368616B6503073Q0044657374726F7900183Q0012433Q00013Q00205F5Q0002001242000100034Q00583Q0002000200064F012Q001700013Q00043B3Q001700010012433Q00043Q002052014Q000500206Q000600206Q000700206Q000800122Q000200098Q0002000200066Q00013Q00043B5Q00010012433Q00043Q00201B5Q000500206Q000600206Q000700206Q000900206Q000A6Q0002000100046Q00012Q00C33Q00017Q00043Q0003043Q0067616D6503093Q00576F726B737061636503053Q00547261707303073Q0044657374726F7901063Q0012A9000100013Q00202Q00010001000200202Q00010001000300202Q0001000100044Q0001000200016Q00017Q00103Q00028Q0003023Q005F4703073Q00416E74694D6F6403053Q00706169727303043Q0067616D6503073Q00506C6179657273030B3Q004765744368696C6472656E030E3Q0047657452616E6B496E47726F7570023Q0020EC8B7F41026Q000840030B3Q004C6F63616C506C6179657203043Q004B69636B032F3Q00436F6E7472696275746F72732F546573746572732F446576656C6F706572732F4F776E65722044657465637465642103043Q007461736B03043Q007761697402FCA9F1D24D62503F01313Q001242000100014Q00B2000200023Q00267C000100020001000100043B3Q00020001001242000200013Q00267C000200050001000100043B3Q00050001001243000300023Q00101F000300033Q001243000300023Q00205F00030003000300064F0103003000013Q00043B3Q00300001001242000300013Q000E380001000E0001000300043B3Q000E0001001243000400043Q00125B000500053Q00202Q00050005000600202Q0005000500074Q000500066Q00043Q000600044Q002300010020F7000900080008001242000B00094Q00480009000B0002000E27010A00230001000900043B3Q00230001001243000900053Q00206F00090009000600202Q00090009000B00202Q00090009000C00122Q000B000D6Q0009000B000100044Q00250001002Q06000400170001000200043B3Q001700010012430004000E3Q00205F00040004000F001242000500104Q00CF00040002000100043B3Q0009000100043B3Q000E000100043B3Q0009000100043B3Q0030000100043B3Q0005000100043B3Q0030000100043B3Q000200012Q00C33Q00017Q000B3Q00028Q0003023Q005F4703073Q00616E746961666B03043Q006E657874030E3Q00676574636F2Q6E656374696F6E7303043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203053Q0049646C656403073Q0044697361626C6503063Q00456E61626C65011B3Q001242000100013Q00267C000100010001000100043B3Q00010001001243000200023Q001039010200033Q00122Q000200043Q00122Q000300053Q00122Q000400063Q00202Q00040004000700202Q00040004000800202Q0004000400094Q00030002000400044Q00160001001243000700023Q00205F00070007000300064F0107001400013Q00043B3Q001400010020F700070006000A2Q00CF00070002000100043B3Q001600010020F700070006000B2Q00CF000700020001002Q060002000D0001000200043B3Q000D000100043B3Q001A000100043B3Q000100012Q00C33Q00017Q00143Q00028Q0003023Q005F4703083Q00616E74696B69636B03053Q00706169727303043Q0067616D6503073Q00436F7265477569030F3Q00526F626C6F7850726F6D7074477569030D3Q0070726F6D70744F7665726C6179030B3Q004765744368696C6472656E03043Q004E616D65030B3Q00452Q726F7250726F6D7074030A3Q0047657453657276696365030F3Q0054656C65706F72745365727669636503173Q0054656C65706F7274546F506C616365496E7374616E636503073Q00506C616365496403053Q004A6F62496403073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q007461736B03043Q007761697401363Q001242000100014Q00B2000200023Q00267C000100020001000100043B3Q00020001001242000200013Q000E38000100050001000200043B3Q00050001001243000300023Q00101F000300033Q001243000300023Q00205F00030003000300064F0103003500013Q00043B3Q00350001001242000300013Q00267C0003000E0001000100043B3Q000E0001001243000400043Q001226010500053Q00202Q00050005000600202Q00050005000700202Q00050005000800202Q0005000500094Q000500066Q00043Q000600044Q0029000100205F00090008000A00267C000900290001000B00043B3Q00290001001243000900053Q00205E00090009000C00122Q000B000D6Q0009000B000200202Q00090009000E00122Q000B00053Q00202Q000B000B000F00122Q000C00053Q00202Q000C000C001000122Q000D00053Q00202Q000D000D001100202Q000D000D00124Q0009000D0001002Q06000400190001000200043B3Q00190001001243000400133Q00205F0004000400142Q003C00040001000100043B3Q0009000100043B3Q000E000100043B3Q0009000100043B3Q0035000100043B3Q0005000100043B3Q0035000100043B3Q000200012Q00C33Q00017Q00023Q0003023Q005F4703083Q007265636F7264763201033Q001243000100013Q00101F000100024Q00C33Q00017Q00263Q0003103Q00426C61636B6C6973746564576F72647303053Q0073706C697403013Q002003023Q005F4703083Q007265636F726476322Q0103053Q00706169727303053Q006C6F77657203053Q006D6174636803093Q007265636F7264696E6703043Q002072656303063Q007265636F726403063Q00646973636F7203063Q0020646973636F03053Q00206469736303063Q007469636B657403073Q007469636B6574732Q033Q002064732Q033Q0020646303053Q0020636C697003053Q0070722Q6F6603083Q0065766964656E636503053Q00636865617403073Q006368656174657203073Q006578706C6F697403093Q006578706C6F6974657203093Q00736C6170206661726D03073Q007265706C696361028Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q004B69636B03253Q00506F2Q7369626C65205265636F726420446574656374656421204D652Q736167653A205B2003023Q00205D03043Q0077616974026Q001440026Q00F03F01B03Q0020002Q013Q000200122Q000300036Q00010003000200122Q000100013Q00122Q000100043Q00202Q00010001000500262Q000100AF0001000600043B3Q00AF0001001243000100073Q001243000200014Q00512Q010002000300043B3Q00AD00010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000A6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000B6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000C6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000D6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000E6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000F6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800106Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800116Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800126Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800136Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800146Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800156Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800166Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800176Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800186Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800196Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001A6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001B6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q00F300060002000200202Q00060006000900122Q0008001C6Q00060008000200062Q000600AD00013Q00043B3Q00AD00010012420006001D4Q00B2000700073Q00267C000600930001001D00043B3Q009300010012420007001D3Q000E38001D00A50001000700043B3Q00A500010012430008001E3Q00203700080008001F00202Q00080008002000202Q00080008002100122Q000A00226Q000B5Q00122Q000C00236Q000A000A000C4Q0008000A000100122Q000800243Q00122Q000900256Q00080002000100122Q000700263Q000E38002600960001000700043B3Q009600012Q006301086Q003C00080001000100043B3Q00AD000100043B3Q0096000100043B3Q00AD000100043B3Q00930001002Q060001000C0001000200043B3Q000C00012Q00C33Q00017Q00023Q0003073Q004368612Q74656403073Q00436F2Q6E65637401063Q00205F00013Q00010020F700010001000200062C01033Q000100012Q0063017Q00712Q01000300012Q00C33Q00013Q00013Q00263Q0003103Q00426C61636B6C6973746564576F72647303053Q0073706C697403013Q002003023Q005F4703083Q007265636F726476322Q0103053Q00706169727303053Q006C6F77657203053Q006D6174636803093Q007265636F7264696E6703043Q002072656303063Q007265636F726403063Q00646973636F7203063Q0020646973636F03053Q00206469736303063Q007469636B657403073Q007469636B6574732Q033Q002064732Q033Q0020646303053Q0020636C697003053Q0070722Q6F6603083Q0065766964656E636503053Q00636865617403073Q006368656174657203073Q006578706C6F697403093Q006578706C6F6974657203093Q00736C6170206661726D03073Q007265706C696361028Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q004B69636B03253Q00506F2Q7369626C65205265636F726420446574656374656421204D652Q736167653A205B2003023Q00205D03043Q0077616974026Q001440026Q00F03F01B03Q0020002Q013Q000200122Q000300036Q00010003000200122Q000100013Q00122Q000100043Q00202Q00010001000500262Q000100AF0001000600043B3Q00AF0001001243000100073Q001243000200014Q00512Q010002000300043B3Q00AD00010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000A6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000B6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000C6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000D6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000E6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000F6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800106Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800116Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800126Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800136Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800146Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800156Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800166Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800176Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800186Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q000800196Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001A6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001B6Q00060008000200062Q000600910001000100043B3Q009100010020F70006000500082Q00F300060002000200202Q00060006000900122Q0008001C6Q00060008000200062Q000600AD00013Q00043B3Q00AD00010012420006001D4Q00B2000700073Q000E38001D00930001000600043B3Q009300010012420007001D3Q00267C000700A50001001D00043B3Q00A500010012430008001E3Q00203700080008001F00202Q00080008002000202Q00080008002100122Q000A00226Q000B5Q00122Q000C00236Q000A000A000C4Q0008000A000100122Q000800243Q00122Q000900256Q00080002000100122Q000700263Q00267C000700960001002600043B3Q009600012Q006301086Q003C00080001000100043B3Q00AD000100043B3Q0096000100043B3Q00AD000100043B3Q00930001002Q060001000C0001000200043B3Q000C00012Q00C33Q00017Q00023Q0003023Q005F4703093Q007265636F72644D415801033Q001243000100013Q00101F000100024Q00C33Q00017Q00683Q0003103Q00426C61636B6C6973746564576F72647303053Q0073706C697403013Q002003023Q005F4703093Q007265636F72644D41582Q0103053Q00706169727303053Q006C6F77657203053Q006D6174636803093Q007265636F7264696E6703043Q002072656303063Q007265636F726403063Q00646973636F7203063Q0020646973636F03053Q00206469736303063Q007469636B657403073Q007469636B6574732Q033Q002064732Q033Q0020646303053Q0020636C697003053Q0070722Q6F6603083Q0065766964656E636503053Q00636865617403073Q006368656174657203073Q006578706C6F697403093Q006578706C6F6974657203093Q00736C6170206661726D03073Q007265706C696361030B3Q00736C6170206661726D6572030F3Q007265706C6963612063686561746572030A3Q00D187D0B8D182D0B0D0BA030A3Q00D187D0B8D182D0B5D18003083Q00D187D0B8D182D18B03103Q00D18DD0BAD181D0BFD0BBD0BED0B8D18203143Q00D18DD0BAD181D0BFD0BBD0BED0B8D182D0B5D180030E3Q00D180D0B5D0BFD0BBD0B8D0BAD0B003053Q00746F70203103083Q00D182D0BED0BF2031030C3Q00D187D0B8D182D0B0D0BAD0B803173Q00D184D0B0D180D0BC20D188D0BBD0B5D0BFD0BAD0BED0B2030A3Q00D0A7D098D0A2D095D0A003113Q00D0A2D0A3D0A220D0A7D098D0A2D095D0A003113Q00D0A2D0A3D0A220D0A7D098D0A2D090D09A03103Q00D187D0B8D182D0B5D180D0B8D189D0B503083Q00656E6761C3B1617203083Q007472616D706F736F03083Q007472616D706F736103083Q006578706C6F746172030A3Q006578706C6F7461646F7203133Q006772616E6A6120646520626F66657461646173030A3Q00656C207072696D65726F03083Q0072C3A9706C69636103083Q00726567697374726F030A3Q0067726162616369C3B36E03063Q00626F6C65746F03093Q00646973636F7264696103053Q00646573637403063Q0067726162617203023Q00647303043Q00D0B4D18103103Q00D0B4D181206C65206C65206C65206C65031A3Q00D0B4D0B8D181D0BAD0BED180D0B4206C65206C65206C65206C6503183Q00D0B4D0B8D181D0BAD0BED180206C65206C65206C65206C65030C3Q00D181D0BDD0B8D0BCD0B0D18E030C3Q00D180D0B5D0BAD0BED180D0B4030E3Q00D181D0BDD0B8D0BCD0B0D182D18C03063Q00D0B1D0B0D0BD030C3Q0070726F686962696369C3B36E2Q033Q0062616E030C3Q00D180D0B5D0BFD0BED180D18203063Q007265706F727403073Q00696E666F726D6503063Q00E9AA97E5AD9003063Q00E6ACBAE9AA9703063Q00E7A681E6ADA203063Q00E8AEB0E5BD9503063Q00E5BC80E58F9103093Q00E589A5E5898AE8808503093Q00E5A48DE588B6E5938103083Q00E9A1B6E983A8203103063Q00E9A1B6E983A803093Q00E4B88DE5928CE8B0902Q033Q00E7A5A8030B3Q00EC8381EC9C842031EC9C8403073Q00EBA7A820EC9C8403093Q00EC82ACEAB8B0EABEBC03093Q00EC868DEC9DB4EB8BA4030C3Q00EC9585EC9AA9ED9598EB8BA403093Q00EC9DB4EC9AA9EC9E9003063Q00EBB688ED99942Q033Q00ED919C030C3Q00EBA088ED948CEBA6ACECB9B403093Q00EC8AACEB9EA9ED8C9C03063Q00EAB8B0EBA19D03063Q00EB85B9EC9D8C03093Q00EBB3B4EAB3A0EC849C03043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q004B69636B03253Q00506F2Q7369626C65205265636F726420446574656374656421204D652Q736167653A205B2003023Q00205D03043Q0077616974026Q00144001A8022Q0020002Q013Q000200122Q000300036Q00010003000200122Q000100013Q00122Q000100043Q00202Q00010001000500262Q000100A70201000600043B3Q00A70201001243000100073Q001243000200014Q00512Q010002000300043B3Q00A502010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800106Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800116Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800126Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800136Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800146Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800156Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800166Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800176Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800186Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800196Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800206Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800216Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800226Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800236Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800246Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800256Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800266Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800276Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800286Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800296Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800306Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800316Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800326Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800336Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800346Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800356Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800366Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800376Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800386Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800396Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800406Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800416Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800426Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800436Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800446Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800456Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800466Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800476Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800486Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800496Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800506Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800516Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800526Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800536Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800546Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800556Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800566Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800576Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800586Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800596Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q000800576Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005A6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005B6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005C6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005D6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005F6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005E6Q00060008000200062Q000600970201000100043B3Q009702010020F70006000500082Q00F300060002000200202Q00060006000900122Q000800606Q00060008000200062Q000600A502013Q00043B3Q00A50201001243000600613Q00202301060006006200202Q00060006006300202Q00060006006400122Q000800656Q00095Q00122Q000A00666Q00080008000A4Q00060008000100122Q000600673Q00122Q000700686Q0006000200014Q00068Q000600010001002Q060001000C0001000200043B3Q000C00012Q00C33Q00017Q00023Q0003073Q004368612Q74656403073Q00436F2Q6E65637401063Q00205F00013Q00010020F700010001000200062C01033Q000100012Q0063017Q00712Q01000300012Q00C33Q00013Q00013Q00723Q0003103Q00426C61636B6C6973746564576F72647303053Q0073706C697403013Q002003023Q005F4703093Q007265636F72644D41582Q0103053Q00706169727303053Q006C6F77657203053Q006D6174636803093Q007265636F7264696E6703043Q002072656303063Q007265636F726403063Q00646973636F7203063Q0020646973636F03053Q00206469736303063Q007469636B657403073Q007469636B6574732Q033Q002064732Q033Q0020646303053Q0020636C697003053Q0070722Q6F6603083Q0065766964656E636503053Q00636865617403073Q006368656174657203073Q006578706C6F697403093Q006578706C6F6974657203093Q00736C6170206661726D03073Q007265706C696361030B3Q00736C6170206661726D6572030F3Q007265706C6963612063686561746572030A3Q00D187D0B8D182D0B0D0BA030A3Q00D187D0B8D182D0B5D18003083Q00D187D0B8D182D18B03103Q00D18DD0BAD181D0BFD0BBD0BED0B8D18203143Q00D18DD0BAD181D0BFD0BBD0BED0B8D182D0B5D180030E3Q00D180D0B5D0BFD0BBD0B8D0BAD0B003053Q00746F70203103083Q00D182D0BED0BF2031030C3Q00D187D0B8D182D0B0D0BAD0B803173Q00D184D0B0D180D0BC20D188D0BBD0B5D0BFD0BAD0BED0B2030A3Q00D0A7D098D0A2D095D0A003113Q00D0A2D0A3D0A220D0A7D098D0A2D095D0A003113Q00D0A2D0A3D0A220D0A7D098D0A2D090D09A03103Q00D187D0B8D182D0B5D180D0B8D189D0B503083Q00656E6761C3B1617203083Q007472616D706F736F03083Q007472616D706F736103083Q006578706C6F746172030A3Q006578706C6F7461646F7203133Q006772616E6A6120646520626F66657461646173030A3Q00656C207072696D65726F03083Q0072C3A9706C69636103083Q00726567697374726F030A3Q0067726162616369C3B36E03063Q00626F6C65746F03093Q00646973636F7264696103053Q00646573637403063Q0067726162617203023Q00647303043Q00D0B4D18103103Q00D0B4D181206C65206C65206C65206C65031A3Q00D0B4D0B8D181D0BAD0BED180D0B4206C65206C65206C65206C6503183Q00D0B4D0B8D181D0BAD0BED180206C65206C65206C65206C65030C3Q00D181D0BDD0B8D0BCD0B0D18E030C3Q00D180D0B5D0BAD0BED180D0B4030E3Q00D181D0BDD0B8D0BCD0B0D182D18C03063Q00D0B1D0B0D0BD030C3Q0070726F686962696369C3B36E2Q033Q0062616E030C3Q00D180D0B5D0BFD0BED180D18203063Q007265706F727403073Q00696E666F726D6503063Q00E9AA97E5AD9003063Q00E6ACBAE9AA9703063Q00E7A681E6ADA203063Q00E8AEB0E5BD9503063Q00E5BC80E58F9103093Q00E589A5E5898AE8808503093Q00E5A48DE588B6E5938103083Q00E9A1B6E983A8203103063Q00E9A1B6E983A803093Q00E4B88DE5928CE8B0902Q033Q00E7A5A8030B3Q00EC8381EC9C842031EC9C8403073Q00EBA7A820EC9C8403093Q00EC82ACEAB8B0EABEBC03093Q00EC868DEC9DB4EB8BA4030C3Q00EC9585EC9AA9ED9598EB8BA403093Q00EC9DB4EC9AA9EC9E9003063Q00EBB688ED99942Q033Q00ED919C030C3Q00EBA088ED948CEBA6ACECB9B403093Q00EC8AACEB9EA9ED8C9C03063Q00EAB8B0EBA19D03063Q00EB85B9EC9D8C03093Q00EBB3B4EAB3A0EC849C030B3Q00656E726567697374726572030E3Q00656E72656769737472656D656E74030F3Q006665726D65206465206769666C657303093Q00696E7465726469726503073Q0072612Q706F727403063Q0068617574203103043Q006861757403093Q0072C3A9706C6971756503063Q0062692Q6C657403083Q00646973636F72646503043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203043Q004B69636B03253Q00506F2Q7369626C65205265636F726420446574656374656421204D652Q736167653A205B2003023Q00205D03043Q0077616974026Q00144001EE022Q0020002Q013Q000200122Q000300036Q00010003000200122Q000100013Q00122Q000100043Q00202Q00010001000500262Q000100ED0201000600043B3Q00ED0201001243000100073Q001243000200014Q00512Q010002000300043B3Q00EB02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008000F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800106Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800116Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800126Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800136Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800146Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800156Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800166Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800176Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800186Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800196Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008001F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800206Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800216Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800226Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800236Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800246Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800256Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800266Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800276Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800286Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800296Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800306Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800316Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800326Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800336Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800346Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800356Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800366Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800376Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008002B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800386Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800396Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008003F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800406Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800416Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800426Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800436Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800446Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800456Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800466Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800476Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800486Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800496Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800506Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800516Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800526Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800536Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008004B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800546Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800556Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800566Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800576Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800586Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800596Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800576Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005A6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005B6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005C6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005D6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005F6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q0008005E6Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800606Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800616Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800626Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800636Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800646Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800656Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800666Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800676Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800686Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q005701060002000200202Q00060006000900122Q000800696Q00060008000200062Q000600DD0201000100043B3Q00DD02010020F70006000500082Q00F300060002000200202Q00060006000900122Q0008006A6Q00060008000200062Q000600EB02013Q00043B3Q00EB02010012430006006B3Q00202301060006006C00202Q00060006006D00202Q00060006006E00122Q0008006F6Q00095Q00122Q000A00706Q00080008000A4Q00060008000100122Q000600713Q00122Q000700726Q0006000200014Q00068Q000600010001002Q060001000C0001000200043B3Q000C00012Q00C33Q00017Q00093Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503093Q00576F726B737061636503053Q004C6F2Q6279030D3Q00537061776E4C6F636174696F6E000C3Q0012673Q00013Q00206Q000200206Q000300206Q000400206Q00050012482Q0100013Q00202Q00010001000700202Q00010001000800202Q00010001000900202Q00010001000600104Q000600016Q00017Q00163Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003053Q00706169727303073Q004B692Q6C657273030E3Q0047657444657363656E64616E747303043Q004E616D6503103Q0048756D616E6F6964522Q6F745061727403073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203063Q00434672616D6503103Q004D616B654E6F74696669636174696F6E03053Q00452Q726F7203073Q00436F6E74656E7403113Q004B692Q6C6572204E6F7420466F756E642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003153Q004D61746368206469646E277420737461727465642E002E3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q002500013Q00043B3Q002500010012433Q00053Q00122D2Q0100013Q00202Q00010001000200202Q00010001000600202Q0001000100074Q000100029Q00000200044Q0022000100205F00050004000800267C0005001A0001000900043B3Q001A0001001243000500013Q00208B00050005000A00202Q00050005000B00202Q00050005000C00202Q00050005000900202Q00060004000D00102Q0005000D000600044Q002200012Q006301055Q00203100050005000E4Q00073Q000400302Q00070008000F00302Q00070010001100302Q00070012001300302Q0007001400154Q000500070001002Q063Q000F0001000200043B3Q000F000100043B3Q002D00012Q0063016Q0020315Q000E4Q00023Q000400302Q00020008000F00302Q00020010001600302Q00020012001300302Q0002001400156Q000200012Q00C33Q00017Q00143Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D65030C3Q004B692Q6C6572737061776E7303053Q00537061776E03103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q001440001D3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q001400013Q00043B3Q001400010012433Q00013Q002031014Q000500206Q000600206Q000700206Q000800122Q000100013Q00202Q00010001000200202Q00010001000400202Q00010001000A00202Q00010001000B00202Q00010001000900104Q0009000100044Q001C00012Q0063016Q0020315Q000C4Q00023Q000400302Q0002000D000E00302Q0002000F001000302Q00020011001200302Q0002001300146Q000200012Q00C33Q00017Q00143Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D65030E3Q005375727669766F72737061776E7303053Q00537061776E03103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q004D61746368206469646E277420737461727465642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q001440001D3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q001400013Q00043B3Q001400010012433Q00013Q002031014Q000500206Q000600206Q000700206Q000800122Q000100013Q00202Q00010001000200202Q00010001000400202Q00010001000A00202Q00010001000B00202Q00010001000900104Q0009000100044Q001C00012Q0063016Q0020315Q000C4Q00023Q000400302Q0002000D000E00302Q0002000F001000302Q00020011001200302Q0002001300146Q000200012Q00C33Q00017Q00183Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003053Q00706169727303053Q005461736B7303073Q0043752Q72656E74030B3Q004765744368696C6472656E03063Q00486974626F7803073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E74030F3Q004E6F205461736B7320466F756E642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003153Q004D61746368206469646E277420737461727465642E00333Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q002A00013Q00043B3Q002A00010012433Q00053Q001293000100013Q00202Q00010001000200202Q00010001000400202Q00010001000600202Q00010001000700202Q0001000100084Q000100029Q00000200044Q002700010020F7000500040003001242000700094Q004800050007000200064F0105001F00013Q00043B3Q001F0001001243000500013Q00201101050005000A00202Q00050005000B00202Q00050005000C00202Q00050005000D00202Q00060004000900202Q00060006000E00102Q0005000E000600044Q002700012Q006301055Q00203100050005000F4Q00073Q000400302Q00070010001100302Q00070012001300302Q00070014001500302Q0007001600174Q000500070001002Q063Q00110001000200043B3Q0011000100043B3Q003200012Q0063016Q0020315Q000F4Q00023Q000400302Q00020010001100302Q00020012001800302Q00020014001500302Q0002001600176Q000200012Q00C33Q00017Q00183Q0003043Q0067616D6503093Q00576F726B7370616365030E3Q0046696E6446697273744368696C642Q033Q004D617003053Q00706169727303053Q004578697473030E3Q0047657444657363656E64616E747303093Q00436C612Q734E616D6503043Q005061727403073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203103Q0048756D616E6F6964522Q6F745061727403063Q00434672616D6503103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E74030F3Q004E6F20457869747320466F756E642E03053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003153Q004D61746368206469646E277420737461727465642E002E3Q0012913Q00013Q00206Q000200206Q000300122Q000200048Q0002000200064Q002500013Q00043B3Q002500010012433Q00053Q00122D2Q0100013Q00202Q00010001000200202Q00010001000600202Q0001000100074Q000100029Q00000200044Q0022000100205F00050004000800267C0005001A0001000900043B3Q001A0001001243000500013Q00208B00050005000A00202Q00050005000B00202Q00050005000C00202Q00050005000D00202Q00060004000E00102Q0005000E000600044Q002200012Q006301055Q00203100050005000F4Q00073Q000400302Q00070010001100302Q00070012001300302Q00070014001500302Q0007001600174Q000500070001002Q063Q000F0001000200043B3Q000F000100043B3Q002D00012Q0063016Q0020315Q000F4Q00023Q000400302Q00020010001100302Q00020012001800302Q00020014001500302Q0002001600176Q000200012Q00C33Q00017Q00163Q0003043Q0067616D65030A3Q004765745365727669636503123Q004D61726B6574706C6163655365727669636503153Q00557365724F776E7347616D6550612Q734173796E6303073Q00506C6179657273030B3Q004C6F63616C506C6179657203063Q00557365724964022Q00801D4BB4CE4103103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403153Q0041726C65616479204F776E2047616D6570612Q732103053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q001440028Q00030C3Q00736574636C6970626F61726403083Q00746F737472696E67032B3Q00682Q7470733A2Q2F3Q772E726F626C6F782E636F6D2F67616D652D70612Q732F3130333032363433373903153Q00436F706965642047616D6570612Q73204C696E6B2100293Q0012DB3Q00013Q00206Q000200122Q000200038Q0002000200206Q000400122Q000200013Q00202Q00020002000500202Q00020002000600202Q00020002000700122Q000300088Q0003000200064Q001600013Q00043B3Q001600012Q0063016Q0020315Q00094Q00023Q000400302Q0002000A000B00302Q0002000C000D00302Q0002000E000F00302Q0002001000116Q0002000100043B3Q002800010012423Q00123Q00267C3Q00170001001200043B3Q00170001001243000100133Q001224010200143Q00122Q000300156Q000200036Q00013Q00014Q00015Q00202Q0001000100094Q00033Q000400302Q0003000A000B00302Q0003000C001600302Q0003000E000F00302Q0003001000114Q00010003000100044Q0028000100043B3Q001700012Q00C33Q00017Q000D3Q0003023Q005F4703073Q005072656D69756D2Q0103103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403143Q00596F75206172652077686974656C69737465642103053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144003173Q00596F75206172656E27742077686974656C69737465642100163Q0012433Q00013Q00205F5Q000200267C3Q000D0001000300043B3Q000D00012Q0063016Q0020315Q00044Q00023Q000400302Q00020005000600302Q00020007000800302Q00020009000A00302Q0002000B000C6Q0002000100043B3Q001500012Q0063016Q0020315Q00044Q00023Q000400302Q00020005000600302Q00020007000D00302Q00020009000A00302Q0002000B000C6Q000200012Q00C33Q00017Q00073Q0003043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q0043686172616374657203083Q0048756D616E6F696403063Q004865616C7468029Q00073Q0012AE3Q00013Q00206Q000200206Q000300206Q000400206Q000500304Q000600076Q00017Q000A3Q0003043Q007461736B03043Q0077616974029A5Q99B93F03043Q0067616D6503073Q00506C6179657273030B3Q004C6F63616C506C6179657203093Q00506C61796572477569030E3Q0046696E6446697273744368696C64030E3Q0052657365745F64697361626C657203073Q0044657374726F7900183Q0012433Q00013Q00205F5Q0002001242000100034Q00583Q0002000200064F012Q001700013Q00043B3Q001700010012433Q00043Q002052014Q000500206Q000600206Q000700206Q000800122Q000200098Q0002000200066Q00013Q00043B5Q00010012433Q00043Q00201B5Q000500206Q000600206Q000700206Q000900206Q000A6Q0002000100046Q00012Q00C33Q00017Q00013Q0003073Q0044657374726F7900044Q0063016Q0020F75Q00012Q00CF3Q000200012Q00C33Q00017Q00043Q00030A3Q006C6F6164737472696E6703043Q0067616D6503073Q00482Q747047657403363Q00682Q7470733A2Q2F63646E2E7765617265646576732E6E65742F736372697074732F496E66696E6974652532305969656C642E74787400083Q0012703Q00013Q00122Q000100023Q00202Q00010001000300122Q000300046Q000100039Q0000026Q000100016Q00017Q00093Q0003103Q004D616B654E6F74696669636174696F6E03043Q004E616D6503053Q00452Q726F7203073Q00436F6E74656E7403353Q004578656375746520496E66696E697479205969656C6420616E64204578656375746520436F2Q6D616E64202Q2766697863616D2Q2703053Q00496D61676503173Q00726278612Q73657469643A2Q2F2Q34382Q3334352Q393803043Q0054696D65026Q00144000094Q0063016Q0020315Q00014Q00023Q000400302Q00020002000300302Q00020004000500302Q00020006000700302Q0002000800096Q000200012Q00C33Q00017Q00", GetFEnv(), ...);
