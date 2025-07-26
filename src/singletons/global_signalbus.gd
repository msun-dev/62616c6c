extends Node

# resource_manager
signal SampleAdded(s: SampleResource, i: int)
signal ColorAdded(c: Color, i: int)
signal ResourceRemoved(t: int, i: int)

# ui
#signal PreviewSelected(n: PreviewBox)
## previews
signal RemoveSample(i: int)
signal RemoveColor(i: int)
## tools
signal ToolSelected(i: int)
