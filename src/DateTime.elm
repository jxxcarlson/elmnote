module DateTime exposing (dateRecordOfString, stringOfDateRecord, europeanStringOfDateRecord, usaStringOfDateRecord)

import Parser exposing (..)
import Derberos.Date.Core exposing (DateRecord)
import Time


-- "2018-11-11T14:22:40"


dateRecordOfString : String -> DateRecord
dateRecordOfString str =
    case run parseDateRecord str of
        Ok dr ->
            dr

        Err _ ->
            defaultDateRecord


defaultDateRecord =
    DateRecord 1900 1 1 0 0 0 0 Time.utc


stringOfDateRecord : DateRecord -> String
stringOfDateRecord dr =
    let
        datePart =
            [ dr.year, dr.month, dr.day ]
                |> List.map String.fromInt
                |> String.join ("-")

        timePart =
            [ dr.hour, dr.minute, dr.second ]
                |> List.map String.fromInt
                |> String.join (":")
    in
        datePart ++ "T" ++ timePart


europeanStringOfDateRecord : DateRecord -> String
europeanStringOfDateRecord dr =
    [ dr.day, dr.month, dr.year ]
        |> List.map String.fromInt
        |> String.join ("-")


usaStringOfDateRecord : DateRecord -> String
usaStringOfDateRecord dr =
    [ dr.month, dr.day, dr.year ]
        |> List.map String.fromInt
        |> String.join ("-")


parseDateRecord : Parser DateRecord
parseDateRecord =
    succeed DateRecord
        |= int
        |. symbol "-"
        |= int
        |. symbol "-"
        |= int
        |. symbol "T"
        |= int
        |. symbol ":"
        |= int
        |. symbol ":"
        |= int
        |= succeed 0
        |= succeed Time.utc
