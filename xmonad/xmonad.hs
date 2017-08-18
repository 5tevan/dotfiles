import XMonad
import System.Exit

import XMonad.Actions.Submap
import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiColumns
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window
import XMonad.Prompt.Workspace
import XMonad.Prompt.Input
import XMonad.Actions.DynamicWorkspaces
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows

import XMonad.Layout.Spiral
import XMonad.Util.Scratchpad

import Graphics.X11.Xlib
import Graphics.X11.Xinerama

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Data.List
import Data.Function

-- Available Layouts
layout = tiled ||| Mirror tiled ||| Full ||| multiCol [1] 1 delta (1/3)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    
    -- The default number of windows in the master pane
    nmaster = 1
    
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100
       
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return)       , spawn $ XMonad.terminal conf)
    , ((modMask,               xK_c)            , spawn $ XMonad.terminal conf)

    , ((modMask,               xK_p     )       , spawn "dmenu_with_clock_run")
    , ((modMask,               xK_bracketright) , spawn "amixer -D pulse sset Master 5%+")
    , ((modMask,               xK_bracketleft)  , spawn "amixer -D pulse sset Master 5%-")
    , ((modMask .|. shiftMask, xK_l)            , spawn "slock")

    -- close focused window
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    , ((modMask              , xK_b     ), sendMessage ToggleStruts)

    -- Restart xmonad
    , ((modMask              , xK_q     ),
       broadcastMessage ReleaseResources >> restart "xmonad" True)

    -- Quit
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((modMask .|. mask, key), f sc)
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]]

main = do
     xmonad $ defaultConfig
       { modMask = mod4Mask -- Use Super instead of Alt
       , borderWidth = 0
       , normalBorderColor = "#000000"
       -- , focusedBorderColor = "#2E9AFE"
       , focusedBorderColor = "#000000"
       , terminal = "terminal"
       , keys = myKeys
       , layoutHook = layout
       , logHook = fadeWindowsLogHook (composeAll [transparency 0.05
                                                  , isUnfocused --> transparency 0.1
                                                  ])
       , handleEventHook = fadeWindowsEventHook
       }
