port module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Core.Navbar as Navbar
import Html exposing (Html, button, div, h3, text)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Page.Task as TaskPage
import Page.TaskList as TaskListPage
import Route exposing (Route)
import Url exposing (Url)


port signIn : () -> Cmd msg



---- MODEL ----


type alias Model =
    { navbarModel : Navbar.Model
    , route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | TaskListPage TaskListPage.Model
    | TaskPage TaskPage.Model



-- | TaskPage Int


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        model =
            { navbarModel = Navbar.init
            , route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Tasks ->
                    let
                        ( pageModel, pageCmds ) =
                            TaskListPage.init
                    in
                    ( TaskListPage pageModel, Cmd.map TaskListPageMsg pageCmds )

                Route.Task id ->
                    let
                        ( pageModel, _ ) =
                            TaskPage.init id
                    in
                    ( TaskPage pageModel, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



---- UPDATE ----


type Msg
    = NavbarMsg Navbar.Msg
    | TaskListPageMsg TaskListPage.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | LogIn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavbarMsg navbarMsg ->
            ( { model | navbarModel = Navbar.update navbarMsg model.navbarModel }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External "" ->
                    ( model, Cmd.none )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        TaskListPageMsg taskListPageMsg ->
            case model.page of
                TaskListPage pageModel ->
                    let
                        ( updatedPageModel, updatedCmd ) =
                            TaskListPage.update taskListPageMsg pageModel
                    in
                    ( { model | page = TaskListPage updatedPageModel }
                    , Cmd.map TaskListPageMsg updatedCmd
                    )

                _ ->
                    ( model, Cmd.none )

        LogIn ->
            ( model, signIn () )



---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Simple Todo App"
    , body =
        [ div
            []
            [ Navbar.view model.navbarModel
                |> Html.map NavbarMsg
            , routePages model
            , button [ onClick LogIn, type_ "button" ] [ text "Login" ]
            ]
        ]
    }


routePages : Model -> Html Msg
routePages model =
    case model.page of
        NotFoundPage ->
            notFoundView

        TaskListPage pageModel ->
            TaskListPage.view pageModel
                |> Html.map TaskListPageMsg

        TaskPage pageModel ->
            TaskPage.view pageModel


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
