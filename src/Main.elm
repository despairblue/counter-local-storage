port module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onInput)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Date.Extra.Core exposing (daysInMonth)
import Time exposing (Time, second)
import String


main : Program (Maybe Model)
main =
    Html.programWithFlags
        { init = init
        , update = (\msg model -> withSetStorage (update msg model))
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { day : Int
    , date : Float
    , ausgabe : Float
    , sicherheit : Float
    }


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    let
        f =
            Debug.log "flags" savedModel
    in
        Maybe.withDefault (Model 0 0 0 0) savedModel ! []



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
                    newTime

                dayOfMonth =
                    newDate
                        |> Date.fromTime
                        |> Date.day

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



-- PORTS


port setStorage : Model -> Cmd msg


withSetStorage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
withSetStorage ( model, cmds ) =
    ( model, Cmd.batch [ setStorage model, cmds ] )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        date =
            Date.fromTime model.date

        year =
            Date.year date

        month =
            Date.month date

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
