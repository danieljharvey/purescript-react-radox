module Radox.React.Internal.Consumer where
  
import Prelude (bind, pure, ($))
import Effect (Effect)
import React as React
import Radox (RadoxStore)

import Radox.React.Internal.Types

-- | Internal function that creates a Purescript React class which allows
-- | consumption of the Radox store via React Context
radoxConsumer
  :: forall props localState action state
   . React.Context (RadoxStore action state)
  -> React.ReactThis props localState
  -> ReactRadoxRenderMethod props state localState action
  -> Effect React.ReactElement
radoxConsumer context this renderer = do
  props <- React.getProps this
  localState <- React.getState this
  let render { state, dispatch } 
        = renderer { props: props
                   , state: state
                   , localState: localState
                   , dispatch: dispatch
                   } 
  pure $ React.createLeafElement context.consumer
          { children: render }
