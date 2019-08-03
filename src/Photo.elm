module Photo exposing (Model, Msg(..), init, main, update, view)

import Browser
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
    Browser.element { init = init, view = view, update = update, subscriptions = always Sub.none }
