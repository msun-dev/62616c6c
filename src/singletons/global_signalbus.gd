extends Node

# resource_manager
signal SampleAdded(s: SampleResource, i: int)
signal ColorAdded(c: Color, i: int)

# ui
signal PreviewSelected(n: PreviewBoxSample)
## previews
signal RemoveSample(i: int)
signal RemoveColor(i: int)
## tools
signal ToolSelected(i: int)
