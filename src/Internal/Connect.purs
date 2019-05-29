module Radox.React.Internal.Connect where
  
import React as React
import Radox (CombinedReducer, emptyStore)

import Radox.React.Internal.Types
import Radox.React.Internal.Provider (radoxProvider)
import Radox.React.Internal.Consumer (radoxConsumer)

-- | Takes a CombinedReducer and a default state, and returns both a root-level
-- | provider and connect component for using the Radox store
createRadoxContext
  :: forall action state
   . CombinedReducer action state
  -> state
  -> ReactRadoxContext action state
createRadoxContext reducer initialState =
  let myContext = React.createContext (emptyStore initialState)
  in  { provider : radoxProvider myContext reducer initialState
      , consumer : radoxConsumer myContext
      }
