module Photo exposing (Model, Msg(..), init, main, update, view)

import Browser
import Css
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = AddFav


type alias Model =
    { fav : Int, title : String, image : String }


init : () -> ( Model, Cmd Msg )
init () =
    let
        model =
            Model 3 "テスト" "/images/15035033_556188317913560_4012462652419735552_n.jpg"

        cmd =
            Cmd.none
    in
    ( model, cmd )


view : Model -> Html Msg
view { fav, title, image } =
    div
        [ class "photo" ]
        [ div []
            [ img [ src <| "http://localhost:8080" ++ image ] []
            ]
        , div [ class "parts" ] [ text title ]
        , div [ class "parts" ]
            [ button
                [ class "fav-button"
                , class <|
                    if fav == 0 then
                        ""

                    else
                        "fav"
                , onClick AddFav
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
        AddFav ->
            ( { model | fav = model.fav + 1 }, Cmd.none )


main =
    let
        v =
            view >> (\a -> div [] [ a, Css.css ])
    in
    Browser.element { init = init, view = v, update = update, subscriptions = always Sub.none }
