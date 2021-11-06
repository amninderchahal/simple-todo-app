module Core.Navbar exposing (Model, Msg, init, update, view)

import Html exposing (Html, a, div, img, nav, span, text)
import Html.Attributes exposing (class, href, src)
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaLabel, role)
import Html.Events exposing (onClick)


type alias Model =
    { brandIcon : String
    , isNavOpen : Bool
    }


type Msg
    = ToggleMenu


init : String -> Model
init brandIcon =
    { brandIcon = brandIcon
    , isNavOpen = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleMenu ->
            { model | isNavOpen = not model.isNavOpen }


view : Model -> Html Msg
view model =
    nav [ class "navbar is-info", role "navigation", ariaLabel "main navigation" ]
        [ div [ class "navbar-brand" ]
            [ a [ class "navbar-item", href "/" ]
                [ img [ src model.brandIcon ] []
                , span [ class "has-text-weight-bold pl-2" ] [ text "Simple Todo App" ]
                ]
            , a [ role "button", class ("navbar-burger" ++ getActiveClass model.isNavOpen), ariaLabel "menu", ariaExpanded "false", onClick ToggleMenu ]
                (List.repeat 3 (span [ ariaHidden True ] []))
            ]
        , div
            [ class ("navbar-menu pl-5 " ++ getActiveClass model.isNavOpen)
            ]
            [ div [ class "navbar-start" ]
                [ a [ class "navbar-item", href "/tasks" ] [ text "Tasks" ]
                ]
            ]
        ]


getActiveClass : Bool -> String
getActiveClass isActive =
    if isActive then
        " is-active"

    else
        ""
