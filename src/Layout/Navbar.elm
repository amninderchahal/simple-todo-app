module Layout.Navbar exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, a, div, img, nav, span, text)
import Html.Attributes exposing (class, href, src)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaLabel, role)
import Html.Events exposing (onClick)


type alias Model =
    Bool


type Msg
    = ToggleMenu


init : Model
init =
    False


update : Msg -> Model -> Model
update msg isMenuOpen =
    case msg of
        ToggleMenu ->
            not isMenuOpen


view : Model -> Html Msg
view isMenuOpen =
    nav [ class "navbar is-info", role "navigation", ariaLabel "main navigation" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", href "#" ]
                [ img [ src "/android-chrome-192x192.png" ] []
                , span [ class "has-text-weight-bold pl-2" ] [ text "Simple Todo App" ]
                ]
            , a [ role "button", class ("navbar-burger" ++ getActiveClass isMenuOpen), ariaLabel "menu", ariaExpanded "false", onClick ToggleMenu ]
                (List.repeat 3 (span [ ariaHidden True ] []))
            ]
        , div
            [ class ("navbar-menu pl-5 " ++ getActiveClass isMenuOpen)
            ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item" ] [ text "Home" ]
                ]
            ]
        ]


getActiveClass : Bool -> String
getActiveClass isActive =
    if isActive then
        " is-active"

    else
        ""
