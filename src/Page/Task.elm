module Page.Task exposing (Model, init, update, view)

import Html exposing (Html, div, text)



---- MODEL ----


type alias Model =
    Int


init : Int -> ( Model, Cmd msg )
init id =
    ( id, Cmd.none )



---- UPDATE ----


update : a -> ( a, Cmd msg )
update model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html msg
view id =
    div [] [ text ("Task " ++ String.fromInt id) ]
