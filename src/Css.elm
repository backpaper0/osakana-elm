module Css exposing (css, main)

import Html exposing (..)


css : Html msg
css =
    node "style" [] [ text """
header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 40px;
    border-bottom: 1px solid silver;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    background-color: white;
}
h1 {
   font-size: large;
   font-style: italic;
   margin: 0;
}
.main {
    width: 500px;
    margin: 65px auto;
}
.photo {
    border: 1px solid silver;
    margin: 25px 0;
}
.photo img {
    width: 100%;
}
.photo .parts {
    padding: 0 5px;
}
.fav-button {
    cursor: pointer;
    border: 0;
    font-size: large;
    background-color: transparent;
    color: gray;
}
.fav-button.fav {
    color: PaleVioletRed;
}
        """ ]


main =
    css
