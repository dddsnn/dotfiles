import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout

main = do
    xmonad $ def {
        startupHook = setWMName "LG3D",
        terminal = "urxvt",
        layoutHook = noBorders Full ||| Tall 1 0.05 0.5
    }
