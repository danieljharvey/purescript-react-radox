module Radox.React.Internal.Types where
  
import Prelude (Unit)
import Effect (Effect)
import React as React

type ReactRadoxContext action state
  = { provider :: React.ReactClass { children :: Array React.ReactElement }
    , consumer :: (forall props localState
                . React.ReactThis props localState
               -> ReactRadoxRenderMethod props state localState action
               -> Effect React.ReactElement)
    }

type ReactRadoxRenderMethod props state localState action 
  = (
      { props :: props
      , localState :: localState
      , state :: state
      , dispatch :: (action -> Effect Unit)
      , getState :: Effect state
      } -> React.ReactElement
    ) 


