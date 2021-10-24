module Main exposing (..)

import Browser
import Html exposing (Html, a, div, h1, img, nav, span, text)
import Html.Attributes exposing (class, href, id, src, width)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaLabel, role)
import Html.Events exposing (onClick)



---- MODEL ----


type alias Model =
    { isMenuOpen : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { isMenuOpen = False }, Cmd.none )



---- UPDATE ----


type Msg
    = ToggleMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleMenu ->
            ( { model | isMenuOpen = not model.isMenuOpen }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div
        []
        [ nav [ class "navbar is-info", role "navigation", ariaLabel "main navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", href "#" ]
                    [ img [ src "/images/brand/original/favicon-32x32.png" ] []
                    , span [ class "has-text-weight-bold pl-2" ] [ text "Simple Task Manager" ]
                    ]
                , a [ role "button", class ("navbar-burger" ++ getActiveClass model.isMenuOpen), ariaLabel "menu", ariaExpanded "false", onClick ToggleMenu ]
                    (List.repeat 3 (span [ ariaHidden True ] []))
                ]
            , div
                [ class ("navbar-menu pl-5 " ++ getActiveClass model.isMenuOpen)
                ]
                [ div [ class "navbar-start" ]
                    [ a [ class "navbar-item" ] [ text "Home" ]
                    ]
                ]
            ]
        , h1 [] [ text "Your Elm App is working!" ]
        ]


getActiveClass : Bool -> String
getActiveClass isActive =
    if isActive then
        " is-active"

    else
        ""



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
