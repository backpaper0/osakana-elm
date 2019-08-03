module Osakanagram exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D
import Photo
import Tuple


type alias Model =
    { photos : List Photo.Model }


type Msg
    = GotPhotos (Result Http.Error (List Photo.Model))
    | PhotoMsg Int Photo.Msg


jsonToPhotos =
    let
        f =
            D.map2
                (Photo.Model 0)
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
    let
        f index model =
            Photo.view model |> Html.map (PhotoMsg index)
    in
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
            (photos |> List.indexedMap f)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPhotos (Ok photos) ->
            ( { model | photos = photos }, Cmd.none )

        GotPhotos (Err s) ->
            Debug.todo "error"

        PhotoMsg index subMsg ->
            let
                f i photo =
                    if i == index then
                        Photo.update subMsg photo

                    else
                        ( photo, Cmd.none )

                photos =
                    List.indexedMap f model.photos

                g i =
                    Cmd.map (PhotoMsg i)

                cmd =
                    photos |> List.map Tuple.second |> List.indexedMap g |> Cmd.batch
            in
            ( { model | photos = photos |> List.map Tuple.first }, cmd )


main =
    Browser.element { init = init, view = view, update = update, subscriptions = always Sub.none }
