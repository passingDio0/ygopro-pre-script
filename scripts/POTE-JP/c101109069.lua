--フェイバリット・コンタクト
--Script by JSY1728
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	c:RegisterEffect(e1)
end
function s.fsfilter1(c,e)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function s.fsfilter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x8)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf,true)
end
function s.fscheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x8)
end
function s.fscfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(s.fsfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		return Duel.IsExistingMatchingCard(s.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.dfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function s.exfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsCode(89943723)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.fsfilter1),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg=Duel.GetMatchingGroup(s.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=tc.hero_fusion_check or s.fscheck
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		local cf=mat:Filter(s.fscfilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		if #mat>0 and Duel.SendtoDeck(mat,nil,SEQ_DECKTOP,REASON_EFFECT)>0 then
			local p=tp
			for i=1,2 do
				local dg=mat:Filter(s.dfilter,nil,p)
				if #dg>1 then
					Duel.SortDecktop(tp,p,#dg)
				end
				for i=1,#dg do
					local mg=Duel.GetDecktopGroup(p,1)
					Duel.MoveSequence(mg:GetFirst(),1)
				end
				p=1-tp
			end
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		if mat:IsExists(s.exfilter,1,nil) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TO_DECK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end