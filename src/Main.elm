port module Main exposing (..)

import Html exposing (div, button, text)
import Html.App exposing (programWithFlags)
import Html.Events exposing (onClick)


main : Program (Maybe Model)
main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    Int


init : Maybe Model -> ( Model, Cmd msg )
init model =
    case model of
        Just model ->
            ( model, Cmd.none )

        Nothing ->
            ( 0, Cmd.none )



-- UPDATE


type Msg
    = Increment
    | Decrement



-- PORTS


port setStorage : Model -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newModel =
            case msg of
                Increment ->
                    model + 1

                Decrement ->
                    model - 1
    in
        ( newModel, setStorage newModel )



-- VIEW


view : a -> Html.Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+" ]
        , div [] [ text (toString model) ]
        , button [ onClick Decrement ] [ text "-" ]
        ]
