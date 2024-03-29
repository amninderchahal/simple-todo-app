port module App.Main exposing (..)

import App.Page.Task as TaskPage
import App.Page.TaskList as TaskListPage
import App.Routes as Routes exposing (Route)
import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, href, src, type_)
import Html.Attributes.Aria exposing (ariaExpanded, ariaLabel, role)
import Html.Events exposing (onClick)
import Html.Events.Extra exposing (onClickPreventDefault)
import Url exposing (Url)


port signIn : () -> Cmd msg


port signOut : () -> Cmd msg


port signInInfo : (Maybe AuthUser -> msg) -> Sub msg



---- MODEL ----


type alias Model =
    { flags : Flags
    , authUser : Maybe AuthUser
    , isDrawerOpen : Bool
    , route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | TaskListPage TaskListPage.Model
    | TaskPage TaskPage.Model


type alias Flags =
    { brandIcon : String }


type alias MessageContent =
    { uid : String, content : String }


type alias ErrorData =
    { code : Maybe String, message : Maybe String, credential : Maybe String }


type alias AuthUser =
    { uid : String
    , email : String
    , displayName : String
    , photoURL : String
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { flags = flags
            , authUser = Maybe.Nothing
            , isDrawerOpen = False
            , route = Routes.parseUrl url
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
                Routes.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Routes.Tasks ->
                    let
                        ( pageModel, pageCmds ) =
                            TaskListPage.init
                    in
                    ( TaskListPage pageModel, Cmd.map TaskListPageMsg pageCmds )

                Routes.Task id ->
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
    = ToggleDrawer
    | CloseDrawer
    | TaskListPageMsg TaskListPage.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | LogIn
    | LogOut
    | SignInInfoReceived (Maybe AuthUser)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleDrawer ->
            ( { model | isDrawerOpen = not model.isDrawerOpen }, Cmd.none )

        CloseDrawer ->
            ( { model | isDrawerOpen = False }, Cmd.none )

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
                    Routes.parseUrl url
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

        LogOut ->
            ( model, signOut () )

        SignInInfoReceived authUser ->
            ( { model | authUser = authUser }, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Simple Todo App"
    , body =
        [ div [ class "h-full flex" ]
            [ drawer model
            , div [ class ("drawer-backdrop md:hidden fixed inset-x-0 top-0 bg-black" ++ getDrawerClass model.isDrawerOpen), onClick ToggleDrawer ] []
            , div [ class "h-full flex-grow overflow-scroll" ]
                [ nav [ class "grid justify-items-start bg-green-500", role "navigation", ariaLabel "main navigation" ]
                    [ a [ class "md:hidden px-3 text-2xl text-gray-100 leading-loose", ariaLabel "menu", ariaExpanded "false", onClickPreventDefault ToggleDrawer ]
                        [ span [ class "fas fa-bars" ] [] ]
                    ]
                , div [ class "main-content" ]
                    [ routePages model
                    , case model.authUser of
                        Maybe.Nothing ->
                            button [ onClick LogIn, type_ "button" ] [ text "Login" ]

                        Just authUser ->
                            div []
                                [ div []
                                    [ text ("Hello " ++ authUser.displayName) ]
                                , button [ onClick LogOut, type_ "button" ] [ text "Log out" ]
                                ]
                    ]
                ]
            ]
        ]
    }


drawer : Model -> Html Msg
drawer model =
    div [ class ("drawer fixed md:static h-full left-0 bg-white border-r border-gray-100" ++ getDrawerClass model.isDrawerOpen) ]
        [ div [ class "brand-wrapper bg-green-500 pl-6 flex items-center" ]
            [ a [ class "brand", href "/", onClick CloseDrawer ]
                [ img [ class "", src model.flags.brandIcon ] [] ]
            ]
        ]


getDrawerClass : Bool -> String
getDrawerClass isActive =
    if isActive then
        " open"

    else
        ""


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



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    signInInfo SignInInfoReceived



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
