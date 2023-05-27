def decide_id():
    """used for interchangable scripts between sway and i3"""
    """not using anywhere"""
    from os import environ

    if "DISPLAY" in environ:
        return "class"

    if "WAYLAND_DISPLAY" in environ:
        return "app_id"
