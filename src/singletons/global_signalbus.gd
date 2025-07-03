extends Node

# resource_manager
signal SampleAdded(s: SampleResource)
signal ColorAdded(c: Color)

# ui
signal SampleSelected(i: int)
signal ColorSelected(i: int)
## previews
signal RemoveSample(i: int)
signal RemoveColor(i: int)
## tools
signal ToolSelected(i: int)
