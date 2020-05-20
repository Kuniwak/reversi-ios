s/(dispatchQueue(Main)?[?!])16/\1GameModelPlaceWorkItem/
s/(dispatchQueue(Main)?[?!])15/\1GameModelPassWorkItem/
s/(dispatchQueue(Main)?[?!])14/\1GameModelResetWorkItem/
s/(dispatchQueue(Main)?[?!])13/\1GameModelStateWorkItem1/
s/(dispatchQueue(Main)?[?!])12/\1GameModelStateWorkItem2/
s/(dispatchQueue(Main)?[?!])11/\1AutoBkupGameModelPlaceWorkItem/
s/(dispatchQueue(Main)?[?!])10/\1AutoBkupGameModelPassWorkItem/
s/(dispatchQueue(Main)?[?!])9/\1AutoBkupGameModelResetWorkItem/
s/(dispatchQueue(Main)?[?!])8/\1AutoBkupGameModelStateWorkItem/
s/(dispatchQueue(Main)?[?!])7/\1UserDefaultsModelStoreWorkItem/
s/(dispatchQueue(Main)?[?!])6/\1AnimatedGameModelPlaceWorkItem/
s/(dispatchQueue(Main)?[?!])5/\1AnimatedGameModelPassWorkItem/
s/(dispatchQueue(Main)?[?!])4/\1AnimatedGameModelResetWorkItem/
s/(dispatchQueue(Main)?[?!])3/\1AnimatedGameModeMarkAnimationAsCompleted/
s/(dispatchQueue(Main)?[?!])2/\1AnimatedGameModelStateWorkItem/
s/(dispatchQueue(Main)?[?!])1/\1BoardAnimationStateWorkItem/
s/(gameModelState( = |==))3/\1GameModelMustPass/
s/(gameModelState( = |==))2/\1GameModelMustPlace/
s/(gameModelState( = |==))1/\1GameModelCompleted/
s/(autoBkupGameModelState( = |==))3/\1AutoBkupGameModelMustPass/
s/(autoBkupGameModelState( = |==))2/\1AutoBkupGameModelMustPlace/
s/(autoBkupGameModelState( = |==))1/\1AutoBkupGameModelCompleted/
s/(animatedGameModelState( = |==))6/\1AnimatedGameModelMustPassNotAnimating/
s/(animatedGameModelState( = |==))5/\1AnimatedGameModelMustPlaceNotAnimating/
s/(animatedGameModelState( = |==))4/\1AnimatedGameModelCompletedNotAnimating/
s/(animatedGameModelState( = |==))3/\1AnimatedGameModelMustPassAnimating/
s/(animatedGameModelState( = |==))2/\1AnimatedGameModelMustPlaceAnimating/
s/(animatedGameModelState( = |==))1/\1AnimatedGameModelCompletedAnimating/
s/(boardAnimationState( = |==))3/\1BoardAnimationNotAnimating/
s/(boardAnimationState( = |==))2/\1BoardAnimationPlacing/
s/(boardAnimationState( = |==))1/\1BoardAnimationFlipping/
