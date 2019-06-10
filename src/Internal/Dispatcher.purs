module Radox.React.Internal.Dispatcher (DispatcherEvent(..), DispatcherProps,
  doDispatcher) where

import Prelude
import Effect (Effect)
import React as React

-- | bit odd this - accessing context (in our case, the dispatch function from
-- | Radox) is not a thing you can comfortably do in React. Therefore, to fire a
-- | dispatch method from componentDidMount we use this component that renders
-- | nothing but fires whatever you like on first mount.

data DispatcherEvent 
  = OnComponentDidMount (Effect Unit)
  | OnComponentDidCatch (Effect Unit)
  | OnComponentDidUpdate (Effect Unit)
  | OnComponentWillUnmount (Effect Unit)

type DispatcherProps
  = { action   :: DispatcherEvent
    }

dispatcher :: React.ReactClass DispatcherProps
dispatcher = React.component "dispatcher" component
  where
    component this = do
       pure $ { state: { }
              , componentDidMount: do
                  props <- React.getProps this
                  case props.action of
                       OnComponentDidMount a -> a
                       _                     -> pure unit
              , componentDidCatch: \_ _ -> do
                  props <- React.getProps this
                  case props.action of
                       OnComponentDidCatch a -> a
                       _                     -> pure unit
              , componentDidUpdate: \_ _ _ -> do
                  props <- React.getProps this
                  case props.action of
                       OnComponentDidUpdate a -> a
                       _                      -> pure unit
              , componentWillUnmount: do
                  props <- React.getProps this
                  case props.action of
                       OnComponentWillUnmount a -> a
                       _                        -> pure unit

              , render: pure mempty
              }

doDispatcher 
  :: DispatcherEvent
  -> React.ReactElement
doDispatcher action
  = React.createLeafElement dispatcher { action: action }
