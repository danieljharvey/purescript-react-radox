module Radox.React.Internal.Provider where
  
import Prelude (Unit, bind, pure, ($))
import Effect (Effect)
import React as React
import Radox (CombinedReducer, RadoxStore, createStore)


-- | Internal function for creating a Purescript React class that providers the
-- | Radox store through React Context
radoxProvider 
  :: forall action state
   . React.Context (RadoxStore action state)
  -> CombinedReducer action state 
  -> state
  -> React.ReactClass { children :: Array React.ReactElement }
radoxProvider context combinedReducer initialState 
  = React.pureComponent "Provider" component
  where
    listener 
      :: React.ReactThis 
          { children     :: Array React.ReactElement } 
          { pureduxState :: state } 
      -> state 
      -> Effect Unit
    listener this' newState
        = React.modifyState this' (\_ -> { pureduxState: newState })

    component this = do
        store  <- createStore initialState [ (listener this) ] combinedReducer
        pure $ { state  : { pureduxState: initialState }
               , render : render' this store
               }

    render' this store = do
        props <- React.getProps this
        state <- React.getState this
        pure $ 
            React.createElement 
              context.provider 
              { value: { dispatch: store.dispatch
                       , getState: store.getState
                       , state: state.pureduxState
                       } 
              }
              props.children

