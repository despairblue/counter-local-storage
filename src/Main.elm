module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra.Core exposing (daysInMonth)
import Time exposing (Time, second)
import String


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { day : Int
    , date : Date
    , ausgabe : Float
    , sicherheit : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Model 0 (Date.fromTime 0) 0 0, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | ChangeAusgabe String
    | ChangeSicherheit String


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Tick newTime ->
            let
                newDate =
                    Date.fromTime newTime

                dayOfMonth =
                    Date.day newDate

                newModel =
                    { model
                        | day = dayOfMonth
                        , date = newDate
                    }
            in
                ( Debug.log "model" newModel, Cmd.none )

        ChangeAusgabe newAusgabe ->
            let
                newAusgabeFloat =
                    Result.withDefault 0 (String.toFloat newAusgabe)
            in
                ( { model | ausgabe = newAusgabeFloat }, Cmd.none )

        ChangeSicherheit newSicherheit ->
            let
                newSicherheitFloat =
                    Result.withDefault 0 (String.toFloat newSicherheit)
            in
                ( { model | sicherheit = newSicherheitFloat }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        year =
            Date.year model.date

        month =
            Date.month model.date

        daysThisMonth =
            toFloat <| daysInMonth year month

        daysLeftThisMonth =
            daysThisMonth - toFloat model.day

        balance =
            (daysLeftThisMonth / daysThisMonth) * model.ausgabe + model.sicherheit
    in
        div []
            [ h1 [] [ text "Money" ]
            , div []
                [ label []
                    [ text "Ausgabe: "
                    , input
                        [ value <| toString <| model.ausgabe
                        , onInput ChangeAusgabe
                        ]
                        []
                    ]
                ]
            , div []
                [ label []
                    [ text "Sicherheit: "
                    , input
                        [ value
                            <| toString
                            <| model.sicherheit
                        , onInput ChangeSicherheit
                        ]
                        []
                    ]
                ]
            , text <| toString <| balance
            ]
