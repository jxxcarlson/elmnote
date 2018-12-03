module Note
    exposing
        ( Note
        , newNoteEncoder
        , noteEncoder
        , noteContentEncoder
        , noteListDecoder
        )

import Json.Decode as D
import Json.Encode as E
import Derberos.Date.Core as DateCore exposing (DateRecord)
import DateTime as DT
import Time


type alias Note =
    { id : String
    , title : String
    , content : String
    , dateModified : DateRecord
    , dateCreated : DateRecord
    }


noteListDecoder : D.Decoder (List Note)
noteListDecoder =
    D.list noteDecoder


noteDecoder : D.Decoder Note
noteDecoder =
    D.map5 Note
        (D.field "id" D.string)
        (D.field "title" D.string)
        (D.field "note" D.string)
        ((D.field "created_on" D.string) |> D.map DT.dateRecordOfString)
        ((D.field "modfied_on" D.string) |> D.map DT.dateRecordOfString)


noteEncoder : Note -> E.Value
noteEncoder note =
    E.object
        [ ( "id", E.string note.id )
        , ( "title", E.string note.title )
        , ( "note", E.string note.content )
        , ( "created_on", E.string <| DT.stringOfDateRecord <| note.dateCreated )
        , ( "modfied_on", E.string <| DT.stringOfDateRecord <| note.dateModified )
        ]


noteContentEncoder : Note -> E.Value
noteContentEncoder note =
    E.object
        [ ( "note", E.string note.content )
        ]


firstLine : String -> String
firstLine str =
    str
        |> String.split "\n"
        |> List.head
        |> Maybe.withDefault ""


newNoteEncoder : String -> Maybe String -> Time.Posix -> E.Value
newNoteEncoder content maybeUuidString posixTime =
    case maybeUuidString of
        Nothing ->
            E.null

        Just uuid ->
            E.object
                [ ( "id", E.string uuid )
                , ( "note", E.string content )
                , ( "title", E.string <| firstLine content )
                , ( "created_on", E.string <| DT.stringOfDateRecord <| DateCore.posixToCivil posixTime )
                , ( "modfied_on", E.string <| DT.stringOfDateRecord <| DateCore.posixToCivil posixTime )
                ]



{-

   [{"id":"15e7bfee-c195-4310-bf08-f1f7f0ebee4b","created_on":"2018-11-11T14:22:40","modfied_on":"2018-11-11T14:22:40","title":"Why Competition in the Politics Industry is Failing America","note":"Why Competition in the Politics Industry is Failing America\nHarvard Business School Review\nhttps://www.hbs.edu/competitiveness/Documents/why-competition-in-the-politics-industry-is-failing-america.pdf"}]

-}
