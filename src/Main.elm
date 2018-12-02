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
    , maybeNoteToEdit : Maybe Note
    , appMode : AppMode
    , message : String
    }


type Msg
    = NoOp
    | AcceptSearchString String
    | Search
    | SearchResults (Result Http.Error (List Note))
    | SearchResultForEditing (Result Http.Error (List Note))
    | EditNote String
    | InputNoteText String
    | NoteUpdated (Result Http.Error ())
    | UpdateNote


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { searchString = ""
      , searchResults = []
      , output = "xxx"
      , appMode = SearchMode
      , maybeNoteToEdit = Nothing
      , message = "App started"
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

        SearchResultForEditing result ->
            case result of
                Ok noteList ->
                    ( { model | maybeNoteToEdit = List.head noteList }, Cmd.none )

                Err _ ->
                    ( { model | output = "Http error" }, Cmd.none )

        EditNote id ->
            ( { model | appMode = EditMode }, fetchNoteToEdit id )

        InputNoteText str ->
            case model.maybeNoteToEdit of
                Nothing ->
                    ( model, Cmd.none )

                Just note ->
                    let
                        nextNote =
                            { note | content = str }
                    in
                        ( { model | maybeNoteToEdit = Just nextNote }, Cmd.none )

        NoteUpdated result ->
            case result of
                Ok _ ->
                    ( model, Cmd.none )

                Err err ->
                    ( { model | message = httpErrorReport err }, Cmd.none )

        UpdateNote ->
            case model.maybeNoteToEdit of
                Nothing ->
                    ( model, Cmd.none )

                Just note ->
                    ( model, updateNote note )



-- Ok x ->
--   ( { model | message = "Update OK"}, Cmd.none )
-- Err _ ->
--   ( { model | message = "Error updating note", Cmd.none )
--
-- HTTP Requests
--


fetchNotes : String -> Cmd Msg
fetchNotes searchString =
    Http.get
        { url = "http://localhost:3000/notes?" ++ searchString
        , expect = Http.expectJson SearchResults Note.noteListDecoder
        }


fetchNoteToEdit : String -> Cmd Msg
fetchNoteToEdit id =
    Http.get
        { url = "http://localhost:3000/notes?id=eq." ++ id
        , expect = Http.expectJson SearchResultForEditing Note.noteListDecoder
        }


updateNote : Note -> Cmd Msg
updateNote note =
    Http.request
        { method = "PATCH"
        , headers =
            [ Http.header "Authorization" "Bearer 037b75e1-ae57-49f1-8431-03b7c21f278c"
            , Http.header "Content-Type" "application/json"
            ]
        , url = "http://localhost:3000/notes"
        , body = Http.jsonBody <| Note.noteEncoder note
        , expect = Http.expectWhatever NoteUpdated
        , timeout = Nothing
        , tracker = Nothing
        }


type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int
    | BadBody String


httpErrorReport : Http.Error -> String
httpErrorReport error =
    case error of
        Http.BadUrl str ->
            "Bad url: " ++ str

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus code ->
            "BadStatus " ++ String.fromInt code

        Http.BadBody str ->
            "BadBody: " ++ str



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
            , row [ centerX, spacing 12 ] [ searchButton, updateButton model ]
            , noteDisplay model
            , outputDisplay model
            , messageDisplay model
            ]
        ]


noteDisplay model =
    case model.appMode of
        SearchMode ->
            viewNotes model.searchResults

        EditMode ->
            editNote model

        CreateMode ->
            editNote model


title : String -> Element msg
title str =
    row [ centerX, Font.bold, Font.color white ] [ text str ]


outputDisplay : Model -> Element msg
outputDisplay model =
    row [ centerX, Font.color white, Font.size 12 ]
        [ text <| "Notes: " ++ (String.fromInt <| List.length <| model.searchResults) ]


messageDisplay : Model -> Element msg
messageDisplay model =
    row [ centerX, Font.color white, Font.size 12 ]
        [ text <| model.message ]


inputText : Model -> Element Msg
inputText model =
    Input.text []
        { onChange = AcceptSearchString
        , text = model.searchString
        , placeholder = Nothing
        , label = Input.labelLeft [] <| el [] (text "")
        }


searchButton : Element Msg
searchButton =
    row [ centerX ]
        [ Input.button buttonStyle
            { onPress = Just Search
            , label = el [ centerX, centerY ] (text "Search")
            }
        ]


updateButton : Model -> Element Msg
updateButton model =
    if model.appMode /= EditMode then
        Element.none
    else
        row [ centerX ]
            [ Input.button buttonStyle
                { onPress = Just UpdateNote
                , label = el [ centerX, centerY ] (text "Update")
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


editNote model =
    let
        editText =
            case model.maybeNoteToEdit of
                Nothing ->
                    "Error: no note to edit"

                Just note ->
                    note.content
    in
        Input.multiline editorStyle
            { onChange = InputNoteText
            , text = editText
            , placeholder = Nothing
            , spellcheck = False
            , label = Input.labelLeft [] <| el [] (text "")
            }



--
-- STYLE
--


editorStyle =
    [ width (px 500)
    , Background.color white
    , padding 8
    , Font.size 12
    , height (px 500)
    ]


charcoal =
    rgb255 40 40 40


lightCharcoal =
    rgb255 90 90 90


white =
    rgb255 240 240 240


mainColumnStyle =
    [ centerX
    , centerY
    , Background.color charcoal
    , paddingXY 20 20
    ]


buttonStyle =
    [ Background.color lightCharcoal
    , Font.color white
    , Font.size 14
    , Font.bold
    , paddingXY 15 8
    , height (px 30)
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
