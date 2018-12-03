module DateTime
    exposing
        ( dateRecordOfString
        , humanStringOfDateRecord
        , stringOfDateRecord
        , europeanStringOfDateRecord
        , usaStringOfDateRecord
        , parseDateRecord
        , digit
        , digitPair
        )

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


humanStringOfDateRecord : DateRecord -> String
humanStringOfDateRecord dr =
    let
        datePart =
            [ dr.month, dr.day, dr.year ]
                |> List.map String.fromInt
                |> String.join ("-")

        timePart =
            [ dr.hour, dr.minute ]
                |> List.map String.fromInt
                |> String.join (":")
    in
        datePart ++ ", " ++ timePart


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
        |= digitPair
        |. symbol "-"
        |= digitPair
        |. symbol "T"
        |= digitPair
        |. symbol ":"
        |= digitPair
        |. symbol ":"
        |= digitPair
        |= succeed 0
        |= succeed Time.utc


digit : Parser String
digit =
    getChompedString <|
        succeed ()
            |. chompIf (\c -> Char.isDigit c)


type DigitPair
    = DigitPair String String


stringOfDigitPair : DigitPair -> String
stringOfDigitPair (DigitPair a b) =
    a ++ b


valueOfDigitPair : DigitPair -> Int
valueOfDigitPair digitPair_ =
    digitPair_
        |> stringOfDigitPair
        |> normalize
        |> String.toInt
        |> Maybe.withDefault 0


normalize : String -> String
normalize str =
    if String.left 1 str == "0" then
        String.dropLeft 1 str
    else
        str


digitPair : Parser Int
digitPair =
    (succeed DigitPair
        |= digit
        |= digit
    )
        |> Parser.map valueOfDigitPair
