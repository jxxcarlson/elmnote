module Main exposing (main)

{- This is a starter app which presents a text label, text field, and a button.
   What you enter in the text field is echoed in the label.  When you press the
   button, the text in the label is reverse.

   This version uses `mdgriffith/elm-ui` for the view functions.
-}

import Browser
import Html exposing (Html)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Http
import Note exposing (Note, noteListDecoder)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type AppMode
    = SearchMode
    | EditMode
    | CreateMode


type alias Model =
    { searchString : String
    , output : String
    , searchResults : List Note
    , appMode : AppMode
    }


type Msg
    = NoOp
    | AcceptSearchString String
    | Search
    | SearchResults (Result Http.Error (List Note))
    | EditNote String


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { searchString = ""
      , searchResults = []
      , output = "App started"
      , appMode = SearchMode
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        AcceptSearchString str ->
            ( { model | searchString = str, output = str, appMode = SearchMode }, Cmd.none )

        Search ->
            ( { model | appMode = SearchMode }, fetchNotes <| "note=ilike." ++ model.searchString ++ "*" )

        SearchResults results ->
            case results of
                Ok noteList ->
                    ( { model | searchResults = noteList }, Cmd.none )

                Err _ ->
                    ( { model | output = "Http error" }, Cmd.none )

        EditNote id ->
            ( { model | appMode = EditMode }, fetchNotes <| "id=eq." ++ id )



-- note=ilike.*why*


fetchNotes : String -> Cmd Msg
fetchNotes searchString =
    Http.get
        { url = "http://localhost:3000/notes?" ++ searchString
        , expect = Http.expectJson SearchResults Note.noteListDecoder
        }



--
-- VIEW
--


view : Model -> Html Msg
view model =
    Element.layout [] (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    column mainColumnStyle
        [ column [ centerX, spacing 20, width (px 500), height (px 760), clipY ]
            [ title "Notes"
            , inputText model
            , appButton
            , viewNotes model.searchResults
            , outputDisplay model
            ]
        ]


title : String -> Element msg
title str =
    row [ centerX, Font.bold, Font.color white ] [ text str ]


outputDisplay : Model -> Element msg
outputDisplay model =
    row [ centerX, Font.color white, Font.size 12 ]
        [ text <| "Notes: " ++ (String.fromInt <| List.length <| model.searchResults) ]


inputText : Model -> Element Msg
inputText model =
    Input.text []
        { onChange = AcceptSearchString
        , text = model.searchString
        , placeholder = Nothing
        , label = Input.labelLeft [] <| el [] (text "")
        }


appButton : Element Msg
appButton =
    row [ centerX ]
        [ Input.button buttonStyle
            { onPress = Just Search
            , label = el [ centerX, centerY ] (text "Search")
            }
        ]


editButton : String -> Element Msg
editButton id =
    column [ alignRight ]
        [ Input.button tinyButtonStyle
            { onPress = Just (EditNote id)
            , label = el [] (text "Edit")
            }
        ]


viewNotes : List Note -> Element Msg
viewNotes notelist =
    column [ spacing 12, scrollbarY, clipX, height (px 560) ] (List.map viewNote notelist)


viewNote : Note -> Element Msg
viewNote note =
    column [ width (px 500), spacing 8, Background.color white, padding 8 ]
        [ row [ Font.size 13, Font.bold, width fill ] [ titleElement note, editButton note.id ]
        , row [ Font.size 13 ] [ text <| removeFirstLine <| note.content ]
        ]


titleElement : Note -> Element Msg
titleElement note =
    column [ alignLeft ] [ text note.title ]



--
-- STYLE
--


charcoal =
    rgb255 40 40 40


white =
    rgb255 240 240 240


mainColumnStyle =
    [ centerX
    , centerY
    , Background.color charcoal
    , paddingXY 20 20
    ]


buttonStyle =
    [ Background.color white
    , Font.color charcoal
    , paddingXY 15 8
    , height (px 35)
    ]


tinyButtonStyle =
    [ Background.color charcoal
    , Font.color white
    , Font.size 11
    , paddingXY 8 4
    , height (px 15)
    , alignRight
    ]



--
-- Helpers
--


removeFirstLine : String -> String
removeFirstLine str =
    str
        |> String.split "\n"
        |> List.drop 1
        |> String.join "\n"



--
