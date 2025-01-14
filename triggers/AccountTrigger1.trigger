trigger AccountTrigger1 on Account (before insert) {
	AccountTriggerHandler.updateRating(Trigger.New);
}