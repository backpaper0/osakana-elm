module Osakanagram exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D


type alias Model =
    { photos : List Photo }


type Msg
    = GotPhotos (Result Http.Error (List Photo))
    | AddFav Int


type alias Photo =
    { fav : Int, title : String, image : String }


jsonToPhotos =
    let
        f =
            D.map2
                (Photo 0)
                (D.field "title" D.string)
                (D.field "image" D.string)
    in
    D.list f


init : () -> ( Model, Cmd Msg )
init () =
    let
        model =
            Model []

        cmd =
            Http.get { url = "http://localhost:8080/api/photos.json", expect = Http.expectJson GotPhotos jsonToPhotos }
    in
    ( model, cmd )


view : Model -> Html Msg
view { photos } =
    div []
        [ header
            [ style "position" "fixed"
            , style "top" "0"
            , style "left" "0"
            , style "width" "100%"
            , style "height" "40px"
            , style "borderBottom" "1px solid silver"
            , style "boxSizing" "border-box"
            , style "display" "flex"
            , style "alignItems" "center"
            , style "backgroundColor" "white"
            ]
            [ h1
                [ style "fontSize" "large"
                , style "fontStyle" "italic"
                , style "margin" "0"
                ]
                [ text "Osakanagram" ]
            ]
        , div
            [ style "width" "500px"
            , style "margin" "65px auto"
            ]
            (photos |> List.indexedMap photoView)
        ]


photoView : Int -> Photo -> Html Msg
photoView index { fav, title, image } =
    div
        [ style "border" "1px solid silver"
        , style "margin" "25px 0"
        ]
        [ div []
            [ img
                [ style "width" "100%"
                , src <| "http://localhost:8080" ++ image
                ]
                []
            ]
        , div [ style "padding" "0 5px" ] [ text title ]
        , div [ style "padding" "0 5px" ]
            [ button
                [ style "cursor" "pointer"
                , style "border" "0"
                , style "fontSize" "large"
                , style "backgroundColor" "transparent"
                , style "color" <|
                    if fav == 0 then
                        "gray"

                    else
                        "PaleVioletRed"
                , onClick (AddFav index)
                ]
                [ text <|
                    if fav == 0 then
                        "☆"

                    else
                        "★"
                ]
            , span [] [ text "いいね！", span [] [ text <| String.fromInt fav ], text "件" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPhotos (Ok photos) ->
            ( { model | photos = photos }, Cmd.none )

        GotPhotos (Err s) ->
            Debug.todo "error"

        AddFav index ->
            ( { model | photos = addFav index model.photos }, Cmd.none )


addFav : Int -> List Photo -> List Photo
addFav index photos =
    photos
        |> List.indexedMap
            (\i p ->
                if i == index then
                    { p | fav = p.fav + 1 }

                else
                    p
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, view = view, update = update, subscriptions = subscriptions }
