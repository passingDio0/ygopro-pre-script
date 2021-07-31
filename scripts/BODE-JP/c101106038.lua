--赫灼竜マスカレイド
--
--Script by 222DIY
function c101106038.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x164),c101106038.matfilter,true)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c101106038.costcon)
	e1:SetCost(c101106038.costchk)
	e1:SetOperation(c101106038.costop)
	c:RegisterEffect(e1)
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+101106038)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101106038,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,101106038)
	e3:SetCondition(c101106038.spcon)
	e3:SetTarget(c101106038.sptg)
	e3:SetOperation(c101106038.spop)
	c:RegisterEffect(e3)
end
function c101106038.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c101106038.costcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101106038.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,101106038)
	return Duel.CheckLPCost(tp,ct*600)
end
function c101106038.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end
function c101106038.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c101106038.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101106038.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c101106038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101106038.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
