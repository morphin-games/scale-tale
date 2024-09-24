@icon("icontrol_context.svg")
class_name ControlContext
## Base class for all Contexts related to controls.
## A ControlContext acts as a communication layer between a [Pawn] and a [Controller].
## Both [Pawn] and [Controller] must read and write in their assigned context to interact with each other.
## Extend this class to create a new context, and add @export variables to communicate between a [Controller] and [Pawn].
extends Resource
