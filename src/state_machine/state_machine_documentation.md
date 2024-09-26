Classes StateMachine and State are just base classes to extend and create more specielized state machines.

StateMachine classes beginning with "PP" such as PPStateMachine or PPState are PlatformerPawn state machine classes.
These classes are specialized on Platformer Pawn movement.

## PPStateMachine (extends StateMachine)
A PPStateMachine holds PPStates and PPConstantActions.

Each PPStateMachine has a reference to its PlatformerPawn, which must be its direct parent:

**Scene tree**
> PlatformerPawn
>> PPStateMachine

A PPStateMachine can hold as many PPStates as needed.
These PPStates must be in order, of priority:
[
	PPStateIdle
	PPStateMove
	PPStateJump
]

In case of condition collision, the PPState with most priority is taken.

## PPState (extends State)
A PPState is an specialized State made for PPStateMachine.

A PPState not only holds the condition to enter said state, but also an Array of PPStateActions that can be used while the PPState is active.

As each PPState has its own array of PPStateActions, each PlatformerPawn that has a PPStateMachine can determine the actions of its Pawn, making it extremely modulable.

Each PPState must override the following functions to add their own functionality:
```gdscript
# The condition to enter the state.
func enter_condition() -> bool:
	return [condition as bool]

# Code to run when entering the state.
func enter() -> void:
	pass
	
# Code to run when exiting the state.
func exit() -> void:
	pass
	
# Code to run each frame when the state is active.
func process(delta : float) -> void:
	pass
```

## PPStateAction
A PPStateAction is a Resource that holds logic about an action that can be triggered while in a PPState.

For example, a player may look like this:
	
**Scene tree**
> PlatformerPawn
>> PPStateMachine
>>> PPStateIdle
>>>> PPStateActionJump
>>>> PPStateActionMove

>>> PPStateMoving
>>>> PPStateActionJump
>>>> PPStateActionMove

>>> PPStateJumping
>>>> PPStateActionMove

This would make the player able to jump while moving or being idle, but not while jumping.

An enemy pawn could look like this:
	
**Scene tree**
> PlatformerPawn
>> PPStateMachine
>>> PPStateIdle
>>>> PPStateActionMove

>>> PPStateMoving
>>>> PPStateActionMove

This would make the enemy pawn only able to move.

Each PPActionState must override the following functions to add their own logic:
```gdscript
# The code inside ready() launches when the PPStateAction is loaded into the PPState.
func ready() -> void:
	# Add 'if(!platformer_pawn_state.active): return' to your logic.
	# This will prevent your Action from firing when its PPState is inactive.
	pass

# This runs every frame.
func process(delta : float) -> void:
	# Add 'if(!platformer_pawn_state.active): return' to your logic.
	# This will prevent your Action from firing when its PPState is inactive.
	pass
```

## PPConstantAction
Equal to PPStateAction, but instead of being inside a PPState, they are inside the PPStateMachine.

These actions will always run, completely independent of the PPStateMachine current state.

Each PPConstantAction must override the following functions to add their own logic:
```gdscript
# The code inside ready() launches when the PPStateAction is loaded into the PPState.
func ready() -> void:
	pass

# This runs every frame.
func process(delta : float) -> void:
	pass
```
