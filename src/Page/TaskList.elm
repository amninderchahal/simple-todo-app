module Page.TaskList exposing (Model, Msg, init, update, view)

import Html exposing (Html, a, button, div, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Model =
    { taskIdList : List Int
    }


init : ( Model, Cmd Msg )
init =
    ( { taskIdList = List.range 1 10 }, Cmd.none )



---- UPDATE ----


type Msg
    = DeleteTask Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeleteTask taskId ->
            ( { model | taskIdList = List.filter (\t -> t /= taskId) model.taskIdList }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div
        []
        [ div [ class "panel" ] (List.map getTaskHtml model.taskIdList)
        ]


getTaskHtml : Int -> Html Msg
getTaskHtml taskId =
    div [ class "panel-block is-flex is-justify-content-space-between px-5 py-4" ]
        [ a [ href ("task/" ++ String.fromInt taskId) ] [ text ("Task " ++ String.fromInt taskId) ]
        , button [ class "delete", onClick (DeleteTask taskId) ] [ text "Delete" ]
        ]
