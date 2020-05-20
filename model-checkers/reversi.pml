// NOTE: This model is based on the following 2 hypotheses:
//
//       NO DIVERGENCE HYPOTHESIS:
//       A process implemented on a serial DispatchQueue has two work-item sources; the process itself and other processes.
//       This hypothesis claims all sound models have an upper bound for a number of the work-items in the DispatchQueue if
//       the number of work-items from other processes is finite. If no upper bounds on a model, the model will produce infinite
//       work items, it must be a bug. At this point, there is a problem that a model that enqueues work-items for each
//       timer ticks may diverge. But if and only if all of the work items from timer ticks finish before starting
//       the next work item, it don't diverge. Otherwise will diverge.
//
//       SMALL SCOPE HYPOTHESIS:
//       A high proportion of bugs can be found by testing a program for all test inputs within some small scope[^1].
//
// [^1]: https://pdfs.semanticscholar.org/0c6d/97fbc3c753f59e7fb723725639f1b18706bb.pdf

mtype:Dest = {
	GameModelPlaceWorkItem,
	GameModelPassWorkItem,
	GameModelResetWorkItem,
	GameModelStateWorkItem1,
	GameModelStateWorkItem2,
	AutoBkupGameModelPlaceWorkItem,
	AutoBkupGameModelPassWorkItem,
	AutoBkupGameModelResetWorkItem,
	AutoBkupGameModelStateWorkItem,
	UserDefaultsModelStoreWorkItem,
	AnimatedGameModelPlaceWorkItem,
	AnimatedGameModelPassWorkItem,
	AnimatedGameModelResetWorkItem,
	AnimatedGameModeMarkAnimationAsCompleted,
	AnimatedGameModelStateWorkItem,
	BoardAnimationStateWorkItem,
}
mtype:GameModelState = {
	GameModelMustPass,
	GameModelMustPlace,
	GameModelCompleted,
}
mtype:AutoBkupGameModelState = {
	AutoBkupGameModelMustPass,
	AutoBkupGameModelMustPlace,
	AutoBkupGameModelCompleted,
}
mtype:AnimatedGameModelState = {
	AnimatedGameModelMustPassNotAnimating,
	AnimatedGameModelMustPlaceNotAnimating,
	AnimatedGameModelCompletedNotAnimating,
	AnimatedGameModelMustPassAnimating,
	AnimatedGameModelMustPlaceAnimating,
	AnimatedGameModelCompletedAnimating,
}
mtype:BoardAnimationState = {
	BoardAnimationNotAnimating,
	BoardAnimationPlacing,
	BoardAnimationFlipping,
}

// NOTE: It must be larger than the upper bound of the number of work-items will be enqueued.
#define CAP_dispatchQueue 10
chan dispatchQueue = [CAP_dispatchQueue] of { mtype:Dest }
chan dispatchQueueMain = [CAP_dispatchQueue] of { mtype:Dest }

// NOTE: It must be finite.
#define MAX_USER_INTERACTION 5


inline enqueueWorkItems1(queue, a) {
	queue!a
}


inline enqueueWorkItems2(queue, a, b) {
	if
	:: queue!a
		queue!b
	:: queue!b
		queue!a
	fi
}



inline map_GameModelState_to_AutoBkupGameModelState(gameModelState, autoBkupGameModelState) {
	if
	:: gameModelState == GameModelMustPass ->
		autoBkupGameModelState = AutoBkupGameModelMustPass
	:: gameModelState == GameModelMustPlace ->
		autoBkupGameModelState = AutoBkupGameModelMustPlace
	:: gameModelState == GameModelCompleted ->
		autoBkupGameModelState = AutoBkupGameModelCompleted
	fi
}


inline animatedGameModelState_from(autoBkupGameModelState, boardAnimationState, animatedGameModelState) {
	if
	:: boardAnimationState == BoardAnimationNotAnimating ->
		if
		:: autoBkupGameModelState == AutoBkupGameModelMustPass -> animatedGameModelState = AnimatedGameModelMustPassNotAnimating
		:: autoBkupGameModelState == AutoBkupGameModelMustPlace -> animatedGameModelState = AnimatedGameModelMustPlaceNotAnimating
		:: autoBkupGameModelState == AutoBkupGameModelCompleted -> animatedGameModelState = AnimatedGameModelCompletedNotAnimating
		fi
	:: boardAnimationState == BoardAnimationPlacing || boardAnimationState == BoardAnimationFlipping ->
		if
		:: autoBkupGameModelState == AutoBkupGameModelMustPass -> animatedGameModelState = AnimatedGameModelMustPassAnimating
		:: autoBkupGameModelState == AutoBkupGameModelMustPlace -> animatedGameModelState = AnimatedGameModelMustPlaceAnimating
		:: autoBkupGameModelState == AutoBkupGameModelCompleted -> animatedGameModelState = AnimatedGameModelCompletedAnimating
		fi
	fi
}


mtype:GameModelState gameModelState = GameModelMustPlace
mtype:AutoBkupGameModelState autoBkupGameModelState
mtype:BoardAnimationState boardAnimationState = BoardAnimationNotAnimating
mtype:AnimatedGameModelState animatedGameModelState


active proctype DispatchQueueLoop() {
	map_GameModelState_to_AutoBkupGameModelState(gameModelState, autoBkupGameModelState)
	animatedGameModelState_from(autoBkupGameModelState, boardAnimationState, animatedGameModelState)

	end: do
	:: dispatchQueue?GameModelPlaceWorkItem ->
		if
		:: gameModelState == GameModelCompleted -> skip
		:: gameModelState == GameModelMustPass -> skip
		:: gameModelState == GameModelMustPlace ->
			if
			:: gameModelState = GameModelMustPass
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: gameModelState = GameModelMustPlace
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: gameModelState = GameModelCompleted
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: else -> skip
			fi
		fi

	:: dispatchQueue?GameModelPassWorkItem ->
		if
		:: gameModelState == GameModelCompleted -> skip
		:: gameModelState == GameModelMustPass ->
			if
			:: gameModelState = GameModelMustPlace
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: gameModelState = GameModelCompleted
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: gameModelState = GameModelCompleted
				enqueueWorkItems2(dispatchQueue, GameModelStateWorkItem1, GameModelStateWorkItem2)
			:: else -> skip
			fi
		:: gameModelState == GameModelMustPlace -> skip
		fi

	:: dispatchQueue?GameModelResetWorkItem ->
		gameModelState = GameModelMustPlace
		enqueueWorkItems1(dispatchQueue, GameModelStateWorkItem1)

	:: dispatchQueue?AutoBkupGameModelPlaceWorkItem ->
		enqueueWorkItems1(dispatchQueue, GameModelPlaceWorkItem)

	:: dispatchQueue?AutoBkupGameModelPassWorkItem ->
		enqueueWorkItems1(dispatchQueue, GameModelPassWorkItem)

	:: dispatchQueue?AutoBkupGameModelResetWorkItem ->
		enqueueWorkItems1(dispatchQueue, GameModelResetWorkItem)
	
	:: dispatchQueue?GameModelStateWorkItem1 ->
		map_GameModelState_to_AutoBkupGameModelState(gameModelState, autoBkupGameModelState)
		enqueueWorkItems1(dispatchQueueMain, AutoBkupGameModelStateWorkItem)

	:: dispatchQueue?GameModelStateWorkItem2 ->
		enqueueWorkItems1(dispatchQueue, UserDefaultsModelStoreWorkItem)

	:: dispatchQueue?UserDefaultsModelStoreWorkItem ->
		// NOTE: No one observe the state change of UserDefaultsModel.
		skip

	:: dispatchQueue?AutoBkupGameModelStateWorkItem ->
		if
		:: boardAnimationState = BoardAnimationPlacing
			enqueueWorkItems1(dispatchQueue, BoardAnimationStateWorkItem)
		:: else ->
			// NOTE: It represents the last accepted game command is pass.
			skip
		fi

	:: dispatchQueue?AnimatedGameModelPlaceWorkItem ->
		enqueueWorkItems1(dispatchQueue, AutoBkupGameModelPlaceWorkItem)

	:: dispatchQueue?AnimatedGameModelPassWorkItem ->
		enqueueWorkItems1(dispatchQueue, AutoBkupGameModelPassWorkItem)

	:: dispatchQueue?AnimatedGameModelResetWorkItem ->
		enqueueWorkItems1(dispatchQueue, AutoBkupGameModelResetWorkItem)

	:: dispatchQueue?AnimatedGameModeMarkAnimationAsCompleted ->
		if
		:: boardAnimationState == BoardAnimationNotAnimating -> skip
		:: boardAnimationState == BoardAnimationPlacing ->
			boardAnimationState = BoardAnimationFlipping
			enqueueWorkItems1(dispatchQueue, BoardAnimationStateWorkItem)
		:: boardAnimationState == BoardAnimationFlipping ->
			if
			:: boardAnimationState = BoardAnimationFlipping
				enqueueWorkItems1(dispatchQueue, BoardAnimationStateWorkItem)
			:: boardAnimationState = BoardAnimationNotAnimating
				enqueueWorkItems1(dispatchQueue, BoardAnimationStateWorkItem)
			fi
		fi

	:: dispatchQueue?BoardAnimationStateWorkItem ->
		animatedGameModelState_from(autoBkupGameModelState, boardAnimationState, animatedGameModelState)
		enqueueWorkItems1(dispatchQueue, AnimatedGameModelStateWorkItem)
	od
}



active proctype DispatchQueueMainLoop() {
	mtype:Dest dest
	// NOTE: This is to assume No divergence hypothesis.
	int remainedUserInteraction = MAX_USER_INTERACTION
	
	end: do
	:: remainedUserInteraction > 0 ->
		enqueueWorkItems1(dispatchQueue, AnimatedGameModelPlaceWorkItem)
		remainedUserInteraction--
	:: remainedUserInteraction > 0 ->
		enqueueWorkItems1(dispatchQueue, AnimatedGameModelPassWorkItem)
		remainedUserInteraction--
	:: remainedUserInteraction > 0 ->
		enqueueWorkItems1(dispatchQueue, AnimatedGameModelResetWorkItem)
		remainedUserInteraction--
	:: remainedUserInteraction > 0 ->
		enqueueWorkItems1(dispatchQueue, AnimatedGameModeMarkAnimationAsCompleted)
		remainedUserInteraction--
	:: dispatchQueueMain?dest ->
		skip
	od
}
