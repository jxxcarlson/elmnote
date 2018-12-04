module Note
    exposing
        ( Note
        , newNoteEncoder
        , noteEncoder
        , noteContentEncoder
        , noteListDecoder
        , noteToString
        , noteFromString
        , exampleNote
        )

import Json.Decode as D
import Json.Encode as E
import Derberos.Date.Core as DateCore exposing (DateRecord)
import DateTime as DT
import Time
import Parser exposing (..)
import DateTime


type alias Note =
    { id : String
    , title : String
    , content : String
    , dateModified : DateRecord
    , dateCreated : DateRecord
    }


noteToString : Note -> String
noteToString note =
    note.content
        ++ "\n!----\n"
        ++ "Created: "
        ++ (DT.stringOfDateRecord note.dateCreated)
        ++ "\n"
        ++ "Modified: "
        ++ (DT.stringOfDateRecord note.dateModified)
        ++ "\n"
        ++ "id: "
        ++ note.id
        ++ "\n"


parseStringUntil : String -> Parser String
parseStringUntil terminator =
    getChompedString <|
        succeed ()
            |. chompUntil terminator


type alias Note2 =
    { content : String
    , dateCreated : DateRecord
    , dateModified : DateRecord
    , id : String
    }


noteOfNote2 : Note2 -> Note
noteOfNote2 note2 =
    { id = note2.id
    , title = firstLine note2.content
    , content = note2.content
    , dateCreated = note2.dateCreated
    , dateModified = note2.dateModified
    }


noteFromString : String -> Result (List DeadEnd) Note
noteFromString str =
    Parser.run noteParser str


noteParser : Parser Note
noteParser =
    (succeed Note2
        |= (parseStringUntil "\n!----\n")
        |. symbol "\n!----\n"
        |. symbol "Created: "
        |= ((parseStringUntil "\n") |> Parser.map DateTime.dateRecordOfString)
        |. symbol "\n"
        |. symbol "Modified: "
        |= ((parseStringUntil "\n") |> Parser.map DateTime.dateRecordOfString)
        |. symbol "\n"
        |. symbol "id: "
        |= (parseStringUntil "\n")
        |. symbol "\n"
    )
        |> Parser.map noteOfNote2


exampleNote =
    """Racket slack password: lobo4795!
Yada yada!!
!----
Created: 2018-10-30T14:13:10
Modified: 2018-10-30T14:13:10
id: 398c31a6-e7fc-4b37-acea-e761c9e70781
"""


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
    let
        title =
            firstLine note.content
    in
        E.object
            [ ( "title", E.string title )
            , ( "note", E.string note.content )
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
